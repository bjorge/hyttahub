package main

import (
	"encoding/base64"
	"log"
	"os"
	"fmt"
	"strings"
	"time"

	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/plugins/migratecmd"
	"github.com/pocketbase/pocketbase/tools/types"
	"google.golang.org/protobuf/proto"

	"pocketbase_emulator/models"
	_ "pocketbase_emulator/migrations"
)

func decodeSegment(segment string) string {
	if !strings.HasPrefix(segment, "e") {
		return segment
	}
	b64 := segment[1:]
	b64 = strings.ReplaceAll(b64, "_", "-")

	// Add padding back if necessary
	if len(b64)%4 != 0 {
		b64 += strings.Repeat("=", 4-len(b64)%4)
	}

	decoded, err := base64.URLEncoding.DecodeString(b64)
	if err != nil {
		return segment
	}
	return string(decoded)
}

func encodeSegment(email string) string {
	b64 := base64.URLEncoding.EncodeToString([]byte(email))
	b64 = strings.ReplaceAll(b64, "=", "")
	return "e" + b64
}

func main() {
	app := pocketbase.New()
	log.Printf("[hyttahub] Starting PocketBase Emulator v1.1 (with auto-delete hooks)...")

	migratecmd.MustRegister(app, app.RootCmd, migratecmd.Config{
		Automigrate: true, // auto creates migration files when making collection changes
	})

	// -------------------------------------------------------------------------
	// Firestore Rules Emulation: Complex Create Logic
	// -------------------------------------------------------------------------
	app.OnRecordCreateRequest().BindFunc(func(e *core.RecordRequestEvent) error {
		colName := e.Record.Collection().Name

		// Require auth for creating records in any hyttahub collection
		if !strings.HasPrefix(colName, "hyttahub__") {
			return e.Next()
		}

		// Bypass for superusers
		if e.HasSuperuserAuth() {
			return e.Next()
		}

		// --- Auto-Timestamp Resolution ---
		// If the client sends "@now" or leave it empty, resolve it to a real timestamp.
		// Since 't' is a DateField, PocketBase might have discarded "@now" as invalid.
		if e.Record.GetString("t") == "" || e.Record.GetString("t") == "@now" {
			e.Record.Set("t", time.Now().UTC().Format("2006-01-02 15:04:05.000Z"))
		}
		// ---------------------------------

		// ── Service Users / Site Users ────────────────────────────────────────
		// Mirror Firestore: allow create if firstServiceUser(app) || isEmailListed
		// The empty-collection check MUST come before the auth guard so that an
		// unauthenticated first-time initializer is not rejected with 401.
		if strings.HasSuffix(colName, "__site_users") || strings.HasSuffix(colName, "__service_users") {
			count, err := app.CountRecords(colName)
			if err != nil {
				return err
			}
			if count == 0 {
				// First user — no auth required (mirrors Firestore firstServiceUser / firstSiteUser)
				log.Printf("[hyttahub] allowing first user creation in %s\n", colName)
				return e.Next()
			}

			// Not the first user — now require auth.
			authEmail := ""
			if e.Auth != nil {
				authEmail = e.Auth.GetString("email")
			}
			if authEmail == "" {
				return apis.NewUnauthorizedError("Unauthorized", nil)
			}

			// Are they already a member?
			records, err := app.FindRecordsByFilter(
				colName,
				"doc_id = {:email}",
				"",
				1,
				0,
				dbx.Params{"email": authEmail},
			)
			if err != nil || len(records) == 0 {
				return apis.NewForbiddenError("Only existing members can add users", nil)
			}
			return e.Next()
		}

		// ── Service Events ────────────────────────────────────────────────────
		// Empty-collection check MUST come before the auth guard (mirrors Firestore
		// firstServiceUser — the very first event is written before any user record).
		if strings.HasSuffix(colName, "__service_events") {
			count, err := app.CountRecords(colName)
			if err != nil {
				return err
			}
			if count == 0 {
				log.Printf("[hyttahub] allowing first event creation in %s\n", colName)
				return e.Next()
			}

			// Not the first event — require auth and check membership.
			authEmail := ""
			if e.Auth != nil {
				authEmail = e.Auth.GetString("email")
			}
			if authEmail == "" {
				return apis.NewUnauthorizedError("Unauthorized", nil)
			}
			usersColName := strings.ReplaceAll(colName, "__service_events", "__service_users")
			records, err := app.FindRecordsByFilter(
				usersColName,
				"doc_id = {:email}",
				"",
				1,
				0,
				dbx.Params{"email": authEmail},
			)
			if err != nil || len(records) == 0 {
				return apis.NewForbiddenError("Only service members can create events", nil)
			}
			return e.Next()
		}

		// ── Site Files ────────────────────────────────────────────────────────
		// Only authenticated site members can upload/delete files.
		if strings.HasSuffix(colName, "__site_files") {
			authEmail := ""
			if e.Auth != nil {
				authEmail = e.Auth.GetString("email")
			}
			if authEmail == "" {
				return apis.NewUnauthorizedError("Unauthorized", nil)
			}
			usersColName := strings.ReplaceAll(colName, "__site_files", "__site_users")
			records, err := app.FindRecordsByFilter(
				usersColName,
				"doc_id = {:email}",
				"",
				1,
				0,
				dbx.Params{"email": authEmail},
			)
			if err != nil || len(records) == 0 {
				return apis.NewForbiddenError("Only site members can upload files", nil)
			}
			return e.Next()
		}

		// ── All other hyttahub__ collections require auth ─────────────────────
		authEmail := ""
		if e.Auth != nil {
			authEmail = e.Auth.GetString("email")
		}
		if authEmail == "" {
			return apis.NewUnauthorizedError("Unauthorized", nil)
		}

		return e.Next()
	})

	// -------------------------------------------------------------------------
	// Firestore Rules Emulation: Auto-Delete Empty Sites
	// -------------------------------------------------------------------------
	app.OnRecordAfterDeleteSuccess().BindFunc(func(e *core.RecordEvent) error {
		colName := e.Record.Collection().Name
		log.Printf("[hyttahub] DEBUG: OnRecordAfterDeleteSuccess triggered: col=%s", colName)

		// 1. Wipe account data immediately if the auth user is deleted
		if colName == "users" {
			email := e.Record.GetString("email")
			if email != "" {
				log.Printf("[hyttahub] Auth user deleted (%s). Cleanup will be handled by cron.", email)
			}
		}

		return e.Next()
	})

	app.OnRecordAfterUpdateSuccess().BindFunc(func(e *core.RecordEvent) error {
		colName := e.Record.Collection().Name
		mValue := e.Record.GetString("m")
		log.Printf("[hyttahub] DEBUG: OnRecordAfterUpdateSuccess triggered: col=%s, m=%s", colName, mValue)

		// We only care if a user is soft-deleted from a site
		if !strings.HasSuffix(colName, "__site_users") {
			return e.Next()
		}

		// Check if it was just marked for deletion ('m' field is set)
		if mValue == "" {
			return e.Next()
		}

		log.Printf("[hyttahub] DEBUG: User marked for deletion in %s (m=%s)", colName, mValue)

		// 1. Decode MarkForDeletion proto
		mBytes, err := base64.StdEncoding.DecodeString(mValue)
		if err != nil {
			log.Printf("[hyttahub] ERROR decoding m base64: %v", err)
		} else {
			mInfo := &models.MarkForDeletion{}
			if err := proto.Unmarshal(mBytes, mInfo); err != nil {
				log.Printf("[hyttahub] ERROR unmarshaling MarkForDeletion: %v", err)
			} else {
				log.Printf("[hyttahub] DEBUG: DeleteReason: %v", mInfo.DeleteReason)

				// Extract app, site, email
				parts := strings.Split(colName, "__")
				// expected: hyttahub__app__sites__siteid__site_users
				if len(parts) >= 5 {
					appName := parts[1]
					siteId := parts[3]
					email := e.Record.GetString("doc_id")
					memberId := e.Record.GetInt("u")

					if mInfo.DeleteReason == models.MarkForDeletion_memberLeftSite {
						// Add SiteEvent: LeaveSite
						eventsCol := strings.TrimSuffix(colName, "__site_users") + "__site_events"
						log.Printf("[hyttahub] DeleteReason: memberLeftSite. Targeting collection: %s", eventsCol)

						// Get latest version
						lastRecords, _ := app.FindRecordsByFilter(eventsCol, "", "-v", 1, 0)
						newVersion := 1
						if len(lastRecords) > 0 {
							newVersion = lastRecords[0].GetInt("v") + 1
						}

						if newVersion > 1 {
							siteEvent := &models.SiteEvent{
								Version: int32(newVersion),
								Author:  int32(memberId),
								EventType: &models.SiteEvent_LeaveSite_{
									LeaveSite: &models.SiteEvent_LeaveSite{
										MemberId: int32(memberId),
									},
								},
							}

							eBytes, _ := proto.Marshal(siteEvent)
							eBase64 := base64.StdEncoding.EncodeToString(eBytes)

							col, _ := app.FindCollectionByNameOrId(eventsCol)
							if col != nil {
								record := core.NewRecord(col)
								record.Set("doc_id", fmt.Sprintf("%d", newVersion))
								record.Set("v", newVersion)
								record.Set("p", eBase64)
								record.Set("t", time.Now().UTC().Format("2006-01-02 15:04:05.000Z"))
								if err := app.Save(record); err != nil {
									log.Printf("[hyttahub] ERROR saving SiteEvent for %s: %v", email, err)
								} else {
									log.Printf("[hyttahub] Created LeaveSite event for %s (version %d) in %s", email, newVersion, eventsCol)
								}
							}
						} else {
							log.Printf("[hyttahub] No previous site events found for site %s, skipping LeaveSite event", siteId)
						}

					} else if mInfo.DeleteReason == models.MarkForDeletion_memberRemovedFromSite {
						// Add AccountEvent: RemoveSite
						encodedEmail := encodeSegment(email)
						accountEventsCol := fmt.Sprintf("hyttahub__%s__accounts__%s__account_events", appName, encodedEmail)
						log.Printf("[hyttahub] DeleteReason: memberRemovedFromSite. Targeting collection: %s", accountEventsCol)

						// Get latest version
						lastRecords, _ := app.FindRecordsByFilter(accountEventsCol, "", "-v", 1, 0)
						newVersion := 1
						if len(lastRecords) > 0 {
							newVersion = lastRecords[0].GetInt("v") + 1
						}

						if newVersion > 1 {
							accountEvent := &models.AccountEvent{
								Version: int32(newVersion),
								EventType: &models.AccountEvent_RemoveSite{
									RemoveSite: siteId,
								},
							}

							eBytes, _ := proto.Marshal(accountEvent)
							eBase64 := base64.StdEncoding.EncodeToString(eBytes)

							col, _ := app.FindCollectionByNameOrId(accountEventsCol)
							if col != nil {
								record := core.NewRecord(col)
								record.Set("doc_id", fmt.Sprintf("%d", newVersion))
								record.Set("v", newVersion)
								record.Set("p", eBase64)
								record.Set("t", time.Now().UTC().Format("2006-01-02 15:04:05.000Z"))
								if err := app.Save(record); err != nil {
									log.Printf("[hyttahub] ERROR saving AccountEvent for %s: %v", email, err)
								} else {
									log.Printf("[hyttahub] Created RemoveSite event for %s (version %d) in %s", email, newVersion, accountEventsCol)
								}
							}
						} else {
							log.Printf("[hyttahub] No previous account events found for user %s, skipping RemoveSite event", email)
						}
					} else {
						log.Printf("[hyttahub] DeleteReason %v (email updating) - no event creation needed", mInfo.DeleteReason)
					}
				}
			}
		}

		// Now delete this record.
		// Note: We are using app.Delete here. This will trigger OnRecordAfterDeleteSuccess.
		log.Printf("[hyttahub] Finalizing: Deleting site user record for %s from %s", e.Record.GetString("doc_id"), colName)
		if err := app.Delete(e.Record); err != nil {
			log.Printf("[hyttahub] ERROR deleting site user record: %v", err)
		} else {
			log.Printf("[hyttahub] Successfully deleted user document for %s", e.Record.GetString("doc_id"))
		}

		return e.Next()
	})

	// -------------------------------------------------------------------------
	// Auto-collection middleware via explicit router intercept
	// -------------------------------------------------------------------------
	// By hooking into OnServe, we can add a middleware to the standard router
	// which intercepts requests before they hit PocketBase's collection checks.
	app.OnServe().BindFunc(func(se *core.ServeEvent) error {

		// Serve static files from pb_public
		se.Router.GET("/{path...}", apis.Static(os.DirFS(app.DataDir()+"/../pb_public"), false))

		// --- Orphan Cleanup Cron ---
		// Runs every minute to purge empty sites and abandoned account collections.
		app.Cron().Add("hyttahub_cleanup", "*/1 * * * *", func() {
			log.Printf("[hyttahub] Running orphaned collection cleanup...")

			collections, err := app.FindAllCollections()
			if err != nil {
				log.Printf("[hyttahub] CRON ERROR: failed to list collections: %v", err)
				return
			}

			// 1. Identify "Parent" status
			// sitePrefix -> exists?
			siteStatus := make(map[string]bool)
			// email -> exists?
			userStatus := make(map[string]bool)

			// Fast pass to find roots
			for _, c := range collections {
				if strings.HasSuffix(c.Name, "__site_users") {
					prefix := strings.TrimSuffix(c.Name, "__site_users")
					count, _ := app.CountRecords(c.Name)
					siteStatus[prefix] = count > 0
				}
			}

			for _, c := range collections {
				// skip internal and non-hyttahub collections
				if !strings.HasPrefix(c.Name, "hyttahub__") {
					continue
				}

				// --- Grace Period Check ---
				// If a collection was created very recently, don't delete it.
				// This prevents race conditions where the cron runs mid-initialization.
				if time.Since(c.Created.Time()) < 2*time.Minute {
					continue
				}

				// A. Empty Site Cleanup
				isDel := false
				for prefix, active := range siteStatus {
					if !active && strings.HasPrefix(c.Name, prefix) {
						log.Printf("[hyttahub] CRON: Deleting collection for empty site: %s", c.Name)
						if err := app.Delete(c); err != nil {
							log.Printf("[hyttahub] CRON ERROR deleting %s: %v", c.Name, err)
						}
						isDel = true
						break
					}
				}
				if isDel {
					continue
				}

				// B. Orphaned Site Data (Parent site_users missing entirely)
				if strings.Contains(c.Name, "__site_") && !strings.HasSuffix(c.Name, "__site_users") {
					parts := strings.Split(c.Name, "__site_")
					prefix := parts[0]
					if _, exists := siteStatus[prefix]; !exists {
						log.Printf("[hyttahub] CRON: Deleting orphaned sub-collection %s (site root missing)", c.Name)
						if err := app.Delete(c); err != nil {
							log.Printf("[hyttahub] CRON ERROR deleting %s: %v", c.Name, err)
						}
						continue
					}
				}

				// C. Orphaned Account Data
				if strings.Contains(c.Name, "__accounts__") {
					parts := strings.Split(c.Name, "__")
					emailChunk := ""
					for i, part := range parts {
						if part == "accounts" && i+1 < len(parts) {
							emailChunk = parts[i+1]
							break
						}
					}
					email := decodeSegment(emailChunk)
					active, exists := userStatus[email]
					if !exists {
						user, _ := app.FindAuthRecordByEmail("users", email)
						active = (user != nil)
						userStatus[email] = active
					}

					if !active {
						log.Printf("[hyttahub] CRON: Deleting collection for missing user %s: %s", email, c.Name)
						if err := app.Delete(c); err != nil {
							log.Printf("[hyttahub] CRON ERROR deleting %s: %v", c.Name, err)
						}
						continue
					}

					// Special case: empty account_events is also a sign of a wiped account
					if strings.HasSuffix(c.Name, "__account_events") {
						count, _ := app.CountRecords(c.Name)
						if count == 0 {
							log.Printf("[hyttahub] CRON: Deleting wiped account collection: %s", c.Name)
							if err := app.Delete(c); err != nil {
								log.Printf("[hyttahub] CRON ERROR deleting %s: %v", c.Name, err)
							}
						}
					}
				}
			}
			log.Printf("[hyttahub] Orphaned collection cleanup finished.")
		})

		se.Router.BindFunc(func(e *core.RequestEvent) error {
			reqPath := e.Request.URL.Path
			reqMethod := e.Request.Method

			// We only care about /api/collections/... requests
			if !strings.HasPrefix(reqPath, "/api/collections/") {
				return e.Next()
			}

			// Extract collection name from the path.
			// For example: /api/collections/hyttahub__tictactoe__accounts__eZkBiLmM__account_events/records
			parts := strings.Split(reqPath, "/")
			if len(parts) < 4 {
				return e.Next()
			}
			collectionName := parts[3]

			// --- Strict Prefix Check ---
			// We only manage collections starting with "hyttahub__"
			if !strings.HasPrefix(collectionName, "hyttahub__") {
				return e.Next()
			}

			// Check if it already exists
			_, err := app.FindCollectionByNameOrId(collectionName)
			if err == nil {
				return e.Next() // exists
			}

			log.Printf("[hyttahub] Middleware: %s %s (processing)", reqMethod, reqPath)

			// --- Refined Auto-Creation Logic ---
			// Identify the type of collection
			isSiteSub := strings.HasSuffix(collectionName, "__site_events") ||
				strings.HasSuffix(collectionName, "__site_emails") ||
				strings.HasSuffix(collectionName, "__site_files") ||
				strings.HasSuffix(collectionName, "__site_exports__export_request")

			isAccountSub := strings.Contains(collectionName, "__accounts__") &&
				(strings.HasSuffix(collectionName, "__account_events") ||
					strings.HasSuffix(collectionName, "__account_settings"))

			// 2. Defensive check for GET requests: don't resurrect deleted/missing entities
			if reqMethod == "GET" || reqMethod == "HEAD" {
				if isSiteSub {
					suffix := "__site_events"
					if strings.HasSuffix(collectionName, "__site_emails") {
						suffix = "__site_emails"
					} else if strings.HasSuffix(collectionName, "__site_files") {
						suffix = "__site_files"
					} else if strings.HasSuffix(collectionName, "__site_exports__export_request") {
						suffix = "__site_exports__export_request"
					}
					parentColName := strings.Split(collectionName, suffix)[0] + "__site_users"

					if _, err := app.FindCollectionByNameOrId(parentColName); err != nil {
						// Parent site_users is missing -> site is deleted. Don't resurrect.
						log.Printf("[hyttahub] Blocking resurrection of sub-collection %s (parent %s missing)", collectionName, parentColName)
						return e.Next()
					}
				} else if isAccountSub {
					// Extract user email and check if auth record exists
					parts := strings.Split(collectionName, "__")
					emailChunk := ""
					for i, part := range parts {
						if part == "accounts" && i+1 < len(parts) {
							emailChunk = parts[i+1]
							break
						}
					}
					email := decodeSegment(emailChunk)
					user, _ := app.FindAuthRecordByEmail("users", email)
					if user == nil {
						// User is gone -> account deleted. Don't resurrect.
						log.Printf("[hyttahub] Blocking resurrection of %s for deleted user %s", collectionName, email)
						return e.Next()
					}
				}
				// NOTICE: We and isRoot (site_users) fall through here and ARE allowed to be created on GET.
				// This allows the app to initialize listeners for new sites.
			}

			// 3. Create it
			log.Printf("[hyttahub] Auto-creating missing collection: %s", collectionName)
			if err := createHyttahubCollection(app, collectionName); err != nil {
				log.Printf("[hyttahub] ERROR auto-creating collection '%s': %v\n", collectionName, err)
				return apis.NewBadRequestError("Failed to auto-create collection", err)
			}

			return e.Next()
		})

		return se.Next()
	})

	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}

// createHyttahubCollection defines the schema and rules for dynamic hyttahub collections.
func createHyttahubCollection(app *pocketbase.PocketBase, collectionName string) error {
	// Skip internal PocketBase collections
	if !strings.HasPrefix(collectionName, "hyttahub__") {
		return nil
	}

	// Check if it already exists
	if _, err := app.FindCollectionByNameOrId(collectionName); err == nil {
		return nil // exists
	}

	// Ensure parent exists for sub-collections to avoid broken rules
	if strings.HasSuffix(collectionName, "__site_events") ||
		strings.HasSuffix(collectionName, "__site_emails") ||
		strings.HasSuffix(collectionName, "__site_files") ||
		strings.HasSuffix(collectionName, "__site_exports__export_request") {

		parent := ""
		if strings.HasSuffix(collectionName, "__site_exports__export_request") {
			parent = strings.Split(collectionName, "__site_exports")[0] + "__site_users"
		} else {
			suffix := "__site_events"
			if strings.HasSuffix(collectionName, "__site_emails") {
				suffix = "__site_emails"
			} else if strings.HasSuffix(collectionName, "__site_files") {
				suffix = "__site_files"
			}
			parent = strings.Split(collectionName, suffix)[0] + "__site_users"
		}

		if parent != "" {
			if err := createHyttahubCollection(app, parent); err != nil {
				return err
			}
		}
	}

	log.Printf("[hyttahub] auto-creating collection: %s\n", collectionName)

	col := core.NewBaseCollection(collectionName)

	var listRule, viewRule, createRule, updateRule, deleteRule *string

	if strings.HasSuffix(collectionName, "__site_users") {
		rule := "@request.auth.id != '' && @collection." + collectionName + ".doc_id ?= @request.auth.email"
		listRule = types.Pointer(rule)
		viewRule = types.Pointer(rule)
		createRule = types.Pointer("") // filtered in Go hook
		updateRule = types.Pointer(rule)
		deleteRule = types.Pointer(rule)
	} else if strings.HasSuffix(collectionName, "__site_events") || strings.HasSuffix(collectionName, "__site_emails") {
		usersColName := strings.Split(collectionName, "__site_events")[0]
		if strings.HasSuffix(collectionName, "__site_emails") {
			usersColName = strings.Split(collectionName, "__site_emails")[0]
		}
		usersColName += "__site_users"
		rule := "@request.auth.id != '' && @collection." + usersColName + ".doc_id ?= @request.auth.email"

		listRule = types.Pointer(rule)
		viewRule = types.Pointer(rule)
		createRule = types.Pointer(rule)
	} else if strings.HasSuffix(collectionName, "__site_exports__export_request") {
		usersColName := strings.Split(collectionName, "__site_exports")[0] + "__site_users"
		rule := "@request.auth.id != '' && @collection." + usersColName + ".doc_id ?= @request.auth.email"

		listRule = types.Pointer(rule)
		viewRule = types.Pointer(rule)
		createRule = types.Pointer(rule)
		updateRule = types.Pointer(rule)
	} else if strings.HasSuffix(collectionName, "__service_users") {
		rule := "@request.auth.id != '' && @collection." + collectionName + ".doc_id ?= @request.auth.email"
		listRule = types.Pointer(rule)
		viewRule = types.Pointer(rule)
		createRule = types.Pointer("") // filtered in Go hook
		updateRule = types.Pointer(rule)
		deleteRule = types.Pointer(rule)
	} else if strings.HasSuffix(collectionName, "__service_events") {
		listRule = types.Pointer("")   // public read
		viewRule = types.Pointer("")   // public read
		createRule = types.Pointer("") // handled via Go hook (allows firstServiceUser)
	} else if strings.HasSuffix(collectionName, "__site_files") {
		authRule := "@request.auth.id != ''"
		listRule = types.Pointer("") // public
		viewRule = types.Pointer("") // public
		createRule = types.Pointer(authRule)
		updateRule = types.Pointer(authRule)
		deleteRule = types.Pointer(authRule)
	} else if strings.Contains(collectionName, "__accounts__") {
		parts := strings.Split(collectionName, "__")
		emailChunk := ""
		for i, part := range parts {
			if part == "accounts" && i+1 < len(parts) {
				emailChunk = parts[i+1]
				break
			}
		}
		decoded := decodeSegment(emailChunk)
		rule := "@request.auth.email = '" + decoded + "'"
		listRule = types.Pointer(rule)
		viewRule = types.Pointer(rule)
		createRule = types.Pointer(rule)
		deleteRule = types.Pointer(rule)
		if !strings.HasSuffix(collectionName, "__account_events") {
			updateRule = types.Pointer(rule)
		}
	}

	col.ListRule = listRule
	col.ViewRule = viewRule
	col.CreateRule = createRule
	col.UpdateRule = updateRule
	col.DeleteRule = deleteRule

	col.Fields.Add(&core.TextField{
		Name: "doc_id",
	})

	eventFields := []core.Field{
		&core.TextField{Name: "p"}, // payload
		&core.NumberField{Name: "v"}, // version
		&core.DateField{
			Name: "t",
		}, // timestamp
	}

	memberFields := []core.Field{
		&core.NumberField{Name: "u"}, // member id
		&core.DateField{
			Name: "t",
		}, // timestamp
		&core.TextField{Name: "m"}, // markedForDeletion
	}

	var schemaFields []core.Field
	if strings.HasSuffix(collectionName, "__site_events") ||
		strings.HasSuffix(collectionName, "__account_events") ||
		strings.HasSuffix(collectionName, "__service_events") {
		schemaFields = eventFields
	}
	if strings.HasSuffix(collectionName, "__site_users") ||
		strings.HasSuffix(collectionName, "__service_users") {
		schemaFields = memberFields
	}
	if strings.HasSuffix(collectionName, "__site_files") {
		schemaFields = []core.Field{
			&core.FileField{
				Name:      "file",
				MaxSelect: 1,
				MaxSize:   10 * 1024 * 1024, // 10 MB
			},
		}
	}

	for _, f := range schemaFields {
		col.Fields.Add(f)
	}

	if err := app.Save(col); err != nil {
		log.Printf("[hyttahub] ERROR saving new collection %s: %v", collectionName, err)
		return err
	}

	log.Printf("[hyttahub] SUCCESSFULLY created collection '%s'\n", collectionName)
	return nil
}

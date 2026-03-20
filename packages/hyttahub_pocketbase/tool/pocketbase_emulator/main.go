package main

import (
	"encoding/base64"
	"fmt"
	"log"
	"os"
	"strings"
	"time"

	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/plugins/migratecmd"
	"github.com/pocketbase/pocketbase/tools/hook"
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

	registerAppHooks(app)

	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}

// registerAppHooks binds all hyttahub-specific logic and middleware to the app.
func registerAppHooks(app core.App) {

	// -------------------------------------------------------------------------
	// Firestore Rules Emulation: Complex Create Logic
	// -------------------------------------------------------------------------
	app.OnRecordCreateRequest().Bind(&hook.Handler[*core.RecordRequestEvent]{
		Func: func(e *core.RecordRequestEvent) error {
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
			if e.Record.GetString("t") == "" || e.Record.GetString("t") == "@now" {
				e.Record.Set("t", time.Now().UTC().Format("2006-01-02 15:04:05.000Z"))
			}
			// ---------------------------------

			// ── Service Users / Site Users ────────────────────────────────────────
			if strings.HasSuffix(colName, "__site_users") || strings.HasSuffix(colName, "__service_users") {
				count, err := app.CountRecords(colName)
				if err != nil {
					return err
				}
				if count == 0 {
					// First user — no auth required (mirrors Firestore firstServiceUser / firstSiteUser)
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
			if strings.HasSuffix(colName, "__service_events") {
				count, err := app.CountRecords(colName)
				if err != nil {
					return err
				}
				if count == 0 {
					return e.Next()
				}

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
		},
		Priority: -99999,
	})

	// -------------------------------------------------------------------------
	// Firestore Rules Emulation: Auto-Delete Empty Sites (Cleanup Logic)
	// -------------------------------------------------------------------------
	app.OnRecordAfterDeleteSuccess().BindFunc(func(e *core.RecordEvent) error {
		colName := e.Record.Collection().Name
		if colName == "users" {
			email := e.Record.GetString("email")
			if email != "" {
				log.Printf("[hyttahub] Auth user deleted (%s). Cleaning up account collections...", email)
				encodedEmail := encodeSegment(email)
				prefix := "hyttahub__"
				suffix := "__accounts__" + encodedEmail + "__"
				collections, _ := app.FindAllCollections()
				for _, c := range collections {
					if strings.HasPrefix(c.Name, prefix) && strings.Contains(c.Name, suffix) {
						log.Printf("[hyttahub] CASCADE: Deleting user collection: %s", c.Name)
						app.Delete(c)
					}
				}
			}
		}
		return e.Next()
	})

	app.OnRecordAfterUpdateSuccess().BindFunc(func(e *core.RecordEvent) error {
		colName := e.Record.Collection().Name
		if !strings.HasSuffix(colName, "__site_users") {
			return e.Next()
		}

		mValue := e.Record.GetString("m")
		copyValue := e.Record.GetString("MarkForCopy")

		if mValue == "" && copyValue == "" {
			return e.Next()
		}

		// ---------------------------------------------------------------------
		// Handle MarkForDeletion (m field)
		// ---------------------------------------------------------------------
		if mValue != "" {
			log.Printf("[hyttahub] DEBUG: Cascading mark triggered for %s (id=%s), mValue=%s", colName, e.Record.Id, mValue)

			mBytes, err := base64.StdEncoding.DecodeString(mValue)
			if err == nil {
				mInfo := &models.MarkForDeletion{}
				if err := proto.Unmarshal(mBytes, mInfo); err == nil {
					log.Printf("[hyttahub] DEBUG: MarkForDeletion reason received: %v", mInfo.DeleteReason)
					parts := strings.Split(colName, "__")
					if len(parts) >= 5 {
						appName := parts[1]
						siteId := parts[3]
						email := e.Record.GetString("doc_id")
						memberId := e.Record.GetInt("u")

						// Common helper to save an event (Site or Account)
						saveGenericEvent := func(targetColName string, version int, base64Payload string, eventType string) {
							log.Printf("[hyttahub] DEBUG:   -> Creating %s event (v=%d) in collection: %s", eventType, version, targetColName)
							col, _ := app.FindCollectionByNameOrId(targetColName)
							if col != nil {
								record := core.NewRecord(col)
								record.Set("doc_id", fmt.Sprintf("%d", version))
								record.Set("v", version)
								record.Set("p", base64Payload)
								record.Set("t", time.Now().UTC().Format("2006-01-02 15:04:05.000Z"))
								if err := app.Save(record); err != nil {
									log.Printf("[hyttahub] ERROR:     Failed to save event record: %v", err)
								} else {
									log.Printf("[hyttahub] DEBUG:     Event successfully saved.")
								}
							} else {
								log.Printf("[hyttahub] WARNING:   Collection %s not found. Event creation skipped.", targetColName)
							}
						}

						switch mInfo.DeleteReason {
						case models.MarkForDeletion_memberLeftSite:
							log.Printf("[hyttahub] DEBUG: Processing Member Left Site (%s) for user %s", siteId, email)

							// 1. Add LeaveSite to Site Events
							eventsCol := strings.TrimSuffix(colName, "__site_users") + "__site_events"
							lastRecords, _ := app.FindRecordsByFilter(eventsCol, "", "-v", 1, 0)
							newVersion := 1
							if len(lastRecords) > 0 {
								newVersion = lastRecords[0].GetInt("v") + 1
							}
							siteEvent := &models.SiteEvent{
								Version: int32(newVersion),
								Author:  int32(mInfo.Author),
								EventType: &models.SiteEvent_LeaveSite_{
									LeaveSite: &models.SiteEvent_LeaveSite{
										MemberId: int32(memberId),
									},
								},
							}
							eBytes, _ := proto.Marshal(siteEvent)
							saveGenericEvent(eventsCol, newVersion, base64.StdEncoding.EncodeToString(eBytes), "Site-Leave")

							// 2. Add LeaveSite to Account Events
							encodedEmail := encodeSegment(email)
							accEventsCol := fmt.Sprintf("hyttahub__%s__accounts__%s__account_events", appName, encodedEmail)
							lastAccRecords, _ := app.FindRecordsByFilter(accEventsCol, "", "-v", 1, 0)
							newAccVersion := 1
							if len(lastAccRecords) > 0 {
								newAccVersion = lastAccRecords[0].GetInt("v") + 1
							}
							accEvent := &models.AccountEvent{
								Version: int32(newAccVersion),
								EventType: &models.AccountEvent_LeaveSite{
									LeaveSite: siteId,
								},
							}
							aeBytes, _ := proto.Marshal(accEvent)
							saveGenericEvent(accEventsCol, newAccVersion, base64.StdEncoding.EncodeToString(aeBytes), "Account-Leave")

						case models.MarkForDeletion_memberRemovedFromSite:
							log.Printf("[hyttahub] DEBUG: Processing Member Removed From Site (%s) for user %s", siteId, email)

							// 1. Add RemoveMember to Site Events
							eventsCol := strings.TrimSuffix(colName, "__site_users") + "__site_events"
							lastRecords, _ := app.FindRecordsByFilter(eventsCol, "", "-v", 1, 0)
							newVersion := 1
							if len(lastRecords) > 0 {
								newVersion = lastRecords[0].GetInt("v") + 1
							}
							siteEvent := &models.SiteEvent{
								Version: int32(newVersion),
								Author:  int32(mInfo.Author),
								EventType: &models.SiteEvent_RemoveMember_{
									RemoveMember: &models.SiteEvent_RemoveMember{
										MemberId: int32(memberId),
									},
								},
							}
							eBytes, _ := proto.Marshal(siteEvent)
							saveGenericEvent(eventsCol, newVersion, base64.StdEncoding.EncodeToString(eBytes), "Site-Remove")

							// 2. Add RemoveSite to Account Events
							encodedEmail := encodeSegment(email)
							accEventsCol := fmt.Sprintf("hyttahub__%s__accounts__%s__account_events", appName, encodedEmail)
							lastAccRecords, _ := app.FindRecordsByFilter(accEventsCol, "", "-v", 1, 0)
							newAccVersion := 1
							if len(lastAccRecords) > 0 {
								newAccVersion = lastAccRecords[0].GetInt("v") + 1
							}
							accEvent := &models.AccountEvent{
								Version: int32(newAccVersion),
								EventType: &models.AccountEvent_RemoveSite{
									RemoveSite: siteId,
								},
							}
							aeBytes, _ := proto.Marshal(accEvent)
							saveGenericEvent(accEventsCol, newAccVersion, base64.StdEncoding.EncodeToString(aeBytes), "Account-Remove")
						}
					}
				} else {
					log.Printf("[hyttahub] ERROR: Failed to unmarshal MarkForDeletion proto: %v", err)
				}
			} else {
				log.Printf("[hyttahub] ERROR: Failed to decode m field base64: %v", err)
			}

			log.Printf("[hyttahub] DEBUG: Deleting original user-site linkage record (id=%s)", e.Record.Id)
			if err := app.Delete(e.Record); err != nil {
				log.Printf("[hyttahub] ERROR: Failed to delete site user record: %v", err)
				return err
			}

			// Immediate Orphan Cleanup: If this was the last user, delete the site collections.
			count, _ := app.CountRecords(colName)
			if count == 0 {
				log.Printf("[hyttahub] CASCADE: Last user removed from %s. Deleting site collections...", colName)
				parts := strings.Split(colName, "__")
				if len(parts) >= 4 {
					prefix := strings.Join(parts[0:len(parts)-1], "__") + "__"
					collections, _ := app.FindAllCollections()
					for _, c := range collections {
						if strings.HasPrefix(c.Name, prefix) {
							log.Printf("[hyttahub] CASCADE: Deleting orphaned site collection: %s", c.Name)
							app.Delete(c)
						}
					}
				}
			}
		}

		// ---------------------------------------------------------------------
		// Handle MarkForCopy
		// ---------------------------------------------------------------------
		if copyValue != "" {
			log.Printf("[hyttahub] DEBUG: MarkForCopy triggered for %s (id=%s)", colName, e.Record.Id)
			copyBytes, err := base64.StdEncoding.DecodeString(copyValue)
			if err == nil {
				copyInfo := &models.MarkForCopy{}
				if err := proto.Unmarshal(copyBytes, copyInfo); err == nil {
					parts := strings.Split(colName, "__")
					if len(parts) >= 5 {
						appName := parts[1]
						sourceSiteId := parts[3]
						email := e.Record.GetString("doc_id")

						// 1. Generate a new Site ID
						newSiteId := fmt.Sprintf("copy-%d", time.Now().Unix())
						log.Printf("[hyttahub] COPY: Copying site %s to %s for user %s (upToVersion=%d)", sourceSiteId, newSiteId, email, copyInfo.UpToVersion)

						// 2. Create the new site_users collection
						newPrefix := fmt.Sprintf("hyttahub__%s__sites__%s", appName, newSiteId)
						if err := createHyttahubCollection(app, newPrefix+"__site_users"); err != nil {
							log.Printf("[hyttahub] ERROR: Failed to create new site_users: %v", err)
						}

						// 3. Copy Site Events (up to specified version)
						srcEventsCol := strings.TrimSuffix(colName, "__site_users") + "__site_events"
						dstEventsCol := newPrefix + "__site_events"

						srcEvents, _ := app.FindRecordsByFilter(srcEventsCol, "", "v", 0, 0)
						var siteName string
						maxV := int32(0)

						for _, srcEv := range srcEvents {
							v := srcEv.GetInt("v")
							if copyInfo.UpToVersion > 0 && int32(v) > copyInfo.UpToVersion {
								continue
							}

							// Extract site name from the NewSite event if possible
							pBase64 := srcEv.GetString("p")
							pBytes, _ := base64.StdEncoding.DecodeString(pBase64)
							event := &models.SiteEvent{}
							if err := proto.Unmarshal(pBytes, event); err == nil {
								if event.GetNewSite() != nil {
									siteName = event.GetNewSite().SiteName
								}
								if int32(v) > maxV {
									maxV = int32(v)
								}
							}

							// Save to new destination site
							col, _ := app.FindCollectionByNameOrId(dstEventsCol)
							newEv := core.NewRecord(col)
							newEv.Set("doc_id", srcEv.GetString("doc_id"))
							newEv.Set("v", v)
							newEv.Set("p", pBase64)
							newEv.Set("t", srcEv.GetString("t"))
							app.Save(newEv)
						}

						// 4. Create an ImportEvent in the new site
						maxV++
						importEvent := &models.SiteEvent{
							Version: maxV,
							Author:  copyInfo.Author,
							EventType: &models.SiteEvent_ImportEvent_{
								ImportEvent: &models.SiteEvent_ImportEvent{
									SiteName: siteName,
								},
							},
						}
						ieBytes, _ := proto.Marshal(importEvent)
						col, _ := app.FindCollectionByNameOrId(dstEventsCol)
						ieRecord := core.NewRecord(col)
						ieRecord.Set("doc_id", fmt.Sprintf("%d", maxV))
						ieRecord.Set("v", maxV)
						ieRecord.Set("p", base64.StdEncoding.EncodeToString(ieBytes))
						ieRecord.Set("t", time.Now().UTC().Format("2006-01-02 15:04:05.000Z"))
						app.Save(ieRecord)

						// 5. Add the copying user as a member to the new site
						usersCol, _ := app.FindCollectionByNameOrId(newPrefix + "__site_users")
						userRec := core.NewRecord(usersCol)
						userRec.Set("doc_id", email)
						userRec.Set("u", copyInfo.Author)
						userRec.Set("t", time.Now().UTC().Format("2006-01-02 15:04:05.000Z"))
						app.Save(userRec)

						// 6. Copy files
						srcFilesCol := strings.TrimSuffix(colName, "__site_users") + "__site_files"
						dstFilesCol := newPrefix + "__site_files"
						srcFiles, _ := app.FindRecordsByFilter(srcFilesCol, "", "", 0, 0)
						for _, srcFile := range srcFiles {
							fcol, _ := app.FindCollectionByNameOrId(dstFilesCol)
							newFile := core.NewRecord(fcol)
							newFile.Set("doc_id", srcFile.GetString("doc_id"))
							// Minimal file metadata copy — actual binary data shared in emulator
							newFile.Set("file", srcFile.Get("file"))
							app.Save(newFile)
						}

						log.Printf("[hyttahub] COPY: Site copy from %s to %s completed.", sourceSiteId, newSiteId)
					}
				}
			}

			// Clear the MarkForCopy field on the original record and save
			e.Record.Set("MarkForCopy", "")
			app.Save(e.Record)
		}

		return e.Next()
	})

	// -------------------------------------------------------------------------
	// Auto-collection middleware via explicit router intercept
	// -------------------------------------------------------------------------
	app.OnServe().Bind(&hook.Handler[*core.ServeEvent]{
		Func: func(se *core.ServeEvent) error {
			// Serve static files from pb_public
			se.Router.GET("/{path...}", apis.Static(os.DirFS(app.DataDir()+"/../pb_public"), false))

			// Add a catch-all route for other methods to ensure middleware runs
			se.Router.POST("/{path...}", func(e *core.RequestEvent) error { return e.Next() })
			se.Router.DELETE("/{path...}", func(e *core.RequestEvent) error { return e.Next() })
			se.Router.PATCH("/{path...}", func(e *core.RequestEvent) error { return e.Next() })

			se.Router.Bind(&hook.Handler[*core.RequestEvent]{
				Func: func(e *core.RequestEvent) error {
					reqPath := e.Request.URL.Path
					reqMethod := e.Request.Method

					// We only care about /api/collections/... requests
					if !strings.HasPrefix(reqPath, "/api/collections/") {
						return e.Next()
					}

					parts := strings.Split(reqPath, "/")
					if len(parts) < 4 {
						return e.Next()
					}
					collectionName := parts[3]

					if !strings.HasPrefix(collectionName, "hyttahub__") {
						return e.Next()
					}

					// Check if it already exists
					_, err := app.FindCollectionByNameOrId(collectionName)
					if err == nil {
						return e.Next() // exists
					}

					log.Printf("[hyttahub] Middleware: %s %s (processing missing collection %s)", reqMethod, reqPath, collectionName)

					// Defensive checks: block "leaf" collections on GET/HEAD/OPTIONS if their dependencies aren't met.
					// We only want to auto-create "leaf" collections during WRITES (POST/PATCH/DELETE) 
					// because writes correctly trigger parent creation first if needed (via Forward Cascade).
					if reqMethod == "GET" || reqMethod == "HEAD" || reqMethod == "OPTIONS" {
						if strings.Contains(collectionName, "__site_") && !strings.HasSuffix(collectionName, "__site_users") {
							// Determine parent (site_users)
							prefix := strings.Split(collectionName, "__site_")[0]
							parent := prefix + "__site_users"
							if _, err := app.FindCollectionByNameOrId(parent); err != nil {
								log.Printf("[hyttahub] Blocking access to leaf collection %s (parent %s not found)", collectionName, parent)
								return e.Next()
							}
						} else if strings.HasSuffix(collectionName, "__service_events") {
							prefix := strings.TrimSuffix(collectionName, "__service_events")
							parent := prefix + "__service_users"
							if _, err := app.FindCollectionByNameOrId(parent); err != nil {
								log.Printf("[hyttahub] Blocking access to leaf collection %s (parent %s not found)", collectionName, parent)
								return e.Next()
							}
						} else if strings.Contains(collectionName, "__accounts__") {
							// For account sub-collections, ensure the auth user exists.
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
								log.Printf("[hyttahub] Blocking resurrection for deleted user %s", email)
								return e.Next()
							}
						}
					}

					// 3. Create it
					log.Printf("[hyttahub] Auto-creating missing collection: %s", collectionName)
					if err := createHyttahubCollection(app, collectionName); err != nil {
						log.Printf("[hyttahub] ERROR auto-creating collection '%s': %v\n", collectionName, err)
						return apis.NewBadRequestError("Failed to auto-create collection", err)
					}

					return e.Next()
				},
				Priority: -99999,
			})

			return se.Next()
		},
		Priority: -99999,
	})
}



func createHyttahubCollection(app core.App, collectionName string) error {
	if !strings.HasPrefix(collectionName, "hyttahub__") {
		return nil
	}
	if _, err := app.FindCollectionByNameOrId(collectionName); err == nil {
		return nil
	}
	// Reverse Cascade Verification: Ensure parent exists before child.
	// We no longer trigger auto-creation of the parent from the child to avoid dangling collections created by clients.
	if strings.Contains(collectionName, "__site_") && !strings.HasSuffix(collectionName, "__site_users") {
		prefix := strings.Split(collectionName, "__site_")[0]
		parent := prefix + "__site_users"
		if _, err := app.FindCollectionByNameOrId(parent); err != nil {
			return fmt.Errorf("missing prerequisite collection %s for %s", parent, collectionName)
		}
	} else if strings.HasSuffix(collectionName, "__service_events") {
		prefix := strings.TrimSuffix(collectionName, "__service_events")
		parent := prefix + "__service_users"
		if _, err := app.FindCollectionByNameOrId(parent); err != nil {
			return fmt.Errorf("missing prerequisite collection %s for %s", parent, collectionName)
		}
	}

	col := core.NewBaseCollection(collectionName)
	var listRule, viewRule, createRule, updateRule, deleteRule *string

	if strings.HasSuffix(collectionName, "__site_users") {
		rule := "@request.auth.id != '' && @collection." + collectionName + ".doc_id ?= @request.auth.email"
		listRule, viewRule, createRule, updateRule, deleteRule = types.Pointer(rule), types.Pointer(rule), types.Pointer(""), types.Pointer(rule), types.Pointer(rule)
	} else if strings.HasSuffix(collectionName, "__site_events") {
		prefix := strings.Split(collectionName, "__site_")[0]
		usersColName := prefix + "__site_users"
		rule := "@request.auth.id != '' && @collection." + usersColName + ".doc_id ?= @request.auth.email"
		listRule, viewRule, createRule = types.Pointer(rule), types.Pointer(rule), types.Pointer(rule)
	} else if strings.HasSuffix(collectionName, "__service_users") {
		rule := "@request.auth.id != '' && @collection." + collectionName + ".doc_id ?= @request.auth.email"
		listRule, viewRule, createRule, updateRule, deleteRule = types.Pointer(rule), types.Pointer(rule), types.Pointer(""), types.Pointer(rule), types.Pointer(rule)
	} else if strings.HasSuffix(collectionName, "__service_events") {
		listRule, viewRule, createRule = types.Pointer(""), types.Pointer(""), types.Pointer("")
	} else if strings.HasSuffix(collectionName, "__site_files") {
		prefix := strings.Split(collectionName, "__site_files")[0]
		usersColName := prefix + "__site_users"
		rule := "@request.auth.id != '' && @collection." + usersColName + ".doc_id ?= @request.auth.email"
		listRule, viewRule, createRule, updateRule, deleteRule = types.Pointer(rule), types.Pointer(rule), types.Pointer(rule), types.Pointer(rule), types.Pointer(rule)
	} else if strings.Contains(collectionName, "__accounts__") {
		parts := strings.Split(collectionName, "__")
		emailChunk := ""
		for i, part := range parts { if part == "accounts" && i+1 < len(parts) { emailChunk = parts[i+1]; break } }
		email := decodeSegment(emailChunk)
		rule := "@request.auth.id != '' && @request.auth.email = \"" + email + "\""
		listRule, viewRule, createRule, deleteRule = types.Pointer(rule), types.Pointer(rule), types.Pointer(rule), types.Pointer(rule)
		if !strings.HasSuffix(collectionName, "__account_events") { updateRule = types.Pointer(rule) }
	}

	col.ListRule, col.ViewRule, col.CreateRule, col.UpdateRule, col.DeleteRule = listRule, viewRule, createRule, updateRule, deleteRule
	col.Fields.Add(&core.TextField{Name: "doc_id"})
	if strings.HasSuffix(collectionName, "_events") {
		col.Fields.Add(&core.TextField{Name: "p"})
		col.Fields.Add(&core.NumberField{Name: "v"})
		col.Fields.Add(&core.DateField{Name: "t"})
	} else if strings.HasSuffix(collectionName, "_users") {
		col.Fields.Add(&core.NumberField{Name: "u"})
		col.Fields.Add(&core.DateField{Name: "t"})
		col.Fields.Add(&core.TextField{Name: "m"})
		col.Fields.Add(&core.TextField{Name: "MarkForCopy"})
	} else if strings.HasSuffix(collectionName, "__site_files") {
		col.Fields.Add(&core.FileField{Name: "file", MaxSelect: 1, MaxSize: 10 * 1024 * 1024})
	}

	// Final check before save to avoid re-entrancy issues with cascading
	if _, err := app.FindCollectionByNameOrId(collectionName); err == nil {
		return nil
	}

	if err := app.Save(col); err != nil {
		return err
	}

	// Forward Cascade: create children when parent is created.
	if strings.HasSuffix(collectionName, "__site_users") {
		prefix := strings.TrimSuffix(collectionName, "__site_users")
		createHyttahubCollection(app, prefix+"__site_events")
		createHyttahubCollection(app, prefix+"__site_files")
	} else if strings.HasSuffix(collectionName, "__service_users") {
		prefix := strings.TrimSuffix(collectionName, "__service_users")
		createHyttahubCollection(app, prefix+"__service_events")
	}

	return nil
}

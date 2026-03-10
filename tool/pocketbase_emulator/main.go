package main

import (
	"encoding/base64"
	"log"
	"os"
	"strings"

	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/plugins/migratecmd"
	"github.com/pocketbase/pocketbase/tools/types"

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
		log.Printf("[hyttahub] DEBUG: OnRecordAfterDeleteSuccess triggered for collection: %s", colName)

		// We only care if the last user leaves a site
		if !strings.HasSuffix(colName, "__site_users") {
			return e.Next()
		}

		count, err := app.CountRecords(colName)
		if err != nil {
			log.Printf("[hyttahub] ERROR counting %s after delete: %v", colName, err)
			return e.Next()
		}

		if count == 0 {
			sitePrefix := strings.TrimSuffix(colName, "__site_users")
			log.Printf("[hyttahub] Site %s is empty. Auto-deleting all related collections...", sitePrefix)

			collections, err := app.FindAllCollections()
			if err != nil {
				log.Printf("[hyttahub] ERROR querying collections for deletion: %v", err)
				return e.Next()
			}

			for _, c := range collections {
				if strings.HasPrefix(c.Name, sitePrefix) {
					log.Printf("[hyttahub] Auto-deleting collection: %s", c.Name)
					if err := app.Delete(c); err != nil {
						log.Printf("[hyttahub] ERROR deleting %s: %v", c.Name, err)
					}
				}
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

		// Count users that are NOT marked for deletion
		records, err := app.FindRecordsByFilter(
			colName,
			"m = ''",
			"",
			1,
			0,
			nil,
		)
		if err != nil {
			log.Printf("[hyttahub] ERROR querying active users in %s: %v", colName, err)
			return e.Next()
		}

		// If no active users remain, drop the site
		if len(records) == 0 {
			sitePrefix := strings.TrimSuffix(colName, "__site_users")
			log.Printf("[hyttahub] Site %s has no active users remaining. Auto-deleting all related collections...", sitePrefix)

			collections, err := app.FindAllCollections()
			if err != nil {
				log.Printf("[hyttahub] ERROR querying collections for deletion: %v", err)
				return e.Next()
			}

			for _, c := range collections {
				if strings.HasPrefix(c.Name, sitePrefix) {
					log.Printf("[hyttahub] Auto-deleting collection: %s", c.Name)
					if err := app.Delete(c); err != nil {
						log.Printf("[hyttahub] ERROR deleting %s: %v", c.Name, err)
					}
				}
			}
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

		se.Router.BindFunc(func(e *core.RequestEvent) error {
			reqPath := e.Request.URL.Path

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

			// Skip internal PocketBase collections
			if !strings.HasPrefix(collectionName, "hyttahub__") {
				return e.Next()
			}

			// Check if it already exists
			_, err := app.FindCollectionByNameOrId(collectionName)
			if err == nil {
				return e.Next() // exists
			}

			log.Printf("[hyttahub] auto-creating collection: %s\n", collectionName)

			// Doesn't exist, create it dynamically
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
				listRule = types.Pointer("") // public read
				viewRule = types.Pointer("") // public read
				createRule = types.Pointer("") // handled via Go hook (allows firstServiceUser)
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
				&core.TextField{Name: "t"}, // timestamp
			}

			memberFields := []core.Field{
				&core.NumberField{Name: "u"}, // member id
				&core.TextField{Name: "t"}, // timestamp
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

			for _, f := range schemaFields {
				col.Fields.Add(f)
			}

			if err := app.Save(col); err != nil {
				log.Printf("[hyttahub] ERROR creating collection '%s': %v\n", collectionName, err)
				return apis.NewBadRequestError("Failed to auto-create collection", err)
			}

			log.Printf("[hyttahub] created '%s'\n", collectionName)

			return e.Next()
		})

		return se.Next()
	})

	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}

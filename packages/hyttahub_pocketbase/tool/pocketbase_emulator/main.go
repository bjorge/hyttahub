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

func generateId() string {
	const validChars = "123456789ABCDE"
	const allValidChars = "123456789ABCDEFG"

	seed := uint64(time.Now().UnixNano())
	firstChar := validChars[int(seed%uint64(len(validChars)))]

	remainingChars := make([]byte, 7)
	for i := 0; i < 7; i++ {
		seed = seed*1103515245 + 12345
		remainingChars[i] = allValidChars[int((seed>>16)%uint64(len(allValidChars)))]
	}

	return string(firstChar) + string(remainingChars)
}

func main() {
	app := pocketbase.New()
	log.Printf("[hyttahub] Starting PocketBase Emulator v1.2 (with copy support)...")

	migratecmd.MustRegister(app, app.RootCmd, migratecmd.Config{
		Automigrate: true,
	})

	registerAppHooks(app)

	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}

func registerAppHooks(app core.App) {

	// -------------------------------------------------------------------------
	// Firestore Rules Emulation: Complex Create Logic
	// -------------------------------------------------------------------------
	app.OnRecordCreateRequest().Bind(&hook.Handler[*core.RecordRequestEvent]{
		Func: func(e *core.RecordRequestEvent) error {
			colName := e.Record.Collection().Name

			if !strings.HasPrefix(colName, "hyttahub__") {
				return e.Next()
			}

			if e.HasSuperuserAuth() {
				return e.Next()
			}

			if e.Record.GetString("t") == "" || e.Record.GetString("t") == "@now" {
				e.Record.Set("t", time.Now().UTC().Format("2006-01-02 15:04:05.000Z"))
			}

			if strings.HasSuffix(colName, "__site_users") || strings.HasSuffix(colName, "__service_users") {
				count, _ := app.CountRecords(colName)
				if count == 0 {
					return e.Next()
				}

				authEmail := ""
				if e.Auth != nil { authEmail = e.Auth.GetString("email") }
				if authEmail == "" { return apis.NewUnauthorizedError("Unauthorized", nil) }

				records, err := app.FindRecordsByFilter(colName, "doc_id = {:email}", "", 1, 0, dbx.Params{"email": authEmail})
				if err != nil || len(records) == 0 {
					return apis.NewForbiddenError("Only existing members can add users", nil)
				}
				return e.Next()
			}

			if strings.HasSuffix(colName, "__service_events") {
				count, _ := app.CountRecords(colName)
				if count == 0 { return e.Next() }

				authEmail := ""
				if e.Auth != nil { authEmail = e.Auth.GetString("email") }
				if authEmail == "" { return apis.NewUnauthorizedError("Unauthorized", nil) }

				usersColName := strings.ReplaceAll(colName, "__service_events", "__service_users")
				records, err := app.FindRecordsByFilter(usersColName, "doc_id = {:email}", "", 1, 0, dbx.Params{"email": authEmail})
				if err != nil || len(records) == 0 {
					return apis.NewForbiddenError("Only service members can create events", nil)
				}
				return e.Next()
			}

			if strings.HasSuffix(colName, "__site_files") {
				authEmail := ""
				if e.Auth != nil { authEmail = e.Auth.GetString("email") }
				if authEmail == "" { return apis.NewUnauthorizedError("Unauthorized", nil) }

				usersColName := strings.ReplaceAll(colName, "__site_files", "__site_users")
				records, err := app.FindRecordsByFilter(usersColName, "doc_id = {:email}", "", 1, 0, dbx.Params{"email": authEmail})
				if err != nil || len(records) == 0 {
					return apis.NewForbiddenError("Only site members can upload files", nil)
				}
				return e.Next()
			}

			authEmail := ""
			if e.Auth != nil { authEmail = e.Auth.GetString("email") }
			if authEmail == "" { return apis.NewUnauthorizedError("Unauthorized", nil) }

			return e.Next()
		},
		Priority: -99999,
	})

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

		parts := strings.Split(colName, "__")
		if len(parts) < 5 {
			return e.Next()
		}
		appName := parts[1]
		email := e.Record.GetString("doc_id")

		saveGenericEvent := func(targetColName string, version int, base64Payload string, eventType string) {
			log.Printf("[hyttahub]   -> Creating %s event (v=%d) in collection: %s", eventType, version, targetColName)
			col, _ := app.FindCollectionByNameOrId(targetColName)
			if col != nil {
				record := core.NewRecord(col)
				record.Set("doc_id", fmt.Sprintf("%d", version))
				record.Set("v", version)
				record.Set("p", base64Payload)
				record.Set("t", time.Now().UTC().Format("2006-01-02 15:04:05.000Z"))
				if err := app.Save(record); err != nil {
					log.Printf("[hyttahub] ERROR saving event record: %v", err)
				} else {
					log.Printf("[hyttahub] Event record %d saved successfully.", version)
				}
			} else {
				log.Printf("[hyttahub] ERROR: Collection %s not found.", targetColName)
			}
		}

		// ---------------------------------------------------------------------
		// Handle MarkForDeletion (m field)
		// ---------------------------------------------------------------------
		if mValue != "" {
			log.Printf("[hyttahub] CASCADE: Processing MarkForDeletion for %s", email)
			mBytes, err := base64.StdEncoding.DecodeString(mValue)
			if err == nil {
				mInfo := &models.MarkForDeletion{}
				if err := proto.Unmarshal(mBytes, mInfo); err == nil {
					siteId := parts[3]
					memberId := e.Record.GetInt("u")
					switch mInfo.DeleteReason {
					case models.MarkForDeletion_memberLeftSite:
						log.Printf("[hyttahub] CASCADE: Processing Member Left Site (%s)", siteId)
						eventsCol := strings.TrimSuffix(colName, "__site_users") + "__site_events"
						lastRecords, _ := app.FindRecordsByFilter(eventsCol, "", "-v", 1, 0)
						newVersion := 1
						if len(lastRecords) > 0 { newVersion = lastRecords[0].GetInt("v") + 1 }
						siteEvent := &models.SiteEvent{
							Version: int32(newVersion), Author: int32(mInfo.Author),
							EventType: &models.SiteEvent_LeaveSite_{ LeaveSite: &models.SiteEvent_LeaveSite{ MemberId: int32(memberId) } },
						}
						eBytes, _ := proto.Marshal(siteEvent)
						saveGenericEvent(eventsCol, newVersion, base64.StdEncoding.EncodeToString(eBytes), "Site-Leave")

						encodedEmail := encodeSegment(email)
						accEventsCol := fmt.Sprintf("hyttahub__%s__accounts__%s__account_events", appName, encodedEmail)
						lastAccRecords, _ := app.FindRecordsByFilter(accEventsCol, "", "-v", 1, 0)
						newAccVersion := 1
						if len(lastAccRecords) > 0 { newAccVersion = lastAccRecords[0].GetInt("v") + 1 }
						accEvent := &models.AccountEvent{
							Version: int32(newAccVersion),
							EventType: &models.AccountEvent_LeaveSite{ LeaveSite: siteId },
						}
						aeBytes, _ := proto.Marshal(accEvent)
						saveGenericEvent(accEventsCol, newAccVersion, base64.StdEncoding.EncodeToString(aeBytes), "Account-Leave")

					case models.MarkForDeletion_memberRemovedFromSite:
						log.Printf("[hyttahub] CASCADE: Processing Member Removed From Site (%s)", siteId)
						eventsCol := strings.TrimSuffix(colName, "__site_users") + "__site_events"
						lastRecords, _ := app.FindRecordsByFilter(eventsCol, "", "-v", 1, 0)
						newVersion := 1
						if len(lastRecords) > 0 { newVersion = lastRecords[0].GetInt("v") + 1 }
						siteEvent := &models.SiteEvent{
							Version: int32(newVersion), Author: int32(mInfo.Author),
							EventType: &models.SiteEvent_RemoveMember_{ RemoveMember: &models.SiteEvent_RemoveMember{ MemberId: int32(memberId) } },
						}
						eBytes, _ := proto.Marshal(siteEvent)
						saveGenericEvent(eventsCol, newVersion, base64.StdEncoding.EncodeToString(eBytes), "Site-Remove")

						encodedEmail := encodeSegment(email)
						accEventsCol := fmt.Sprintf("hyttahub__%s__accounts__%s__account_events", appName, encodedEmail)
						lastAccRecords, _ := app.FindRecordsByFilter(accEventsCol, "", "-v", 1, 0)
						newAccVersion := 1
						if len(lastAccRecords) > 0 { newAccVersion = lastAccRecords[0].GetInt("v") + 1 }
						accEvent := &models.AccountEvent{
							Version: int32(newAccVersion),
							EventType: &models.AccountEvent_RemoveSite{ RemoveSite: siteId },
						}
						aeBytes, _ := proto.Marshal(accEvent)
						saveGenericEvent(accEventsCol, newAccVersion, base64.StdEncoding.EncodeToString(aeBytes), "Account-Remove")
					}
				}
			}
			app.Delete(e.Record)
			count, _ := app.CountRecords(colName)
			if count == 0 {
				prefix := strings.Join(parts[0:len(parts)-1], "__") + "__"
				collections, _ := app.FindAllCollections()
				for _, c := range collections {
					if strings.HasPrefix(c.Name, prefix) { app.Delete(c) }
				}
			}
		}

		// ---------------------------------------------------------------------
		// Handle MarkForCopy
		// ---------------------------------------------------------------------
		if copyValue != "" {
			log.Printf("[hyttahub] COPY: MarkForCopy field detected for %s", email)
			copyBytes, _ := base64.StdEncoding.DecodeString(copyValue)
			copyInfo := &models.MarkForCopy{}
			if err := proto.Unmarshal(copyBytes, copyInfo); err == nil {
				sourceSiteId := parts[3]
				newSiteId := generateId()
				log.Printf("[hyttahub] COPY: Performing site copy: SOURCE=%s -> DEST=%s (upToVersion=%d)", sourceSiteId, newSiteId, copyInfo.UpToVersion)

				newPrefix := fmt.Sprintf("hyttahub__%s__sites__%s", appName, newSiteId)
				if err := createHyttahubCollection(app, newPrefix+"__site_users"); err != nil {
					log.Printf("[hyttahub] COPY ERROR: Failed to create site_users: %v", err)
				}

				srcEventsCol := strings.TrimSuffix(colName, "__site_users") + "__site_events"
				dstEventsCol := newPrefix + "__site_events"
				srcEvents, _ := app.FindRecordsByFilter(srcEventsCol, "", "v", 0, 0)
				var siteName string
				maxV := int32(0)
				for _, srcEv := range srcEvents {
					v := srcEv.GetInt("v")
					if copyInfo.UpToVersion > 0 && int32(v) > copyInfo.UpToVersion { continue }
					pBase64 := srcEv.GetString("p")
					pBytes, _ := base64.StdEncoding.DecodeString(pBase64)
					event := &models.SiteEvent{}
					if err := proto.Unmarshal(pBytes, event); err == nil {
						if event.GetNewSite() != nil { siteName = event.GetNewSite().SiteName }
						if int32(v) > maxV { maxV = int32(v) }
					}
					saveGenericEvent(dstEventsCol, v, pBase64, "Site-Event-Copy")
				}

				maxV++
				log.Printf("[hyttahub] COPY: Site name detected as: %s. Creating ImportEvent (v=%d)", siteName, maxV)
				importEvent := &models.SiteEvent{
					Version: maxV, Author:  copyInfo.Author,
					EventType: &models.SiteEvent_ImportEvent_{ ImportEvent: &models.SiteEvent_ImportEvent{ SiteName: siteName } },
				}
				ieBytes, _ := proto.Marshal(importEvent)
				saveGenericEvent(dstEventsCol, int(maxV), base64.StdEncoding.EncodeToString(ieBytes), "Site-Import-Event")

				usersCol, _ := app.FindCollectionByNameOrId(newPrefix + "__site_users")
				if usersCol != nil {
					userRec := core.NewRecord(usersCol)
					userRec.Set("doc_id", email)
					userRec.Set("u", copyInfo.Author)
					userRec.Set("t", time.Now().UTC().Format("2006-01-02 15:04:05.000Z"))
					if err := app.Save(userRec); err == nil {
						log.Printf("[hyttahub] COPY: Admin user link created for %s on new site.", email)
					}
				}

				srcFilesCol := strings.TrimSuffix(colName, "__site_users") + "__site_files"
				dstFilesCol := newPrefix + "__site_files"
				srcFiles, _ := app.FindRecordsByFilter(srcFilesCol, "", "", 0, 0)
				for _, srcFile := range srcFiles {
					fcol, _ := app.FindCollectionByNameOrId(dstFilesCol)
					if fcol == nil { break }
					newFile := core.NewRecord(fcol)
					newFile.Set("doc_id", srcFile.GetString("doc_id"))
					newFile.Set("file", srcFile.Get("file"))
					app.Save(newFile)
				}
				log.Printf("[hyttahub] COPY: %d files metadata entries duplicated.", len(srcFiles))

				encodedEmail := encodeSegment(email)
				accEventsCol := fmt.Sprintf("hyttahub__%s__accounts__%s__account_events", appName, encodedEmail)
				lastAccRecords, _ := app.FindRecordsByFilter(accEventsCol, "", "-v", 1, 0)
				newAccVersion := 1
				if len(lastAccRecords) > 0 { newAccVersion = lastAccRecords[0].GetInt("v") + 1 }
				
				log.Printf("[hyttahub] COPY: Adding CreateSite event to account stream (%s) at v=%d", accEventsCol, newAccVersion)
				accEvent := &models.AccountEvent{
					Version: int32(newAccVersion),
					EventType: &models.AccountEvent_CreateSite{ CreateSite: newSiteId },
				}
				aeBytes, _ := proto.Marshal(accEvent)
				saveGenericEvent(accEventsCol, newAccVersion, base64.StdEncoding.EncodeToString(aeBytes), "Account-Create-Event")
				
				log.Printf("[hyttahub] COPY SUCCESS: Site %s is ready.", newSiteId)
			}
			e.Record.Set("MarkForCopy", "")
			app.Save(e.Record)
		}
		return e.Next()
	})

	app.OnServe().Bind(&hook.Handler[*core.ServeEvent]{
		Func: func(se *core.ServeEvent) error {
			se.Router.GET("/{path...}", apis.Static(os.DirFS(app.DataDir()+"/../pb_public"), false))
			se.Router.POST("/{path...}", func(e *core.RequestEvent) error { return e.Next() })
			se.Router.DELETE("/{path...}", func(e *core.RequestEvent) error { return e.Next() })
			se.Router.PATCH("/{path...}", func(e *core.RequestEvent) error { return e.Next() })

			se.Router.Bind(&hook.Handler[*core.RequestEvent]{
				Func: func(e *core.RequestEvent) error {
					reqPath := e.Request.URL.Path
					reqMethod := e.Request.Method

					if !strings.HasPrefix(reqPath, "/api/collections/") { return e.Next() }
					parts := strings.Split(reqPath, "/")
					if len(parts) < 4 { return e.Next() }
					collectionName := parts[3]

					if !strings.HasPrefix(collectionName, "hyttahub__") { return e.Next() }

					col, err := app.FindCollectionByNameOrId(collectionName)
					if err == nil {
						if strings.HasSuffix(collectionName, "_users") {
							if col.Fields.GetByName("MarkForCopy") == nil {
								log.Printf("[hyttahub] Syncing MarkForCopy field: %s", collectionName)
								col.Fields.Add(&core.TextField{Name: "MarkForCopy"})
								app.Save(col)
							}
						}
						return e.Next()
					}

					if reqMethod == "GET" || reqMethod == "HEAD" || reqMethod == "OPTIONS" {
						if strings.Contains(collectionName, "__site_") && !strings.HasSuffix(collectionName, "__site_users") {
							prefix := strings.Split(collectionName, "__site_")[0]
							parent := prefix + "__site_users"
							if _, err := app.FindCollectionByNameOrId(parent); err != nil { return e.Next() }
						} else if strings.HasSuffix(collectionName, "__service_events") {
							prefix := strings.TrimSuffix(collectionName, "__service_events")
							parent := prefix + "__service_users"
							if _, err := app.FindCollectionByNameOrId(parent); err != nil { return e.Next() }
						} else if strings.Contains(collectionName, "__accounts__") {
							parts := strings.Split(collectionName, "__")
							emailChunk := ""
							for i, part := range parts { if part == "accounts" && i+1 < len(parts) { emailChunk = parts[i+1]; break } }
							email := decodeSegment(emailChunk)
							user, _ := app.FindAuthRecordByEmail("users", email)
							if user == nil { return e.Next() }
						}
					}

					if err := createHyttahubCollection(app, collectionName); err != nil {
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
	if !strings.HasPrefix(collectionName, "hyttahub__") { return nil }
	if _, err := app.FindCollectionByNameOrId(collectionName); err == nil { return nil }

	if strings.Contains(collectionName, "__site_") && !strings.HasSuffix(collectionName, "__site_users") {
		prefix := strings.Split(collectionName, "__site_")[0]
		parent := prefix + "__site_users"
		if _, err := app.FindCollectionByNameOrId(parent); err != nil {
			return fmt.Errorf("missing prerequisite collection %s", parent)
		}
	} else if strings.HasSuffix(collectionName, "__service_events") {
		prefix := strings.TrimSuffix(collectionName, "__service_events")
		parent := prefix + "__service_users"
		if _, err := app.FindCollectionByNameOrId(parent); err != nil {
			return fmt.Errorf("missing prerequisite collection %s", parent)
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

	if _, err := app.FindCollectionByNameOrId(collectionName); err == nil { return nil }
	if err := app.Save(col); err != nil { return err }

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

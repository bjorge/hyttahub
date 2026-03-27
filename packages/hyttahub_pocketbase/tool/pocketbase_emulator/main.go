package main

import (
	"crypto/sha1"
	"encoding/base64"
	"encoding/hex"
	"fmt"
	"log"
	"os"
	"strings"
	"time"

	"io"
	"path/filepath"

	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/plugins/migratecmd"
	"github.com/pocketbase/pocketbase/tools/hook"
	"github.com/pocketbase/pocketbase/tools/types"
	"google.golang.org/protobuf/proto"

	_ "pocketbase_emulator/migrations"
	"pocketbase_emulator/models"
)

var allowSelfJoin = false
var allowAnonymous = false


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

	app.RootCmd.PersistentFlags().BoolVar(
		&allowSelfJoin,
		"allow-self-join",
		os.Getenv("ALLOW_SELF_JOIN") == "1" || os.Getenv("ALLOW_SELF_JOIN") == "true",
		"Allow authenticated users to self-join sites",
	)
	app.RootCmd.PersistentFlags().BoolVar(
		&allowAnonymous,
		"allow-anonymous",
		os.Getenv("ALLOW_ANONYMOUS") == "1" || os.Getenv("ALLOW_ANONYMOUS") == "true",
		"Allow anonymous users via X-Auth-Email header",
	)

	log.Printf("[hyttahub] Starting PocketBase Emulator v1.2 (with copy support, allow-self-join=%v, allow-anonymous=%v)...", allowSelfJoin, allowAnonymous)

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

			if e.Record.GetString(FieldTimeStamp) == "" || e.Record.GetString(FieldTimeStamp) == "@now" {
				e.Record.Set(FieldTimeStamp, time.Now().UTC().Format("2006-01-02 15:04:05.000Z"))
			}

			if strings.HasSuffix(colName, SuffixSiteUsers) || strings.HasSuffix(colName, SuffixServiceUsers) {
				count, _ := app.CountRecords(colName)
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

				records, err := app.FindRecordsByFilter(colName, "doc_id = {:email}", "", 1, 0, dbx.Params{"email": authEmail})
				if err != nil || len(records) == 0 {
					// Allow self-join: user can add themselves to the site
					if allowSelfJoin && strings.HasSuffix(colName, SuffixSiteUsers) && e.Record.GetString("doc_id") == authEmail {
						return e.Next()
					}
					return apis.NewForbiddenError("Only existing members can add users", nil)
				}
				return e.Next()
			}

			if strings.HasSuffix(colName, "__service_events") {
				count, _ := app.CountRecords(colName)
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
				records, err := app.FindRecordsByFilter(usersColName, "doc_id = {:email}", "", 1, 0, dbx.Params{"email": authEmail})
				if err != nil || len(records) == 0 {
					return apis.NewForbiddenError("Only service members can create events", nil)
				}
				return e.Next()
			}

			if strings.HasSuffix(colName, "__site_files") {
				authEmail := ""
				if e.Auth != nil {
					authEmail = e.Auth.GetString("email")
				}
				if authEmail == "" {
					return apis.NewUnauthorizedError("Unauthorized", nil)
				}

				usersColName := strings.ReplaceAll(colName, SuffixSiteFiles, SuffixSiteUsers)
				records, err := app.FindRecordsByFilter(usersColName, FieldDocId+" = {:email}", "", 1, 0, dbx.Params{"email": authEmail})
				if err != nil || len(records) == 0 {
					return apis.NewForbiddenError("Only site members can upload files", nil)
				}
				return e.Next()
			}

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
		if !strings.HasSuffix(colName, SuffixSiteUsers) {
			return e.Next()
		}

		mValue := e.Record.GetString(FieldMarkDelete)
		copyValue := e.Record.GetString(FieldMarkCopy)
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
				record.Set(FieldDocId, fmt.Sprintf("%d", version))
				record.Set(FieldVersion, version)
				record.Set(FieldPayload, base64Payload)
				record.Set(FieldTimeStamp, time.Now().UTC().Format("2006-01-02 15:04:05.000Z"))
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
					memberId := e.Record.GetInt(FieldUserId)
					switch mInfo.DeleteReason {
					case models.MarkForDeletion_memberLeftSite:
						log.Printf("[hyttahub] CASCADE: Processing Member Left Site (%s)", siteId)
						eventsCol := strings.TrimSuffix(colName, SuffixSiteUsers) + SuffixSiteEvents
						lastRecords, _ := app.FindRecordsByFilter(eventsCol, "", "-v", 1, 0)
						newVersion := 1
						if len(lastRecords) > 0 {
							newVersion = lastRecords[0].GetInt(FieldVersion) + 1
						}
						siteEvent := &models.SiteEvent{
							Version: int32(newVersion), Author: int32(mInfo.Author),
							EventType: &models.SiteEvent_LeaveSite_{LeaveSite: &models.SiteEvent_LeaveSite{MemberId: int32(memberId)}},
						}
						eBytes, _ := proto.Marshal(siteEvent)
						saveGenericEvent(eventsCol, newVersion, base64.StdEncoding.EncodeToString(eBytes), "Site-Leave")

						encodedEmail := encodeSegment(email)
						accEventsCol := fmt.Sprintf("hyttahub__%s__accounts__%s__account_events", appName, encodedEmail)
						lastAccRecords, _ := app.FindRecordsByFilter(accEventsCol, "", "-v", 1, 0)
						newAccVersion := 1
						if len(lastAccRecords) > 0 {
							newAccVersion = lastAccRecords[0].GetInt("v") + 1
						}
						accEvent := &models.AccountEvent{
							Version:   int32(newAccVersion),
							EventType: &models.AccountEvent_LeaveSite{LeaveSite: siteId},
						}
						aeBytes, _ := proto.Marshal(accEvent)
						saveGenericEvent(accEventsCol, newAccVersion, base64.StdEncoding.EncodeToString(aeBytes), "Account-Leave")

					case models.MarkForDeletion_memberRemovedFromSite:
						log.Printf("[hyttahub] CASCADE: Processing Member Removed From Site (%s)", siteId)
						eventsCol := strings.TrimSuffix(colName, SuffixSiteUsers) + SuffixSiteEvents
						lastRecords, _ := app.FindRecordsByFilter(eventsCol, "", "-v", 1, 0)
						newVersion := 1
						if len(lastRecords) > 0 {
							newVersion = lastRecords[0].GetInt(FieldVersion) + 1
						}
						siteEvent := &models.SiteEvent{
							Version: int32(newVersion), Author: int32(mInfo.Author),
							EventType: &models.SiteEvent_RemoveMember_{RemoveMember: &models.SiteEvent_RemoveMember{MemberId: int32(memberId)}},
						}
						eBytes, _ := proto.Marshal(siteEvent)
						saveGenericEvent(eventsCol, newVersion, base64.StdEncoding.EncodeToString(eBytes), "Site-Remove")

						encodedEmail := encodeSegment(email)
						accEventsCol := fmt.Sprintf("hyttahub__%s__accounts__%s__account_events", appName, encodedEmail)
						lastAccRecords, _ := app.FindRecordsByFilter(accEventsCol, "", "-v", 1, 0)
						newAccVersion := 1
						if len(lastAccRecords) > 0 {
							newAccVersion = lastAccRecords[0].GetInt("v") + 1
						}
						accEvent := &models.AccountEvent{
							Version:   int32(newAccVersion),
							EventType: &models.AccountEvent_RemoveSite{RemoveSite: siteId},
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
					if strings.HasPrefix(c.Name, prefix) {
						app.Delete(c)
					}
				}
			}
		}

		// ---------------------------------------------------------------------
		// Handle Copy (c field)
		// ---------------------------------------------------------------------
		if copyValue != "" {
			log.Printf("[hyttahub] COPY: 'c' field detected for %s", email)
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

				srcEventsCol := strings.TrimSuffix(colName, SuffixSiteUsers) + SuffixSiteEvents
				dstEventsCol := newPrefix + SuffixSiteEvents
				srcEvents, _ := app.FindRecordsByFilter(srcEventsCol, "", "v", 0, 0)
				var siteName string
				maxV := int32(0)
				for _, srcEv := range srcEvents {
					v := srcEv.GetInt(FieldVersion)
					if copyInfo.UpToVersion > 0 && int32(v) > copyInfo.UpToVersion {
						continue
					}
					pBase64 := srcEv.GetString(FieldPayload)
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
					saveGenericEvent(dstEventsCol, v, pBase64, "Site-Event-Copy")
				}

				maxV++
				log.Printf("[hyttahub] COPY: Site name detected as: %s. Creating ImportEvent (v=%d)", siteName, maxV)
				importEvent := &models.SiteEvent{
					Version: maxV, Author: copyInfo.Author,
					EventType: &models.SiteEvent_ImportEvent_{ImportEvent: &models.SiteEvent_ImportEvent{}},
				}
				ieBytes, _ := proto.Marshal(importEvent)
				saveGenericEvent(dstEventsCol, int(maxV), base64.StdEncoding.EncodeToString(ieBytes), "Site-Import-Event")

				usersCol, _ := app.FindCollectionByNameOrId(newPrefix + SuffixSiteUsers)
				if usersCol != nil {
					userRec := core.NewRecord(usersCol)
					userRec.Set(FieldDocId, email)
					userRec.Set(FieldUserId, copyInfo.Author)
					userRec.Set(FieldTimeStamp, time.Now().UTC().Format("2006-01-02 15:04:05.000Z"))
					if err := app.Save(userRec); err == nil {
						log.Printf("[hyttahub] COPY: Admin user link created for %s on new site.", email)
					}
				}

				srcFilesCol := strings.TrimSuffix(colName, SuffixSiteUsers) + SuffixSiteFiles
				dstFilesCol := newPrefix + SuffixSiteFiles
				srcFiles, _ := app.FindRecordsByFilter(srcFilesCol, "", "", 0, 0)
				for _, srcFile := range srcFiles {
					fcol, _ := app.FindCollectionByNameOrId(dstFilesCol)
					if fcol == nil {
						break
					}
					newFile := core.NewRecord(fcol)
					newFile.Set(FieldDocId, srcFile.GetString(FieldDocId))
					filename := srcFile.GetString(FieldFile)
					// Save record first without the file field to avoid validation errors for missing files
					if err := app.Save(newFile); err == nil && filename != "" {
						srcPath := filepath.Join(app.DataDir(), "storage", srcFile.BaseFilesPath(), filename)
						dstPath := filepath.Join(app.DataDir(), "storage", newFile.BaseFilesPath(), filename)

						if err := os.MkdirAll(filepath.Dir(dstPath), 0755); err == nil {
							if err := copyFileLocal(srcPath, dstPath); err == nil {
								// Also copy .attrs if they exist
								copyFileLocal(srcPath+".attrs", dstPath+".attrs")

								// Use direct DB update to bypass PocketBase file field validation
								_, dbErr := app.DB().Update(newFile.Collection().Name, dbx.Params{"file": filename}, dbx.HashExp{"id": newFile.Id}).Execute()
								if dbErr != nil {
									log.Printf("[hyttahub] COPY ERROR: Failed to update file metadata for %s: %v", filename, dbErr)
								}
							} else {
								log.Printf("[hyttahub] COPY ERROR: Failed to copy physical file %s: %v", filename, err)
							}
						} else {
							log.Printf("[hyttahub] COPY ERROR: Failed to create directories for %s: %v", filename, err)
						}
					} else if err != nil {
						log.Printf("[hyttahub] COPY ERROR: Failed to create file record metadata for %s: %v", srcFile.GetString("doc_id"), err)
					}
				}
				log.Printf("[hyttahub] COPY: %d files processed.", len(srcFiles))

				encodedEmail := encodeSegment(email)
				accEventsCol := fmt.Sprintf("hyttahub__%s__accounts__%s__account_events", appName, encodedEmail)
				lastAccRecords, _ := app.FindRecordsByFilter(accEventsCol, "", "-v", 1, 0)
				newAccVersion := 1
				if len(lastAccRecords) > 0 {
					newAccVersion = lastAccRecords[0].GetInt(FieldVersion) + 1
				}

				log.Printf("[hyttahub] COPY: Adding CreateSite event to account stream (%s) at v=%d", accEventsCol, newAccVersion)
				accEvent := &models.AccountEvent{
					Version:   int32(newAccVersion),
					EventType: &models.AccountEvent_CreateSite{CreateSite: newSiteId},
				}
				aeBytes, _ := proto.Marshal(accEvent)
				saveGenericEvent(accEventsCol, newAccVersion, base64.StdEncoding.EncodeToString(aeBytes), "Account-Create-Event")

				log.Printf("[hyttahub] COPY SUCCESS: Site %s is ready.", newSiteId)
			}
			e.Record.Set("c", "")
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

					// Anonymous Auth support: populate e.Auth from X-Auth-Email header if present.
					if allowAnonymous && e.Auth == nil {
						if authEmail := e.Request.Header.Get("X-Auth-Email"); authEmail != "" {
							user, _ := app.FindAuthRecordByEmail("users", authEmail)
							if user == nil {
								// For anonymous auth, create a "virtual" record in-memory instead of saving to DB.
								usersCol, _ := app.FindCollectionByNameOrId("users")
								if usersCol != nil {
									user = core.NewRecord(usersCol)
									user.Set("email", authEmail)
									user.SetVerified(true)

									// Deterministic 15-char ID ensures consistency for ownership rules.
									h := sha1.Sum([]byte(authEmail))
									user.Id = hex.EncodeToString(h[:])[:15]
									log.Printf("[hyttahub] Header Auth: Virtual user for %s (id: %s) -> %s %s", authEmail, user.Id, reqMethod, reqPath)
								}
							} else {
								log.Printf("[hyttahub] Header Auth: Existing user for %s (id: %s) -> %s %s", authEmail, user.Id, reqMethod, reqPath)
							}
							if user != nil {
								e.Auth = user
							}
						}
					}

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

					// Skip auto-sync if prerequisites are missing for read operations.
					if reqMethod == "GET" || reqMethod == "HEAD" || reqMethod == "OPTIONS" {
						if strings.Contains(collectionName, "__site_") && !strings.HasSuffix(collectionName, "__site_users") {
							prefix := strings.Split(collectionName, "__site_")[0]
							parent := prefix + "__site_users"
							if _, err := app.FindCollectionByNameOrId(parent); err != nil {
								return e.Next()
							}
						} else if strings.HasSuffix(collectionName, "__service_events") {
							prefix := strings.TrimSuffix(collectionName, "__service_events")
							parent := prefix + "__service_users"
							if _, err := app.FindCollectionByNameOrId(parent); err != nil {
								return e.Next()
							}
						} else if strings.Contains(collectionName, "__accounts__") {
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
								return e.Next()
							}
						}
					}

					if err := createHyttahubCollection(app, collectionName); err != nil {
						return apis.NewBadRequestError("Failed to auto-sync collection", err)
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

	col, _ := app.FindCollectionByNameOrId(collectionName)

	if col != nil && strings.Contains(collectionName, "__site_") && !strings.HasSuffix(collectionName, "__site_users") {
		// Prerequisite check for existing site collections
	} else if col == nil {
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
	}

	isNew := false
	if col == nil {
		col = core.NewBaseCollection(collectionName)
		isNew = true
	}

	var listRule, viewRule, createRule, updateRule, deleteRule *string

	if strings.HasSuffix(collectionName, "__site_users") {
		rule := "@request.auth.id != '' && @collection." + collectionName + ".doc_id ?= @request.auth.email"
		listRule, viewRule, createRule, updateRule, deleteRule = types.Pointer(rule), types.Pointer(rule), types.Pointer(""), types.Pointer(rule), types.Pointer(rule)
	} else if strings.HasSuffix(collectionName, "__site_events") {
		prefix := strings.Split(collectionName, "__site_")[0]
		usersColName := prefix + "__site_users"
		rule := "@request.auth.id != '' && @collection." + usersColName + ".doc_id ?= @request.auth.email"
		if allowSelfJoin {
			rule = "@request.auth.id != ''"
		}
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
		for i, part := range parts {
			if part == "accounts" && i+1 < len(parts) {
				emailChunk = parts[i+1]
				break
			}
		}
		email := decodeSegment(emailChunk)
		rule := "@request.auth.id != '' && @request.auth.email = \"" + email + "\""
		listRule, viewRule, createRule, deleteRule = types.Pointer(rule), types.Pointer(rule), types.Pointer(rule), types.Pointer(rule)
		if !strings.HasSuffix(collectionName, "__account_events") {
			updateRule = types.Pointer(rule)
		}
	}

	col.ListRule, col.ViewRule, col.CreateRule, col.UpdateRule, col.DeleteRule = listRule, viewRule, createRule, updateRule, deleteRule

	addFieldIfMissing := func(name string, field core.Field) {
		if col.Fields.GetByName(name) == nil {
			col.Fields.Add(field)
		}
	}

	addFieldIfMissing(FieldDocId, &core.TextField{Name: FieldDocId})
	if strings.HasSuffix(collectionName, "_events") {
		addFieldIfMissing(FieldPayload, &core.TextField{Name: FieldPayload})
		addFieldIfMissing(FieldVersion, &core.NumberField{Name: FieldVersion})
		addFieldIfMissing(FieldTimeStamp, &core.DateField{Name: FieldTimeStamp})
	} else if strings.HasSuffix(collectionName, "_users") {
		addFieldIfMissing(FieldUserId, &core.NumberField{Name: FieldUserId})
		addFieldIfMissing(FieldTimeStamp, &core.DateField{Name: FieldTimeStamp})
		addFieldIfMissing(FieldMarkDelete, &core.TextField{Name: FieldMarkDelete})
		addFieldIfMissing(FieldMarkCopy, &core.TextField{Name: FieldMarkCopy})
	} else if strings.HasSuffix(collectionName, SuffixSiteFiles) {
		addFieldIfMissing(FieldFile, &core.FileField{Name: FieldFile, MaxSelect: 1, MaxSize: 10 * 1024 * 1024})
	}

	if err := app.Save(col); err != nil {
		return err
	}

	if isNew {
		if strings.HasSuffix(collectionName, "__site_users") {
			prefix := strings.TrimSuffix(collectionName, "__site_users")
			createHyttahubCollection(app, prefix+"__site_events")
			createHyttahubCollection(app, prefix+"__site_files")
		} else if strings.HasSuffix(collectionName, "__service_users") {
			prefix := strings.TrimSuffix(collectionName, "__service_users")
			createHyttahubCollection(app, prefix+"__service_events")
		}
	}

	return nil
}

func copyFileLocal(src, dst string) error {
	in, err := os.Open(src)
	if err != nil {
		return err
	}
	defer in.Close()
	out, err := os.Create(dst)
	if err != nil {
		return err
	}
	defer out.Close()
	_, err = io.Copy(out, in)
	return err
}

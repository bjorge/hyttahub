package main

import (
	"crypto/sha1"
	"encoding/base64"
	"encoding/hex"
	"fmt"
	"log"
	"os"
	"sync"
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

	log.Printf("[hyttahub] Starting PocketBase Emulator (Flat Schema)...")

	migratecmd.MustRegister(app, app.RootCmd, migratecmd.Config{
		Automigrate: true,
	})

	registerAppHooks(app)

	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}

var migrateMutex sync.Mutex

// migrate creates the 7 flat collections if they don't exist
func migrate(app core.App) error {
	migrateMutex.Lock()
	defer migrateMutex.Unlock()

	collections := []struct {
		Name     string
		IdField  string
		IsEvent  bool
		IsUser   bool
		IsFile   bool
		ListRule string
	}{
		{Name: ColSiteUsers, IdField: FieldSiteId, IsUser: true, ListRule: "@request.auth.id != '' && @collection.hyttahub_site_users.doc_id ?= @request.auth.email"},
		{Name: ColServiceUsers, IdField: FieldServiceId, IsUser: true, ListRule: "@request.auth.id != '' && @collection.hyttahub_service_users.doc_id ?= @request.auth.email"},
		{Name: ColBetaUsers, IdField: FieldServiceId, IsUser: true, ListRule: "@request.auth.id != '' && @collection.hyttahub_service_users.doc_id ?= @request.auth.email && @collection.hyttahub_service_users.serviceId ?= serviceId && @collection.hyttahub_service_users.app ?= app"},
		{Name: ColSiteEvents, IdField: FieldSiteId, IsEvent: true, ListRule: "@request.auth.id != '' && @collection.hyttahub_site_users.doc_id ?= @request.auth.email && @collection.hyttahub_site_users.siteId ?= siteId && @collection.hyttahub_site_users.app ?= app"},
		{Name: ColSiteFiles, IdField: FieldSiteId, IsFile: true, ListRule: "@request.auth.id != '' && @collection.hyttahub_site_users.doc_id ?= @request.auth.email && @collection.hyttahub_site_users.siteId ?= siteId && @collection.hyttahub_site_users.app ?= app"},
		{Name: ColAccountEvents, IdField: FieldAccountId, IsEvent: true, ListRule: "@request.auth.id != '' && @request.auth.email = accountId"},
		{Name: ColServiceEvents, IdField: FieldServiceId, IsEvent: true, ListRule: ""},
	}

	for _, cfg := range collections {
		col, _ := app.FindCollectionByNameOrId(cfg.Name)
		isNew := col == nil
		if isNew {
			col = core.NewBaseCollection(cfg.Name)
		}

		// Basic Rules
		if cfg.Name == ColSiteEvents && allowSelfJoin {
			col.ListRule = types.Pointer("@request.auth.id != ''")
			col.ViewRule = types.Pointer("@request.auth.id != ''")
			col.CreateRule = types.Pointer("@request.auth.id != ''")
			col.UpdateRule = nil
			col.DeleteRule = nil
		} else {
			col.ListRule = types.Pointer(cfg.ListRule)
			col.ViewRule = types.Pointer(cfg.ListRule)
			col.UpdateRule = nil
			col.DeleteRule = nil
			if cfg.IsEvent {
				if cfg.Name == ColServiceEvents {
					col.CreateRule = types.Pointer("")
				} else if cfg.Name == ColAccountEvents {
					col.CreateRule = types.Pointer("@request.auth.id != ''")
					col.DeleteRule = types.Pointer(cfg.ListRule)
				} else {
					col.CreateRule = types.Pointer(cfg.ListRule)
				}
			} else {
				// Users/Files
				col.CreateRule = types.Pointer("")
				col.UpdateRule = types.Pointer(cfg.ListRule)
				col.DeleteRule = types.Pointer(cfg.ListRule)
			}
		}

		if isNew {
			// Core fields
			col.Fields.Add(&core.TextField{Name: FieldApp, Required: true})
			col.Fields.Add(&core.TextField{Name: cfg.IdField, Required: true})
			col.Fields.Add(&core.TextField{Name: FieldDocId, Required: true})

			// Indexes
			col.Indexes = append(col.Indexes, fmt.Sprintf("CREATE INDEX idx_%s_app ON %s (%s)", cfg.Name, cfg.Name, FieldApp))
			col.Indexes = append(col.Indexes, fmt.Sprintf("CREATE INDEX idx_%s_%s ON %s (%s, %s)", cfg.Name, cfg.IdField, cfg.Name, FieldApp, cfg.IdField))

			if cfg.IsEvent {
				col.Fields.Add(&core.NumberField{Name: FieldVersion})
				col.Fields.Add(&core.TextField{Name: FieldPayload})
				col.Fields.Add(&core.DateField{Name: FieldTimeStamp})
				col.Indexes = append(col.Indexes, fmt.Sprintf("CREATE UNIQUE INDEX idx_%s_app_%s_v ON %s (%s, %s, %s)", cfg.Name, cfg.IdField, cfg.Name, FieldApp, cfg.IdField, FieldVersion))
			} else if cfg.IsUser {
				col.Fields.Add(&core.NumberField{Name: FieldUserId})
				col.Fields.Add(&core.DateField{Name: FieldTimeStamp})
				col.Fields.Add(&core.TextField{Name: FieldMarkDelete})
				col.Fields.Add(&core.TextField{Name: FieldMarkCopy})
				if cfg.Name == ColBetaUsers {
					col.Fields.Add(&core.TextField{Name: FieldBetaUsers})
				}
			} else if cfg.IsFile {
				col.Fields.Add(&core.FileField{Name: FieldFile, MaxSelect: 1, MaxSize: 10 * 1024 * 1024})
			}
		}

		if err := app.Save(col); err != nil {
			log.Printf("[hyttahub] ERROR saving %s: %v", cfg.Name, err)
			return err
		}
	}
	return nil
}

func registerAppHooks(app core.App) {

	app.OnServe().Bind(&hook.Handler[*core.ServeEvent]{
		Func: func(se *core.ServeEvent) error {
			// Run migration to ensure the 7 flat collections exist
			if err := migrate(app); err != nil {
				log.Fatalf("[hyttahub] Migration failed: %v", err)
			}

			se.Router.GET("/{path...}", apis.Static(os.DirFS(app.DataDir()+"/../pb_public"), false))
			
			// Anonymous Auth Middleware
			se.Router.Bind(&hook.Handler[*core.RequestEvent]{
				Func: func(e *core.RequestEvent) error {
					reqPath := e.Request.URL.Path
					reqMethod := e.Request.Method

					if allowAnonymous && e.Auth == nil {
						if authEmail := e.Request.Header.Get("X-Auth-Email"); authEmail != "" {
							user, _ := app.FindAuthRecordByEmail("users", authEmail)
							if user == nil {
								usersCol, _ := app.FindCollectionByNameOrId("users")
								if usersCol != nil {
									user = core.NewRecord(usersCol)
									user.Set("email", authEmail)
									user.SetVerified(true)
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
					return e.Next()
				},
				Priority: -99999,
			})
			return se.Next()
		},
		Priority: -99999,
	})

	// Security logic for Creates
	app.OnRecordCreateRequest().Bind(&hook.Handler[*core.RecordRequestEvent]{
		Func: func(e *core.RecordRequestEvent) error {
			colName := e.Record.Collection().Name

			if e.HasSuperuserAuth() {
				return e.Next()
			}

			if e.Record.GetString(FieldTimeStamp) == "" || e.Record.GetString(FieldTimeStamp) == "@now" {
				e.Record.Set(FieldTimeStamp, time.Now().UTC().Format("2006-01-02 15:04:05.000Z"))
			}

			appId := e.Record.GetString(FieldApp)
			if appId == "" {
				// Not a hyttahub flat collection record if it has no app
				return e.Next()
			}

			// Helper to get authEmail, returning error if not authenticated
			getAuthEmail := func() (string, error) {
				authEmail := ""
				if e.Auth != nil {
					authEmail = e.Auth.GetString("email")
				}
				if authEmail == "" {
					return "", apis.NewUnauthorizedError("Unauthorized", nil)
				}
				return authEmail, nil
			}

			if colName == ColSiteUsers || colName == ColServiceUsers || colName == ColBetaUsers {
				siteIdField := FieldSiteId
				if colName == ColServiceUsers || colName == ColBetaUsers {
					siteIdField = FieldServiceId
				}
				siteId := e.Record.GetString(siteIdField)

				count, _ := app.CountRecords(colName, dbx.NewExp("app = {:app} AND "+siteIdField+" = {:siteId}", dbx.Params{"app": appId, "siteId": siteId}))
				if count == 0 {
					return e.Next() // First user/document allowed
				}

				authEmail, err := getAuthEmail()
				if err != nil {
					return err
				}

				memberCol := colName
				if colName == ColBetaUsers {
					memberCol = ColServiceUsers
				}

				records, err := app.FindRecordsByFilter(memberCol, "app = {:app} && "+siteIdField+" = {:siteId} && doc_id = {:email}", "", 1, 0, dbx.Params{"app": appId, "siteId": siteId, "email": authEmail})
				if err != nil || len(records) == 0 {
					log.Printf("[DEBUG] Failed to find existing member. app=%s, siteId=%s, authEmail=%s, err=%v, len(records)=%d", appId, siteId, authEmail, err, len(records))
					if allowSelfJoin && colName == ColSiteUsers && e.Record.GetString(FieldDocId) == authEmail {
						return e.Next()
					}
					return apis.NewForbiddenError("Only existing members can add users.", nil)
				}
				return e.Next()
			}

			if colName == ColServiceEvents {
				serviceId := e.Record.GetString(FieldServiceId)
				count, _ := app.CountRecords(colName, dbx.NewExp("app = {:app} AND serviceId = {:serviceId}", dbx.Params{"app": appId, "serviceId": serviceId}))
				if count == 0 {
					return e.Next() // First event allowed
				}

				authEmail, err := getAuthEmail()
				if err != nil {
					return err
				}

				records, err := app.FindRecordsByFilter(ColServiceUsers, "app = {:app} && serviceId = {:serviceId} && doc_id = {:email}", "", 1, 0, dbx.Params{"app": appId, "serviceId": serviceId, "email": authEmail})
				if err != nil || len(records) == 0 {
					return apis.NewForbiddenError("Only service members can create events", nil)
				}
				return e.Next()
			}

			if colName == ColSiteFiles {
				authEmail, err := getAuthEmail()
				if err != nil {
					return err
				}

				siteId := e.Record.GetString(FieldSiteId)
				records, err := app.FindRecordsByFilter(ColSiteUsers, "app = {:app} && siteId = {:siteId} && doc_id = {:email}", "", 1, 0, dbx.Params{"app": appId, "siteId": siteId, "email": authEmail})
				if err != nil || len(records) == 0 {
					return apis.NewForbiddenError("Only site members can upload files", nil)
				}
				return e.Next()
			}

			if colName == ColAccountEvents {
				authEmail, err := getAuthEmail()
				if err != nil {
					return err
				}

				accountId := e.Record.GetString(FieldAccountId)
				if authEmail != accountId {
					return apis.NewForbiddenError("You can only create events for your own account", nil)
				}
				return e.Next()
			}

			return e.Next()
		},
		Priority: -99999,
	})

	// User deletion cascade
	app.OnRecordAfterDeleteSuccess().BindFunc(func(e *core.RecordEvent) error {
		if e.Record.Collection().Name == "users" {
			email := e.Record.GetString("email")
			if email != "" {
				log.Printf("[hyttahub] Auth user deleted (%s). Cleaning up account collections...", email)
				// Delete all account events for this email
				events, _ := app.FindRecordsByFilter(ColAccountEvents, "accountId = {:email}", "", 0, 0, dbx.Params{"email": email})
				for _, ev := range events {
					app.Delete(ev)
				}
			}
		}
		return e.Next()
	})

	app.OnRecordAfterUpdateSuccess().BindFunc(func(e *core.RecordEvent) error {
		colName := e.Record.Collection().Name
		if colName != ColSiteUsers {
			return e.Next()
		}

		mValue := e.Record.GetString(FieldMarkDelete)
		copyValue := e.Record.GetString(FieldMarkCopy)
		if mValue == "" && copyValue == "" {
			return e.Next()
		}

		appId := e.Record.GetString(FieldApp)
		siteId := e.Record.GetString(FieldSiteId)
		email := e.Record.GetString(FieldDocId)

		saveGenericEvent := func(targetColName string, idField string, idValue string, version int, base64Payload string, eventType string) {
			col, _ := app.FindCollectionByNameOrId(targetColName)
			if col != nil {
				record := core.NewRecord(col)
				record.Set(FieldApp, appId)
				record.Set(idField, idValue)
				record.Set(FieldDocId, fmt.Sprintf("%d", version))
				record.Set(FieldVersion, version)
				record.Set(FieldPayload, base64Payload)
				record.Set(FieldTimeStamp, time.Now().UTC().Format("2006-01-02 15:04:05.000Z"))
				if err := app.Save(record); err != nil {
					log.Printf("[hyttahub] ERROR saving %s: %v", targetColName, err)
				}
			}
		}

		// Handle MarkForDeletion
		if mValue != "" {
			mBytes, err := base64.StdEncoding.DecodeString(mValue)
			if err == nil {
				mInfo := &models.MarkForDeletion{}
				if err := proto.Unmarshal(mBytes, mInfo); err == nil {
					memberId := e.Record.GetInt(FieldUserId)
					switch mInfo.DeleteReason {
					case models.MarkForDeletion_memberLeftSite:
						lastRecords, _ := app.FindRecordsByFilter(ColSiteEvents, "app = {:app} && siteId = {:siteId}", "-v", 1, 0, dbx.Params{"app": appId, "siteId": siteId})
						newVersion := 1
						if len(lastRecords) > 0 {
							newVersion = lastRecords[0].GetInt(FieldVersion) + 1
						}
						siteEvent := &models.SiteEvent{
							Version: int32(newVersion), Author: int32(mInfo.Author),
							EventType: &models.SiteEvent_LeaveSite_{LeaveSite: &models.SiteEvent_LeaveSite{MemberId: int32(memberId)}},
						}
						eBytes, _ := proto.Marshal(siteEvent)
						saveGenericEvent(ColSiteEvents, FieldSiteId, siteId, newVersion, base64.StdEncoding.EncodeToString(eBytes), "Site-Leave")

						lastAccRecords, _ := app.FindRecordsByFilter(ColAccountEvents, "app = {:app} && accountId = {:accountId}", "-v", 1, 0, dbx.Params{"app": appId, "accountId": email})
						newAccVersion := 1
						if len(lastAccRecords) > 0 {
							newAccVersion = lastAccRecords[0].GetInt(FieldVersion) + 1
						}
						accEvent := &models.AccountEvent{
							Version:   int32(newAccVersion),
							EventType: &models.AccountEvent_LeaveSite{LeaveSite: siteId},
						}
						aeBytes, _ := proto.Marshal(accEvent)
						saveGenericEvent(ColAccountEvents, FieldAccountId, email, newAccVersion, base64.StdEncoding.EncodeToString(aeBytes), "Account-Leave")

					case models.MarkForDeletion_memberRemovedFromSite:
						lastRecords, _ := app.FindRecordsByFilter(ColSiteEvents, "app = {:app} && siteId = {:siteId}", "-v", 1, 0, dbx.Params{"app": appId, "siteId": siteId})
						newVersion := 1
						if len(lastRecords) > 0 {
							newVersion = lastRecords[0].GetInt(FieldVersion) + 1
						}
						siteEvent := &models.SiteEvent{
							Version: int32(newVersion), Author: int32(mInfo.Author),
							EventType: &models.SiteEvent_RemoveMember_{RemoveMember: &models.SiteEvent_RemoveMember{MemberId: int32(memberId)}},
						}
						eBytes, _ := proto.Marshal(siteEvent)
						saveGenericEvent(ColSiteEvents, FieldSiteId, siteId, newVersion, base64.StdEncoding.EncodeToString(eBytes), "Site-Remove")

						lastAccRecords, _ := app.FindRecordsByFilter(ColAccountEvents, "app = {:app} && accountId = {:accountId}", "-v", 1, 0, dbx.Params{"app": appId, "accountId": email})
						newAccVersion := 1
						if len(lastAccRecords) > 0 {
							newAccVersion = lastAccRecords[0].GetInt(FieldVersion) + 1
						}
						accEvent := &models.AccountEvent{
							Version:   int32(newAccVersion),
							EventType: &models.AccountEvent_RemoveSite{RemoveSite: siteId},
						}
						aeBytes, _ := proto.Marshal(accEvent)
						saveGenericEvent(ColAccountEvents, FieldAccountId, email, newAccVersion, base64.StdEncoding.EncodeToString(aeBytes), "Account-Remove")
					}
				}
			}
			app.Delete(e.Record)
			
			count, _ := app.CountRecords(ColSiteUsers, dbx.NewExp("app = {:app} AND siteId = {:siteId}", dbx.Params{"app": appId, "siteId": siteId}))
			if count == 0 {
				events, _ := app.FindRecordsByFilter(ColSiteEvents, "app = {:app} && siteId = {:siteId}", "", 0, 0, dbx.Params{"app": appId, "siteId": siteId})
				for _, ev := range events {
					app.Delete(ev)
				}
				files, _ := app.FindRecordsByFilter(ColSiteFiles, "app = {:app} && siteId = {:siteId}", "", 0, 0, dbx.Params{"app": appId, "siteId": siteId})
				for _, f := range files {
					app.Delete(f)
				}
			}
		}

		// Handle Copy
		if copyValue != "" {
			copyBytes, _ := base64.StdEncoding.DecodeString(copyValue)
			copyInfo := &models.MarkForCopy{}
			if err := proto.Unmarshal(copyBytes, copyInfo); err == nil {
				newSiteId := generateId()

				srcEvents, _ := app.FindRecordsByFilter(ColSiteEvents, "app = {:app} && siteId = {:siteId}", "v", 0, 0, dbx.Params{"app": appId, "siteId": siteId})
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
					saveGenericEvent(ColSiteEvents, FieldSiteId, newSiteId, v, pBase64, "Site-Event-Copy")
				}

				maxV++
				log.Printf("[hyttahub] COPY: Site name: %s. Creating ImportEvent (v=%d)", siteName, maxV)
				importEvent := &models.SiteEvent{
					Version: maxV, Author: copyInfo.Author,
					EventType: &models.SiteEvent_ImportEvent_{ImportEvent: &models.SiteEvent_ImportEvent{}},
				}
				ieBytes, _ := proto.Marshal(importEvent)
				saveGenericEvent(ColSiteEvents, FieldSiteId, newSiteId, int(maxV), base64.StdEncoding.EncodeToString(ieBytes), "Site-Import")

				usersCol, _ := app.FindCollectionByNameOrId(ColSiteUsers)
				userRec := core.NewRecord(usersCol)
				userRec.Set(FieldApp, appId)
				userRec.Set(FieldSiteId, newSiteId)
				userRec.Set(FieldDocId, email)
				userRec.Set(FieldUserId, copyInfo.Author)
				userRec.Set(FieldTimeStamp, time.Now().UTC().Format("2006-01-02 15:04:05.000Z"))
				app.Save(userRec)

				srcFiles, _ := app.FindRecordsByFilter(ColSiteFiles, "app = {:app} && siteId = {:siteId}", "", 0, 0, dbx.Params{"app": appId, "siteId": siteId})
				for _, srcFile := range srcFiles {
					fcol, _ := app.FindCollectionByNameOrId(ColSiteFiles)
					newFile := core.NewRecord(fcol)
					newFile.Set(FieldApp, appId)
					newFile.Set(FieldSiteId, newSiteId)
					newFile.Set(FieldDocId, srcFile.GetString(FieldDocId))
					filename := srcFile.GetString(FieldFile)
					if err := app.Save(newFile); err == nil && filename != "" {
						srcPath := filepath.Join(app.DataDir(), "storage", srcFile.BaseFilesPath(), filename)
						dstPath := filepath.Join(app.DataDir(), "storage", newFile.BaseFilesPath(), filename)

						if err := os.MkdirAll(filepath.Dir(dstPath), 0755); err == nil {
							if err := copyFileLocal(srcPath, dstPath); err == nil {
								copyFileLocal(srcPath+".attrs", dstPath+".attrs")
								app.DB().Update(newFile.Collection().Name, dbx.Params{"file": filename}, dbx.HashExp{"id": newFile.Id}).Execute()
							}
						}
					}
				}

				lastAccRecords, _ := app.FindRecordsByFilter(ColAccountEvents, "app = {:app} && accountId = {:accountId}", "-v", 1, 0, dbx.Params{"app": appId, "accountId": email})
				newAccVersion := 1
				if len(lastAccRecords) > 0 {
					newAccVersion = lastAccRecords[0].GetInt(FieldVersion) + 1
				}

				accEvent := &models.AccountEvent{
					Version:   int32(newAccVersion),
					EventType: &models.AccountEvent_CreateSite{CreateSite: newSiteId},
				}
				aeBytes, _ := proto.Marshal(accEvent)
				saveGenericEvent(ColAccountEvents, FieldAccountId, email, newAccVersion, base64.StdEncoding.EncodeToString(aeBytes), "Account-Create")
			}
			e.Record.Set("c", "")
			app.Save(e.Record)
		}
		return e.Next()
	})
}

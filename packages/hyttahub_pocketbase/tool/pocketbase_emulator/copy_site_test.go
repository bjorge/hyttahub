package main

import (
	"encoding/base64"
	"testing"

	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
	"google.golang.org/protobuf/proto"

	"pocketbase_emulator/models"
)

func TestSiteCopyLogic(t *testing.T) {
	testApp, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}

	setupCollections(testApp)
	registerAppHooks(testApp)

	email := "copy-user@example.com"
	appName := "testapp"
	sourceSiteId := "SRC123"

	// Add user to source site
	col, _ := testApp.FindCollectionByNameOrId(ColSiteUsers)
	record := core.NewRecord(col)
	record.Set(FieldApp, appName)
	record.Set(FieldSiteId, sourceSiteId)
	record.Set(FieldDocId, email)
	record.Set(FieldUserId, 100)
	if err := testApp.Save(record); err != nil {
		t.Fatal(err)
	}

	// Add an event to source site
	eventsCol, _ := testApp.FindCollectionByNameOrId(ColSiteEvents)
	newSiteEvent := &models.SiteEvent{
		Version: 1,
		Author: 100,
		EventType: &models.SiteEvent_NewSite_{
			NewSite: &models.SiteEvent_NewSite{
				SiteName: "Source Site",
			},
		},
	}
	nseBytes, _ := proto.Marshal(newSiteEvent)
	eventRecord := core.NewRecord(eventsCol)
	eventRecord.Set(FieldApp, appName)
	eventRecord.Set(FieldSiteId, sourceSiteId)
	eventRecord.Set(FieldDocId, "1")
	eventRecord.Set(FieldVersion, 1)
	eventRecord.Set(FieldPayload, base64.StdEncoding.EncodeToString(nseBytes))
	testApp.Save(eventRecord)

	// 2. Trigger Site Copy
	copyInfo := &models.MarkForCopy{
		Author: 100,
		UpToVersion: 1,
	}
	cpBytes, _ := proto.Marshal(copyInfo)
	record.Set(FieldMarkCopy, base64.StdEncoding.EncodeToString(cpBytes))
	
	if err := testApp.Save(record); err != nil {
		t.Fatal(err)
	}

	// 3. Verify MarkForCopy was cleared
	updatedRecord, _ := testApp.FindRecordById(ColSiteUsers, record.Id)
	if updatedRecord.GetString(FieldMarkCopy) != "" {
		t.Errorf("'%s' field should have been cleared", FieldMarkCopy)
	}

	// 4. Verify Account Event (CreateSite) was created
	accEvents, err := testApp.FindRecordsByFilter(ColAccountEvents, "app='testapp' && accountId='copy-user@example.com' && v > 0", "-v", 1, 0)
	if err != nil || len(accEvents) == 0 {
		t.Fatalf("Account event should have been created for site copy")
	}

	// Extract the new site ID
	var newSiteId string
	pBase64 := accEvents[0].GetString(FieldPayload)
	pBytes, _ := base64.StdEncoding.DecodeString(pBase64)
	accEvent := &models.AccountEvent{}
	if err := proto.Unmarshal(pBytes, accEvent); err == nil {
		if accEvent.GetCreateSite() != "" {
			newSiteId = accEvent.GetCreateSite()
			t.Logf("Found new site ID in account events: %s", newSiteId)
		} else {
			t.Errorf("Account event should be CreateSite, but got: %v", accEvent.EventType)
		}
	}

	if newSiteId == "" {
		t.Fatal("Could not find new site ID in account events")
	}

	// 6. Verify User is member of new site
	dstUsers, _ := testApp.FindRecordsByFilter(ColSiteUsers, "app='testapp' && siteId={:siteId} && doc_id={:email}", "", 1, 0, map[string]any{"siteId": newSiteId, "email": email})
	if len(dstUsers) == 0 {
		t.Errorf("User should be a member of the new site")
	}

	// 7. Verify Events were copied and ImportEvent exists
	dstEvents, _ := testApp.FindRecordsByFilter(ColSiteEvents, "app='testapp' && siteId={:siteId} && v > 0", "v", 100, 0, map[string]any{"siteId": newSiteId})
	if len(dstEvents) < 2 {
		t.Errorf("Should have at least 2 events in new site (copied 1 + 1 import), got %d", len(dstEvents))
	}

	// Check for ImportEvent
	foundImport := false
	for _, ev := range dstEvents {
		evPBytes, _ := base64.StdEncoding.DecodeString(ev.GetString(FieldPayload))
		siteEv := &models.SiteEvent{}
		proto.Unmarshal(evPBytes, siteEv)
		if siteEv.GetImportEvent() != nil {
			foundImport = true
			if siteEv.GetImportEvent().SiteName != "" {
				t.Errorf("Expected empty site name in ImportEvent, got '%s'", siteEv.GetImportEvent().SiteName)
			}
		}
	}
	if !foundImport {
		t.Errorf("ImportEvent not found in destination site events")
	}
}

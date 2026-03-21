package main

import (
	"encoding/base64"
	"fmt"
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

	registerAppHooks(testApp)

	email := "copy-user@example.com"
	appName := "testapp"
	sourceSiteId := "SRC123"

	// 1. Setup Source Site
	srcPrefix := fmt.Sprintf("%s%s__sites__%s", PrefixHyttaHub, appName, sourceSiteId)
	srcUsersCol := srcPrefix + SuffixSiteUsers
	srcEventsCol := srcPrefix + SuffixSiteEvents
	
	createHyttahubCollection(testApp, srcUsersCol)
	// site_events is auto-created by createHyttahubCollection for site_users

	// Add user to source site
	col, _ := testApp.FindCollectionByNameOrId(srcUsersCol)
	record := core.NewRecord(col)
	record.Set(FieldDocId, email)
	record.Set(FieldUserId, 100)
	if err := testApp.Save(record); err != nil {
		t.Fatal(err)
	}

	// Add an event to source site
	eventsCol, _ := testApp.FindCollectionByNameOrId(srcEventsCol)
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
	eventRecord.Set(FieldDocId, "1")
	eventRecord.Set(FieldVersion, 1)
	eventRecord.Set(FieldPayload, base64.StdEncoding.EncodeToString(nseBytes))
	testApp.Save(eventRecord)

	// Setup Account Events collection for the user
	accEventsColName := fmt.Sprintf("%s%s%s%s%s", PrefixHyttaHub, appName, SegmentAccounts, encodeSegment(email), SuffixAccountEvents)
	createHyttahubCollection(testApp, accEventsColName)

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
	updatedRecord, _ := testApp.FindRecordById(srcUsersCol, record.Id)
	if updatedRecord.GetString(FieldMarkCopy) != "" {
		t.Errorf("'%s' field should have been cleared", FieldMarkCopy)
	}

	// 4. Verify Account Event (CreateSite) was created
	accEvents, err := testApp.FindRecordsByFilter(accEventsColName, "v > 0", "-v", 1, 0)
	if err != nil || len(accEvents) == 0 {
		t.Fatalf("Account event should have been created for site copy")
	}

	// Extract the new site ID from logic or search for it
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

	// 5. Verify New Site Collections exist
	dstPrefix := fmt.Sprintf("%s%s__sites__%s", PrefixHyttaHub, appName, newSiteId)
	dstUsersCol := dstPrefix + SuffixSiteUsers
	dstEventsCol := dstPrefix + SuffixSiteEvents

	if _, err := testApp.FindCollectionByNameOrId(dstUsersCol); err != nil {
		t.Errorf("Destination site_users collection %s should exist", dstUsersCol)
	}
	if _, err := testApp.FindCollectionByNameOrId(dstEventsCol); err != nil {
		t.Errorf("Destination site_events collection %s should exist", dstEventsCol)
	}

	// 6. Verify User is member of new site
	dstUsers, _ := testApp.FindRecordsByFilter(dstUsersCol, "doc_id = {:email}", "", 1, 0, map[string]any{"email": email})
	if len(dstUsers) == 0 {
		t.Errorf("User should be a member of the new site")
	}

	// 7. Verify Events were copied and ImportEvent exists
	dstEvents, _ := testApp.FindRecordsByFilter(dstEventsCol, "v > 0", "v", 100, 0)
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

package main

import (
	"encoding/base64"
	"testing"

	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
	"google.golang.org/protobuf/proto"

	"pocketbase_emulator/models"
)

func TestMemberRemovedCascadingEffect(t *testing.T) {
	testApp, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}

	setupCollections(testApp)
	registerAppHooks(testApp)

	email := "removed-user@example.com"
	appName := "testapp"
	siteId := "S123"

	// Create a user for testing
	user, _ := testApp.FindAuthRecordByEmail("users", email)
	if user == nil {
		col, _ := testApp.FindCollectionByNameOrId("users")
		user = core.NewRecord(col)
		user.SetEmail(email)
		user.SetPassword("1234567890")
		testApp.Save(user)
	}

	// 1. Manually create the collections (now just records in flat schema)
	accEventsCol, _ := testApp.FindCollectionByNameOrId(ColAccountEvents)
	accountEvent := core.NewRecord(accEventsCol)
	accountEvent.Set(FieldApp, appName)
	accountEvent.Set(FieldAccountId, email)
	accountEvent.Set(FieldDocId, "2")
	accountEvent.Set(FieldVersion, 2)
	accountEvent.Set(FieldPayload, "init")
	testApp.Save(accountEvent)

	col, _ := testApp.FindCollectionByNameOrId(ColSiteUsers)
	record := core.NewRecord(col)
	record.Set(FieldApp, appName)
	record.Set(FieldSiteId, siteId)
	record.Set(FieldDocId, email)
	record.Set(FieldUserId, 123)
	if err := testApp.Save(record); err != nil {
		t.Fatal(err)
	}

	// 2. Prepare the MarkForDeletion protobuf
	mInfo := &models.MarkForDeletion{
		DeleteReason: models.MarkForDeletion_memberRemovedFromSite,
	}
	mBytes, _ := proto.Marshal(mInfo)
	mBase64 := base64.StdEncoding.EncodeToString(mBytes)

	// 3. Update the record with the deletion mark
	record.Set(FieldMarkDelete, mBase64)
	if err := testApp.Save(record); err != nil {
		t.Fatal(err)
	}

	// 4. Verify that the site user record is gone (as per the hook at the end)
	_, err = testApp.FindRecordById(ColSiteUsers, record.Id)
	if err == nil {
		t.Logf("Site user record ID %s still exists in %s", record.Id, ColSiteUsers)
		t.Errorf("Site user record should have been deleted by the hook")
	}

	// 6. Verify that an account event was created
	events, err := testApp.FindRecordsByFilter(ColAccountEvents, "app='testapp' && accountId='removed-user@example.com' && v > 0", "-v", 1, 0)
	if err != nil || len(events) == 0 {
		t.Errorf("Account event should have been created for removed user")
	}

	// 7. Verify that site collections were deleted (because it was the last user)
	siteEvents, _ := testApp.FindRecordsByFilter(ColSiteEvents, "app='testapp' && siteId='S123'", "", 1, 0)
	if len(siteEvents) > 0 {
		t.Errorf("Site events records should have been deleted (last user removed)")
	}
}

func TestMemberLeftCascadingEffect(t *testing.T) {
	testApp, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}

	setupCollections(testApp)
	registerAppHooks(testApp)

	email := "leaving-user@example.com"
	appName := "testapp_left"
	siteId := "SLEFT"

	// Create a user for testing
	user, _ := testApp.FindAuthRecordByEmail("users", email)
	if user == nil {
		col, _ := testApp.FindCollectionByNameOrId("users")
		user = core.NewRecord(col)
		user.SetEmail(email)
		user.SetPassword("1234567890")
		testApp.Save(user)
	}

	// Seed v=1 event in site_events because main.go only creates v > 1
	eventsCol, _ := testApp.FindCollectionByNameOrId(ColSiteEvents)
	initEvent := core.NewRecord(eventsCol)
	initEvent.Set(FieldApp, appName)
	initEvent.Set(FieldSiteId, siteId)
	initEvent.Set(FieldDocId, "1")
	initEvent.Set(FieldVersion, 1)
	initEvent.Set(FieldPayload, "init")
	testApp.Save(initEvent)

	col, _ := testApp.FindCollectionByNameOrId(ColSiteUsers)
	record := core.NewRecord(col)
	record.Set(FieldApp, appName)
	record.Set(FieldSiteId, siteId)
	record.Set(FieldDocId, email)
	record.Set(FieldUserId, 123)
	if err := testApp.Save(record); err != nil {
		t.Fatal(err)
	}

	// 2. Prepare the MarkForDeletion protobuf
	mBase64 := base64.StdEncoding.EncodeToString([]byte{0x08, 0x00})

	// 3. Update the record with the deletion mark
	record.Set(FieldMarkDelete, mBase64)
	if err := testApp.Save(record); err != nil {
		t.Fatal(err)
	}

	// 4. Verify that the site user record is gone
	_, err = testApp.FindRecordById(ColSiteUsers, record.Id)
	if err == nil {
		t.Errorf("Site user record should have been deleted by the hook")
	}

	// 6. Verify that account event was created
	accEvents, err := testApp.FindRecordsByFilter(ColAccountEvents, "app='testapp_left' && accountId='leaving-user@example.com' && v >= 1", "-v", 1, 0)
	if err != nil || len(accEvents) == 0 {
		t.Errorf("Account event should have been created for leaving user")
	}

	// 7. Verify that site records were deleted
	events, _ := testApp.FindRecordsByFilter(ColSiteEvents, "app='testapp_left' && siteId='SLEFT'", "", 1, 0)
	if len(events) > 0 {
		t.Errorf("Site events should have been deleted (last user left)")
	}
}

func TestMemberLeavesWithOthersRemaining(t *testing.T) {
	testApp, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}

	setupCollections(testApp)
	registerAppHooks(testApp)

	email1 := "user1@example.com"
	email2 := "user2@example.com"
	appName := "testapp_others"
	siteId := "SOTHERS"

	// Add both users
	col, _ := testApp.FindCollectionByNameOrId(ColSiteUsers)
	record1 := core.NewRecord(col)
	record1.Set(FieldApp, appName)
	record1.Set(FieldSiteId, siteId)
	record1.Set(FieldDocId, email1)
	record1.Set(FieldUserId, 1)
	testApp.Save(record1)

	record2 := core.NewRecord(col)
	record2.Set(FieldApp, appName)
	record2.Set(FieldSiteId, siteId)
	record2.Set(FieldDocId, email2)
	record2.Set(FieldUserId, 2)
	testApp.Save(record2)

	// Prepare leave mark for user1
	mBase64 := base64.StdEncoding.EncodeToString([]byte{0x08, 0x00})
	record1.Set(FieldMarkDelete, mBase64)
	
	// Trigger leave
	if err := testApp.Save(record1); err != nil {
		t.Fatal(err)
	}

	// Verify user1 is gone
	_, err = testApp.FindRecordById(ColSiteUsers, record1.Id)
	if err == nil {
		t.Errorf("User1 record should have been deleted")
	}

	// Verify user2 STILL EXISTS
	_, err = testApp.FindRecordById(ColSiteUsers, record2.Id)
	if err != nil {
		t.Errorf("User2 record should STILL exist")
	}

	// Verify site event (LeaveSite) was created
	events, err := testApp.FindRecordsByFilter(ColSiteEvents, "app='testapp_others' && siteId='SOTHERS' && v > 0", "-v", 1, 0)
	if err != nil || len(events) == 0 {
		t.Errorf("Site event should have been created")
	}
}

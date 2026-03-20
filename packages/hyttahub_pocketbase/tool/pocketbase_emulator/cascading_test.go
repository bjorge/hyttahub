package main

import (
	"encoding/base64"
	"fmt"
	"testing"
	"time"

	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
	"google.golang.org/protobuf/proto"

	"pocketbase_emulator/models"
)

func TestOrphanCleanup(t *testing.T) {
	testApp, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}

	registerAppHooks(testApp)

	// 1. Create a "dead site" (empty site_users and over 2 mins old)
	siteRoot := "hyttahub__test__sites__DEAD__site_users"
	siteSub := "hyttahub__test__sites__DEAD__site_events"
	createHyttahubCollection(testApp, siteRoot)
	createHyttahubCollection(testApp, siteSub)

	// Force age them to bypass grace period
	oldTime := time.Now().Add(-10 * time.Minute).Format("2006-01-02 15:04:05.000Z")
	testApp.DB().Update("_collections", dbx.Params{"created": oldTime}, dbx.HashExp{"name": siteRoot}).Execute()
	testApp.DB().Update("_collections", dbx.Params{"created": oldTime}, dbx.HashExp{"name": siteSub}).Execute()

	// 2. Run cleanup
	runOrphanCleanup(testApp)

	// 3. Verify they are gone
	if _, err := testApp.FindCollectionByNameOrId(siteRoot); err == nil {
		t.Errorf("Collection %s should have been purged", siteRoot)
	}
	if _, err := testApp.FindCollectionByNameOrId(siteSub); err == nil {
		t.Errorf("Collection %s should have been purged", siteSub)
	}
}

func TestMemberRemovedCascadingEffect(t *testing.T) {
	testApp, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}

	registerAppHooks(testApp)

	email := "removed-user@example.com"
	encodedEmail := encodeSegment(email)
	appName := "testapp"
	siteId := "S123"

	siteUsersCol := fmt.Sprintf("hyttahub__%s__sites__%s__site_users", appName, siteId)
	accountEventsCol := fmt.Sprintf("hyttahub__%s__accounts__%s__account_events", appName, encodedEmail)

	// Create a user for testing
	user, _ := testApp.FindAuthRecordByEmail("users", email)
	if user == nil {
		col, _ := testApp.FindCollectionByNameOrId("users")
		user = core.NewRecord(col)
		user.SetEmail(email)
		user.SetPassword("1234567890")
		testApp.Save(user)
	}

	// 1. Manually create the collections
	createHyttahubCollection(testApp, siteUsersCol)
	siteEventsCol := fmt.Sprintf("hyttahub__%s__sites__%s__site_events", appName, siteId)
	createHyttahubCollection(testApp, siteEventsCol)
	createHyttahubCollection(testApp, accountEventsCol)

	// Seed v=1 event in account_events because main.go only creates v > 1
	accEventsCol, _ := testApp.FindCollectionByNameOrId(accountEventsCol)
	initEvent := core.NewRecord(accEventsCol)
	initEvent.Set("doc_id", "1")
	initEvent.Set("v", 1)
	initEvent.Set("p", "init")
	testApp.Save(initEvent)

	col, _ := testApp.FindCollectionByNameOrId(siteUsersCol)
	record := core.NewRecord(col)
	record.Set("doc_id", email)
	record.Set("u", 123)
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
	record.Set("m", mBase64)
	if err := testApp.Save(record); err != nil {
		t.Fatal(err)
	}

	// 4. Verify that the site user record is gone (as per the hook at the end)
	_, err = testApp.FindRecordById(siteUsersCol, record.Id)
	if err == nil {
		t.Logf("Site user record ID %s still exists in %s", record.Id, siteUsersCol)
		t.Errorf("Site user record should have been deleted by the hook")
	} else {
		t.Logf("Site user record was successfully deleted")
	}

	// 5. Verify that an account event was created
	events, err := testApp.FindRecordsByFilter(accountEventsCol, "v > 0", "-v", 1, 0)
	if err != nil || len(events) == 0 {
		t.Errorf("Account event should have been created for removed user")
	} else {
		t.Logf("Successfully verified account event creation: removeSite")
	}

	// 6. Verify that a site event was created (RemoveMember)
	sEvents, err := testApp.FindRecordsByFilter(siteEventsCol, "v >= 1", "-v", 1, 0)
	if err != nil || len(sEvents) == 0 {
		t.Errorf("Site event should have been created for removed member in %s", siteEventsCol)
	} else {
		t.Logf("Successfully verified site event creation: removeMember")
	}
}

func TestMemberLeftCascadingEffect(t *testing.T) {
	testApp, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}

	registerAppHooks(testApp)

	email := "leaving-user@example.com"
	appName := "testapp_left"
	siteId := "SLEFT"

	siteUsersCol := fmt.Sprintf("hyttahub__%s__sites__%s__site_users", appName, siteId)
	siteEventsCol := fmt.Sprintf("hyttahub__%s__sites__%s__site_events", appName, siteId)

	// Create a user for testing
	user, _ := testApp.FindAuthRecordByEmail("users", email)
	if user == nil {
		col, _ := testApp.FindCollectionByNameOrId("users")
		user = core.NewRecord(col)
		user.SetEmail(email)
		user.SetPassword("1234567890")
		testApp.Save(user)
	}

	// 1. Manually create the site_users and site_events
	createHyttahubCollection(testApp, siteUsersCol)
	createHyttahubCollection(testApp, siteEventsCol)

	// Seed v=1 event in site_events because main.go only creates v > 1
	eventsCol, _ := testApp.FindCollectionByNameOrId(siteEventsCol)
	initEvent := core.NewRecord(eventsCol)
	initEvent.Set("doc_id", "1")
	initEvent.Set("v", 1)
	initEvent.Set("p", "init")
	testApp.Save(initEvent)

	col, _ := testApp.FindCollectionByNameOrId(siteUsersCol)
	record := core.NewRecord(col)
	record.Set("doc_id", email)
	record.Set("u", 123)
	if err := testApp.Save(record); err != nil {
		t.Fatal(err)
	}

	// 2. Prepare the MarkForDeletion protobuf
	// memberLeftSite is 0, so proto.Marshal returns empty bytes by default.
	// To pass the main.go non-empty check, we can manually encode a Tag 1 (DeleteReason), Type 0 (Varint), Value 0.
	// 0x08 = (1 << 3) | 0. 0x00 = 0.
	mBase64 := base64.StdEncoding.EncodeToString([]byte{0x08, 0x00})

	// 3. Update the record with the deletion mark
	accountEventsCol := fmt.Sprintf("hyttahub__%s__accounts__%s__account_events", appName, encodeSegment(email))
	createHyttahubCollection(testApp, accountEventsCol) // Ensure it exists

	// Pre-create the site_events collection before triggering the cascading effect.
	// It's already created in step 1, but ensuring it's explicitly present here
	// before the record update is consistent with the instruction's intent.
	// The instruction also included a seedEvent line which seems misplaced or incomplete,
	// so it's omitted to maintain syntactical correctness and focus on the collection creation.

	record.Set("m", mBase64)
	if err := testApp.Save(record); err != nil {
		t.Fatal(err)
	}

	// 4. Verify that the site user record is gone
	_, err = testApp.FindRecordById(siteUsersCol, record.Id)
	if err == nil {
		t.Logf("Site user record ID %s still exists in %s", record.Id, siteUsersCol)
		t.Errorf("Site user record should have been deleted by the hook")
	} else {
		t.Logf("Site user record was successfully deleted")
	}

	// 5. Verify that a site event was created (LeaveSite)
	events, err := testApp.FindRecordsByFilter(siteEventsCol, "v > 0", "-v", 1, 0)
	if err != nil || len(events) == 0 {
		t.Errorf("Site event should have been created for leaving user")
	} else {
		t.Logf("Successfully verified site event creation: leaveSite")
	}

	// 6. Verify that an account event was created (LeaveSite)
	accEvents, err := testApp.FindRecordsByFilter(accountEventsCol, "v >= 1", "-v", 1, 0)
	if err != nil || len(accEvents) == 0 {
		t.Errorf("Account event should have been created for leaving user in %s", accountEventsCol)
	} else {
		t.Logf("Successfully verified account event creation: leaveSite")
	}
}

func TestForwardCascading(t *testing.T) {
	testApp, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}

	registerAppHooks(testApp)

	siteUsersCol := "hyttahub__test__sites__CASC__site_users"

	// 1. Create site_users
	if err := createHyttahubCollection(testApp, siteUsersCol); err != nil {
		t.Fatal(err)
	}

	// 2. Verify related collections were created
	related := []string{
		"hyttahub__test__sites__CASC__site_events",
		"hyttahub__test__sites__CASC__site_files",
	}
	for _, colName := range related {
		if _, err := testApp.FindCollectionByNameOrId(colName); err != nil {
			t.Errorf("Collection %s should have been forward-cascaded", colName)
		}
	}

	// 3. Verify deprecated collections were NOT created
	deprecated := []string{
		"hyttahub__test__sites__CASC__site_emails",
		"hyttahub__test__sites__CASC__site_exports",
	}
	for _, colName := range deprecated {
		if _, err := testApp.FindCollectionByNameOrId(colName); err == nil {
			t.Errorf("Deprecated collection %s should NOT have been created", colName)
		}
	}
}

func TestReverseCascading(t *testing.T) {
	testApp, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}

	registerAppHooks(testApp)

	siteEventsCol := "hyttahub__test__sites__REV__site_events"

	// 1. Create site_events (should trigger creation of site_users)
	if err := createHyttahubCollection(testApp, siteEventsCol); err != nil {
		t.Fatal(err)
	}

	// 2. Verify parent was created
	parent := "hyttahub__test__sites__REV__site_users"
	if _, err := testApp.FindCollectionByNameOrId(parent); err != nil {
		t.Errorf("Collection %s should have been reverse-cascaded", parent)
	}

	// 3. Verify other children were also created (via site_users forward cascade)
	child := "hyttahub__test__sites__REV__site_files"
	if _, err := testApp.FindCollectionByNameOrId(child); err != nil {
		t.Errorf("Collection %s should have been forward-cascaded from the reverse-cascaded parent", child)
	}
}

func TestServiceCascading(t *testing.T) {
	testApp, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}

	registerAppHooks(testApp)

	serviceUsersCol := "hyttahub__app__service_users"

	// 1. Create service_users
	if err := createHyttahubCollection(testApp, serviceUsersCol); err != nil {
		t.Fatal(err)
	}

	// 2. Verify service_events was created
	serviceEventsCol := "hyttahub__app__service_events"
	if _, err := testApp.FindCollectionByNameOrId(serviceEventsCol); err != nil {
		t.Errorf("Collection %s should have been cascaded", serviceEventsCol)
	}
}


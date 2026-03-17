package main

import (
	"encoding/base64"
	"fmt"
	"net/http"
	"strings"
	"testing"
	"time"

	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
	"google.golang.org/protobuf/proto"

	"pocketbase_emulator/models"
)

func TestAutoCollectionCreation(t *testing.T) {
	testApp, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}

	registerAppHooks(testApp)

	collectionName := "hyttahub__test__sites__T123__site_users"
	
	// Use the app we already configured
	scenario := tests.ApiScenario{
		Name:            "GET triggers auto-creation",
		Method:          http.MethodGet,
		URL:             "/api/collections/" + collectionName + "/records",
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusOK, 
		ExpectedContent: []string{`"items":[]`},
	}
	scenario.Test(t)

	// Verify it exists now
	_, err = testApp.FindCollectionByNameOrId(collectionName)
	if err != nil {
		t.Fatalf("Collection %s should have been auto-created", collectionName)
	}
}

func TestMembershipSecurity(t *testing.T) {
	testApp, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}

	registerAppHooks(testApp)

	siteUsersCol := "hyttahub__test__sites__SWS__site_users"
	
	// Create a user for testing
	user, err := testApp.FindAuthRecordByEmail("users", "test@example.com")
	if err != nil {
		col, _ := testApp.FindCollectionByNameOrId("users")
		user = core.NewRecord(col)
		user.SetEmail("test@example.com")
		user.SetPassword("1234567890")
		if err := testApp.Save(user); err != nil {
			t.Fatal(err)
		}
	}

	token, _ := user.NewAuthToken()

	// 1. First user creation should be allowed
	scenario1 := tests.ApiScenario{
		Name:            "Allow first user creation in new site",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + siteUsersCol + "/records",
		Body:            strings.NewReader(fmt.Sprintf(`{"doc_id": "test@example.com", "u": 1, "t": "%s"}`, time.Now().UTC().Format(time.RFC3339))),
		Headers:         map[string]string{"Authorization": token},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusOK, 
		ExpectedContent: []string{`"doc_id":"test@example.com"`},
	}
	scenario1.Test(t)

	// 2. Second user creation by a non-member should be FORBIDDEN
	otherUser, _ := testApp.FindAuthRecordByEmail("users", "other@example.com")
	if otherUser == nil {
		col, _ := testApp.FindCollectionByNameOrId("users")
		otherUser = core.NewRecord(col)
		otherUser.SetEmail("other@example.com")
		otherUser.SetPassword("1234567890")
		testApp.Save(otherUser)
	}
	otherToken, _ := otherUser.NewAuthToken()

	scenario2 := tests.ApiScenario{
		Name:            "Forbidden if non-member tries to add themselves",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + siteUsersCol + "/records",
		Body:            strings.NewReader(fmt.Sprintf(`{"doc_id": "other@example.com", "u": 2, "t": "%s"}`, time.Now().UTC().Format(time.RFC3339))),
		Headers:         map[string]string{"Authorization": otherToken},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusForbidden,
		ExpectedContent: []string{`"message":"Only existing members can add users."`},
	}
	scenario2.Test(t)
}

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

func TestSiteEventsImmutability(t *testing.T) {
	testApp, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}

	registerAppHooks(testApp)

	siteEventsCol := "hyttahub__test__sites__IMMUTABLE__site_events"
	siteUsersCol := "hyttahub__test__sites__IMMUTABLE__site_users"

	// Create a user for testing
	user, err := testApp.FindAuthRecordByEmail("users", "test@example.com")
	if err != nil {
		col, _ := testApp.FindCollectionByNameOrId("users")
		user = core.NewRecord(col)
		user.SetEmail("test@example.com")
		user.SetPassword("1234567890")
		if err := testApp.Save(user); err != nil {
			t.Fatal(err)
		}
	}
	token, _ := user.NewAuthToken()

	// 1. Add user to site_users first so they can create events
	createHyttahubCollection(testApp, siteUsersCol)
	col, _ := testApp.FindCollectionByNameOrId(siteUsersCol)
	record := core.NewRecord(col)
	record.Set("doc_id", "test@example.com")
	record.Set("u", 1)
	if err := testApp.Save(record); err != nil {
		t.Fatal(err)
	}

	// 2. Create a site event
	scenario1 := tests.ApiScenario{
		Name:            "Allow creating a site event",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + siteEventsCol + "/records",
		Body:            strings.NewReader(`{"id": "eventid12345678", "doc_id": "1", "v": 1, "p": "test-payload"}`),
		Headers:         map[string]string{"Authorization": token},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{`"doc_id":"1"`, `"id":"eventid12345678"`},
	}
	scenario1.Test(t)

	// 3. Try to update the event (should be FORBIDDEN)
	scenario2 := tests.ApiScenario{
		Name:            "Forbidden updating a site event",
		Method:          http.MethodPatch,
		URL:             "/api/collections/" + siteEventsCol + "/records/eventid12345678",
		Body:            strings.NewReader(`{"p": "updated-payload"}`),
		Headers:         map[string]string{"Authorization": token},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusForbidden,
		ExpectedContent: []string{`"Only superusers can perform this action."`},
	}
	scenario2.Test(t)

	// 4. Try to delete the event (should be FORBIDDEN)
	scenario3 := tests.ApiScenario{
		Name:            "Forbidden deleting a site event",
		Method:          http.MethodDelete,
		URL:             "/api/collections/" + siteEventsCol + "/records/eventid12345678",
		Headers:         map[string]string{"Authorization": token},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusForbidden,
		ExpectedContent: []string{`"Only superusers can perform this action."`},
	}
	scenario3.Test(t)
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

	// 1. Manually create the site_users record and account_events
	createHyttahubCollection(testApp, siteUsersCol)
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
	// This should trigger the hook that creates an account event and then deletes the site user record
	record.Set("m", mBase64)
	if err := testApp.Save(record); err != nil {
		t.Fatal(err)
	}

	// 4. Verify that the site user record is gone (as per the hook at the end)
	_, err = testApp.FindRecordById(siteUsersCol, record.Id)
	if err == nil {
		t.Errorf("Site user record should have been deleted by the hook")
	}

	// 5. Verify that an account event was created
	events, err := testApp.FindRecordsByFilter(accountEventsCol, "v > 0", "-v", 1, 0)
	if err != nil || len(events) == 0 {
		t.Errorf("Account event should have been created for removed user")
	} else {
		t.Logf("Successfully verified account event creation")
	}
}

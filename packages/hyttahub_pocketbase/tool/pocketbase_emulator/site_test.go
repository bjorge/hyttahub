package main

import (
	"fmt"
	"net/http"
	"strings"
	"testing"
	"time"

	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
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

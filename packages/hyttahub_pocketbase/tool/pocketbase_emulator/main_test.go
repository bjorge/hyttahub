package main

import (
	"fmt"
	"net/http"
	"strings"
	"testing"
	"time"

	"github.com/pocketbase/dbx"
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

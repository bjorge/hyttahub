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

func setupCollections(app core.App) {
	migrate(app)
}

func TestSiteMembershipSecurity(t *testing.T) {
	testApp, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}

	setupCollections(testApp)
	registerAppHooks(testApp)

	appName := "tictactoe"
	siteId := "S123"

	// Create users
	user1, _ := testApp.FindAuthRecordByEmail("users", "user1@example.com")
	if user1 == nil {
		col, _ := testApp.FindCollectionByNameOrId("users")
		user1 = core.NewRecord(col)
		user1.SetEmail("user1@example.com")
		user1.SetPassword("1234567890")
		testApp.Save(user1)
	}

	user2, _ := testApp.FindAuthRecordByEmail("users", "user2@example.com")
	if user2 == nil {
		col, _ := testApp.FindCollectionByNameOrId("users")
		user2 = core.NewRecord(col)
		user2.SetEmail("user2@example.com")
		user2.SetPassword("1234567890")
		testApp.Save(user2)
	}

	token1, _ := user1.NewAuthToken()
	token2, _ := user2.NewAuthToken()

	// 1. user1 creates the site (first user allowed)
	scenario1 := tests.ApiScenario{
		Name:            "Create Site (First User)",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + ColSiteUsers + "/records",
		Body:            strings.NewReader(fmt.Sprintf(`{"app": "%s", "siteId": "%s", "doc_id": "user1@example.com", "u": %d}`, appName, siteId, time.Now().Unix())),
		Headers:         map[string]string{"Authorization": token1},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{""},
	}
	scenario1.Test(t)

	// 2. user2 tries to join site without invite
	scenario2 := tests.ApiScenario{
		Name:            "Join Site Without Invite",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + ColSiteUsers + "/records",
		Body:            strings.NewReader(fmt.Sprintf(`{"app": "%s", "siteId": "%s", "doc_id": "user2@example.com", "u": %d}`, appName, siteId, time.Now().Unix())),
		Headers:         map[string]string{"Authorization": token2},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusForbidden,
		ExpectedContent: []string{""},
	}
	scenario2.Test(t)

	// Seed user1 as the first member (since scenario1 rolled back)
	col, _ := testApp.FindCollectionByNameOrId(ColSiteUsers)
	su := core.NewRecord(col)
	su.Set(FieldApp, appName)
	su.Set(FieldSiteId, siteId)
	su.Set(FieldDocId, "user1@example.com")
	su.Set(FieldUserId, 123)
	testApp.Save(su)

	// 3. user1 invites user2
	scenario3 := tests.ApiScenario{
		Name:            "Invite User",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + ColSiteUsers + "/records",
		Body:            strings.NewReader(fmt.Sprintf(`{"app": "%s", "siteId": "%s", "doc_id": "user2@example.com", "u": %d}`, appName, siteId, time.Now().Unix())),
		Headers:         map[string]string{"Authorization": token1},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{""},
	}
	scenario3.Test(t)

	// 4. Verify user2 can now see the events
	scenario4 := tests.ApiScenario{
		Name:            "Read Events as Member",
		Method:          http.MethodGet,
		URL:             fmt.Sprintf("/api/collections/%s/records?filter=(app='%s'%%26%%26siteId='%s')", ColSiteEvents, appName, siteId),
		Headers:         map[string]string{"Authorization": token2},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{""},
	}
	scenario4.Test(t)

	// 5. Verify non-member cannot see events
	user3, _ := testApp.FindAuthRecordByEmail("users", "user3@example.com")
	if user3 == nil {
		col, _ := testApp.FindCollectionByNameOrId("users")
		user3 = core.NewRecord(col)
		user3.SetEmail("user3@example.com")
		user3.SetPassword("1234567890")
		testApp.Save(user3)
	}
	token3, _ := user3.NewAuthToken()

	scenario5 := tests.ApiScenario{
		Name:            "Read Events as Non-Member",
		Method:          http.MethodGet,
		URL:             fmt.Sprintf("/api/collections/%s/records?filter=(app='%s'%%26%%26siteId='%s')", ColSiteEvents, appName, siteId),
		Headers:         map[string]string{"Authorization": token3},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{`"totalItems":0`},
	}
	scenario5.Test(t)
}

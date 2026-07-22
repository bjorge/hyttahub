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

func setupSiteTestApp(t testing.TB) *tests.TestApp {
	testApp, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}

	setupCollections(testApp)
	registerAppHooks(testApp)

	col, _ := testApp.FindCollectionByNameOrId("users")

	user1 := core.NewRecord(col)
	user1.SetEmail("user1@example.com")
	user1.SetPassword("1234567890")
	testApp.Save(user1)

	user2 := core.NewRecord(col)
	user2.SetEmail("user2@example.com")
	user2.SetPassword("1234567890")
	testApp.Save(user2)

	user3 := core.NewRecord(col)
	user3.SetEmail("user3@example.com")
	user3.SetPassword("1234567890")
	testApp.Save(user3)

	return testApp
}

func TestSiteMembershipSecurity(t *testing.T) {
	appName := "tictactoe"
	siteId := "S123"
	email1 := "user1@example.com"
	email2 := "user2@example.com"
	email3 := "user3@example.com"

	// 1. user1 creates the site (first user allowed)
	scenario1 := tests.ApiScenario{
		Name:            "Create Site (First User)",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + ColSiteUsers + "/records",
		Body:            strings.NewReader(fmt.Sprintf(`{"app": "%s", "siteId": "%s", "doc_id": "user1@example.com", "u": %d}`, appName, siteId, time.Now().Unix())),
		TestAppFactory:  setupSiteTestApp,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{`"doc_id":"user1@example.com"`},
	}
	scenario1.BeforeTestFunc = func(t testing.TB, app *tests.TestApp, e *core.ServeEvent) {
		scenario1.Headers = map[string]string{"Authorization": getAuthToken(app, email1)}
	}
	scenario1.Test(t)

	// 2. user2 tries to join site without invite
	scenario2 := tests.ApiScenario{
		Name:            "Join Site Without Invite",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + ColSiteUsers + "/records",
		Body:            strings.NewReader(fmt.Sprintf(`{"app": "%s", "siteId": "%s", "doc_id": "user2@example.com", "u": %d}`, appName, siteId, time.Now().Unix())),
		TestAppFactory:  setupSiteTestApp,
		ExpectedStatus:  http.StatusBadRequest,
		ExpectedContent: []string{`"Failed to create record."`},
	}
	scenario2.BeforeTestFunc = func(t testing.TB, app *tests.TestApp, e *core.ServeEvent) {
		scenario2.Headers = map[string]string{"Authorization": getAuthToken(app, email2)}
		col, _ := app.FindCollectionByNameOrId(ColSiteUsers)
		su := core.NewRecord(col)
		su.Set(FieldApp, appName)
		su.Set(FieldSiteId, siteId)
		su.Set(FieldDocId, email1)
		su.Set(FieldUserId, 123)
		app.Save(su)
	}
	scenario2.Test(t)

	// 3. user1 invites user2
	scenario3 := tests.ApiScenario{
		Name:            "Invite User",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + ColSiteUsers + "/records",
		Body:            strings.NewReader(fmt.Sprintf(`{"app": "%s", "siteId": "%s", "doc_id": "user2@example.com", "u": %d}`, appName, siteId, time.Now().Unix())),
		TestAppFactory:  setupSiteTestApp,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{`"doc_id":"user2@example.com"`},
	}
	scenario3.BeforeTestFunc = func(t testing.TB, app *tests.TestApp, e *core.ServeEvent) {
		scenario3.Headers = map[string]string{"Authorization": getAuthToken(app, email1)}
		col, _ := app.FindCollectionByNameOrId(ColSiteUsers)
		su := core.NewRecord(col)
		su.Set(FieldApp, appName)
		su.Set(FieldSiteId, siteId)
		su.Set(FieldDocId, email1)
		su.Set(FieldUserId, 123)
		app.Save(su)
	}
	scenario3.Test(t)

	// 4. Verify user2 can now see the events
	scenario4 := tests.ApiScenario{
		Name:            "Read Events as Member",
		Method:          http.MethodGet,
		URL:             fmt.Sprintf("/api/collections/%s/records?filter=(app='%s'%%26%%26siteId='%s')", ColSiteEvents, appName, siteId),
		TestAppFactory:  setupSiteTestApp,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{`"totalItems":0`},
	}
	scenario4.BeforeTestFunc = func(t testing.TB, app *tests.TestApp, e *core.ServeEvent) {
		scenario4.Headers = map[string]string{"Authorization": getAuthToken(app, email2)}
		col, _ := app.FindCollectionByNameOrId(ColSiteUsers)
		su := core.NewRecord(col)
		su.Set(FieldApp, appName)
		su.Set(FieldSiteId, siteId)
		su.Set(FieldDocId, email2)
		su.Set(FieldUserId, 456)
		app.Save(su)
	}
	scenario4.Test(t)

	// 5. Verify non-member cannot see events
	scenario5 := tests.ApiScenario{
		Name:            "Read Events as Non-Member",
		Method:          http.MethodGet,
		URL:             fmt.Sprintf("/api/collections/%s/records?filter=(app='%s'%%26%%26siteId='%s')", ColSiteEvents, appName, siteId),
		TestAppFactory:  setupSiteTestApp,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{`"totalItems":0`},
	}
	scenario5.BeforeTestFunc = func(t testing.TB, app *tests.TestApp, e *core.ServeEvent) {
		scenario5.Headers = map[string]string{"Authorization": getAuthToken(app, email3)}
	}
	scenario5.Test(t)
}

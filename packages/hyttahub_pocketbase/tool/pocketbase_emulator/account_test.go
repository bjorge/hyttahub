package main

import (
	"fmt"
	"net/http"
	"strings"
	"testing"

	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
)

func setupAccountTestApp(t testing.TB) *tests.TestApp {
	testApp, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}

	setupCollections(testApp)
	registerAppHooks(testApp)

	col, _ := testApp.FindCollectionByNameOrId("users")

	user1 := core.NewRecord(col)
	user1.SetEmail("account1@example.com")
	user1.SetPassword("1234567890")
	testApp.Save(user1)

	user2 := core.NewRecord(col)
	user2.SetEmail("account2@example.com")
	user2.SetPassword("1234567890")
	testApp.Save(user2)

	return testApp
}

func getAuthToken(app *tests.TestApp, email string) string {
	user, _ := app.FindAuthRecordByEmail("users", email)
	token, _ := user.NewAuthToken()
	return token
}

func TestAccountMembershipSecurity(t *testing.T) {
	appName := "tictactoe"
	email1 := "account1@example.com"
	email2 := "account2@example.com"

	// 1. user1 creates an account event (should succeed)
	scenario1 := tests.ApiScenario{
		Name:            "Create Account Event (Self)",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + ColAccountEvents + "/records",
		Body:            strings.NewReader(fmt.Sprintf(`{"app": "%s", "accountId": "%s", "doc_id": "1", "v": 1, "t": "@now"}`, appName, email1)),
		TestAppFactory:  setupAccountTestApp,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{`"accountId":"account1@example.com"`},
	}
	scenario1.BeforeTestFunc = func(t testing.TB, app *tests.TestApp, e *core.ServeEvent) {
		scenario1.Headers = map[string]string{"Authorization": getAuthToken(app, email1)}
	}
	scenario1.Test(t)

	// 2. user2 tries to create an account event for user1 (should fail with 403)
	scenario2 := tests.ApiScenario{
		Name:            "Create Account Event (Other)",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + ColAccountEvents + "/records",
		Body:            strings.NewReader(fmt.Sprintf(`{"app": "%s", "accountId": "%s", "doc_id": "2", "v": 1, "t": "@now"}`, appName, email1)),
		TestAppFactory:  setupAccountTestApp,
		ExpectedStatus:  http.StatusForbidden,
		ExpectedContent: []string{`"You can only create events for your own account."`},
	}
	scenario2.BeforeTestFunc = func(t testing.TB, app *tests.TestApp, e *core.ServeEvent) {
		scenario2.Headers = map[string]string{"Authorization": getAuthToken(app, email2)}
	}
	scenario2.Test(t)

	// 3. user1 reads their own events
	scenario3 := tests.ApiScenario{
		Name:            "Read Account Events (Self)",
		Method:          http.MethodGet,
		URL:             fmt.Sprintf("/api/collections/%s/records?filter=(app='%s'%%26%%26accountId='%s')", ColAccountEvents, appName, email1),
		TestAppFactory:  setupAccountTestApp,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{`"totalItems":1`},
	}
	scenario3.BeforeTestFunc = func(t testing.TB, app *tests.TestApp, e *core.ServeEvent) {
		scenario3.Headers = map[string]string{"Authorization": getAuthToken(app, email1)}
		col, _ := app.FindCollectionByNameOrId(ColAccountEvents)
		rec := core.NewRecord(col)
		rec.Set(FieldApp, appName)
		rec.Set(FieldAccountId, email1)
		rec.Set(FieldDocId, "1")
		rec.Set(FieldVersion, 1)
		app.Save(rec)
	}
	scenario3.Test(t)

	// 4. user2 reads user1's events
	scenario4 := tests.ApiScenario{
		Name:            "Read Account Events (Other)",
		Method:          http.MethodGet,
		URL:             fmt.Sprintf("/api/collections/%s/records?filter=(app='%s'%%26%%26accountId='%s')", ColAccountEvents, appName, email1),
		TestAppFactory:  setupAccountTestApp,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{`"totalItems":0`},
	}
	scenario4.BeforeTestFunc = func(t testing.TB, app *tests.TestApp, e *core.ServeEvent) {
		scenario4.Headers = map[string]string{"Authorization": getAuthToken(app, email2)}
		col, _ := app.FindCollectionByNameOrId(ColAccountEvents)
		rec := core.NewRecord(col)
		rec.Set(FieldApp, appName)
		rec.Set(FieldAccountId, email1)
		rec.Set(FieldDocId, "1")
		rec.Set(FieldVersion, 1)
		app.Save(rec)
	}
	scenario4.Test(t)

	// 5. user2 tries to delete user1's event (should fail with 404)
	scenario5 := tests.ApiScenario{
		Name:            "Delete Account Event (Other)",
		Method:          http.MethodDelete,
		URL:             fmt.Sprintf("/api/collections/%s/records/rec123456789012", ColAccountEvents),
		TestAppFactory:  setupAccountTestApp,
		ExpectedStatus:  http.StatusNotFound,
		ExpectedContent: []string{`"message":"The requested resource wasn't found."`},
	}
	scenario5.BeforeTestFunc = func(t testing.TB, app *tests.TestApp, e *core.ServeEvent) {
		scenario5.Headers = map[string]string{"Authorization": getAuthToken(app, email2)}
		col, _ := app.FindCollectionByNameOrId(ColAccountEvents)
		rec := core.NewRecord(col)
		rec.Id = "rec123456789012"
		rec.Set(FieldApp, appName)
		rec.Set(FieldAccountId, email1)
		rec.Set(FieldDocId, "test-delete-1")
		rec.Set(FieldVersion, 2)
		app.Save(rec)
	}
	scenario5.Test(t)

	// 6. user1 deletes their own event (should succeed with 204)
	scenario6 := tests.ApiScenario{
		Name:           "Delete Account Event (Self)",
		Method:         http.MethodDelete,
		URL:            fmt.Sprintf("/api/collections/%s/records/rec123456789012", ColAccountEvents),
		TestAppFactory: setupAccountTestApp,
		ExpectedStatus: http.StatusNoContent,
	}
	scenario6.BeforeTestFunc = func(t testing.TB, app *tests.TestApp, e *core.ServeEvent) {
		scenario6.Headers = map[string]string{"Authorization": getAuthToken(app, email1)}
		col, _ := app.FindCollectionByNameOrId(ColAccountEvents)
		rec := core.NewRecord(col)
		rec.Id = "rec123456789012"
		rec.Set(FieldApp, appName)
		rec.Set(FieldAccountId, email1)
		rec.Set(FieldDocId, "test-delete-1")
		rec.Set(FieldVersion, 2)
		app.Save(rec)
	}
	scenario6.Test(t)
}

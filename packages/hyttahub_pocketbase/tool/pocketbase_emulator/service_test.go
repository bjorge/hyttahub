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

func setupServiceTestApp(t testing.TB) *tests.TestApp {
	testApp, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}

	setupCollections(testApp)
	registerAppHooks(testApp)

	col, _ := testApp.FindCollectionByNameOrId("users")

	user1 := core.NewRecord(col)
	user1.SetEmail("admin@example.com")
	user1.SetPassword("1234567890")
	testApp.Save(user1)

	user2 := core.NewRecord(col)
	user2.SetEmail("normal@example.com")
	user2.SetPassword("1234567890")
	testApp.Save(user2)

	return testApp
}

func TestServiceSecurity(t *testing.T) {
	appName := "tictactoe"
	serviceId := "status"
	email1 := "admin@example.com"
	email2 := "normal@example.com"

	// 1. user1 creates the service (first user allowed)
	scenario1 := tests.ApiScenario{
		Name:            "Create Service (First User)",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + ColServiceUsers + "/records",
		Body:            strings.NewReader(fmt.Sprintf(`{"app": "%s", "serviceId": "%s", "doc_id": "admin@example.com", "u": %d}`, appName, serviceId, time.Now().Unix())),
		TestAppFactory:  setupServiceTestApp,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{`"doc_id":"admin@example.com"`},
	}
	scenario1.BeforeTestFunc = func(t testing.TB, app *tests.TestApp, e *core.ServeEvent) {
		scenario1.Headers = map[string]string{"Authorization": getAuthToken(app, email1)}
	}
	scenario1.Test(t)

	// 2. user2 tries to join service without invite
	scenario2 := tests.ApiScenario{
		Name:            "Join Service Without Invite",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + ColServiceUsers + "/records",
		Body:            strings.NewReader(fmt.Sprintf(`{"app": "%s", "serviceId": "%s", "doc_id": "normal@example.com", "u": %d}`, appName, serviceId, time.Now().Unix())),
		TestAppFactory:  setupServiceTestApp,
		ExpectedStatus:  http.StatusBadRequest,
		ExpectedContent: []string{`"Failed to create record."`},
	}
	scenario2.BeforeTestFunc = func(t testing.TB, app *tests.TestApp, e *core.ServeEvent) {
		scenario2.Headers = map[string]string{"Authorization": getAuthToken(app, email2)}
		col, _ := app.FindCollectionByNameOrId(ColServiceUsers)
		rec := core.NewRecord(col)
		rec.Set(FieldApp, appName)
		rec.Set(FieldServiceId, serviceId)
		rec.Set(FieldDocId, email1)
		rec.Set(FieldUserId, time.Now().Unix())
		app.Save(rec)
	}
	scenario2.Test(t)

	// 3. user1 creates a service event
	scenario3 := tests.ApiScenario{
		Name:            "Create Event as Admin",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + ColServiceEvents + "/records",
		Body:            strings.NewReader(fmt.Sprintf(`{"app": "%s", "serviceId": "%s", "doc_id": "1", "v": 1, "t": "@now"}`, appName, serviceId)),
		TestAppFactory:  setupServiceTestApp,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{`"hyttahub_service_events"`},
	}
	scenario3.BeforeTestFunc = func(t testing.TB, app *tests.TestApp, e *core.ServeEvent) {
		scenario3.Headers = map[string]string{"Authorization": getAuthToken(app, email1)}
		col, _ := app.FindCollectionByNameOrId(ColServiceUsers)
		rec := core.NewRecord(col)
		rec.Set(FieldApp, appName)
		rec.Set(FieldServiceId, serviceId)
		rec.Set(FieldDocId, email1)
		rec.Set(FieldUserId, time.Now().Unix())
		app.Save(rec)
	}
	scenario3.Test(t)

	// 4. user2 tries to create a service event
	scenario4 := tests.ApiScenario{
		Name:            "Create Event as Non-Member",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + ColServiceEvents + "/records",
		Body:            strings.NewReader(fmt.Sprintf(`{"app": "%s", "serviceId": "%s", "doc_id": "2", "v": 1, "t": "@now"}`, appName, serviceId)),
		TestAppFactory:  setupServiceTestApp,
		ExpectedStatus:  http.StatusForbidden,
		ExpectedContent: []string{`"Only service members can create events."`},
	}
	scenario4.BeforeTestFunc = func(t testing.TB, app *tests.TestApp, e *core.ServeEvent) {
		scenario4.Headers = map[string]string{"Authorization": getAuthToken(app, email2)}
		col, _ := app.FindCollectionByNameOrId(ColServiceEvents)
		rec := core.NewRecord(col)
		rec.Set(FieldApp, appName)
		rec.Set(FieldServiceId, serviceId)
		rec.Set(FieldDocId, "1")
		rec.Set(FieldVersion, 1)
		app.Save(rec)
	}
	scenario4.Test(t)

	// 5. Verify everyone can read events
	scenario5 := tests.ApiScenario{
		Name:            "Read Events as Anyone",
		Method:          http.MethodGet,
		URL:             fmt.Sprintf("/api/collections/%s/records?filter=(app='%s'%%26%%26serviceId='%s')", ColServiceEvents, appName, serviceId),
		TestAppFactory:  setupServiceTestApp,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{`"totalItems":1`},
	}
	scenario5.BeforeTestFunc = func(t testing.TB, app *tests.TestApp, e *core.ServeEvent) {
		scenario5.Headers = map[string]string{"Authorization": getAuthToken(app, email2)}
		col, _ := app.FindCollectionByNameOrId(ColServiceEvents)
		rec := core.NewRecord(col)
		rec.Set(FieldApp, appName)
		rec.Set(FieldServiceId, serviceId)
		rec.Set(FieldDocId, "1")
		rec.Set(FieldVersion, 1)
		app.Save(rec)
	}
	scenario5.Test(t)
}

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

func TestServiceSecurity(t *testing.T) {
	testApp, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}

	setupCollections(testApp)
	registerAppHooks(testApp)

	appName := "tictactoe"
	serviceId := "status"

	user1, _ := testApp.FindAuthRecordByEmail("users", "admin@example.com")
	if user1 == nil {
		col, _ := testApp.FindCollectionByNameOrId("users")
		user1 = core.NewRecord(col)
		user1.SetEmail("admin@example.com")
		user1.SetPassword("1234567890")
		testApp.Save(user1)
	}

	user2, _ := testApp.FindAuthRecordByEmail("users", "normal@example.com")
	if user2 == nil {
		col, _ := testApp.FindCollectionByNameOrId("users")
		user2 = core.NewRecord(col)
		user2.SetEmail("normal@example.com")
		user2.SetPassword("1234567890")
		testApp.Save(user2)
	}

	token1, _ := user1.NewAuthToken()
	token2, _ := user2.NewAuthToken()

	// 1. user1 creates the service (first user allowed)
	scenario1 := tests.ApiScenario{
		Name:            "Create Service (First User)",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + ColServiceUsers + "/records",
		Body:            strings.NewReader(fmt.Sprintf(`{"app": "%s", "serviceId": "%s", "doc_id": "admin@example.com", "u": %d}`, appName, serviceId, time.Now().Unix())),
		Headers:         map[string]string{"Authorization": token1},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{""},
	}
	scenario1.Test(t)

	// 2. user2 tries to join service without invite
	scenario2 := tests.ApiScenario{
		Name:            "Join Service Without Invite",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + ColServiceUsers + "/records",
		Body:            strings.NewReader(fmt.Sprintf(`{"app": "%s", "serviceId": "%s", "doc_id": "normal@example.com", "u": %d}`, appName, serviceId, time.Now().Unix())),
		Headers:         map[string]string{"Authorization": token2},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusForbidden,
		ExpectedContent: []string{""},
	}
	scenario2.Test(t)

	// 3. user1 creates a service event
	scenario3 := tests.ApiScenario{
		Name:            "Create Event as Admin",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + ColServiceEvents + "/records",
		Body:            strings.NewReader(fmt.Sprintf(`{"app": "%s", "serviceId": "%s", "doc_id": "1", "v": 1, "t": %d}`, appName, serviceId, time.Now().Unix())),
		Headers:         map[string]string{"Authorization": token1},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{""},
	}
	scenario3.Test(t)

	// 4. user2 tries to create a service event
	scenario4 := tests.ApiScenario{
		Name:            "Create Event as Non-Member",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + ColServiceEvents + "/records",
		Body:            strings.NewReader(fmt.Sprintf(`{"app": "%s", "serviceId": "%s", "doc_id": "2", "v": 1, "t": %d}`, appName, serviceId, time.Now().Unix())),
		Headers:         map[string]string{"Authorization": token2},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusForbidden,
		ExpectedContent: []string{""},
	}
	scenario4.Test(t)
	
	// 5. Verify everyone can read events
	scenario5 := tests.ApiScenario{
		Name:            "Read Events as Anyone",
		Method:          http.MethodGet,
		URL:             fmt.Sprintf("/api/collections/%s/records?filter=(app='%s'%%26%%26serviceId='%s')", ColServiceEvents, appName, serviceId),
		Headers:         map[string]string{"Authorization": token2},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{`"totalItems":1`},
	}
	scenario5.Test(t)
}

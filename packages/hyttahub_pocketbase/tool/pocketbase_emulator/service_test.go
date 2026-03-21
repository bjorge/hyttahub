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

	registerAppHooks(testApp)

	serviceUsersCol := "hyttahub__app__service_admins"
	serviceEventsCol := "hyttahub__app__service_events"

	createHyttahubCollection(testApp, serviceUsersCol)
	createHyttahubCollection(testApp, serviceEventsCol)

	// 1. Create first service user (no auth required)
	scenario1 := tests.ApiScenario{
		Name:            "Allow first service user creation",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + serviceUsersCol + "/records",
		Body:            strings.NewReader(fmt.Sprintf(`{"doc_id": "service1@example.com", "u": 1, "t": "%s"}`, time.Now().UTC().Format(time.RFC3339))),
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{`"doc_id":"service1@example.com"`},
	}
	scenario1.Test(t)

	// Create auth users for tokens
	user1, _ := testApp.FindAuthRecordByEmail("users", "service1@example.com")
	if user1 == nil {
		col, _ := testApp.FindCollectionByNameOrId("users")
		user1 = core.NewRecord(col)
		user1.SetEmail("service1@example.com")
		user1.SetPassword("1234567890")
		testApp.Save(user1)
	}
	token1, _ := user1.NewAuthToken()

	user2, _ := testApp.FindAuthRecordByEmail("users", "other@example.com")
	if user2 == nil {
		col, _ := testApp.FindCollectionByNameOrId("users")
		user2 = core.NewRecord(col)
		user2.SetEmail("other@example.com")
		user2.SetPassword("1234567890")
		testApp.Save(user2)
	}
	token2, _ := user2.NewAuthToken()

	// 2. Second service user creation by non-member should be FORBIDDEN
	scenario2 := tests.ApiScenario{
		Name:            "Forbidden if non-service-member tries to add a service user",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + serviceUsersCol + "/records",
		Body:            strings.NewReader(fmt.Sprintf(`{"doc_id": "other@example.com", "u": 2, "t": "%s"}`, time.Now().UTC().Format(time.RFC3339))),
		Headers:         map[string]string{"Authorization": token2},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusForbidden,
		ExpectedContent: []string{`"Only existing members can add users."`},
	}
	scenario2.Test(t)

	// 3. Service events creation
	// First event should be allowed (e.g. initial setup)
	scenario3 := tests.ApiScenario{
		Name:            "Allow first service event creation",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + serviceEventsCol + "/records",
		Body:            strings.NewReader(`{"id": "svcevt123456789", "doc_id": "1", "v": 1, "p": "init"}`),
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{`"id":"svcevt123456789"`},
	}
	scenario3.Test(t)

	// Subsequent events should require service membership
	scenario4 := tests.ApiScenario{
		Name:            "Allow service member to create service event",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + serviceEventsCol + "/records",
		Body:            strings.NewReader(`{"id": "svcevt999999999", "doc_id": "2", "v": 2, "p": "ping"}`),
		Headers:         map[string]string{"Authorization": token1},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{`"id":"svcevt999999999"`},
	}
	scenario4.Test(t)

	scenario5 := tests.ApiScenario{
		Name:            "Forbidden if non-service-member tries to create service event",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + serviceEventsCol + "/records",
		Body:            strings.NewReader(`{"id": "svcevt000000000", "doc_id": "3", "v": 3, "p": "evil"}`),
		Headers:         map[string]string{"Authorization": token2},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusForbidden,
		ExpectedContent: []string{`"Only service members can create events."`},
	}
	scenario5.Test(t)
}

func TestServiceEventsImmutability(t *testing.T) {
	testApp, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}

	registerAppHooks(testApp)

	serviceUsersCol := "hyttahub__app__service_admins"
	serviceEventsCol := "hyttahub__app__service_events"
	createHyttahubCollection(testApp, serviceUsersCol)
	createHyttahubCollection(testApp, serviceEventsCol)

	// 1. Create a service event
	scenario1 := tests.ApiScenario{
		Name:            "Allow creating a service event",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + serviceEventsCol + "/records",
		Body:            strings.NewReader(`{"id": "svcevt123456789", "doc_id": "1", "v": 1, "p": "payload"}`),
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusOK, 
		ExpectedContent: []string{`"id":"svcevt123456789"`},
	}
	scenario1.Test(t)

	// 2. Try to update the event (should be FORBIDDEN)
	scenario2 := tests.ApiScenario{
		Name:            "Forbidden updating a service event",
		Method:          http.MethodPatch,
		URL:             "/api/collections/" + serviceEventsCol + "/records/svcevt123456789",
		Body:            strings.NewReader(`{"p": "updated-payload"}`),
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusForbidden,
		ExpectedContent: []string{`"Only superusers can perform this action."`},
	}
	scenario2.Test(t)

	// 3. Try to delete the event (should be FORBIDDEN)
	scenario3 := tests.ApiScenario{
		Name:            "Forbidden deleting a service event",
		Method:          http.MethodDelete,
		URL:             "/api/collections/" + serviceEventsCol + "/records/svcevt123456789",
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusForbidden,
		ExpectedContent: []string{`"Only superusers can perform this action."`},
	}
	scenario3.Test(t)
}

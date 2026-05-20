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

func TestAccountMembershipSecurity(t *testing.T) {
	testApp, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}

	setupCollections(testApp)
	registerAppHooks(testApp)

	appName := "tictactoe"
	email1 := "account1@example.com"
	email2 := "account2@example.com"

	// Create users
	user1, _ := testApp.FindAuthRecordByEmail("users", email1)
	if user1 == nil {
		col, _ := testApp.FindCollectionByNameOrId("users")
		user1 = core.NewRecord(col)
		user1.SetEmail(email1)
		user1.SetPassword("1234567890")
		testApp.Save(user1)
	}

	user2, _ := testApp.FindAuthRecordByEmail("users", email2)
	if user2 == nil {
		col, _ := testApp.FindCollectionByNameOrId("users")
		user2 = core.NewRecord(col)
		user2.SetEmail(email2)
		user2.SetPassword("1234567890")
		testApp.Save(user2)
	}

	token1, _ := user1.NewAuthToken()
	token2, _ := user2.NewAuthToken()

	// 1. user1 creates an account event (should succeed)
	scenario1 := tests.ApiScenario{
		Name:            "Create Account Event (Self)",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + ColAccountEvents + "/records",
		Body:            strings.NewReader(fmt.Sprintf(`{"app": "%s", "accountId": "%s", "doc_id": "1", "v": 1, "t": %d}`, appName, email1, time.Now().Unix())),
		Headers:         map[string]string{"Authorization": token1},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{""},
	}
	scenario1.Test(t)

	// 2. user2 tries to create an account event for user1 (should fail)
	scenario2 := tests.ApiScenario{
		Name:            "Create Account Event (Other)",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + ColAccountEvents + "/records",
		Body:            strings.NewReader(fmt.Sprintf(`{"app": "%s", "accountId": "%s", "doc_id": "2", "v": 1, "t": %d}`, appName, email1, time.Now().Unix())),
		Headers:         map[string]string{"Authorization": token2},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusForbidden,
		ExpectedContent: []string{""},
	}
	scenario2.Test(t)

	// 3. user1 reads their own events
	scenario3 := tests.ApiScenario{
		Name:            "Read Account Events (Self)",
		Method:          http.MethodGet,
		URL:             fmt.Sprintf("/api/collections/%s/records?filter=(app='%s'%%26%%26accountId='%s')", ColAccountEvents, appName, email1),
		Headers:         map[string]string{"Authorization": token1},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{`"totalItems":1`},
	}
	scenario3.Test(t)

	// 4. user2 reads user1's events
	scenario4 := tests.ApiScenario{
		Name:            "Read Account Events (Other)",
		Method:          http.MethodGet,
		URL:             fmt.Sprintf("/api/collections/%s/records?filter=(app='%s'%%26%%26accountId='%s')", ColAccountEvents, appName, email1),
		Headers:         map[string]string{"Authorization": token2},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusOK,
		ExpectedContent: []string{`"totalItems":0`},
	}
	scenario4.Test(t)

	// Create a record in ColAccountEvents for user1 to delete
	col, _ := testApp.FindCollectionByNameOrId(ColAccountEvents)
	rec := core.NewRecord(col)
	rec.Set(FieldApp, appName)
	rec.Set(FieldAccountId, email1)
	rec.Set(FieldDocId, "test-delete-1")
	rec.Set(FieldVersion, 2)
	if err := testApp.Save(rec); err != nil {
		t.Fatal(err)
	}
	recId := rec.Id

	// 5. user2 tries to delete user1's event (should fail with 404 because they don't have access to the record)
	scenario5 := tests.ApiScenario{
		Name:            "Delete Account Event (Other)",
		Method:          http.MethodDelete,
		URL:             fmt.Sprintf("/api/collections/%s/records/%s", ColAccountEvents, recId),
		Headers:         map[string]string{"Authorization": token2},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusNotFound,
		ExpectedContent: []string{`"message":"The requested resource wasn't found."`},
	}
	scenario5.Test(t)

	// 6. user1 deletes their own event (should succeed with 204)
	scenario6 := tests.ApiScenario{
		Name:            "Delete Account Event (Self)",
		Method:          http.MethodDelete,
		URL:             fmt.Sprintf("/api/collections/%s/records/%s", ColAccountEvents, recId),
		Headers:         map[string]string{"Authorization": token1},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusNoContent,
	}
	scenario6.Test(t)
}

package main

import (
	"fmt"
	"net/http"
	"strings"
	"testing"

	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
)

func TestAccountSecurity(t *testing.T) {
	testApp, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}

	registerAppHooks(testApp)

	email1 := "user1@example.com"
	email2 := "user2@example.com"
	encodedEmail1 := encodeSegment(email1)
	
	accountEventsCol1 := fmt.Sprintf("hyttahub__app__accounts__%s__account_events", encodedEmail1)
	createHyttahubCollection(testApp, accountEventsCol1)

	// Create users
	user1, _ := testApp.FindAuthRecordByEmail("users", email1)
	if user1 == nil {
		col, _ := testApp.FindCollectionByNameOrId("users")
		user1 = core.NewRecord(col)
		user1.SetEmail(email1)
		user1.SetPassword("1234567890")
		testApp.Save(user1)
	}
	token1, _ := user1.NewAuthToken()

	user2, _ := testApp.FindAuthRecordByEmail("users", email2)
	if user2 == nil {
		col, _ := testApp.FindCollectionByNameOrId("users")
		user2 = core.NewRecord(col)
		user2.SetEmail(email2)
		user2.SetPassword("1234567890")
		testApp.Save(user2)
	}
	token2, _ := user2.NewAuthToken()

	// 1. User1 should be able to create their own account event
	scenario1 := tests.ApiScenario{
		Name:            "Allow user to access their own account collection",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + accountEventsCol1 + "/records",
		Body:            strings.NewReader(`{"id": "acevt1234567890", "doc_id": "1", "v": 1, "p": "payload"}`),
		Headers:         map[string]string{"Authorization": token1},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusOK, 
		ExpectedContent: []string{`"id":"acevt1234567890"`},
	}
	scenario1.Test(t)

	// 2. User2 should NOT be able to access User1's account collection (Create should be forbidden)
	scenario2 := tests.ApiScenario{
		Name:            "Forbidden if user tries to create in another's account collection",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + accountEventsCol1 + "/records",
		Body:            strings.NewReader(`{"id": "acevt9999999999", "doc_id": "1", "v": 1, "p": "payload"}`),
		Headers:         map[string]string{"Authorization": token2},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusBadRequest,
		ExpectedContent: []string{`"message":"Failed to create record."`},
	}
	scenario2.Test(t)
}

func TestAccountEventsImmutability(t *testing.T) {
	testApp, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}

	registerAppHooks(testApp)

	email := "test@example.com"
	encodedEmail := encodeSegment(email)
	accountEventsCol := fmt.Sprintf("hyttahub__app__accounts__%s__account_events", encodedEmail)
	createHyttahubCollection(testApp, accountEventsCol)

	user, _ := testApp.FindAuthRecordByEmail("users", email)
	if user == nil {
		col, _ := testApp.FindCollectionByNameOrId("users")
		user = core.NewRecord(col)
		user.SetEmail(email)
		user.SetPassword("1234567890")
		testApp.Save(user)
	}
	token, _ := user.NewAuthToken()

	// 1. Create an account event
	scenario1 := tests.ApiScenario{
		Name:            "Allow creating an account event",
		Method:          http.MethodPost,
		URL:             "/api/collections/" + accountEventsCol + "/records",
		Body:            strings.NewReader(`{"id": "acevt6789012345", "doc_id": "1", "v": 1, "p": "test-payload"}`),
		Headers:         map[string]string{"Authorization": token},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusOK, 
		ExpectedContent: []string{`"id":"acevt6789012345"`},
	}
	scenario1.Test(t)

	// 2. Try to update the account event (should be FORBIDDEN)
	scenario2 := tests.ApiScenario{
		Name:            "Forbidden updating an account event",
		Method:          http.MethodPatch,
		URL:             "/api/collections/" + accountEventsCol + "/records/acevt6789012345",
		Body:            strings.NewReader(`{"p": "updated-payload"}`),
		Headers:         map[string]string{"Authorization": token},
		TestAppFactory:  func(t testing.TB) *tests.TestApp { return testApp },
		DisableTestAppCleanup: true,
		ExpectedStatus:  http.StatusForbidden,
		ExpectedContent: []string{`"Only superusers can perform this action."`},
	}
	scenario2.Test(t)
}

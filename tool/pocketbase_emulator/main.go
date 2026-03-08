package main

import (
	"log"
	"os"
	"strings"

	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/plugins/migratecmd"
	"github.com/pocketbase/pocketbase/tools/types"

	_ "pocketbase_emulator/migrations"
)

func main() {
	app := pocketbase.New()

	migratecmd.MustRegister(app, app.RootCmd, migratecmd.Config{
		Automigrate: true, // auto creates migration files when making collection changes
	})

	// -------------------------------------------------------------------------
	// Auto-verify new users (dev emulator only)
	// -------------------------------------------------------------------------
	app.OnRecordCreate("users").BindFunc(func(e *core.RecordEvent) error {
		e.Record.Set("verified", true)
		log.Printf("[hyttahub] auto-verifying new user: %s\n", e.Record.GetString("email"))
		return e.Next()
	})

	// -------------------------------------------------------------------------
	// Auto-collection middleware via explicit router intercept
	// -------------------------------------------------------------------------
	// By hooking into OnServe, we can add a middleware to the standard router
	// which intercepts requests before they hit PocketBase's collection checks.
	app.OnServe().BindFunc(func(se *core.ServeEvent) error {

		// Serve static files from pb_public
		se.Router.GET("/{path...}", apis.Static(os.DirFS(app.DataDir()+"/../pb_public"), false))

		se.Router.BindFunc(func(e *core.RequestEvent) error {
			reqPath := e.Request.URL.Path

			// We only care about /api/collections/... requests
			if !strings.HasPrefix(reqPath, "/api/collections/") {
				return e.Next()
			}

			// Extract collection name from the path.
			// For example: /api/collections/hyttahub__tictactoe__accounts__eZkBiLmM__account_events/records
			parts := strings.Split(reqPath, "/")
			if len(parts) < 4 {
				return e.Next()
			}
			collectionName := parts[3]

			// Skip internal PocketBase collections
			if !strings.HasPrefix(collectionName, "hyttahub__") {
				return e.Next()
			}

			// Check if it already exists
			_, err := app.FindCollectionByNameOrId(collectionName)
			if err == nil {
				return e.Next() // exists
			}

			log.Printf("[hyttahub] auto-creating collection: %s\n", collectionName)

			// Doesn't exist, create it dynamically
			col := core.NewBaseCollection(collectionName)
			col.ListRule = types.Pointer("")
			col.ViewRule = types.Pointer("")
			col.CreateRule = types.Pointer("")
			col.UpdateRule = types.Pointer("")
			col.DeleteRule = types.Pointer("")

			col.Fields.Add(&core.TextField{
				Name: "doc_id",
			})

			eventFields := []core.Field{
				&core.TextField{Name: "p"}, // payload
				&core.NumberField{Name: "v"}, // version
				&core.TextField{Name: "t"}, // timestamp
			}

			memberFields := []core.Field{
				&core.NumberField{Name: "u"}, // member id
				&core.TextField{Name: "t"}, // timestamp
				&core.TextField{Name: "m"}, // markedForDeletion
			}

			var schemaFields []core.Field
			if strings.HasSuffix(collectionName, "__site_events") ||
				strings.HasSuffix(collectionName, "__account_events") ||
				strings.HasSuffix(collectionName, "__service_events") {
				schemaFields = eventFields
			}
			if strings.HasSuffix(collectionName, "__site_users") ||
				strings.HasSuffix(collectionName, "__service_users") {
				schemaFields = memberFields
			}

			for _, f := range schemaFields {
				col.Fields.Add(f)
			}

			if err := app.Save(col); err != nil {
				log.Printf("[hyttahub] ERROR creating collection '%s': %v\n", collectionName, err)
				return apis.NewBadRequestError("Failed to auto-create collection", err)
			}

			log.Printf("[hyttahub] created '%s'\n", collectionName)

			return e.Next()
		})

		return se.Next()
	})

	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}

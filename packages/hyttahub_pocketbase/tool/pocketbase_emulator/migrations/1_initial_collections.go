package migrations

import (
	"log"

	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
	"github.com/pocketbase/pocketbase/tools/types"
)

func init() {
	m.Register(func(app core.App) error {
		// ---------------------------------------------------------------------------
		// Default dev superuser — LOCAL DEVELOPMENT ONLY
		// Email: admin@dev.local  |  Password: Admin1234!
		// ---------------------------------------------------------------------------
		_, err := app.FindAuthRecordByEmail("_superusers", "admin@dev.local")
		if err != nil {
			superusers, err := app.FindCollectionByNameOrId("_superusers")
			if err != nil {
				return err
			}
			su := core.NewRecord(superusers)
			su.Set("email", "admin@dev.local")
			su.SetPassword("Admin1234!")
			if err := app.Save(su); err != nil {
				return err
			}
			log.Println("[hyttahub] created default dev superuser: admin@dev.local")
		}

		// ---------------------------------------------------------------------------
		// users — auth collection (required by PocketbaseHyttaHubAuth)
		// All app-specific hyttahub__ collections are created on-demand by the
		// auto-collection middleware in main.go — no hardcoded app names here.
		// ---------------------------------------------------------------------------
		_, err = app.FindCollectionByNameOrId("users")
		if err != nil {
			users := core.NewAuthCollection("users")
			users.ListRule = types.Pointer("@request.auth.id != ''")
			users.ViewRule = types.Pointer("@request.auth.id != ''")
			users.CreateRule = types.Pointer("")
			users.UpdateRule = types.Pointer("@request.auth.id = id")
			users.DeleteRule = types.Pointer("@request.auth.id = id")

			users.AuthRule = types.Pointer("")
			users.ManageRule = nil

			users.Fields.Add(&core.EmailField{
				Name:     "email",
				Required: true,
			})

			users.PasswordAuth.Enabled = true
			users.PasswordAuth.IdentityFields = []string{"email"}

			if err := app.Save(users); err != nil {
				return err
			}
		}

		return nil
	}, func(app core.App) error {
		// Rollback: remove users collection and dev superuser
		if c, err := app.FindCollectionByNameOrId("users"); err == nil {
			app.Delete(c)
		}
		if su, err := app.FindAuthRecordByEmail("_superusers", "admin@dev.local"); err == nil {
			app.Delete(su)
		}
		return nil
	})
}

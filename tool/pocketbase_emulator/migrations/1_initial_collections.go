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
		// ---------------------------------------------------------------------------
		_, err = app.FindCollectionByNameOrId("users")
		if err != nil {
			users := core.NewAuthCollection("users")
			users.ListRule = types.Pointer("@request.auth.id != ''")
			users.ViewRule = types.Pointer("@request.auth.id != ''")
			users.CreateRule = types.Pointer("")
			users.UpdateRule = types.Pointer("@request.auth.id = id")
			users.DeleteRule = types.Pointer("@request.auth.id = id")
			
			// Auth specifics
			users.AuthRule = types.Pointer("")
			users.ManageRule = nil
			
			users.Fields.Add(&core.EmailField{
				Name: "email",
				Required: true,
			})
			users.Fields.Add(&core.BoolField{
				Name: "verified",
				Required: false,
			})
			
			users.PasswordAuth.Enabled = true
			users.PasswordAuth.IdentityFields = []string{"email"}

			if err := app.Save(users); err != nil {
				return err
			}
		}

		// ---------------------------------------------------------------------------
		// Helper: create a base collection if it doesn't already exist.
// ---------------------------------------------------------------------------
		ensureBaseCollection := func(name string, fields []core.Field) error {
			_, err := app.FindCollectionByNameOrId(name)
			if err == nil {
				return nil
			}

			c := core.NewBaseCollection(name)
			c.ListRule = types.Pointer("")
			c.ViewRule = types.Pointer("")
			c.CreateRule = types.Pointer("")
			c.UpdateRule = types.Pointer("")
			c.DeleteRule = types.Pointer("")

			c.Fields.Add(&core.TextField{Name: "doc_id"})
for _, f := range fields {
c.Fields.Add(f)
}
return app.Save(c)
}

eventFields := []core.Field{
&core.TextField{Name: "p"},
&core.NumberField{Name: "v"},
&core.TextField{Name: "t"},
}
userFields := []core.Field{
&core.NumberField{Name: "u"},
&core.TextField{Name: "t"},
&core.TextField{Name: "m"},
}
betaUsersFields := []core.Field{
&core.TextField{Name: "b"},
&core.TextField{Name: "t"},
}

if err := ensureBaseCollection("hyttahub__tictactoe__services__status__service_events", eventFields); err != nil {
return err
}
if err := ensureBaseCollection("hyttahub__tictactoe__services__status__service_users", userFields); err != nil {
return err
}
if err := ensureBaseCollection("hyttahub__tictactoe__services", betaUsersFields); err != nil {
return err
}

return nil
}, func(app core.App) error {
// Rollback
collections := []string{
"hyttahub__tictactoe__services__status__service_events",
"hyttahub__tictactoe__services__status__service_users",
"hyttahub__tictactoe__services",
"users",
}
for _, name := range collections {
c, err := app.FindCollectionByNameOrId(name)
if err == nil {
app.Delete(c)
}
}
su, err := app.FindAuthRecordByEmail("_superusers", "admin@dev.local")
if err == nil {
app.Delete(su)
}
return nil
})
}

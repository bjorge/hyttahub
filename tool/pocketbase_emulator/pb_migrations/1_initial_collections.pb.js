/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  // =========================================================================
  // Migration 1: Initial collections for HyttaHub / tictactoe example
  //
  // PocketBase collection names must be valid identifiers ([a-zA-Z0-9_]+).
  // HyttaHub uses slash-separated paths, encoded by the Dart client as:
  //   path.replaceAll('/', '__')
  //
  // e.g. "hyttahub/tictactoe/services/status/service_events"
  //   →  "hyttahub__tictactoe__services__status__service_events"
  //
  // This migration creates:
  //   - A default dev superuser  (admin@dev.local / Admin1234!)
  //   - users  (auth collection — required by PocketbaseHyttaHubAuth)
  //   - Static service-level collections for the tictactoe root collection
  //
  // Dynamic site/account collections are auto-created on first access by
  // the middleware in pb_hooks/main.pb.js.
  // =========================================================================

  // ---------------------------------------------------------------------------
  // Default dev superuser
  // Email:    admin@dev.local
  // Password: Admin1234!
  //
  // LOCAL DEVELOPMENT ONLY — never use in production.
  // ---------------------------------------------------------------------------
  const superuserExists = (() => {
    try { app.findAuthRecordByEmail("_superusers", "admin@dev.local"); return true; } catch(_) { return false; }
  })();

  if (!superuserExists) {
    const superusers = app.findCollectionByNameOrId("_superusers");
    const su = new Record(superusers);
    su.set("email",           "admin@dev.local");
    su.set("password",        "Admin1234!");
    su.set("passwordConfirm", "Admin1234!");
    app.save(su);
    console.log("[hyttahub] created default dev superuser: admin@dev.local");
  }

  // ---------------------------------------------------------------------------
  // users — auth collection (required by PocketbaseHyttaHubAuth)
  // ---------------------------------------------------------------------------
  const usersExists = (() => {
    try { app.findCollectionByNameOrId("users"); return true; } catch(_) { return false; }
  })();

  if (!usersExists) {
    const users = new Collection({
      type:       "auth",
      name:       "users",
      listRule:   "@request.auth.id != ''",
      viewRule:   "@request.auth.id != ''",
      createRule: "",   // allow self-registration
      updateRule: "@request.auth.id = id",
      deleteRule: "@request.auth.id = id",
      authRule:   "",
      manageRule: null,
      fields: [
        { name: "email",    type: "email", required: true },
        { name: "verified", type: "bool",  required: false },
      ],
      authAlert:    { enabled: false },
      passwordAuth: { enabled: true, identityFields: ["email"] },
    });
    app.save(users);
  }

  // ---------------------------------------------------------------------------
  // Helper: create a base collection if it doesn't already exist.
  // ---------------------------------------------------------------------------
  function ensureBaseCollection(name, fields) {
    try { app.findCollectionByNameOrId(name); return; } catch (_) {}

    const c = new Collection({
      type:       "base",
      name:       name,
      listRule:   "",
      viewRule:   "",
      createRule: "",
      updateRule: "",
      deleteRule: "",
    });
    for (const f of fields) {
      c.fields.add(new Field(f));
    }
    app.save(c);
  }

  // Common field sets
  const eventFields = [
    { name: "p", type: "text"   }, // payload  (base64 proto)
    { name: "v", type: "number" }, // version  (int)
    { name: "t", type: "text"   }, // timestamp
  ];
  const userFields = [
    { name: "u", type: "number" }, // member / author id
    { name: "t", type: "text"   }, // timestamp
    { name: "m", type: "text"   }, // markedForDeletion (base64 proto)
  ];
  const betaUsersFields = [
    { name: "b", type: "text" }, // betaUsers (repeated emails)
    { name: "t", type: "text" }, // timestamp
  ];

  // ---------------------------------------------------------------------------
  // Static tictactoe service collections
  // ---------------------------------------------------------------------------
  ensureBaseCollection("hyttahub__tictactoe__services__status__service_events", eventFields);
  ensureBaseCollection("hyttahub__tictactoe__services__status__service_users",  userFields);
  ensureBaseCollection("hyttahub__tictactoe__services",                          betaUsersFields);

  // Dynamic site/account collections are NOT pre-created here because their
  // paths contain runtime-generated IDs. The auto-collection middleware in
  // pb_hooks/main.pb.js creates them on first access.
  //
  // Examples of auto-created collection names:
  //   hyttahub__tictactoe__sites__<siteId>__site_events
  //   hyttahub__tictactoe__sites__<siteId>__site_users
  //   hyttahub__tictactoe__accounts__<userId>__account_events

}, (app) => {
  // Rollback
  for (const name of [
    "hyttahub__tictactoe__services__status__service_events",
    "hyttahub__tictactoe__services__status__service_users",
    "hyttahub__tictactoe__services",
    "users",
  ]) {
    try { app.delete(app.findCollectionByNameOrId(name)); } catch (_) {}
  }
  try {
    app.delete(app.findAuthRecordByEmail("_superusers", "admin@dev.local"));
  } catch (_) {}
});

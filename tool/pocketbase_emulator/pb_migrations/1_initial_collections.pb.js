/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  // =========================================================================
  // Migration 1: Initial collections for HyttaHub / tictactoe example
  //
  // PocketBase collection names must be valid identifiers ([a-zA-Z0-9_]+).
  // HyttaHub uses slash-separated paths, which are encoded by the Dart client
  // using: path.replaceAll('/', '__')
  //
  // So the canonical path "hyttahub/tictactoe/services/status/service_events"
  // becomes the collection name "hyttahub__tictactoe__services__status__service_events".
  //
  // This migration creates:
  //   - users  (auth collection — required by PocketbaseHyttaHubAuth)
  //   - Static service-level collections for the "tictactoe" root collection
  //
  // Dynamic site/account collections are created on first access by the
  // auto-collection middleware in pb_hooks/main.pb.js.
  // =========================================================================

  // ---------------------------------------------------------------------------
  // users — auth collection
  // ---------------------------------------------------------------------------
  const usersExists = (() => {
    try { app.findCollectionByNameOrId("users"); return true; } catch(_) { return false; }
  })();

  if (!usersExists) {
    const users = new Collection({
      type:            "auth",
      name:            "users",
      listRule:        "@request.auth.id != ''",
      viewRule:        "@request.auth.id != ''",
      createRule:      "",   // allow self-registration
      updateRule:      "@request.auth.id = id",
      deleteRule:      "@request.auth.id = id",
      authRule:        "",
      manageRule:      null,
      fields: [
        { name: "email",    type: "email", required: true },
        { name: "verified", type: "bool",  required: false },
      ],
      authAlert: { enabled: false },
      passwordAuth: { enabled: true, identityFields: ["email"] },
    });
    app.save(users);
  }

  // ---------------------------------------------------------------------------
  // Helper: create a base collection if it doesn't already exist.
  // ---------------------------------------------------------------------------
  function ensureBaseCollection(name, fields) {
    try {
      app.findCollectionByNameOrId(name);
      return; // already exists
    } catch (_) {}

    const c = new Collection({
      type:       "base",
      name:       name,
      // Wide-open rules for the local dev emulator.
      // Tighten before any production deployment.
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
  // Static tictactoe service collections (slash → __ encoding)
  //
  //  hyttahub/tictactoe/services/status/service_events
  //      → hyttahub__tictactoe__services__status__service_events
  //  hyttahub/tictactoe/services/status/service_users
  //      → hyttahub__tictactoe__services__status__service_users
  //  hyttahub/tictactoe/services   (stores beta_users doc)
  //      → hyttahub__tictactoe__services
  // ---------------------------------------------------------------------------
  ensureBaseCollection("hyttahub__tictactoe__services__status__service_events", eventFields);
  ensureBaseCollection("hyttahub__tictactoe__services__status__service_users",  userFields);
  ensureBaseCollection("hyttahub__tictactoe__services",                          betaUsersFields);

  // ---------------------------------------------------------------------------
  // Dynamic site / account collections are NOT pre-created here because their
  // paths contain runtime-generated IDs. The auto-collection middleware in
  // pb_hooks/main.pb.js creates them on first access.
  //
  // Examples (encoded names):
  //   hyttahub__tictactoe__sites__<siteId>__site_events
  //   hyttahub__tictactoe__sites__<siteId>__site_users
  //   hyttahub__tictactoe__accounts__<userId>__account_events
  // ---------------------------------------------------------------------------

}, (app) => {
  // Rollback: drop collections created by this migration.
  for (const name of [
    "hyttahub__tictactoe__services__status__service_events",
    "hyttahub__tictactoe__services__status__service_users",
    "hyttahub__tictactoe__services",
    "users",
  ]) {
    try { app.delete(app.findCollectionByNameOrId(name)); } catch (_) {}
  }
});

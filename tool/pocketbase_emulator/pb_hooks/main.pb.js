/// <reference path="../pb_data/types.d.ts" />

// ---------------------------------------------------------------------------
// HyttaHub auto-collection middleware
// ---------------------------------------------------------------------------
// The HyttaHub Dart client encodes slash-separated paths into valid PocketBase
// collection names by replacing '/' with '__':
//
//   "hyttahub/tictactoe/sites/<siteId>/site_events"
//   → "hyttahub__tictactoe__sites__<siteId>__site_events"
//
// This middleware intercepts record API requests and auto-creates the
// collection (with the correct schema) if it doesn't exist yet.
//
// Only collections whose names start with "hyttahub__" are auto-created;
// internal PocketBase and Admin UI collections are skipped.
// ---------------------------------------------------------------------------

routerUse((e) => {
  const reqPath = e.request.url.path;

  // Only intercept /api/collections/<name>/records[/...] requests.
  const m = reqPath.match(/^\/api\/collections\/(.+?)\/records/);
  if (!m) return e.next();

  const collectionName = decodeURIComponent(m[1]);

  // Only auto-create hyttahub-owned collections; skip internal PocketBase
  // collections (e.g. _superusers, _pb_users_auth_, pbc_* IDs).
  if (!collectionName.startsWith("hyttahub__")) return e.next();

  // ensureCollection is defined here (inside the callback) to avoid
  // the "not defined" ReferenceError that occurs when PocketBase's JSVM
  // calls the routerUse callback in a scope that doesn't have access to
  // top-level function declarations.
  function ensureCollection(name) {
    try {
      $app.findCollectionByNameOrId(name);
      return; // already exists
    } catch (_) {}

    console.log("[hyttahub] auto-creating collection: " + name);

    const col = new Collection({
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

    const eventFields = [
      new Field({ name: "p", type: "text"   }), // payload (base64 proto)
      new Field({ name: "v", type: "number" }), // version (int)
      new Field({ name: "t", type: "text"   }), // timestamp
    ];
    const memberFields = [
      new Field({ name: "u", type: "number" }), // member / author id
      new Field({ name: "t", type: "text"   }), // timestamp
      new Field({ name: "m", type: "text"   }), // markedForDeletion (base64 proto)
    ];

    let fields = [];
    if (name.endsWith("__site_events"))    fields = eventFields;
    if (name.endsWith("__account_events")) fields = eventFields;
    if (name.endsWith("__service_events")) fields = eventFields;
    if (name.endsWith("__site_users"))     fields = memberFields;
    if (name.endsWith("__service_users"))  fields = memberFields;

    for (const f of fields) {
      col.fields.add(f);
    }

    $app.save(col);
    console.log("[hyttahub] created collection '" + name + "' with " + fields.length + " fields");
  }

  ensureCollection(collectionName);
  return e.next();
});

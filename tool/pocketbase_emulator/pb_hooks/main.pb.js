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
// Because site IDs are runtime-generated, we cannot pre-create every possible
// collection in a migration. This middleware intercepts every request to
// /api/collections/<name>/records before PocketBase resolves the collection,
// and auto-creates it with the appropriate schema if it doesn't exist yet.
//
// Schema mapping (by name suffix after __ encoding):
//
//   __site_events     → p (text), v (number), t (text)
//   __account_events  → p (text), v (number), t (text)
//   __service_events  → p (text), v (number), t (text)
//   __site_users      → u (number), t (text), m (text)
//   __service_users   → u (number), t (text), m (text)
// ---------------------------------------------------------------------------

function ensureCollection(name) {
  try {
    $app.findCollectionByNameOrId(name);
  } catch (_) {
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
      new Field({ name: "p", type: "text"   }), // payload  (base64 proto)
      new Field({ name: "v", type: "number" }), // version  (int)
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
}

// Register a global middleware that runs before ALL routes.
// For any request targeting /api/collections/<name>/records[/...],
// we pre-create the collection before PocketBase resolves it.
routerUse((e) => {
  const path = e.request.url.path;
  const m = path.match(/^\/api\/collections\/(.+?)\/records/);
  if (m) {
    const collectionName = decodeURIComponent(m[1]);
    ensureCollection(collectionName);
  }
  return e.next();
});

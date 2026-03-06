/// <reference path="../pb_data/types.d.ts" />

// ---------------------------------------------------------------------------
// HyttaHub auto-collection middleware + dev helpers
// ---------------------------------------------------------------------------
// The HyttaHub Dart client encodes slash-separated paths into valid PocketBase
// collection names by replacing '/' with '__':
//
//   "hyttahub/tictactoe/sites/<siteId>/site_events"
//   → "hyttahub__tictactoe__sites__<siteId>__site_events"
//
// Every collection gets a "doc_id" text field so the Dart client can look up
// records by application-level ID (email, version number, etc.) without
// running into PocketBase's 15-character primary key constraint.
//
// Only collections whose names start with "hyttahub__" are auto-created;
// internal PocketBase/Admin UI collections are skipped entirely.
//
// DEV HELPER: New users in the "users" collection are auto-verified so the
// hyttahub auth flow can proceed without a real SMTP server.
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Auto-verify new users (dev emulator only)
// ---------------------------------------------------------------------------
// onRecordBeforeCreateRequest is a REQUEST-level hook, so e.collection is
// available. We set verified=true before the INSERT so the record is written
// as verified from the start — no after-hook save needed.
onRecordBeforeCreateRequest((e) => {
  try {
    if (e.collection.name === "users") {
      e.record.set("verified", true);
      console.log("[hyttahub] auto-verifying new user: " + e.record.getString("email"));
    }
  } catch(err) {
    // Non-fatal: log and continue. User will need manual verification if this fails.
    console.log("[hyttahub] auto-verify error (non-fatal): " + err);
  }
  return e.next();
});

// ---------------------------------------------------------------------------
// Auto-collection middleware
// ---------------------------------------------------------------------------
routerUse((e) => {
  const reqPath = e.request.url.path;

  // Only intercept /api/collections/<name>/records[/...] requests.
  const m = reqPath.match(/^\/api\/collections\/(.+?)\/records/);
  if (!m) return e.next();

  const collectionName = decodeURIComponent(m[1]);

  // Skip internal PocketBase collections — only auto-create hyttahub ones.
  if (!collectionName.startsWith("hyttahub__")) return e.next();

  // ensureCollection is defined inside the callback to avoid ReferenceError:
  // PocketBase's JSVM executes the routerUse callback in a scope that does
  // not have access to top-level function declarations.
  function ensureCollection(name) {
    try {
      $app.findCollectionByNameOrId(name);
      return; // already exists
    } catch (_) {}

    console.log("[hyttahub] auto-creating collection: " + name);

    const col = new Collection({
      type:       "base",
      name:       name,
      listRule:   "",
      viewRule:   "",
      createRule: "",
      updateRule: "",
      deleteRule: "",
    });

    // doc_id stores the application-level document ID (email, version string,
    // etc.) so the Dart client can filter by it instead of the PB primary key.
    col.fields.add(new Field({ name: "doc_id", type: "text" }));

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

    let schemaFields = [];
    if (name.endsWith("__site_events"))    schemaFields = eventFields;
    if (name.endsWith("__account_events")) schemaFields = eventFields;
    if (name.endsWith("__service_events")) schemaFields = eventFields;
    if (name.endsWith("__site_users"))     schemaFields = memberFields;
    if (name.endsWith("__service_users"))  schemaFields = memberFields;

    for (const f of schemaFields) {
      col.fields.add(f);
    }

    $app.save(col);
    console.log("[hyttahub] created '" + name + "' (" + schemaFields.length + " schema fields + doc_id)");
  }

  ensureCollection(collectionName);
  return e.next();
});

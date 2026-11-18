## Real-Time Event Delivery and Gap Recovery

HyttaHub replays an append-only, contiguously versioned event log. A single
missing version stalls replay, so most of the complexity in the realtime path
exists to detect and recover from a version that never arrived.

This document records the failure modes, which mechanism covers each, and how
to tell them apart when one shows up in production. It exists because several
of the conclusions below are not obvious from reading the code, and were
expensive to work out.

### The two layers

**`BaseReplayBloc`** (`lib/common_blocs/base_replay_bloc.dart`) owns the
consumer's position in the log — `_lastVersion` — and the recovery policy. It
buffers out-of-order events and only replays a contiguous run.

**The storage implementation** owns the transport. `listenEvents` takes a
version *cursor* (`int Function()`), not a snapshot, and reads it on every seed
and re-seed. The storage must not keep its own watermark: a version the
consumer has not processed yet has to be re-delivered, not assumed delivered.
Keeping a second watermark is what made it possible, before 0.2.0, for storage
to advance past an event the consumer never received, with nothing able to
recover it.

### Failure modes

**1. Mid-sequence hole.** v10 arrives, v9 never did. `_processBuffer` sees the
discontinuity and arms the gap timer (`base_replay_bloc.dart:218`).

**2. Tail silence.** v9 was the last write and never arrived. The gap timer can
*never* fire for this — there is no later event to reveal the hole. Only the
periodic resync catches it. This is why both detectors exist; they are not
redundant.

**3. Half-open connection.** The TCP connection is alive but carries nothing.
`SseClient` keys its auto-retry off `onDone`/`onError`, neither of which a
half-open socket produces, so it never reconnects. Nothing client-side can
observe this: `RealtimeService._sse` is private, `clientId` is the only exposed
state, and server pings are explicitly discarded
(`sse_client.dart:160` in the pocketbase SDK). A REST probe comparing the
highest known version is the only available detector short of patching the SDK.

### The timer race — read this before tuning either value

`gapTimeout` and `resyncInterval` are in competition, and the obvious reasoning
about their ordering is wrong.

- `_resetResyncTimer()` is called at the end of `_onNewEvents`
  (`base_replay_bloc.dart:181`) — on **every** event batch. It cancels and
  re-arms a fresh timer.
- `_gapTimer ??= Timer(gapTimeout, ...)` (`:218`) — the `??=` means it is armed
  **once** when the hole appears and keeps its original deadline.

So "my resync interval is shorter than my gap timeout, therefore the resync
fires first" only holds when the stream is **idle**. During an active session
every incoming event pushes the resync deadline out while the gap timer counts
down steadily. The gap timer wins exactly when it matters least.

Do not rely on the ordering. The robust protection is that `_handleGapTimeout`
reads storage before it will skip anything (see below), which works regardless
of which timer wins.

### What protects what

| Mechanism | Covers | Where |
| --- | --- | --- |
| Gap timer → storage read → skip only if genuinely absent | mid-sequence hole | `_handleGapTimeout` / `_fillGapFromStorage` (`:252`, `:280`) |
| Periodic resync: probe highest version, fetch the difference, then `reconnectRealtime()` | tail silence, stale transport | `_resetResyncTimer` (`:506`) |
| `reconnectRealtime()` tearing down the shared connection | half-open connection | storage implementation |
| Server-side SSE keep-alive | half-open connection, at the source | server config, not this repo |

`gapTimeout` defaults to one resync interval plus slack, read when the timer is
armed so it tracks `HyttaHubOptions.resyncInterval` (`:96`). A gap timeout
*shorter* than the resync interval silently pre-empts its own recovery: the
skip advances `_lastVersion` past the hole, after which the resync's
`latestVersion > _lastVersion` check can never fire and the event is lost with
no error. That was the behaviour before 0.2.0.

### Diagnosing a gap in production

Two debug lines distinguish the cases:

- `gap refetch recovered N event(s)` — the version existed in storage and was
  delivered late or not at all. A **delivery** problem. Now self-healing.
- `gap vN..vM not in storage either, skipping` — the version genuinely is not
  in storage. An **allocation** problem: something wrote past a hole. Look at
  the write path, not the transport.

To confirm against PocketBase directly, using the `expected vN` from the error:

```
curl -s 'http://<host>/api/collections/hyttahub_site_events/records?filter=(siteId="<siteId>"%26%26v=<N>)'
```

If vN exists, it is delivery. If it does not, it is allocation.

### Version allocation with multiple listeners

Several blocs may replay the **same** collection — `SiteReplayBloc` and an
app-level replay bloc both resolve to `collectionSiteEventsPath(siteId)`. They
are independent listeners with independent cursors, so **a writer must allocate
the next version from the maximum across all of them**, plus any local
optimistic events. Taking it from one bloc collides with versions another has
already seen, and the unique index on `(app, parentId, v)` rejects the write.

Note the two replay functions have deliberately different gap policies, and the
asymmetry is load-bearing:

- `siteReplay` records everything handed to it unconditionally
  (`lib/site_blocs/site_replay.dart:34`), so its `lastVersion` jumps past holes.
- An app replay that enforces contiguity stops at the hole, so its
  `lastVersion` freezes there.

The consequence is that after a gap the site cursor runs ahead and the app
cursor stalls. Taking the max routes around whichever one is stuck. Changing
either policy means revisiting the allocation logic.

### Open items

- A real connection-liveness check needs the pocketbase Dart SDK to expose
  something — a last-message timestamp or a ping callback. Until then the
  data-level REST probe is a proxy, not a liveness check.
- `registerListener` runs at stream construction rather than at `onListen`, so
  a stream created and never listened to stays registered.
- `reconnectRealtime()` is a no-op in one case: once the SDK has flagged the
  connection dead it clears `clientId`, and `unsubscribe()` then returns
  without tearing down the socket. Recovery there falls back to `SseClient`'s
  own retry. The half-open case — connection alive, `clientId` still set — is
  the one it genuinely fixes, and the common one on mobile.

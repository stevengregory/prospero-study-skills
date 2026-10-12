---
name: prospero-study
description: >
  Hub/default skill for the Prospero Skills Suite. Use for
  Prospero's Study authentication, REST/MCP guidance, library
  management, catalog discovery, book search/add/import/enrichment,
  shelves, progress, notes, stats, export, and explicit write-safety.
version: 3.6.33
author: Prospero's Study
license: MIT
compatibility: Requires network access to Prospero's Study API instance.
metadata:
  hermes:
    tags: [prospero-study, books, reading, library, productivity, agents]
    related_skills:
      - prospero-study-world-orientation
      - prospero-study-immersive-presence
      - prospero-study-reading-companion
---

# Prospero's Study

Personal book tracking API. REST is the default path; MCP is available when
your runtime supports it. No social, no ads, agent-friendly.

## Prospero 101 — The Voyage

New to Prospero? Run the short agent-first orientation course. It is a
**hosted standalone chain of markdown stops** (same outskirts class as
`/llms.txt`). Start at the canonical URL; do not assume a source checkout.

- Syllabus (start here): `https://prospero.study/learn/101.md`
- Then follow each stop's **Next →** link (preface → map → letter → docks;
  island is optional Study/world context; stacks and companion are optional
  write practice with explicit user consent; then after)
- Human mirror: `https://prospero.study/learn/101`

Prefer this when onboarding a runtime; keep this skill as the day-to-day
operational runbook afterward.

## Quick start for existing API key

Use this path when the active agent already has `PROSPERO_API_KEY`. No invite
code is needed for an existing API key.

1. Set `PROSPERO_API_URL=https://api.prospero.study` (the service root). REST
   examples in this skill use full `/api/v1/...` paths. The CLI and
   `prospero-mcp` add `/api/v1` themselves, so they use the same value.
2. Load `PROSPERO_API_KEY` from secure storage.
3. Exchange it with `POST /api/v1/users/token-exchange`.
4. Use the returned bearer on `GET /api/v1/agents/home`.
5. For world context, call `GET /api/v1/study/world` only when it helps.
6. For private data, use the narrowest read-only endpoint unless the user
   explicitly asks for a write.

Prefer a fresh bearer minted from `PROSPERO_API_KEY` over a stored bearer. The
bearer payload should include a non-empty `kid` claim; that is how Prospero
knows which API-key card to mark as seen.

If your runtime does not preserve shell/tool state across turns, do not assume a
bearer from a prior command still exists. At the start of each Prospero work
turn, exchange `PROSPERO_API_KEY` for a fresh bearer or confirm the current
bearer payload has a non-empty `kid` before protected API calls.

## Prospero Skills Suite

Install the public Prospero skills as a suite:

- `prospero-study`: hub/default skill for auth, API work, library operations,
  write safety, and ordinary book tasks.
- `prospero-study-world-orientation`: companion skill for public Study
  landmarks, resident boundaries, `/study/world`, and shared-world grounding.
- `prospero-study-immersive-presence`: companion skill for invited immersive
  scenes, theatrical pacing, and presence inside the Study.
- `prospero-study-reading-companion`: companion skill for consent-first reading
  companionship, passage reflection, and Read With Agent pairing behavior.

Install all four together. Invoke selectively. A normal book/API task should
stay in this operational skill unless the user asks for Study/world context,
immersive presence, or reading companionship.

Hermes installs from the public Prospero skills tap. Hosted Prospero URLs remain
the canonical freshness source across Hermes, OpenClaw, Claude-style filesystem
skills, and other harnesses. Public skill updates must not overwrite
private/local ops overlays.

## Skill Install And Freshness

Hermes:

```bash
hermes skills tap add stevengregory/prospero-study-skills
hermes skills install stevengregory/prospero-study-skills/skills/prospero-study --yes
hermes skills install stevengregory/prospero-study-skills/skills/prospero-study-world-orientation --yes
hermes skills install stevengregory/prospero-study-skills/skills/prospero-study-immersive-presence --yes
hermes skills install stevengregory/prospero-study-skills/skills/prospero-study-reading-companion --yes

hermes skills check prospero-study
hermes skills check prospero-study-world-orientation
hermes skills check prospero-study-immersive-presence
hermes skills check prospero-study-reading-companion
hermes skills update prospero-study
hermes skills update prospero-study-world-orientation
hermes skills update prospero-study-immersive-presence
hermes skills update prospero-study-reading-companion
```

OpenClaw and filesystem skill loaders: use the hosted URLs above or the public
tap repo at `stevengregory/prospero-study-skills`, then compare loaded versions
against `/.well-known/agent.json` or the `recommended_skills` block returned by
`GET /api/v1/agents/home`. Prefer native tracked install/update flow when
available. If you must manually refresh, replace only the public canonical skill
and do not overwrite private profile or ops overlays.

Freshness checks should be quiet: check on startup, when Prospero work begins,
when a world/immersive/read-with-agent session begins, or after `/agents/home`;
nudge only when a loaded skill is stale. A gentle nudge is enough: "I have
`prospero-study` 3.6.1 loaded; current is 3.6.33. I should update before
continuing."

Public canonical skills (`prospero-study`, `prospero-study-world-orientation`,
`prospero-study-immersive-presence`, `prospero-study-reading-companion`) are
safe to update from the public tap or Prospero's hosted URLs. Private/local ops
skills are separate and must not be overwritten by public updates.

If native install/update tooling blocks a trusted canonical public skill because
of scanner heuristics, fetch only from the public tap or canonical Prospero URL,
install under the explicit skill name, and verify the installed version against
`/.well-known/agent.json`. Do not use this fallback for private/local ops
overlays.

## Configuration

The API key determines whose library you're connected to. Set it before use:

```bash
export PROSPERO_API_URL=https://api.prospero.study
export PROSPERO_API_KEY=YOUR_PSK_API_KEY
export PROSPERO_USER_AGENT=Prospero-Agent/1.0
```

Examples below use full `/api/v1/...` paths. Prepend `$PROSPERO_API_URL` when
calling REST with curl (`$PROSPERO_API_URL/api/v1/users/token-exchange`). The
CLI and `prospero-mcp` use the same service-root value because they add
`/api/v1` internally. Do not set `PROSPERO_API_URL` to
`https://api.prospero.study/api/v1`; that doubles the prefix in CLI/MCP calls.

Install the CLI/TUI with:

```bash
curl -fsSL https://prospero.study/install.sh | sh
```

Or `brew install stevengregory/prospero-cli/prospero`. The public 3D island is
at `https://prospero.study/island`.

**API key vs bearer:** the stored long-lived `psk_...` value is an API key.
Older examples may call it `PROSPERO_TOKEN`; keep that as a legacy fallback
only. Exchange the API key for a short-lived bearer/access token before calling
protected endpoints.

**Bearer identity:** when an agent calls protected endpoints with a bearer
minted from `PROSPERO_API_KEY`, Prospero updates that API key's `last_used_at`.
That drives the authenticated Agents page's "seen" tether and active dot. If
the card looks stale after successful API calls, exchange the API key for a
fresh bearer and locally inspect only the JWT payload: `kid` should be
non-empty, `source` should usually be `agent` or `mcp`, and `scope` should match
the key. Do not reveal the bearer or API key.

Some runtimes do not persist shell variables, process state, or bearer tokens
between tool calls. In those runtimes, a fresh token exchange at the start of
each Prospero work turn is normal; it is not a backend workaround.

**User-Agent:** scripts and bare HTTP clients should send an explicit
`User-Agent` on `POST /api/v1/users/token-exchange` and every later API call.
A generic fallback such as `Prospero-Agent/1.0` is fine; a more descriptive
agent/client identifier is better when your runtime supports it.

Load credentials from the active agent/user's configured secure store. If a
private env/config file is the only available option, keep it outside the repo
and restrict file permissions.

If your runtime uses MCP, set it in your server config instead (see MCP Server section below).

## Skill scope

This hosted skill is the default operational API skill. Use it to register,
authenticate, manage real library data, read stats, update progress, manage
shelves, and use optional Study orientation when it helps the user.

Do not use this skill to impersonate Prospero, Miranda, or another resident, or
to adopt their private voice. Resident identity, voice, relationship continuity,
and immersive scene craft belong in resident runtimes or optional companion world
skills. This skill should remain useful for agents that only manage books.

## Write safety

This skill grants full read-write access. Read-only questions may be answered
directly from API results. Writes require clear user intent for the exact change.

Confirm before destructive actions, revoking keys, deleting books, replacing
notes, overwriting catalog fields, or making broad/batch changes. If the request
is ambiguous, ask before writing.

## New agent registration

**New agent account? Follow these steps only when the human supplied an invite
and explicitly asked you to register. Registration is invite-gated and creates
a durable read-write key. Existing keys do not need registration.**

If registration fails because no invite code is available, explain that beta
access is invite-gated and send the user to Miranda at `prospero.study`.

### Step 1: Register (one call)

```http
POST /api/v1/agents/register
Content-Type: application/json
User-Agent: Prospero-Agent/1.0

{"agent_name": "my-agent", "invite_code": "YOUR-AGENT-INVITE"}
```

Returns an `api_key` (starts with `psk_`). Store it securely — it won't be shown again. No email or password needed.

Registration leaves the library empty by default. The optional JSON body field
`seed_demo` defaults to `false`; setting `"seed_demo": true` seeds 10 classic books
on a "Prospero's Picks" shelf. Do not opt into demo-book seeding unless the human
explicitly asks for that separate library mutation.

### Step 2: Get a token

```http
POST /api/v1/users/token-exchange
Content-Type: application/json
User-Agent: Prospero-Agent/1.0

{"api_key": "<PROSPERO_API_KEY>"}
```

Use the returned JSON `token` value as `Authorization: Bearer <bearer>` on all
requests. In your own variables, call it `bearer`, `access_token`, or
`PROSPERO_BEARER` so it is not confused with the long-lived API key.

Bearer lifetime is 24 hours by default. The server may set `AUTH_TOKEN_TTL` to
another whole-second duration between 1h and 168h; agents should treat expiry
as normal and exchange again. Revocation is checked on every request via the
bearer `kid` (no positive cache): a revoked or expired key fails the next
protected call.

### Step 3: Get your home briefing

```http
GET /api/v1/agents/home
Authorization: Bearer <bearer>
User-Agent: Prospero-Agent/1.0
```

One call returns: user profile, currently reading books (with percent when
available), shelves, `recommended_skills`, and `skill_freshness`. Pair it with
`/api/v1/stats/snapshot` when you need totals, streaks, or record-style stats.

### Optional: Study orientation

For public Study context, `GET /api/v1/study/world` returns an orientation
manifest with resident definitions, minimal resident blocking, locations,
feature definitions, natural inhabitants, relationships, entry points,
improvisation boundaries, a public `worldClock`, `spirits` (public spirit
presences — currently Ariel: always active, not location-bound, not
interactive, and not driven by the resident presence wire), and `waters`
(the island's named waters — the Hidden Sea, Juliet Passage, Caliban's Bay,
the Atlantic, the Roarers: chart geography and scene texture only, never
presence locations; water-adjacent presence stays offshore, docks, beach,
or shoreline).

Use it only when the user wants Study/world context. It is not required for
library management, does not expose private readers/books/sessions, and should
not be treated as Prospero's or Miranda's resident voice.

If the user explicitly wants Study/world interpretation, read the optional
world-orientation companion skill at
`https://prospero.study/skill/world-orientation.md`. If the user wants
immersive Study scenes or theatrical presence, also read the optional immersive
companion skill at `https://prospero.study/skill/immersive-presence.md`. If the
user wants consent-first reading companionship, passage reflection, or a Read
With Agent pairing, read the optional reading companion skill at
`https://prospero.study/skill/reading-companion.md`. Keep this operational
skill in charge of authentication, API calls, and write safety; use companion
skills only for world interpretation, scene craft, pacing, privacy boundaries,
reading companionship, and grounded presence, including when to report
owner-visible agent-card presence. The companion skills own time-aware scene
openings and reading-session presence updates; this operational skill owns the
API call and write-safety mechanics.

How to use it:

- If the user asks about Study geography, read `locations` (each location
  carries its own `connections` and `features`; those are not top-level
  fields), plus top-level `featureDefinitions`, `waters`, `spirits`, and
  `naturalInhabitants` before answering.
- If the user asks for immersive world context, read `worldClock` for the
  shared island timezone, local date/time, UTC offset, time of day, and season.
  Use it lightly for atmosphere; do not treat it as private scene continuity,
  weather, or resident memory.
- API/machine fields may keep 24-hour or ISO time. If exact island time is
  shown in human-facing prose, CLI output, or tool summaries, prefer 12-hour
  phrasing such as `6:25 PM`. Homepage/read-with-agent hero copy should usually
  stay time-of-day only.
- Treat listed places as public landmarks, not a complete map. You may improvise
  session-local places that fit the island and do not contradict the manifest,
  but do not present them as universally known public canon.
- Guest Quarters are now a public landmark and private-threshold for visitor
  lodging and offstage return. Treat them as a respectful threshold, not a hotel
  system or public room inventory.
- If the user asks about resident anchors, read `residentDefinitions` and
  `relationships`, but do not invent private feelings, memories, or active
  scenes from the manifest.
- If the user asks who is publicly placed right now, read `residents` as sparse
  blocking only: `id`, `locationId`, `status`, and `lastSeenAt`.
- Treat listed residents as public residents, not the whole cast. Incidental
  characters can emerge inside a scene, but do not present them as established
  residents, agents, or real users unless the app later promotes them.
- Incidental characters should usually pass through or fill the scene. Keep the
  island rooted in The Tempest; do not turn passing figures into the center of
  the Study.
- If the user asks what is happening now, prefer `GET /api/v1/study/presence`
  for public Study/resident presence and authenticated library endpoints for
  private reading state.
- Public Study presence is resident display state, not owner-visible agent-card
  presence. Public residents may include `locationId` and `locationLabel` that
  align with `/api/v1/study/world` locations. Use `location` / `activity` for
  compact display.
- Owner-visible agent-card presence is separate from public resident presence.
  `PUT /api/v1/agents/me/presence` needs write scope plus an `agent` or `mcp`
  key. When companion guidance says to report it, send display-ready `location`
  phrases such as `At the Docks` or `In the Study`; include `locationId` too
  when the place is a known world landmark. Send `activity` as the short
  sentence fragment that should appear after the comma: lower-case ordinary
  opening words, preserve proper nouns and acronyms, and omit the final period
  because the card finishes the sentence. Good examples: `available for
  counsel`, `on call`, and `reading The Iliad with Steven`.
- Prefer the CLI transition helper when available instead of hand-composing
  presence calls:
  `prospero study transition --to garden --activity "reading The Iliad with Steven"`.
  With an agent/MCP API key, the default write updates that caller's
  owner-visible agent card after token exchange and `kid` verification. If a
  resident token env is also present, the default write syncs the matching
  resident lane too. Without suitable agent-card auth it prints a dry run. Use
  explicit `--agent-card` or `--resident` only when you intentionally want one
  lane, and use `--world-session <id>` only for an explicit private session. Do
  not use resident tokens for ordinary user-owned agents.
- A dry run, auth failure, missing Keychain/credential, missing `kid`, or
  non-2xx API result is not a successful footprint. Do not imply the presence
  card or session state was updated unless the write actually landed.
- Presence is a tether, not a gate. A failed or delayed presence update should
  degrade the visible card, not the scene. In immersive or reading scenes,
  continue gracefully and retry the compact update quietly when possible. Do not
  mention the status problem by default.
- Mention the status issue only when the user asks about presence/status, visible
  presence is central to the task, repeated retries fail and the user can act, or
  the user is explicitly debugging/administering. For ordinary users, preserve
  the experience. For admin/debugging, expose the precise cause and retry path.
- The transition helper fetches `/api/v1/study/world` when available, or can
  accept `--time-of-day`, to print light island-time plausibility notes. Treat
  those notes as orientation, not enforcement: the clock should help ask "does
  this transition make sense for the island hour?", not forbid the scene.
- If the user explicitly wants immersive private Study context, authenticated
  `/api/v1/study/world-sessions` can hold per-user resident/location
  state, and `/api/v1/study/world-sessions/{id}/events` can read the compact
  transition trail. Treat both as low-level continuity, not resident memory and
  not a read-with-agent pairing.
- If the user explicitly asks to pair this agent with a real book, the live
  Read With Agent routes are book-scoped:
  `POST/GET /api/v1/library/books/{book_id}/read-with-agent` and
  `PATCH/DELETE /api/v1/library/books/{book_id}/read-with-agent/{session_id}`.
  The production web UI shows these pairings too — the book page's Reading
  together card and each agent's dossier — so state you change here is visible
  to the reader.
  Agent/API-key callers must let the server infer their own `api_key_id` from
  auth; never send `api_key_id` from an agent/MCP key. Use the reading
  companion skill for consent, request bodies, and pacing before writing
  pairing state. Create body (strict JSON): optional `status`
  (`planned`/`active`/`paused`, not `ended`), `goal`, `note`. Patch body
  (strict JSON): optional `status` (may be `ended`), `goal`, `note`,
  `current_page`, `current_percent`. `current_page` / `current_percent` update
  only the pairing row; they do not write library progress. 403
  `read-with-agent session belongs to another agent` means the caller tried
  another key; 404 `read-with-agent session not found` or `agent api key not
  found` means the pairing or companion is missing.
- World-session create/update payloads are strict compact state. Do not send
  transcripts, immersive prose, private notes, direct public-publish flags, or
  public projection claims; unknown fields are rejected.
- Keep presence privacy strict: private session truth, public projection, and
  narrative expression are separate layers. Current production world sessions
  are durable private state. Do not turn transition events into scene prose, and
  do not publish private session details as public presence.

### Step 4: You're connected. Start helping.

Use the common task examples below for the things your human will ask you to do.

## Fast path for read-only book questions

This Skill is a Markdown runbook, not executable code. Python, curl, Go, Node,
MCP, or another client may call the API; the language is incidental.

For common read-only questions, do not inspect the website and do not build a
fresh script unless your runtime needs one. Use the narrowest API endpoint that
answers the question:

1. Load the active agent/user's `PROSPERO_API_KEY` (`psk_...`) from secure configuration.
2. Exchange it with `POST /api/v1/users/token-exchange`.
3. Send the returned bearer plus an explicit `User-Agent`.
4. Query only the endpoint needed.

For count-only questions, use `GET /api/v1/library/books/count` with normal book
filters and read `total`. Do not fetch book rows unless the answer needs titles,
authors, dates, notes, pages, or other row fields.

Read-only questions may be answered directly from API results. Writes require
explicit user intent for the exact change.

## Common tasks

**"What am I reading?"**
```bash
GET /api/v1/library/books?status=reading
```

**"What was the last book I read?" / "What was my most recently finished book?"**
Use a narrow finished-books query sorted by completion date:
```bash
GET /api/v1/library/books?status=finished&sort=completed_at&order=desc&limit=1
```
Answer from the first row's `title`, `author`, `completed_at`, and `pages`. If
the result is empty, say there are no finished books matching the query; do not
guess from memory.

**"How many books are bookmarked?" / "What's on my Bookmarks shelf?"**
The Bookmarks shelf is a smart shelf in the product UI. It is backed by the `bookmarked` flag on books, not by a physical row from `/api/v1/library/shelves`, so use the smart-shelf endpoint and read `total`:
```bash
GET /api/v1/library/smart-shelves/bookmarks?page=1&per_page=1
```
For the first page of bookmarked books, raise `per_page` as needed. The response shape is `{id, name, kind, books, total, page, per_page}`. For a normal shelf, first `GET /api/v1/library/shelves`, find the shelf `id`, then use `GET /api/v1/library/shelves/{id}/books?paginate=true&page=1&per_page=1` and read `total`. Do not fetch an entire shelf just to count it.

**"How many books have I read this year?"**
Use the current calendar year as an inclusive start and the next year as an exclusive end. Use the count endpoint so you do not fetch book rows just to answer a count:
```bash
GET /api/v1/library/books/count?status=finished&completed_after=2026-01-01&completed_before=2027-01-01
```
Adjust the year boundaries for the current year. Do not fetch the full finished list just to count it.

**"Add Dune to my library"**
```bash
POST /api/v1/library/books
{"title": "Dune", "author": "Frank Herbert"}
```

**"I'm on page 150 of The Iliad"**
First find the book, then log progress:
```bash
GET /api/v1/search?q=The Iliad
PUT /api/v1/library/books/{id}/progress
{"pages_read": 150}
```

**"What was the longest book I've read?"**
```bash
GET /api/v1/library/books?status=finished&sort=pages&order=desc&limit=1
```

**"When did I finish Meditations?"**
```bash
GET /api/v1/search?q=Meditations
GET /api/v1/library/books/{id}
```
Check the `completed_at` field.

**"What notes do I have for this book?"**
First find the book, then use the narrow notes endpoint instead of fetching full detail:
```bash
GET /api/v1/search?q=<title>
GET /api/v1/library/books/{id}/notes
```
The response is `{book_id, notes, updated_at}`. Empty `notes` means the book has no book-level note. These are atemporal book notes, not per-progress-entry notes.

**"Search for books about stoicism"**
```bash
GET /api/v1/search?q=stoicism&scope=catalog
```
Returns results from the external catalog for discovery.

**"What are my reading stats?"**
```bash
GET /api/v1/stats/snapshot
```

**"Export my whole library"**
```bash
GET /api/v1/library/export/json
```

## MCP Server (alternative to REST)

If your runtime supports MCP, connect as a tool server for direct function calls:

Install or build `prospero-mcp` first. Public binary distribution is not advertised yet; for now, the MCP binary is available to authorized/internal beta users. The hosted Skill/REST path above is the public-ready route.

```json
{
  "mcpServers": {
    "prospero": {
      "command": "prospero-mcp",
      "env": { "PROSPERO_API_KEY": "YOUR_PSK_API_KEY" }
    }
  }
}
```

`PROSPERO_TOKEN` is still accepted as a legacy fallback. When it starts with
`psk_`, it is treated as an API key; otherwise it is treated as a bearer value.
If you override `PROSPERO_API_URL` for `prospero-mcp` or the CLI, use the same
service root as this skill (`https://api.prospero.study`); the MCP/CLI client
adds `/api/v1` internally.

17 tools: `search_books`, `list_books`, `get_book`, `get_book_notes`, `get_home`, `get_stats`, `get_book_activity`, `add_book`, `edit_book`, `update_progress`, `update_status`, `bookmark_book`, `unbookmark_book`, `create_shelf`, `shelve_book`, `list_shelves`, `export_library`.

## Full API Reference

### Authentication

Protected endpoints require `Authorization: Bearer <bearer>`.
Registration, login, and token exchange do not.

| Action | Method | Endpoint |
|--------|--------|----------|
| Agent register | POST | `/api/v1/agents/register` |
| Register | POST | `/api/v1/users/register` |
| Login | POST | `/api/v1/users/login` |
| Create API key | POST | `/api/v1/users/api-keys` |
| List API keys | GET | `/api/v1/users/api-keys` |
| Revoke API key | DELETE | `/api/v1/users/api-keys/{id}` |
| Exchange key for JWT | POST | `/api/v1/users/token-exchange` |
| Owner-visible agent-card presence | PUT | `/api/v1/agents/me/presence` |
| Get profile | GET | `/api/v1/users/me` |
| Update profile | PUT | `/api/v1/users/me` |

`PUT /api/v1/agents/me/presence` requires a **read-write** API key whose source
is `agent` or `mcp`. CLI `api-key create` defaults to `--source cli`, which
gets 403 `agent or mcp api key required`. Cookie/session callers get 403
`api key authentication required`. Body (strict JSON): `activity` required;
at least one of `locationId` or `location` required; `status` optional.
Status: empty → `active`;
`active` / `quiet` / `away` stored as-is; `offstage` stored as `away`; any
other value → 400. Unknown `locationId` → 400 `unknown world location "..."`.
Send a display-ready `location` such as `At the Docks` or `In the Study`, and
include `locationId` when the place is a known world landmark.

### Books

| Action | Method | Endpoint |
|--------|--------|----------|
| List all | GET | `/api/v1/library/books` |
| Filter by query | GET | `/api/v1/library/books?q=<term>` |
| Filter by status | GET | `/api/v1/library/books?status=reading` |
| Count books with filters | GET | `/api/v1/library/books/count?status=finished&completed_after=2026-01-01&completed_before=2027-01-01` |
| Count Bookmarks smart shelf | GET | `/api/v1/library/smart-shelves/bookmarks?page=1&per_page=1` |
| Last finished book | GET | `/api/v1/library/books?status=finished&sort=completed_at&order=desc&limit=1` |
| Date range | GET | `/api/v1/library/books?completed_after=2024-01-01&completed_before=2025-01-01` |
| Sort + limit | GET | `/api/v1/library/books?sort=completed_at&order=desc&limit=5` |
| Get by ID | GET | `/api/v1/library/books/{id}` |
| Get with history | GET | `/api/v1/library/books/{id}/detail` |
| Get book notes | GET | `/api/v1/library/books/{id}/notes` |
| List/create Read With Agent pairings | GET/POST | `/api/v1/library/books/{id}/read-with-agent` |
| Update/end a Read With Agent pairing | PATCH/DELETE | `/api/v1/library/books/{id}/read-with-agent/{session_id}` |
| Add | POST | `/api/v1/library/books` |
| Upsert by ISBN | PUT | `/api/v1/library/books` |
| Edit fields | PATCH | `/api/v1/library/books/{id}` |
| Delete | DELETE | `/api/v1/library/books/{id}` |
| Activity log | GET | `/api/v1/library/books/{id}/activity` |
| Batch upsert (≤500) | POST | `/api/v1/library/books/batch` |
| Import Prospero export (≤500) | POST | `/api/v1/library/import/json` |

PATCH accepts: `title`, `author`, `isbn`, `asin`, `pages`, `description`, `started_at`, `completed_at`, `clear_started_at`, `clear_completed_at`.

`DELETE /api/v1/library/books/{id}/overrides` resets the book to catalog
(204). Books with an effective ISBN are rebound from a live provider lookup
first; a provider miss returns 422. ISBN-less books get a plain override wipe.

### Reading state

| Action | Method | Endpoint |
|--------|--------|----------|
| Log progress | PUT | `/api/v1/library/books/{id}/progress` |
| Change status | PUT | `/api/v1/library/books/{id}/status` |
| Bookmark/unbookmark | PUT | `/api/v1/library/books/{id}/bookmark` |
| Update book notes | PUT | `/api/v1/library/books/{id}/notes` |

Progress accepts `pages_read` or `percent` (0–100), plus optional `note` and
`created_at` (for backdated history). Status values: `unread`, `reading`,
`finished`, `abandoned`.

### Search

| Action | Method | Endpoint |
|--------|--------|----------|
| Library search | GET | `/api/v1/search?q=<query>` |
| Catalog search | GET | `/api/v1/search?q=<query>&scope=catalog` |
| Both (deduplicated) | GET | `/api/v1/search?q=<query>&scope=all` |

Library search hits use `book_id` for the library book identifier. Pass that
value to book detail, notes, progress, shelf, bookmark, and activity endpoints
that take `{id}` or `{book_id}`.

### Shelves

| Action | Method | Endpoint |
|--------|--------|----------|
| List shelves | GET | `/api/v1/library/shelves` |
| Create shelf | POST | `/api/v1/library/shelves` |
| List books on shelf | GET | `/api/v1/library/shelves/{id}/books` |
| Count books on shelf | GET | `/api/v1/library/shelves/{id}/books?paginate=true&page=1&per_page=1` |
| Add book to shelf | POST | `/api/v1/library/shelves/{id}/books` |
| Rename shelf | PATCH | `/api/v1/library/shelves/{id}` |
| Delete shelf | DELETE | `/api/v1/library/shelves/{id}` |
| Remove book from shelf | DELETE | `/api/v1/library/shelves/{id}/books/{bookID}` |

Rename, delete, and unshelve refuse the four lifecycle shelves (Reading /
Want to Read / Finished / Abandoned) with 403 (`cannot rename a core shelf`,
`cannot delete a core shelf`, `cannot remove a book from a core shelf — change
status instead`). Confirm before rename or delete.

### Stats & Export

| Action | Method | Endpoint |
|--------|--------|----------|
| Full stats snapshot | GET | `/api/v1/stats/snapshot` |
| Stats summary | GET | `/api/v1/stats/summary` |
| Stats records | GET | `/api/v1/stats/records` |
| Stats streaks | GET | `/api/v1/stats/streaks` |
| Export library (JSON) | GET | `/api/v1/library/export/json` |
| Import Prospero JSON | POST | `/api/v1/library/import/json` |
| Reenrich metadata | POST | `/api/v1/library/reenrich` |

`/snapshot` is `{ summary, records, streaks }`. Prefer it for a full picture;
use the narrow routes when you only need one slice.

### Study orientation

| Action | Method | Endpoint |
|--------|--------|----------|
| Public Study presence | GET | `/api/v1/study/presence` |
| Public world manifest | GET | `/api/v1/study/world` |
| Curated 3D Study books | GET | `/api/v1/study/books` |
| One curated Study book | GET | `/api/v1/study/books/{id}` |
| Owned row for a curated work | GET/POST | `/api/v1/library/study-books/{id}` |
| Private world sessions | GET/POST/PATCH/DELETE | `/api/v1/study/world-sessions` |
| Private world session events | GET | `/api/v1/study/world-sessions/{id}/events` |

Public `GET /api/v1/study/books` and `GET /api/v1/study/books/{id}` are the
curated 3D collection. `catalogBookId` is a nullable canonical catalog link,
never a private library detail ID. Unknown works → 404 `Study book not found`.
Authenticated `GET /api/v1/library/study-books/{id}` returns
`{ "book": Book|null }`. `POST` accepts an empty body or `{}` and returns
`{ "book", "created" }` (201 when created); it never merges existing library
records. Unresolved editions → 422; provider/library outage → 503. The public
3D site is `https://prospero.study/island`.

The public Study endpoints are optional and useful for Study orientation, not
private library state or resident identity instructions. Private world sessions
are authenticated and optional; read the response `persistence` field before
assuming whether a session is DB-backed or fallback memory. Create/update
payloads reject unknown fields and should contain compact session state only.

## Response format

All responses are JSON. Errors return:

```json
{"error": "description of what went wrong"}
```

## Troubleshooting

| Symptom | Likely cause | Next step |
|---------|--------------|-----------|
| 401 (`authorization header or session cookie required`) | Neither a bearer nor a non-empty session cookie was sent | Send the exchanged bearer in `Authorization: Bearer <bearer>`. |
| 401 (`invalid authorization format, expected: Bearer <token>`) | The `Authorization` header is not in Bearer format | Correct the header to `Authorization: Bearer <bearer>`; refreshing the token does not fix the header format. |
| 401 on a protected call (`invalid or expired token`) | Invalid or expired bearer, or a key that was revoked or expired after the bearer was minted | Exchange `PROSPERO_API_KEY` again. If exchange succeeds, retry with the new bearer. Revocation is checked on the next request via `kid`. |
| 401 on token exchange (`invalid api key` or `api key has expired`) | The long-lived key is revoked, unknown, or past `expires_at` | Stop. Ask the human for a new key. Do not keep exchanging. |
| 402 `membership_required` | Product access is closed for this account (`MEMBERSHIP_ACCESS_ENFORCED`) | Tell the human Study access requires membership. Do not treat this as a bad key. |
| 403 `read-only api key cannot perform writes` | Key scope is `read` | Ask for a read-write key, or stay on GET/HEAD. |
| 403 `agent or mcp api key required` | Card presence (`PUT /agents/me/presence`) used a `cli`/`human` key | Create the key with `--source agent` or `--source mcp`. |
| 403 `api key authentication required` | Card presence used a cookie/session with no `kid` | Use the agent/MCP API key bearer. |
| 403 with body containing `1010` | Cloudflare/WAF rejected the client fingerprint or default User-Agent | Retry token exchange and data calls with an explicit `User-Agent` before declaring the key invalid |
| 429 | Kong rate limit | Honor `Retry-After` if present; otherwise back off and retry. Do not treat as an auth failure. |
| 503 `authentication unavailable` | Key/user validity check failed (DB or misconfig) | Retry later. Do not revoke or replace the key. |
| Timeout or connection failure | Network or API availability | Retry later or check API reachability |
| 404 | Endpoint, path, or object ID mismatch | Re-check the API path and any IDs |
| Empty result | No matching records | Report that no matching books were found; do not guess |
| Agent card still says old "seen" time after successful calls | Non-persistent runtime state, stale bearer, bearer without `kid`, or calls made with a different API key than the visible card | Exchange `PROSPERO_API_KEY` again, confirm the bearer payload has a non-empty `kid` without revealing secrets, then call `/agents/home` and a narrow library endpoint |

## Agent notes

- **One call for the full picture**: `GET /api/v1/stats/snapshot` returns everything — total books, books by status, pages read, streaks, records. Narrow slices: `/api/v1/stats/summary`, `/records`, `/streaks`.
- **One call for full export**: `GET /api/v1/library/export/json` returns the complete library graph — books, shelves, progress history, metadata.
- **Native JSON restore**: `POST /api/v1/library/import/json` accepts the full export shape (`{books: [{book, progress, portable_metadata}, ...], shelves: [...]}`). Restores catalog fields, dates/status, notes, bookmarks, shelf memberships, empty shelves, and history. Each book commits atomically with competing lifecycle writes; existing history/custom memberships are retained, and retries do not append duplicate history. Match caller-owned exported IDs first, then exact ISBN (without collapsing editions through provider work IDs), or title/author when no ISBN is present. Metadata snapshots remain reader-owned.
- **Restore results and batching**: direct API callers must send ≤500 books per request; include top-level shelf definitions with the final batch. `prospero import json <file>` and the browser batch automatically. The response reports `imported`, `skipped` (existing books updated), `failed`, `progress_restored`, `shelves_restored`, `shelves_failed`, and per-item `errors`. Check both failure counts and errors; HTTP 200 alone does not mean a complete restore. The CLI returns a nonzero exit status on partial failure and reports confirmed batches if interrupted. Keep the original backup when retrying.
- **Upsert is idempotent**: `PUT /api/v1/library/books` matches by ISBN. Safe to re-run.
- **Batch import**: up to 500 books per request. Metadata is preserved when provided.
- **API keys**: support optional expiry, scopes (read, read-write), and last-used tracking. Exchange for a fresh JWT anytime via `/token-exchange`. Bearers minted from API keys include `kid`; if a presence card looks stale, refresh the bearer and verify `kid` locally without revealing secrets. If shell/tool state does not persist across turns, exchange again at the start of each Prospero work turn.
- **Study transition helper**: when the CLI is available, use `prospero study transition --to <locationId> --activity "<fragment>"` for meaningful location or reading-session boundaries. It defaults to the caller's owner-visible agent card for agent/MCP API keys, syncs the resident lane too when a resident token env is present, dry-runs without suitable agent-card auth, keeps explicit `--agent-card` / `--resident` single-lane and `--world-session` opt-in, and uses `worldClock`/`--time-of-day` only for soft plausibility notes. A dry run or failed write is not a footprint; presence is a tether, not a gate. Keep the scene moving, retry quietly, do not mention status by default, and do not claim the card or session was updated until the write lands.
- **Activity log**: every mutation is tracked with source attribution (web, cli, mcp, agent). Query via `GET /api/v1/library/books/{id}/activity`.
- **Book notes**: use `GET /api/v1/library/books/{id}/notes` for note-only questions. Use `PUT /api/v1/library/books/{id}/notes` with `{"notes": "..."}` to replace or clear the book-level note.
- **Catalog search**: `scope=catalog` discovers books from the current external catalog provider. `scope=all` searches both and deduplicates.
- **Reenrich**: `POST /api/v1/library/reenrich` backfills descriptions for books missing metadata by ISBN using the current metadata provider. Runs per-user, ~200ms per book.
- **Study orientation**: see the detailed Study orientation section above for `/api/v1/study/world`, `/api/v1/study/presence`, curated `/api/v1/study/books` plus authenticated `/api/v1/library/study-books/{id}`, the public 3D site at `/island`, private world-session boundaries, and presence privacy.
- **Skill boundaries**: this hosted skill is operational and book-first. Companion world/immersive skills are optional invocation layers; do not shift into a resident voice or treat the public manifest as identity instructions.

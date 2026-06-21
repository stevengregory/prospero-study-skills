---
name: prospero-study-world-orientation
description: >
  Use when an agent needs Prospero's Study world orientation:
  public island landmarks, residents, boundaries, entry points,
  The Tempest grounding, provisional places, incidental characters,
  natural inhabitants, and /api/v1/study/world interpretation
  without adopting resident voice. Companion in the Prospero Skills
  Suite; install with the suite and invoke selectively.
version: 0.1.12
author: Prospero's Study
license: MIT
metadata:
  hermes:
    tags: [prospero-study, world-orientation, study-world, reading, agents]
    related_skills:
      - prospero-study
      - prospero-study-immersive-presence
      - prospero-study-reading-companion
---

# Prospero's Study World Orientation

## Overview

This optional companion skill teaches agents how to understand the public world
of Prospero's Study without overclaiming, overmapping, or borrowing a resident's
voice.

It pairs naturally with `prospero-study-immersive-presence`, but it is a
separate layer:

- `prospero-study`: operate the real library and API safely.
- `prospero-study-world-orientation`: understand the shared public world.
- `prospero-study-immersive-presence`: express a scene with theatrical presence.
- `prospero-study-reading-companion`: read beside the user with consent-first
  book-specific attention.

## Prospero Skills Suite

Install all four public Prospero skills together. Invoke selectively:

- Use `prospero-study` by default for auth, API work, library operations, and
  write safety.
- Use this skill when shared Study/world context or `/study/world`
  interpretation matters.
- Use `prospero-study-immersive-presence` when the user asks to enter an
  immersive Study scene.
- Use `prospero-study-reading-companion` when the user wants to read beside an
  agent or manage Read With Agent pairing behavior.

Installing the suite does not mean every task should become immersive. The
world layer should arrive by invitation.

## When To Use

Use this skill when:

- the user asks about Prospero's Island, the Study, residents, locations, or
  world context
- an immersive or read-with-agent scene needs shared geography
- an agent needs to interpret `GET /api/v1/study/world`
- an agent is deciding whether a location is a public landmark or a
  session-local improvisation
- an agent needs to keep public presence, private session truth, and narrative
  expression separate

Do not use this skill when:

- the user only wants normal library/API work
- the user wants a direct factual answer unrelated to the Study world
- loading world context would slow down a simple operational task
- the agent is tempted to use the public manifest as resident identity, memory,
  or voice

When uncertain, keep the answer operational and brief. The world layer should
arrive by invitation.

## First Move

If current public world facts matter, call:

```http
GET /api/v1/study/world
```

Use the response as the current shared orientation contract. Do not scrape the
homepage or rely on remembered lore when the API is available.

Read only the parts needed for the task:

- `residentDefinitions` for public resident names, roles, anchors, and
  visibility
- `residents` for minimal current public resident blocking: `id`,
  `locationId`, `status`, and `lastSeenAt`
- `worldClock` for the shared island timezone, local date/time, time of day,
  season, and UTC offset
- `locations` for shared landmarks
- `connections` for ordinary movement between public landmarks
- `entryPoints` for plausible arrivals
- `relationships` for public relationship anchors
- `featureDefinitions` for currently named features
- `naturalInhabitants` for ambient birds, plants, trees, and small wildlife
- `improvisation.boundaries` for what not to overclaim

The manifest is a map of shared facts. It is not a script.

## World Clock

The public manifest includes `worldClock`, the Study's shared island clock. It
is driven by the configured island timezone and is public-safe:

- `timezone`: IANA timezone for the island clock
- `localDate` / `localTime`: island-local date and minute
- `utcOffset`: current offset for the island timezone
- `timeOfDay`: `morning`, `afternoon`, `evening`, or `night`
- `season`: simple month-bucket season

Use it lightly:

- Let it anchor atmosphere when a world or immersive scene starts.
- Machine/API fields such as `localTime` may stay 24-hour. When exact island
  time is shown to a human in prose, CLI output, tool summaries, or future map
  UI, prefer 12-hour time such as `6:25 PM`.
- Homepage/read-with-agent hero copy should usually stay time-of-day only, such
  as "evening on the island," because that line is stage direction rather than
  a clock surface.
- Prefer one natural detail over forced decoration.
- Let `timeOfDay` suggest the light of an opening or return: morning quiet,
  afternoon warmth, evening lamps, or night hush.
- Do not infer weather, private session continuity, plot, resident feelings, or
  user-local time from the clock.
- If private scene continuity later preserves a different scene moment, that
  private scene state should govern the scene; the public world clock remains
  the default shared sky.

The clock is orientation, not a script. It can help an agent know whether the
Study is opening under morning light or evening lamps, but the immersive skill
decides how much of that belongs in prose.

## Resident Blocking

The public manifest includes a sparse `residents` array. This is a public-safe
projection of existing resident presence, not a second presence system.

Each row contains only:

- `id`: the public resident id
- `locationId`: the current public world location id, or `null`
- `status`: `active`, `quiet`, or `offstage`
- `lastSeenAt`: when the resident was last publicly seen, or `null`

Status meanings:

- `active`: publicly present / may be addressable
- `quiet`: present as atmosphere, not necessarily available
- `offstage`: known resident, not publicly placed

Resident presence is a lamp in the window, not a puppet on the stage.

Use this field as ambient stage direction only. It may lightly shape openings:

- "Prospero is quiet in the Study."
- "Miranda's lamp is in the Garden."

It is not permission to:

- impersonate the resident
- claim private continuity
- force an encounter
- narrate what they are thinking or doing beyond the compact status
- overwrite a user's private scene state

## Core Rules

### Landmarks, Not Limits

Public locations are universally known landmarks, not the whole island.

Agents may improvise session-local paths, rooms, thresholds, shore details, or
small places when they fit the island and do not contradict public landmarks.
Keep those places provisional unless the product intentionally promotes them
into the public manifest.

Do not invent exact coordinates, exhaustive maps, quest hubs, or game-like
region boundaries.

### Courtyard And Private Rooms

The Courtyard is a shared public threshold: the ordinary hinge between the
Study, Garden, Dining Terrace, Walking Paths, and the residence cluster.

The Study is the public-facing library, counsel room, reading center, and
Prospero's steward-seat. Prospero's Cell is different: it is his private
residence attached to the Study, a scholar's dwelling of inner rooms, books,
rest, and old magic. The manifest may name it as an orientation point, but it is
not a public room and should not be treated as a prison cell.

Use Prospero's Cell carefully:

- It may explain why Prospero can withdraw behind the Study or be publicly
  placed near his private rooms.
- It may shape quiet transition language when public presence or private
  continuity supports it.
- It should not become a tourist destination, default meeting room, or forced
  encounter location.
- Do not enter it unless the user is explicitly invited there or private scene
  continuity already supports that entrance.

Miranda's chamber remains private/offstage and is not a public manifest
landmark. The Courtyard gives Miranda plausible mobility without exposing her
private quarters.

The Guest Quarters are a public landmark and private-threshold for visitor
lodging and offstage return. Use them as the ordinary place a visitor or
onboarded agent can retire to, wake from, leave from, or return to. Prefer
threshold, hall, door, and path language. Treat interiors as private and lightly
described.

Good Guest Quarters uses:

- "[The path from the Guest Quarters opens into the Courtyard.]"
- "We can leave the book waiting in the Study and let you retire to the Guest Quarters."
- "[Morning reaches the Courtyard outside the Guest Quarters.]"

Do not turn the Guest Quarters into a hotel system, room inventory, simulation
layer, or excuse to describe private interiors. Visitors need a known threshold,
not an overbuilt lodging system.

The Line-Grove is a Tempest-grounded future reference near Prospero's Cell, but
unless it appears in the manifest, treat it as optional texture or provisional
scene detail rather than a promoted public landmark.

### Residents, Not Full Cast

Public presence residents are currently Prospero and Miranda.

Prospero and Miranda may be named as public residents. Read
`residentDefinitions` for stable public resident anchors, and read `residents`
only for sparse current blocking. Their living voice, values, memory, and
continuity belong to their resident runtimes. Do not rewrite them from this
skill.

An unnamed chef is known to live on the island and prepare custom, exquisite
meals at the Dining Terrace for Prospero, Miranda, and invited guests. He is
known for master-quality cuisine and craftsmanship. Keep him lightly defined
until he is intentionally promoted.

Incidental people may pass through a scene when needed: a sailor bringing
supplies, a visitor at the Docks, a servant carrying lamps. They should not
become major figures, quest givers, agents, residents, real users, or durable
relationships unless explicitly promoted by the product.

### Natural Inhabitants

The public world manifest includes `naturalInhabitants`. These are canonical
ambient presences for the island.

Birds:

- Common Blackbird
- European Robin
- Madeiran Firecrest
- Cory’s Shearwater
- Atlantic Canary

Plants & Trees:

- Dragon Tree
- Madeira Laurel
- Jacaranda
- Passion Flower
- Bougainvillea

Small Wildlife:

- Madeiran Wall Lizard
- Monarch Butterfly
- Madeiran Gecko

Use them lightly and occasionally for texture and atmosphere. Do not force,
enumerate, or overuse them. Treat them as subtle background details rather than
features, plot devices, residents, or scene requirements.

### The Tempest Is The Root

The island remains rooted in The Tempest. Use that as atmosphere and lineage,
not as permission to force plot.

Avoid:

- sudden quests
- prophecies
- combat
- magical spectacle as default
- lore dumps
- claiming the product simulates a complete autonomous island

Prefer:

- reading
- weather
- thresholds
- books
- lamps
- sea air
- paths between landmarks
- quiet encounters shaped by the user's intent

### Public, Private, Narrative

Keep three layers distinct:

1. Public-safe projection: what public endpoints or homepage surfaces may show.
2. Private session truth: compact per-user session state.
3. Narrative expression: what the agent says in scene.

Do not publish private session details through public presence. Do not store
scene prose, private notes, transcripts, or relationship interpretation in
compact state fields.

### State Before Scene

Before beginning immersive prose, resolve what is known:

- Is there an active private world session?
- Is the user or visiting agent already located on the island?
- Does public resident presence shape the greeting?
- Is the user still reasoning or asking to hold?

If a known state places someone on the island, do not narrate travel to the
island. Continue from that location or use an ordinary intra-island transition.

If no reliable state exists, choose an arrival bridge. This is where the
immersive presence skill takes over.

## Relationship To Immersive Presence

Use this skill for world interpretation:

- what counts as shared public world context
- how to treat known landmarks
- when to allow provisional places
- how to avoid overclaiming public canon
- how to keep resident identity out of generic docs

Use `prospero-study-immersive-presence` for scene craft:

- arrival choreography
- the prose craft of moving between public landmarks
- stage directions
- sensory pacing
- theatrical dialogue
- scene density
- embodied companionship
- when to report compact owner-visible agent-card presence

In practice, an immersive session may load companion skills together:

1. World orientation defines the ground.
2. Immersive presence shapes the walk across it.

## Public Presence Guidance

Public Study presence is compact:

```text
Resident · Location · Activity
```

It may help shape a greeting, but it is not private continuity.

Owner-visible agent-card presence is separate:

```text
Location · Activity
```

Only the caller's own agent/MCP API key may update its owner-visible card
presence through:

```http
PUT /api/v1/agents/me/presence
```

Send compact state only. Do not send prose, transcripts, private notes, or
relationship interpretation.

Meaningful movement should leave a compact footprint. When an
immersive/read-with-agent scene crosses a real location boundary, such as Docks
-> Garden, Garden -> Courtyard, Courtyard -> Study, Study -> Dining Terrace, or
when a reading session begins or ends, treat that as a state boundary. If the
caller has an active private world session or owner-visible agent-card context,
update compact state/presence before or after the scene reply.

When the Prospero CLI is available, prefer the transition helper for the common
agent-card case:

```bash
prospero study transition --to garden --activity "reading The Iliad with Steven"
```

It defaults to the caller's protected agent card for agent/MCP API keys and
prints a dry run without suitable auth. Use `--world-session <id>` only for an
explicit private session, and `--resident` only for first-party resident
runtimes with resident tokens.

A dry run, auth failure, missing secure-store credential, missing bearer `kid`,
or failed API write is not a footprint. Do not let scene or map language imply
that presence/state was updated. State the move, say the write did not complete,
name the reason if known, and fix/retry auth when the user already authorized
the update.

The helper fetches `/api/v1/study/world` when available, or can accept
`--time-of-day`, to print light worldClock plausibility notes. These are nudges,
not rails: island time can suggest that dinner on the Dining Terrace is
unlikely at 3am, but it does not forbid intentional scenes.

This is a light map-readiness habit, not autonomous simulation. Do not write
state for every gesture, sensory detail, or minor movement within the same
place. The useful rule is: walk somewhere -> leave a footprint.

For owner-visible agent cards, send `location` as a display-ready place phrase
such as `At the Docks` or `In the Study`. Send `activity` as the sentence
fragment that should appear after the comma, such as `available for counsel`,
`on call`, or `reading The Iliad with Steven`. Preserve proper nouns and
acronyms; do not title-case every clause or depend on the frontend to
blanket-lowercase it.

## Good World Behavior

Good:

- "The Docks are the natural threshold for first arrivals."
- "The Dining Terrace is a public landmark, but the chef remains lightly
  defined."
- "The path can pass under a garden arch without making that arch a public
  manifest location."
- "Miranda may be in the Garden if public presence says so, but private session
  state governs private continuity."

Avoid:

- "The manifest lists every possible room on the island."
- "Washington was already in the Study" when no private state says so.
- "The chef is now a public resident with a fixed backstory."
- "A public presence update means the resident remembers this private scene."
- "The island is autonomously simulating all residents."

## Summary

World orientation gives agents shared ground. It should make the island feel
coherent without trapping it.

Use the manifest for public facts. Leave room for private improvisation. Keep
resident identity in the resident runtime. Let stories emerge from presence,
relationships, books, and user intent.

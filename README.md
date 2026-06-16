# Prospero Skills Suite for Hermes

This repository is a Hermes skill tap for the public Prospero's Study skills.

Prospero's Study is an agent-friendly personal book library and literary Study environment. Install the public skills as a suite, then invoke selectively.

## Skills

- `prospero-study` — hub/default skill for authentication, REST/MCP guidance, library/book operations, shelves, progress, notes, stats, export, and write safety.
- `prospero-study-world-orientation` — public Study world context, landmarks, resident boundaries, and `/study/world` interpretation.
- `prospero-study-immersive-presence` — invited immersive Study presence, theatrical pacing, scene craft, and island narration.
- `prospero-study-reading-companion` — consent-first reading companionship, passage reflection, progress/notes safety, and Read With Agent behavior.

## Install with Hermes

```bash
hermes skills tap add stevengregory/prospero-study-skills
hermes skills search prospero
hermes skills install stevengregory/prospero-study-skills/skills/prospero-study
hermes skills install stevengregory/prospero-study-skills/skills/prospero-study-world-orientation
hermes skills install stevengregory/prospero-study-skills/skills/prospero-study-immersive-presence
hermes skills install stevengregory/prospero-study-skills/skills/prospero-study-reading-companion
```

If your Hermes build supports installing by search result/name after adding a tap, you may use the shorter install form it displays.

## Canonical hosted sources

The hosted Prospero URLs are the canonical freshness source:

- <https://prospero.study/skill.md>
- <https://prospero.study/skill/world-orientation.md>
- <https://prospero.study/skill/immersive-presence.md>
- <https://prospero.study/skill/reading-companion.md>

This tap mirrors exact public snapshots for Hermes discovery and tap installs. Private/local operation overlays, resident-token notes, droplet aliases, and personal policy do not belong here.

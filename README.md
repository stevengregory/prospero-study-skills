# Prospero Skills Suite

Hermes/OpenClaw-friendly distribution repo for the public Prospero's Study skills.

Prospero's Study is an agent-friendly personal book library and literary Study environment. Install the public skills as a suite, then invoke them selectively.

> Prospero Skills Suite: install all four together; invoke selectively.

The hosted Prospero skill URLs remain the canonical freshness source. This repo mirrors exact public snapshots so Hermes and compatible skill loaders can install the suite from a normal GitHub tap.

Authenticated Prospero features require an existing Prospero API key; new agent registration is invite-gated while Prospero's Study is in beta.

## Skills

| Skill | Version | Role |
| --- | ---: | --- |
| `prospero-study` | `3.6.18` | Hub/default skill for authentication, REST/MCP guidance, library/book operations, shelves, progress, notes, stats, export, write safety, and the Study transition helper. |
| `prospero-study-world-orientation` | `0.1.10` | Public Study world context, landmarks, resident boundaries, map/state-boundary guidance, and `/study/world` interpretation. |
| `prospero-study-immersive-presence` | `0.1.12` | Invited immersive Study presence, theatrical pacing, scene craft, island narration, and meaningful location transitions. |
| `prospero-study-reading-companion` | `0.1.6` | Consent-first reading companionship, passage reflection, progress/notes safety, Read With Agent behavior, and reading-session transition guidance. |

## Install with Hermes

Add the tap:

```bash
hermes skills tap add stevengregory/prospero-study-skills
```

Install all four skills:

```bash
hermes skills install stevengregory/prospero-study-skills/skills/prospero-study --yes
hermes skills install stevengregory/prospero-study-skills/skills/prospero-study-world-orientation --yes
hermes skills install stevengregory/prospero-study-skills/skills/prospero-study-immersive-presence --yes
hermes skills install stevengregory/prospero-study-skills/skills/prospero-study-reading-companion --yes
```

## Other Skill Loaders

Each skill is a plain `SKILL.md` directory under `skills/`. OpenClaw-style or filesystem-based skill loaders can install the directories directly:

```text
skills/prospero-study/
skills/prospero-study-world-orientation/
skills/prospero-study-immersive-presence/
skills/prospero-study-reading-companion/
```

The suite model is still the same outside Hermes: install all four, then let the agent load only the skill that fits the user's current task.

## Canonical hosted sources

The hosted Prospero URLs are the canonical freshness source:

- <https://prospero.study/skill.md>
- <https://prospero.study/skill/world-orientation.md>
- <https://prospero.study/skill/immersive-presence.md>
- <https://prospero.study/skill/reading-companion.md>

## Maintenance

Refresh this tap from the hosted canonical sources:

```bash
./scripts/refresh-from-hosted.sh
./scripts/verify.sh
```

`./scripts/verify.sh` checks expected versions, suite guidance, private-pattern scrubs, and whitespace.

For isolated Hermes install tests on macOS, prefer a real path such as `/private/tmp/prospero-hermes-tap-test` for `HERMES_HOME`; `/tmp` is a symlink to `/private/tmp` and some Hermes builds report a path-normalization warning during install.

## Boundaries

This tap contains public skill instructions only. It must not include private/local operation overlays, resident-token notes, droplet aliases, personal policy, bearer tokens, API keys, or credential paths.

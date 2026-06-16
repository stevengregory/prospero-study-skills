# Agent instructions for prospero-study-skills

This repository distributes the public Prospero Skills Suite for Hermes, OpenClaw, Claude-style filesystem skills, and other agent runtimes.

## Purpose

Keep this repo public-safe, portable, and installable as a skill tap/filesystem skill source.

The hosted Prospero URLs are the canonical source of truth:

- https://prospero.study/skill.md
- https://prospero.study/skill/world-orientation.md
- https://prospero.study/skill/immersive-presence.md
- https://prospero.study/skill/reading-companion.md

This repo mirrors reviewed public snapshots for distribution.

## Suite model

Treat the skills as the Prospero Skills Suite:

- install all four together;
- invoke selectively;
- `prospero-study` is the hub/default operational/API skill;
- companion skills remain standalone and portable.

Do not add a hard parent/child dependency or a fifth meta-skill unless the repo explicitly adopts a first-class bundle format later.

## Public/private boundary

Never add:

- API keys, bearer tokens, invite codes, or credentials;
- resident-token operational notes;
- droplet aliases, deploy-key names, SSH hostnames, or private server paths;
- Miranda/Steven private operations policy;
- private session state, private reader data, or personal memories.

Public world context must remain ambient and public-safe. Private user/session state stays private.

## Refresh workflow

To refresh from hosted canonical sources:

```bash
./scripts/refresh-from-hosted.sh
./scripts/verify.sh
git diff --check
```

Review diffs before committing. Confirm versions and suite guidance are correct.

## Review checklist

Before committing:

- [ ] All four `skills/*/SKILL.md` files are present.
- [ ] `./scripts/verify.sh` passes.
- [ ] `git diff --check` passes.
- [ ] README install commands still match current Hermes behavior.
- [ ] No private operations/secrets/personal policy leaked.
- [ ] Skills remain useful as plain Markdown for non-Hermes harnesses.

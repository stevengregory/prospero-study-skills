#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
curl -fsSL -A 'Prospero-Skills-Tap/1.0' https://prospero.study/skill.md -o skills/prospero-study/SKILL.md
curl -fsSL -A 'Prospero-Skills-Tap/1.0' https://prospero.study/skill/world-orientation.md -o skills/prospero-study-world-orientation/SKILL.md
curl -fsSL -A 'Prospero-Skills-Tap/1.0' https://prospero.study/skill/immersive-presence.md -o skills/prospero-study-immersive-presence/SKILL.md
curl -fsSL -A 'Prospero-Skills-Tap/1.0' https://prospero.study/skill/reading-companion.md -o skills/prospero-study-reading-companion/SKILL.md
python3 - <<'PY'
from pathlib import Path
for p in Path('skills').glob('*/SKILL.md'):
    text=p.read_text()
    p.write_text('\n'.join(line.rstrip() for line in text.splitlines())+'\n')
PY

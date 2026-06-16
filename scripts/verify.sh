#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 - <<'PY'
from pathlib import Path
import re, sys
expected = {
  'prospero-study': '3.6.17',
  'prospero-study-world-orientation': '0.1.8',
  'prospero-study-immersive-presence': '0.1.10',
  'prospero-study-reading-companion': '0.1.5',
}
for name, ver in expected.items():
    path = Path('skills') / name / 'SKILL.md'
    if not path.exists():
        raise SystemExit(f'missing {path}')
    text = path.read_text()
    fm = text.split('---', 2)[1]
    found = re.search(r'(?m)^version:\s*"?([^"\n]+)', fm)
    if not found or found.group(1).strip() != ver:
        raise SystemExit(f'{name}: expected {ver}, found {found.group(1).strip() if found else None}')
    if 'Prospero Skills Suite' not in text:
        raise SystemExit(f'{name}: missing suite guidance')
private_patterns = [
    'MIRANDA_STUDY_RESIDENT_TOKEN', 'study-droplet', 'agent-miranda',
    '/Users/agent-miranda', '356291d9a5057771', 'resident-token'
]
for path in Path('skills').glob('*/SKILL.md'):
    text = path.read_text()
    for pat in private_patterns:
        if pat in text:
            raise SystemExit(f'private pattern {pat!r} in {path}')
print('Prospero skill tap verification ok')
PY
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git diff --check -- README.md skills.sh.json skills scripts
fi

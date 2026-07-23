#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 - <<'PY'
from pathlib import Path
import json
import re

suite = (
    'prospero-study',
    'prospero-study-world-orientation',
    'prospero-study-immersive-presence',
    'prospero-study-reading-companion',
)
readme = Path('README.md').read_text()
versions = {}

for name in suite:
    path = Path('skills') / name / 'SKILL.md'
    if not path.exists():
        raise SystemExit(f'missing {path}')
    text = path.read_text()
    parts = text.split('---', 2)
    if len(parts) != 3 or parts[0].strip():
        raise SystemExit(f'{path}: missing leading YAML frontmatter')
    frontmatter = parts[1]
    found_name = re.search(r'(?m)^name:\s*([^\n]+)', frontmatter)
    if not found_name or found_name.group(1).strip() != name:
        actual = found_name.group(1).strip() if found_name else None
        raise SystemExit(f'{path}: expected name {name}, found {actual}')
    found_version = re.search(r'(?m)^version:\s*"?([^"\n]+)', frontmatter)
    if not found_version:
        raise SystemExit(f'{path}: missing version')
    version = found_version.group(1).strip()
    versions[name] = version
    if 'Prospero Skills Suite' not in text:
        raise SystemExit(f'{name}: missing suite guidance')

    readme_row = re.compile(
        rf'^\|\s*`{re.escape(name)}`\s*\|\s*`{re.escape(version)}`\s*\|',
        re.MULTILINE,
    )
    if not readme_row.search(readme):
        raise SystemExit(f'README.md: missing {name} version {version}')

manifest = json.loads(Path('skills.sh.json').read_text())
configured = [
    skill
    for grouping in manifest.get('groupings', [])
    for skill in grouping.get('skills', [])
]
if len(configured) != len(set(configured)):
    raise SystemExit('skills.sh.json: duplicate skill entries')
if set(configured) != set(suite):
    missing = sorted(set(suite) - set(configured))
    extra = sorted(set(configured) - set(suite))
    raise SystemExit(f'skills.sh.json: missing={missing}, extra={extra}')

private_patterns = [
    'MIRANDA_STUDY_RESIDENT_TOKEN', 'study-droplet', 'agent-miranda',
    '/Users/agent-miranda', '356291d9a5057771', 'resident-token'
]
for path in Path('skills').glob('*/SKILL.md'):
    text = path.read_text()
    for pat in private_patterns:
        if pat in text:
            raise SystemExit(f'private pattern {pat!r} in {path}')
summary = ', '.join(f'{name}={versions[name]}' for name in suite)
print(f'Prospero skill tap verification ok ({summary})')
PY
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git diff --check -- .github AGENTS.md LICENSE README.md skills.sh.json skills scripts
fi

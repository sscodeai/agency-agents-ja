#!/usr/bin/env bash
# Two agent files that normalize to the same output slug must not silently
# overwrite one agent's output with the other's.
#
# Slugs here come from the file stem, so the collision is two files with the
# same basename in different divisions (engineering/dupe.md, marketing/dupe.md).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
scratch="$(mktemp -d)"
trap 'rm -rf "$scratch"' EXIT

mkdir -p "$scratch/repo/scripts" "$scratch/repo/engineering" "$scratch/repo/marketing" \
  "$scratch/output/gemini-cli"
cp "$SCRIPT_DIR/convert.sh" "$SCRIPT_DIR/lib.sh" "$scratch/repo/scripts/"

cat > "$scratch/repo/engineering/dupe.md" <<'EOF'
---
name: Engineering Dupe
description: First agent
color: blue
---
# First agent
EOF
cat > "$scratch/repo/marketing/dupe.md" <<'EOF'
---
name: Marketing Dupe
description: Second agent
color: red
---
# Second agent
EOF

printf 'keep existing output\n' > "$scratch/output/gemini-cli/sentinel"
if bash "$scratch/repo/scripts/convert.sh" --tool gemini-cli --out "$scratch/output" > "$scratch/log" 2>&1; then
  echo "FAIL: converter accepted two agents with the same output slug"
  exit 1
fi
grep -q "duplicate agent slug 'dupe'" "$scratch/log"
grep -q 'engineering/dupe.md' "$scratch/log"
grep -q 'marketing/dupe.md' "$scratch/log"
[[ "$(cat "$scratch/output/gemini-cli/sentinel")" == 'keep existing output' ]]
echo "PASS: duplicate slug refused before existing output changed"

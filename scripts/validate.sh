#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

errors=0
AGENT_DIRS="engineering project-management testing product marketing paid-media finance hr design legal sales support supply-chain specialized"

while IFS= read -r file; do
  if ! head -n 1 "$file" | grep -q '^---$'; then
    echo "Missing frontmatter: $file"
    errors=$((errors + 1))
    continue
  fi
  frontmatter="$(sed -n '1,/^---$/p' "$file" | tail -n +2)"
  for field in name description emoji color; do
    if ! printf '%s\n' "$frontmatter" | grep -q "^${field}:"; then
      echo "Missing $field: $file"
      errors=$((errors + 1))
    fi
  done

  dir="${file%%/*}"
  base="$(basename "$file")"
  case "$dir" in
    project-management)
      expected="project-management-"
      ;;
    supply-chain)
      expected="supply-chain-"
      ;;
    *)
      expected="${dir}-"
      ;;
  esac
  if [[ "$base" != "$expected"* && "$dir" != "specialized" ]]; then
    echo "Filename prefix mismatch: $file (expected prefix: $expected)"
    errors=$((errors + 1))
  fi
done < <(find $AGENT_DIRS -name '*.md' -type f | sort)

if grep -R -n -E 'agency-agents-zh|jnMetaCode|小红书|抖音|微信|飞书|钉钉|百度|淘宝|拼多多|京东' \
  README.md ROADMAP.md AGENT-LIST.md $AGENT_DIRS >/tmp/agency-agents-ja-forbidden.txt; then
  cat /tmp/agency-agents-ja-forbidden.txt
  errors=$((errors + 1))
fi

if ! node scripts/generate-agent-list.js --check; then
  errors=$((errors + 1))
fi

if ! node scripts/validate-workflows.js; then
  errors=$((errors + 1))
fi

if [ "$errors" -gt 0 ]; then
  exit 1
fi

echo "All agent files and workflows are valid."

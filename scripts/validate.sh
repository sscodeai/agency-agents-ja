#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

errors=0
AGENT_DIRS="academic engineering project-management testing product marketing paid-media finance game-development gis healthcare hr design legal sales security spatial-computing support supply-chain specialized"

while IFS= read -r file; do
  if ! head -n 1 "$file" | grep -q '^---$'; then
    echo "Missing frontmatter: $file"
    errors=$((errors + 1))
    continue
  fi
  frontmatter="$(sed -n '1,/^---$/p' "$file" | tail -n +2)"
  for field in name description emoji color source; do
    if ! printf '%s\n' "$frontmatter" | grep -q "^${field}:"; then
      echo "Missing $field: $file"
      errors=$((errors + 1))
    fi
  done
  name_value="$(printf '%s\n' "$frontmatter" | grep '^name:' | head -n1 | sed 's/^name:[[:space:]]*//')"
  if [[ "$name_value" == \[upstream\]* ]]; then
    echo "Do not put upstream status in name; use source/upstream_name/translation_status instead: $file"
    errors=$((errors + 1))
  fi
  if printf '%s\n' "$frontmatter" | grep -qE '^color:[[:space:]]*#[0-9A-Fa-f]{6}[[:space:]]*$'; then
    echo "Quote hex color values so standard YAML parsers do not treat them as comments: $file"
    errors=$((errors + 1))
  fi
  source_value="$(printf '%s\n' "$frontmatter" | grep '^source:' | head -n1 | sed 's/^source:[[:space:]]*//')"
  if [[ "$source_value" != "upstream" && "$source_value" != "japan-original" ]]; then
    echo "Invalid source '$source_value' (must be 'upstream' or 'japan-original'): $file"
    errors=$((errors + 1))
  fi
  if [[ "$source_value" == "upstream" ]]; then
    if ! printf '%s\n' "$frontmatter" | grep -q '^upstream_path:'; then
      echo "Missing upstream_path (required when source=upstream): $file"
      errors=$((errors + 1))
    fi
    translation_status_value="$(printf '%s\n' "$frontmatter" | grep '^translation_status:' | head -n1 | sed 's/^translation_status:[[:space:]]*//')"
    if [[ "$translation_status_value" != "skeleton" && "$translation_status_value" != "translated" && "$translation_status_value" != "adapted" ]]; then
      echo "Invalid or missing translation_status '$translation_status_value' (must be skeleton, translated, or adapted when source=upstream): $file"
      errors=$((errors + 1))
    fi
  else
    if printf '%s\n' "$frontmatter" | grep -q '^translation_status:'; then
      echo "translation_status is only for source=upstream: $file"
      errors=$((errors + 1))
    fi
    if printf '%s\n' "$frontmatter" | grep -q '^upstream_path:'; then
      echo "upstream_path is only for source=upstream: $file"
      errors=$((errors + 1))
    fi
  fi

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
  if [[ "$base" != "$expected"* && "$dir" != "specialized" && "$dir" != "game-development" && "$dir" != "spatial-computing" && "$base" != "project-manager-senior.md" ]]; then
    echo "Filename prefix mismatch: $file (expected prefix: $expected)"
    errors=$((errors + 1))
  fi
done < <(find $AGENT_DIRS -name '*.md' -type f | sort)

if grep -R -n -E '小红书|抖音|微信|飞书|钉钉|百度|淘宝|拼多多|京东' \
  README.md ROADMAP.md AGENT-LIST.md $AGENT_DIRS >/tmp/agency-agents-ja-forbidden.txt; then
  cat /tmp/agency-agents-ja-forbidden.txt
  errors=$((errors + 1))
fi

if grep -R -n -E 'agency-agents-zh|jnMetaCode' \
  ROADMAP.md AGENT-LIST.md $AGENT_DIRS >/tmp/agency-agents-ja-forbidden.txt; then
  cat /tmp/agency-agents-ja-forbidden.txt
  errors=$((errors + 1))
fi

if ! node scripts/generate-agent-list.js --check; then
  errors=$((errors + 1))
fi

if ! node scripts/generate-workflow-table.js --check; then
  errors=$((errors + 1))
fi

if ! node scripts/generate-translation-progress.js --check; then
  errors=$((errors + 1))
fi

if ! node scripts/sync-readme-stats.js --check; then
  errors=$((errors + 1))
fi

if ! node scripts/check-upstream-coverage.js --check; then
  errors=$((errors + 1))
fi

if ! node scripts/check-adapted-quality.js; then
  errors=$((errors + 1))
fi

if ! node scripts/test-maintenance-scripts.js; then
  errors=$((errors + 1))
fi

if ! node scripts/validate-workflows.js; then
  errors=$((errors + 1))
fi

if ! bash scripts/check-runbooks.sh; then
  errors=$((errors + 1))
fi

if ! bash scripts/check-divisions.sh; then
  errors=$((errors + 1))
fi

if ! bash scripts/check-tools.sh; then
  errors=$((errors + 1))
fi

if [ "$errors" -gt 0 ]; then
  exit 1
fi

echo "All agent files and workflows are valid."

#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

errors=0
while IFS= read -r file; do
  if ! head -n 1 "$file" | grep -q '^---$'; then
    echo "Missing frontmatter: $file"
    errors=$((errors + 1))
    continue
  fi
  frontmatter="$(sed -n '1,/^---$/p' "$file" | tail -n +2)"
  for field in name description; do
    if ! printf '%s\n' "$frontmatter" | grep -q "^${field}:"; then
      echo "Missing $field: $file"
      errors=$((errors + 1))
    fi
  done
done < <(find engineering project-management testing product marketing legal sales support specialized -name '*.md' -type f | sort)

if [ "$errors" -gt 0 ]; then
  exit 1
fi

echo "All agent files are valid."

#!/usr/bin/env bash
#
# check-tools.sh - enforce a single source of truth for the supported tool set.
#
# tools.json is canonical. This script fails if any of the following disagree:
#   1. ALL_TOOLS in scripts/install.sh
#   2. valid_tools in scripts/convert.sh
#   3. Every tools.json entry has id, label, kebab, format, installKind, and dest
#      (installKind is one of: per-agent | roster | plugin)
#
# Usage: ./scripts/check-tools.sh

set -euo pipefail

cd "$(dirname "$0")/.."

JSON="tools.json"
errors=0
fail() { echo "ERROR $*"; errors=$((errors + 1)); }

canonical() {
  awk '/"tools"[[:space:]]*:[[:space:]]*\{/{f=1; next} f' "$JSON" \
    | grep -oE '^    "[a-z0-9-]+"' \
    | sed -E 's/.*"([a-z0-9-]+)".*/\1/' \
    | sort -u
}

convertible() {
  awk '/"tools"[[:space:]]*:[[:space:]]*\{/{f=1; next} f' "$JSON" \
    | grep -E '^    "[a-z0-9-]+"[[:space:]]*:' \
    | grep -v '"format":"identity"' \
    | sed -E 's/^    "([a-z0-9-]+)".*/\1/' \
    | sort -u
}

bash_array() {
  grep -oE "$2=\([^)]*\)" "$1" | head -1 \
    | sed -E "s/^$2=\(//; s/\)\$//" \
    | tr -d '"' \
    | tr ' \t' '\n\n' \
    | grep -E '^[a-z0-9-]+$' \
    | sort -u
}

[[ -f "$JSON" ]] || { echo "ERROR $JSON not found at repo root"; exit 1; }

canon="$(canonical)"
convertible_tools="$(convertible)"

all_tools="$(bash_array scripts/install.sh ALL_TOOLS)"
missing="$(comm -23 <(echo "$canon") <(echo "$all_tools"))"
extra="$(comm -13 <(echo "$canon") <(echo "$all_tools"))"
[[ -n "$missing" ]] && fail "scripts/install.sh ALL_TOOLS is missing tool(s) in $JSON: $(echo "$missing" | tr '\n' ' ')"
[[ -n "$extra" ]] && fail "scripts/install.sh ALL_TOOLS has tool(s) not in $JSON: $(echo "$extra" | tr '\n' ' ')"

conv="$(bash_array scripts/convert.sh valid_tools | grep -v '^all$' || true)"
missing_conv="$(comm -23 <(echo "$convertible_tools") <(echo "$conv"))"
notin="$(comm -13 <(echo "$convertible_tools") <(echo "$conv"))"
[[ -n "$missing_conv" ]] && fail "scripts/convert.sh valid_tools is missing convertible tool(s) in $JSON: $(echo "$missing_conv" | tr '\n' ' ')"
[[ -n "$notin" ]] && fail "scripts/convert.sh converts tool(s) absent from $JSON: $(echo "$notin" | tr '\n' ' ')"

while IFS= read -r tool; do
  [[ -n "$tool" ]] || continue
  line="$(grep -E "^    \"$tool\"[[:space:]]*:" "$JSON")"
  for field in id label kebab format installKind dest; do
    echo "$line" | grep -qE "\"$field\":" || fail "tool '$tool' in $JSON is missing \"$field\""
  done
  if echo "$line" | grep -qE '"installKind":'; then
    echo "$line" | grep -qE '"installKind":[[:space:]]*"(per-agent|roster|plugin)"' \
      || fail "tool '$tool' in $JSON has an invalid installKind (must be per-agent|roster|plugin)"
  fi
done < <(echo "$canon")

count="$(echo "$canon" | grep -c .)"
if [[ $errors -gt 0 ]]; then
  echo ""
  echo "FAILED: $errors tool consistency error(s). $JSON is the source of truth."
  exit 1
fi

echo "PASSED: $count tools consistent across tools.json, install.sh, and convert.sh."

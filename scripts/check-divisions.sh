#!/usr/bin/env bash
#
# check-divisions.sh - enforce a single source of truth for source agent divisions.
#
# divisions.json (repo root) is canonical. This script fails if it disagrees with:
#   1. The actual top-level source agent directories tracked by git
#   2. AGENT_DIRS in scripts/convert.sh
#   3. AGENT_DIRS in scripts/install.sh
#   4. AGENT_DIRS in scripts/lint-agents.sh
#   5. AGENT_DIRS in scripts/validate.sh
#   6. The path filters in .github/workflows/lint-agents.yml
#   7. Every divisions.json entry has at least one frontmatter agent file
#
# Add a division by creating its directory, adding it to divisions.json, and
# updating AGENT_DIRS in the scripts listed above. Framework and generated
# directories such as strategy/ and integrations/ are intentionally excluded:
# they contain playbooks, runbooks, or converted tool output rather than source
# agent files.
#
# Usage: ./scripts/check-divisions.sh

set -euo pipefail

cd "$(dirname "$0")/.."

JSON="divisions.json"
# Top-level directories that are not source-agent divisions. actual_dirs()
# enumerates git-tracked top-level directories, so these exclusions keep
# generated integrations, workflow examples, and upstream strategy documents out
# of the source-agent category contract.
NON_DIVISION_DIRS=(
  bin
  docs
  examples
  integrations
  scripts
  strategy
  workflows
)

errors=0
fail() {
  echo "ERROR $*"
  errors=$((errors + 1))
}

canonical() {
  awk '/"divisions"[[:space:]]*:[[:space:]]*\{/{f=1; next} f' "$JSON" \
    | grep -oE '"[a-z0-9-]+"[[:space:]]*:[[:space:]]*\{' \
    | sed -E 's/"([a-z0-9-]+)".*/\1/' \
    | sort -u
}

has_agent_file() {
  local f first
  while IFS= read -r f; do
    first="$(head -1 "$f" | tr -d '\r')"
    [[ "$first" == "---" ]] && return 0
  done < <(find "$1" -name '*.md' -type f 2>/dev/null)
  return 1
}

actual_dirs() {
  local base
  find . -mindepth 1 -maxdepth 1 -type d -print | sed 's#^\./##' | sort -u | while IFS= read -r base; do
    [[ "$base" == .* ]] && continue
    case " ${NON_DIVISION_DIRS[*]} " in *" $base "*) continue ;; esac
    has_agent_file "$base" || continue
    echo "$base"
  done
}

agent_dirs_array() {
  awk '/AGENT_DIRS=\(/{f=1; next} f && /^\)/{exit} f{print}' "$1" \
    | tr ' \t' '\n\n' \
    | grep -E '^[a-z0-9-]+$' \
    | sort -u
}

validate_dirs_string() {
  sed -n 's/^AGENT_DIRS="\([^"]*\)".*/\1/p' "$1" \
    | tr ' ' '\n' \
    | grep -E '^[a-z0-9-]+$' \
    | sort -u
}

compare() {
  local label="$1" candidate="$2" canon missing extra
  canon="$(canonical)"
  missing="$(comm -23 <(echo "$canon") <(echo "$candidate"))"
  extra="$(comm -13 <(echo "$canon") <(echo "$candidate"))"
  if [[ -n "$missing" ]]; then
    fail "$label is missing division(s) present in $JSON: $(echo "$missing" | tr '\n' ' ')"
  fi
  if [[ -n "$extra" ]]; then
    fail "$label has division(s) not in $JSON: $(echo "$extra" | tr '\n' ' ')"
  fi
}

[[ -f "$JSON" ]] || { echo "ERROR $JSON not found at repo root"; exit 1; }

compare "the source agent directories on disk" "$(actual_dirs)"
compare "scripts/convert.sh AGENT_DIRS" "$(agent_dirs_array scripts/convert.sh)"
compare "scripts/install.sh AGENT_DIRS" "$(agent_dirs_array scripts/install.sh)"
compare "scripts/lint-agents.sh AGENT_DIRS" "$(agent_dirs_array scripts/lint-agents.sh)"
compare "scripts/validate.sh AGENT_DIRS" "$(validate_dirs_string scripts/validate.sh)"

WF=".github/workflows/lint-agents.yml"
if [[ -f "$WF" ]]; then
  while IFS= read -r div; do
    grep -qE "\b${div}/" "$WF" || fail "$WF has no path filter for division '$div'"
  done < <(canonical)
else
  fail "$WF not found"
fi

while IFS= read -r div; do
  block="$(awk -v d="\"$div\"" '$0 ~ d"[[:space:]]*:[[:space:]]*\\{" {print; found=1; next} found && /\}/ {print; exit} found {print}' "$JSON")"
  for field in label icon color; do
    echo "$block" | grep -qE "\"$field\"[[:space:]]*:" \
      || fail "division '$div' in $JSON is missing \"$field\""
  done
done < <(canonical)

while IFS= read -r div; do
  if [[ ! -d "$div" ]]; then
    fail "division '$div' has no directory on disk"
  elif ! has_agent_file "$div"; then
    fail "division '$div' has no agent files (.md with '---' frontmatter) - not a real source-agent division"
  fi
done < <(canonical)

count="$(canonical | wc -l | tr -d ' ')"
if [[ $errors -gt 0 ]]; then
  echo ""
  echo "FAILED: $errors division consistency error(s). $JSON is the source of truth."
  exit 1
fi

echo "PASSED: $count divisions consistent across $JSON, directories, scripts, and CI."

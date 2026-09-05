#!/usr/bin/env bash
#
# Regression tests for scripts/install.sh.
#
# These tests run every install into a throwaway HOME so they never touch the
# operator's real tool configuration.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INSTALL="$SCRIPT_DIR/install.sh"

SANDBOX_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/agency-install-tests.XXXXXX")"
trap 'rm -rf "$SANDBOX_ROOT"' EXIT

pass_count=0

pass() {
  printf '  ok   %s\n' "$1"
  pass_count=$((pass_count + 1))
}

fail() {
  printf '  FAIL %s\n' "$1" >&2
  [[ -n "${2:-}" ]] && printf '       %s\n' "$2" >&2
  exit 1
}

assert_eq() {
  local expected="$1" actual="$2" label="$3"
  if [[ "$expected" == "$actual" ]]; then
    pass "$label"
  else
    fail "$label" "expected '$expected', got '$actual'"
  fi
}

sandbox() {
  local name="$1"
  local dir="$SANDBOX_ROOT/$name"
  rm -rf "$dir"
  mkdir -p "$dir"
  printf '%s' "$dir"
}

count_md() {
  [[ -d "$1" ]] || { printf '0'; return; }
  find "$1" -maxdepth 1 -name '*.md' -type f | wc -l | tr -d ' '
}

agent_count() {
  local count=0 div
  for div in $(node -e "const d=require('./divisions.json').divisions; console.log(Object.keys(d).join(' '))"); do
    [[ -d "$REPO_ROOT/$div" ]] || continue
    count=$((count + $(find "$REPO_ROOT/$div" -name '*.md' -type f -exec sh -c 'head -n 1 "$1" | grep -qx -- "---"' _ {} \; -print | wc -l | tr -d ' ')))
  done
  printf '%s' "$count"
}

run_install() {
  local home="$1"
  shift
  RUN_OUT="$(HOME="$home" "$INSTALL" --no-interactive "$@" 2>&1)"
  RUN_STATUS=$?
}

TOTAL_AGENTS="$(agent_count)"

echo "Testing $INSTALL"
echo "  repo: $REPO_ROOT"
echo "  agents: $TOTAL_AGENTS"
echo ""

home="$(sandbox help)"
RUN_OUT="$(HOME="$home" "$INSTALL" --help 2>&1)"
RUN_STATUS=$?
assert_eq 0 "$RUN_STATUS" "--help exits 0"
case "$RUN_OUT" in
  *"Usage:"*) pass "--help prints usage" ;;
  *) fail "--help prints usage" ;;
esac

home="$(sandbox list-teams)"
run_install "$home" --list teams
assert_eq 0 "$RUN_STATUS" "--list teams exits 0"
case "$RUN_OUT" in
  *"research"*) pass "--list teams includes research" ;;
  *) fail "--list teams includes research" ;;
esac

home="$(sandbox dry-run)"
run_install "$home" --tool claude-code --dry-run
assert_eq 0 "$RUN_STATUS" "--dry-run exits 0"
assert_eq 0 "$(find "$home" -type f | wc -l | tr -d ' ')" "--dry-run creates no files"

home="$(sandbox default-claude)"
run_install "$home" --tool claude-code
assert_eq 0 "$RUN_STATUS" "claude-code install exits 0"
assert_eq "$TOTAL_AGENTS" "$(count_md "$home/.claude/agents")" "claude-code installs to HOME/.claude/agents"
assert_eq 0 "$(count_md "$home/.claude")" "claude-code leaves config root empty"

home="$(sandbox claude-config-dir)"
cfg="$home/.config/claude-code"
RUN_OUT="$(HOME="$home" CLAUDE_CONFIG_DIR="$cfg" "$INSTALL" --no-interactive --tool claude-code 2>&1)"
RUN_STATUS=$?
assert_eq 0 "$RUN_STATUS" "CLAUDE_CONFIG_DIR install exits 0"
assert_eq "$TOTAL_AGENTS" "$(count_md "$cfg/agents")" "CLAUDE_CONFIG_DIR writes to config-root/agents"
assert_eq 0 "$(count_md "$cfg")" "CLAUDE_CONFIG_DIR leaves root empty"

home="$(sandbox claude-config-agents)"
cfg="$home/.config/claude-code/agents"
RUN_OUT="$(HOME="$home" CLAUDE_CONFIG_DIR="$cfg" "$INSTALL" --no-interactive --tool claude-code 2>&1)"
RUN_STATUS=$?
assert_eq 0 "$RUN_STATUS" "pre-suffixed CLAUDE_CONFIG_DIR install exits 0"
assert_eq "$TOTAL_AGENTS" "$(count_md "$cfg")" "pre-suffixed CLAUDE_CONFIG_DIR is not double-nested"

home="$(sandbox path-override)"
dest="$home/custom path"
run_install "$home" --tool claude-code --path "$dest"
assert_eq 0 "$RUN_STATUS" "--path install exits 0"
assert_eq "$TOTAL_AGENTS" "$(count_md "$dest")" "--path overrides claude-code destination"
assert_eq 0 "$(count_md "$home/.claude/agents")" "--path leaves default destination empty"

home="$(sandbox path-collision)"
set +e
RUN_OUT="$(HOME="$home" "$INSTALL" --no-interactive --tool claude-code,copilot --path "$home/same" 2>&1)"
RUN_STATUS=$?
set -e
[[ "$RUN_STATUS" -ne 0 ]] || fail "--path rejects colliding tool outputs"
case "$RUN_OUT" in
  *"colliding"*) pass "--path collision explains the error" ;;
  *) fail "--path collision explains the error" "$RUN_OUT" ;;
esac

home="$(sandbox agent-filter)"
run_install "$home" --tool claude-code --agent 'Developer Tooling Engineer'
assert_eq 0 "$RUN_STATUS" "--agent display-name install exits 0"
assert_eq 1 "$(count_md "$home/.claude/agents")" "--agent display-name installs one file"

echo ""
echo "PASS: install.sh behavior tests passed ($pass_count checks)"

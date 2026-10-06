#!/usr/bin/env bash

# Shared shell helpers for scripts that scan Markdown agent bodies.

# fence_open_p <line>
# Returns 0 if the line opens a CommonMark-style fenced code block with 0-3
# leading spaces and a run of at least 3 backticks or tildes. Callers read
# BASH_REMATCH directly to avoid subshells inside line-by-line loops.
fence_open_p() {
  local line="$1"
  local re='^( {0,3})(`{3,}|~{3,})'
  [[ "$line" =~ $re ]]
}

# fence_closes_p <line> <open_marker> <open_len> [<open_indent>]
# Returns 0 if the line closes the currently open fence: same character, a run
# at least as long as the opener, indent 0-3, and nothing but whitespace after
# the run.
#
# The closing fence's indent is its own rule: CommonMark allows up to three
# spaces whatever the opener's indent, and GitHub renders by it (an unindented
# ``` block is closed by a two-space "  ```"). The opener's indent is still
# accepted as the optional fourth argument, but it is deliberately not
# consulted — requiring close_indent <= open_indent read GitHub-valid documents
# as still open, so lint miscounted sections and the OpenClaw split kept the
# next "##" heading inside the block.
#
# "Nothing after the run" is CommonMark's rule: inside an open ``` block, a
# "```python" line is content, not a closer. Without it the block ended early.
fence_closes_p() {
  local line="$1" open_marker="$2" open_len="$3"
  local re='^( {0,3})(`{3,}|~{3,})'
  [[ "$line" =~ $re ]] || return 1
  local close_run="${BASH_REMATCH[2]}"
  local rest="${line:${#BASH_REMATCH[0]}}"
  [[ "${close_run:0:1}" == "$open_marker" ]] || return 1
  (( ${#close_run} >= open_len )) || return 1
  [[ -z "${rest//[[:space:]]/}" ]] || return 1
  return 0
}

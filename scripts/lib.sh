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

# fence_closes_p <line> <open_marker> <open_len> <open_indent>
# Returns 0 if the line closes the currently open fence.
fence_closes_p() {
  local line="$1" open_marker="$2" open_len="$3" open_indent="$4"
  local re='^( {0,3})(`{3,}|~{3,})'
  [[ "$line" =~ $re ]] || return 1
  local close_indent=${#BASH_REMATCH[1]}
  local close_run="${BASH_REMATCH[2]}"
  [[ "${close_run:0:1}" == "$open_marker" ]] || return 1
  (( ${#close_run} >= open_len )) || return 1
  (( close_indent <= open_indent )) || return 1
  return 0
}

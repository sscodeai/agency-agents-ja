#!/usr/bin/env bash
#
# install.sh -- Install The Agency agents into your local agentic tool(s).
#
# Reads converted files from integrations/ and copies them to the appropriate
# config directory for each tool. Run scripts/convert.sh first if integrations/
# is missing or stale.
#
# Usage:
#   ./scripts/install.sh [selection] [mode] [behavior]
#
# Tools:
#   claude-code  -- Copy agents to ~/.claude/agents/
#   copilot      -- Copy agents to ~/.github/agents/ and ~/.copilot/agents/
#   antigravity  -- Copy skills to ~/.gemini/config/skills/
#   gemini-cli   -- Install extension to ~/.gemini/extensions/agency-agents/
#   opencode     -- Copy agents to .opencode/agents/ in current directory
#   cursor       -- Copy rules to .cursor/rules/ in current directory
#   aider        -- Copy CONVENTIONS.md to current directory
#   windsurf     -- Copy .windsurfrules to current directory
#   openclaw     -- Copy workspaces to ~/.openclaw/agency-agents/
#   qwen         -- Copy SubAgents to ~/.qwen/agents/ (user-wide) or .qwen/agents/ (project)
#   zcode        -- Copy agents to ~/.zcode/agents/ (user-wide) or .zcode/agents/ (project)
#   codex        -- Copy custom agent TOML files to ~/.codex/agents/
#   osaurus      -- Copy skills to ~/.osaurus/skills/
#   hermes       -- Copy lazy-router plugin to ~/.hermes/plugins/
#   vibe         -- Copy agents and prompts to ~/.vibe/agents/ and ~/.vibe/prompts/
#   all          -- Install for all detected tools (default)
#
# Flags:
#   --tool <name>     Install only the specified tool
#   --division <name> Install only one or more divisions (comma-separated)
#   --agent <name>    Install only one or more agents by display name or file slug
#   --agents-file <path> Install agents listed in a file (one name or slug per line)
#   --dry-run         Print the install plan without writing files
#   --list [tools|teams|agents] List tools, divisions, or agents and exit
#   --path <dir>      Override the install directory for selected tools
#   --no-convert      Do not auto-generate missing integration outputs
#   --interactive     Show interactive selector (default when run in a terminal)
#   --no-interactive  Skip interactive selector, install all detected tools
#   --parallel        Run install for each selected tool in parallel (output order may vary)
#   --jobs N          Max parallel jobs when using --parallel (default: nproc or 4)
#   --help            Show this help
#
# Env path overrides:
#   CLAUDE_CONFIG_DIR, CLAUDE_AGENTS_DIR, GITHUB_AGENT_DIR, COPILOT_AGENT_DIR,
#   ANTIGRAVITY_SKILLS_DIR, GEMINI_EXTENSION_DIR, OPENCODE_AGENTS_DIR,
#   OPENCLAW_DIR, CURSOR_RULES_DIR, QWEN_AGENTS_DIR, ZCODE_AGENTS_DIR, KIMI_AGENTS_DIR,
#   CODEX_AGENTS_DIR, OSAURUS_SKILLS_DIR, HERMES_PLUGIN_DIR, VIBE_HOME
#
# Platform support:
#   Linux, macOS (requires bash 3.2+), Windows Git Bash / WSL

set -euo pipefail

# ---------------------------------------------------------------------------
# Colours -- only when stdout supports color
# ---------------------------------------------------------------------------
if [[ -t 1 && -z "${NO_COLOR:-}" && "${TERM:-}" != "dumb" ]]; then
  C_GREEN=$'\033[0;32m'
  C_YELLOW=$'\033[1;33m'
  C_RED=$'\033[0;31m'
  C_CYAN=$'\033[0;36m'
  C_BOLD=$'\033[1m'
  C_DIM=$'\033[2m'
  C_RESET=$'\033[0m'
else
  C_GREEN=''; C_YELLOW=''; C_RED=''; C_CYAN=''; C_BOLD=''; C_DIM=''; C_RESET=''
fi

ok()     { printf "${C_GREEN}[OK]${C_RESET}  %s\n" "$*"; }
warn()   { printf "${C_YELLOW}[!!]${C_RESET}  %s\n" "$*"; }
err()    { printf "${C_RED}[ERR]${C_RESET} %s\n" "$*" >&2; }
header() { printf "\n${C_BOLD}%s${C_RESET}\n" "$*"; }
dim()    { printf "${C_DIM}%s${C_RESET}\n" "$*"; }

# Progress bar: [=======>    ] 3/8 (tqdm-style)
progress_bar() {
  local current="$1" total="$2" width="${3:-20}" i filled empty
  (( total > 0 )) || return
  filled=$(( width * current / total ))
  empty=$(( width - filled ))
  printf "\r  ["
  for (( i=0; i<filled; i++ )); do printf "="; done
  if (( filled < width )); then printf ">"; (( empty-- )); fi
  for (( i=0; i<empty; i++ )); do printf " "; done
  printf "] %s/%s" "$current" "$total"
  [[ -t 1 ]] || printf "\n"
}

# ---------------------------------------------------------------------------
# Box drawing -- pure ASCII, fixed 52-char wide
#   box_top / box_mid / box_bot  -- structural lines
#   box_row <text>               -- content row, right-padded to fit
# ---------------------------------------------------------------------------
BOX_INNER=48   # chars between the two | walls

box_top() { printf "  +"; printf '%0.s-' $(seq 1 $BOX_INNER); printf "+\n"; }
box_bot() { box_top; }
box_sep() { printf "  |"; printf '%0.s-' $(seq 1 $BOX_INNER); printf "|\n"; }
strip_ansi() {
  awk '{ gsub(/\033\[[0-9;]*m/, ""); print }' <<< "$1"
}
box_row() {
  # Strip ANSI escapes when measuring visible length
  local raw="$1"
  local visible
  visible="$(strip_ansi "$raw")"
  local pad=$(( BOX_INNER - 2 - ${#visible} ))
  if (( pad < 0 )); then pad=0; fi
  printf "  | %s%*s |\n" "$raw" "$pad" ''
}
box_blank() { printf "  |%*s|\n" $BOX_INNER ''; }

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INTEGRATIONS="$REPO_ROOT/integrations"

ALL_TOOLS=(claude-code copilot antigravity gemini-cli opencode openclaw cursor aider windsurf qwen zcode kimi codex osaurus hermes vibe)

resolve_dest() {
  local env_name="$1"
  local default_path="$2"
  if [[ -n "${OVERRIDE_PATH:-}" ]]; then
    printf '%s' "$OVERRIDE_PATH"
    return
  fi
  if [[ "$env_name" == "CLAUDE_AGENTS_DIR" && -z "${CLAUDE_AGENTS_DIR:-}" && -n "${CLAUDE_CONFIG_DIR:-}" ]]; then
    local cfg="${CLAUDE_CONFIG_DIR%/}"
    if [[ "$cfg" == */agents ]]; then
      printf '%s' "$cfg"
    else
      printf '%s' "$cfg/agents"
    fi
    return
  fi
  if [[ -n "${!env_name:-}" ]]; then
    printf '%s' "${!env_name}"
  else
    printf '%s' "$default_path"
  fi
}

# Standard agent category directories (keep sorted, sync with convert.sh / lint-agents.sh)
AGENT_DIRS=(
  academic design engineering finance game-development gis healthcare hr legal marketing paid-media product project-management
  research sales security spatial-computing specialized support supply-chain testing
)

FILTER_DIVISIONS=()
FILTER_AGENTS=()
AGENTS_FILE=""
DRY_RUN=false
SELECTION_ACTIVE=false
_ALLOWED_SLUGS=""
AUTO_CONVERT=true
OVERRIDE_PATH=""

get_field() {
  local field="$1" file="$2"
  awk -v f="$field" '
    function emit(v) {
      sub(/^[ \t]+/, "", v); sub(/[ \t]+$/, "", v)
      if (v ~ /^".*"$/)            { v = substr(v, 2, length(v) - 2); gsub(/\\"/, "\"", v); gsub(/\\\\/, "\\", v) }
      else if (v ~ /^\047.*\047$/) { v = substr(v, 2, length(v) - 2); gsub(/\047\047/, "\047", v) }
      print v; printed = 1; exit
    }
    /^---$/ { fm++; if (fm == 2 && found) emit(val); next }
    fm == 1 && !found && $0 ~ "^" f ": " { sub("^" f ": ", ""); val = $0; found = 1; next }
    fm == 1 && found && /^[ \t]+[^ \t]/ { sub(/^[ \t]+/, ""); val = val " " $0; next }
    fm == 1 && found { emit(val) }
    END { if (found && !printed) emit(val) }
  ' "$file"
}

slugify() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]' \
    | sed 's/[^a-z0-9]/-/g; s/--*/-/g; s/^-//; s/-$//'
}

is_agent_file() {
  [[ -f "$1" ]] && [[ "$(head -1 "$1")" == "---" ]]
}

agent_file_slug() {
  basename "$1" .md
}

agent_name_slug() {
  local name
  name="$(get_field name "$1")"
  [[ -n "$name" ]] && slugify "$name"
}

division_files() {
  local d="$REPO_ROOT/$1" f
  [[ -d "$d" ]] || return 0
  while IFS= read -r -d '' f; do
    is_agent_file "$f" && printf '%s\n' "$f"
  done < <(find "$d" -name "*.md" -type f -print0 2>/dev/null)
}

division_count() {
  division_files "$1" | awk 'END { print NR + 0 }'
}

validate_division() {
  local candidate
  for candidate in "${AGENT_DIRS[@]}"; do
    [[ "$candidate" == "$1" ]] && return 0
  done
  err "Unknown division '$1'. Valid: ${AGENT_DIRS[*]}"
  exit 1
}

lookup_agent_file_slug() {
  local target="$1" div f file_slug name_slug
  for div in "${AGENT_DIRS[@]}"; do
    while IFS= read -r f; do
      file_slug="$(agent_file_slug "$f")"
      name_slug="$(agent_name_slug "$f")"
      if [[ "$file_slug" == "$target" || "$name_slug" == "$target" ]]; then
        printf '%s\n' "$file_slug"
        return 0
      fi
    done < <(division_files "$div")
  done
  return 1
}

agent_slug_exists() {
  lookup_agent_file_slug "$1" >/dev/null
}

build_selection() {
  if [[ ${#FILTER_DIVISIONS[@]} -eq 0 && ${#FILTER_AGENTS[@]} -eq 0 && -z "$AGENTS_FILE" ]]; then
    SELECTION_ACTIVE=false
    return
  fi
  SELECTION_ACTIVE=true
  local slugs="" div f s line requested resolved
  for div in ${FILTER_DIVISIONS[@]+"${FILTER_DIVISIONS[@]}"}; do
    while IFS= read -r f; do
      s="$(agent_file_slug "$f")"
      [[ -n "$s" ]] && slugs+="$s"$'\n'
    done < <(division_files "$div")
  done
  for s in ${FILTER_AGENTS[@]+"${FILTER_AGENTS[@]}"}; do
    requested="$(slugify "$s")"
    if ! resolved="$(lookup_agent_file_slug "$requested")"; then
      err "Unknown agent '$s'. Use --list agents to see the available roster."
      exit 1
    fi
    slugs+="$resolved"$'\n'
  done
  if [[ -n "$AGENTS_FILE" ]]; then
    [[ -f "$AGENTS_FILE" ]] || { err "agents-file not found: $AGENTS_FILE"; exit 1; }
    while IFS= read -r line || [[ -n "$line" ]]; do
      line="${line%%#*}"
      line="$(printf '%s' "$line" | xargs 2>/dev/null)"
      [[ -z "$line" ]] && continue
      requested="$(slugify "$line")"
      if ! resolved="$(lookup_agent_file_slug "$requested")"; then
        err "Unknown agent '$line' in agents-file '$AGENTS_FILE'."
        exit 1
      fi
      slugs+="$resolved"$'\n'
    done < "$AGENTS_FILE"
  fi
  _ALLOWED_SLUGS="$(printf '%s' "$slugs" | sort -u | sed '/^$/d')"
}

slug_allowed() {
  $SELECTION_ACTIVE || return 0
  local slug="${1#agency-}"
  printf '%s\n' "$_ALLOWED_SLUGS" | grep -qxF "$slug"
}

selected_agent_count() {
  if ! $SELECTION_ACTIVE; then
    source_agent_count
  else
    printf '%s\n' "$_ALLOWED_SLUGS" | grep -c .
  fi
}

path_collision_group() {
  case "$1" in
    claude-code|copilot)            printf 'raw-source-md' ;;
    gemini-cli|opencode|qwen|zcode) printf 'slug-md' ;;
    antigravity|osaurus)            printf 'agency-skill' ;;
    *)                              printf '' ;;
  esac
}

validate_path_override() {
  [[ -z "$OVERRIDE_PATH" || ${#SELECTED_TOOLS[@]} -lt 2 ]] && return 0
  local seen="" tool group
  for tool in "${SELECTED_TOOLS[@]}"; do
    group="$(path_collision_group "$tool")"
    [[ -z "$group" ]] && continue
    case "$seen" in
      *"|$group|"*)
        err "--path cannot safely combine tools that write colliding $group outputs. Run them separately or choose distinct paths."
        exit 1
        ;;
    esac
    seen="$seen|$group|"
  done
}

ensure_converted() {
  local tool="$1"
  $AUTO_CONVERT || return 0
  case "$tool" in claude-code|copilot) return 0 ;; esac
  local d="$INTEGRATIONS/$tool"
  if [[ ! -d "$d" ]] || [[ -z "$(find "$d" -type f ! -name 'README.md' 2>/dev/null | head -1)" ]]; then
    warn "$tool: integration files missing -- running convert.sh --tool $tool"
    "$SCRIPT_DIR/convert.sh" --tool "$tool" >/dev/null 2>&1 \
      && ok "$tool: generated integration files" \
      || { err "$tool: convert.sh failed; run it manually"; return 1; }
  fi
}

division_emoji() {
  case "$1" in
    academic) printf '📚';; design) printf '🎨';; engineering) printf '💻';;
    finance) printf '💵';; game-development) printf '🎮';; gis) printf '🌍';; healthcare) printf '🏥';;
    hr) printf '👥';; legal) printf '⚖️';; marketing) printf '📢';; paid-media) printf '💰';;
    product) printf '📊';; project-management) printf '🎬';; research) printf '🔍';;
    sales) printf '💼';; security) printf '🔒';; spatial-computing) printf '🥽';;
    specialized) printf '🎯';; support) printf '🛟';; supply-chain) printf '🚚';; testing) printf '🧪';;
    *) printf '•';;
  esac
}

do_list() {
  case "${1:-all}" in
    tools)
      printf '%s\n' "${ALL_TOOLS[@]}" ;;
    teams|divisions)
      local div
      for div in "${AGENT_DIRS[@]}"; do
        printf '%s %-22s %3s agents\n' "$(division_emoji "$div")" "$div" "$(division_count "$div")"
      done ;;
    agents)
      local div f
      for div in "${AGENT_DIRS[@]}"; do
        while IFS= read -r f; do
          printf '%-22s %-42s %s\n' "$div" "$(agent_file_slug "$f")" "$(get_field name "$f")"
        done < <(division_files "$div")
      done ;;
    all)
      echo "Tools (${#ALL_TOOLS[@]}):"
      printf '  %s\n' "${ALL_TOOLS[@]}"
      echo
      echo "Teams (${#AGENT_DIRS[@]}):"
      local div
      for div in "${AGENT_DIRS[@]}"; do
        printf '  %s %-22s %3s agents\n' "$(division_emoji "$div")" "$div" "$(division_count "$div")"
      done ;;
    *) err "Unknown list target '$1'. Valid: tools, teams, agents"; exit 1 ;;
  esac
}

# ---------------------------------------------------------------------------
# Usage
# ---------------------------------------------------------------------------
usage() {
  sed -n '3,32p' "$0" | sed 's/^# \{0,1\}//'
  exit 0
}

# Default parallel job count (nproc on Linux; sysctl on macOS when nproc missing)
parallel_jobs_default() {
  local n
  n=$(nproc 2>/dev/null) && [[ -n "$n" ]] && echo "$n" && return
  n=$(sysctl -n hw.ncpu 2>/dev/null) && [[ -n "$n" ]] && echo "$n" && return
  echo 4
}

# ---------------------------------------------------------------------------
# Preflight
# ---------------------------------------------------------------------------
check_integrations() {
  if [[ ! -d "$INTEGRATIONS" ]]; then
    err "integrations/ not found. Run ./scripts/convert.sh first."
    exit 1
  fi
}

source_agent_count() {
  local count=0 dir f first_line
  for dir in "${AGENT_DIRS[@]}"; do
    [[ -d "$REPO_ROOT/$dir" ]] || continue
    while IFS= read -r -d '' f; do
      first_line="$(head -1 "$f")"
      [[ "$first_line" == "---" ]] || continue
      count=$((count + 1))
    done < <(find "$REPO_ROOT/$dir" -name "*.md" -type f -print0)
  done
  printf '%s\n' "$count"
}

require_generated_count() {
  local tool="$1" generated="$2" expected
  expected="$(source_agent_count)"
  if [[ "$generated" != "$expected" ]]; then
    err "$tool: generated artifact count ($generated) does not match source agent count ($expected). Run ./scripts/convert.sh --tool $tool first."
    return 1
  fi
}

# ---------------------------------------------------------------------------
# Tool detection
# ---------------------------------------------------------------------------
detect_claude_code() { [[ -n "${CLAUDE_CONFIG_DIR:-}${CLAUDE_AGENTS_DIR:-}" || -d "${HOME}/.claude" ]]; }
detect_copilot()      { command -v code >/dev/null 2>&1 || [[ -n "${GITHUB_AGENT_DIR:-}${COPILOT_AGENT_DIR:-}" || -d "${HOME}/.github" || -d "${HOME}/.copilot" ]]; }
detect_antigravity()  { [[ -n "${ANTIGRAVITY_SKILLS_DIR:-}" || -d "${HOME}/.gemini/config/skills" || -d "${PWD}/.agents/skills" ]]; }
detect_gemini_cli()   { command -v gemini >/dev/null 2>&1 || [[ -n "${GEMINI_EXTENSION_DIR:-}" || -d "${HOME}/.gemini" ]]; }
detect_cursor()       { command -v cursor >/dev/null 2>&1 || [[ -n "${CURSOR_RULES_DIR:-}" || -d "${HOME}/.cursor" ]]; }
detect_opencode()     { command -v opencode >/dev/null 2>&1 || [[ -n "${OPENCODE_AGENTS_DIR:-}" || -d "${HOME}/.config/opencode" ]]; }
detect_aider()        { command -v aider >/dev/null 2>&1; }
detect_openclaw()     { command -v openclaw >/dev/null 2>&1 || [[ -n "${OPENCLAW_DIR:-}" || -d "${HOME}/.openclaw" ]]; }
detect_windsurf()     { command -v windsurf >/dev/null 2>&1 || [[ -d "${HOME}/.codeium" ]]; }
detect_qwen()         { command -v qwen >/dev/null 2>&1 || [[ -n "${QWEN_AGENTS_DIR:-}" || -d "${HOME}/.qwen" ]]; }
detect_zcode()        { command -v zcode >/dev/null 2>&1 || [[ -n "${ZCODE_AGENTS_DIR:-}" || -d "${HOME}/.zcode" ]]; }
detect_kimi()         { command -v kimi >/dev/null 2>&1 || [[ -n "${KIMI_AGENTS_DIR:-}" ]]; }
detect_codex()        { command -v codex >/dev/null 2>&1 || [[ -n "${CODEX_AGENTS_DIR:-}" || -d "${HOME}/.codex" ]]; }
detect_osaurus()      { command -v osaurus >/dev/null 2>&1 || [[ -n "${OSAURUS_SKILLS_DIR:-}" || -d "${HOME}/.osaurus" ]]; }
detect_hermes()       { command -v hermes >/dev/null 2>&1 || [[ -n "${HERMES_PLUGIN_DIR:-}" || -d "${HERMES_HOME:-${HOME}/.hermes}" ]]; }
detect_vibe()         { command -v vibe >/dev/null 2>&1 || [[ -n "${VIBE_HOME:-}" || -d "${HOME}/.vibe" ]]; }

is_detected() {
  case "$1" in
    claude-code) detect_claude_code ;;
    copilot)     detect_copilot     ;;
    antigravity) detect_antigravity ;;
    gemini-cli)  detect_gemini_cli  ;;
    opencode)    detect_opencode    ;;
    openclaw)    detect_openclaw    ;;
    cursor)      detect_cursor      ;;
    aider)       detect_aider       ;;
    windsurf)    detect_windsurf    ;;
    qwen)        detect_qwen        ;;
    zcode)       detect_zcode       ;;
    kimi)        detect_kimi        ;;
    codex)       detect_codex       ;;
    osaurus)     detect_osaurus     ;;
    hermes)      detect_hermes      ;;
    vibe)        detect_vibe        ;;
    *)           return 1 ;;
  esac
}

# Fixed-width labels: name (14) + detail (24) = 38 visible chars
tool_label() {
  case "$1" in
    claude-code) printf "%-14s  %s" "Claude Code"  "(claude.ai/code)"        ;;
    copilot)     printf "%-14s  %s" "Copilot"      "(~/.github + ~/.copilot)" ;;
    antigravity) printf "%-14s  %s" "Antigravity"  "(~/.gemini/config/skills)" ;;
    gemini-cli)  printf "%-14s  %s" "Gemini CLI"   "(gemini extension)"      ;;
    opencode)    printf "%-14s  %s" "OpenCode"     "(opencode.ai)"           ;;
    openclaw)    printf "%-14s  %s" "OpenClaw"     "(~/.openclaw/agency-agents)" ;;
    cursor)      printf "%-14s  %s" "Cursor"       "(.cursor/rules)"         ;;
    aider)       printf "%-14s  %s" "Aider"        "(CONVENTIONS.md)"        ;;
    windsurf)    printf "%-14s  %s" "Windsurf"     "(.windsurfrules)"        ;;
    qwen)        printf "%-14s  %s" "Qwen Code"    "(~/.qwen/agents)"        ;;
    zcode)       printf "%-14s  %s" "ZCode"        "(~/.zcode/agents)"       ;;
    kimi)        printf "%-14s  %s" "Kimi Code"    "(~/.config/kimi/agents)" ;;
    codex)       printf "%-14s  %s" "Codex"        "(~/.codex/agents)"       ;;
    osaurus)     printf "%-14s  %s" "Osaurus"      "(~/.osaurus/skills)"     ;;
    hermes)      printf "%-14s  %s" "Hermes"       "(~/.hermes/plugins)"     ;;
    vibe)        printf "%-14s  %s" "Mistral Vibe" "(~/.vibe/agents)"        ;;
  esac
}

# ---------------------------------------------------------------------------
# Interactive selector
# ---------------------------------------------------------------------------
interactive_select() {
  # bash 3-compatible arrays
  declare -a selected=()
  declare -a detected_map=()

  local t
  for t in "${ALL_TOOLS[@]}"; do
    if is_detected "$t" 2>/dev/null; then
      selected+=(1); detected_map+=(1)
    else
      selected+=(0); detected_map+=(0)
    fi
  done

  while true; do
    # --- header ---
    printf "\n"
    box_top
    box_row "${C_BOLD}  The Agency -- Tool Installer${C_RESET}"
    box_bot
    printf "\n"
    printf "  ${C_DIM}System scan:  [*] = detected on this machine${C_RESET}\n"
    printf "\n"

    # --- tool rows ---
    local i=0
    for t in "${ALL_TOOLS[@]}"; do
      local num=$(( i + 1 ))
      local label
      label="$(tool_label "$t")"
      local dot
      if [[ "${detected_map[$i]}" == "1" ]]; then
        dot="${C_GREEN}[*]${C_RESET}"
      else
        dot="${C_DIM}[ ]${C_RESET}"
      fi
      local chk
      if [[ "${selected[$i]}" == "1" ]]; then
        chk="${C_GREEN}[x]${C_RESET}"
      else
        chk="${C_DIM}[ ]${C_RESET}"
      fi
      printf "  %s  %s)  %s  %s\n" "$chk" "$num" "$dot" "$label"
      (( i++ )) || true
    done

    # --- controls ---
    printf "\n"
    printf "  ------------------------------------------------\n"
    printf "  ${C_CYAN}[1-%s]${C_RESET} toggle   ${C_CYAN}[a]${C_RESET} all   ${C_CYAN}[n]${C_RESET} none   ${C_CYAN}[d]${C_RESET} detected\n" "${#ALL_TOOLS[@]}"
    printf "  ${C_GREEN}[Enter]${C_RESET} install   ${C_RED}[q]${C_RESET} quit\n"
    printf "\n"
    printf "  >> "
    read -r input </dev/tty

    case "$input" in
      q|Q)
        printf "\n"; ok "Aborted."; exit 0 ;;
      a|A)
        for (( j=0; j<${#ALL_TOOLS[@]}; j++ )); do selected[$j]=1; done ;;
      n|N)
        for (( j=0; j<${#ALL_TOOLS[@]}; j++ )); do selected[$j]=0; done ;;
      d|D)
        for (( j=0; j<${#ALL_TOOLS[@]}; j++ )); do selected[$j]="${detected_map[$j]}"; done ;;
      "")
        local any=false
        local s
        for s in "${selected[@]}"; do [[ "$s" == "1" ]] && any=true && break; done
        if $any; then
          break
        else
          printf "  ${C_YELLOW}Nothing selected -- pick a tool or press q to quit.${C_RESET}\n"
          sleep 1
        fi ;;
      *)
        local toggled=false
        local num
        for num in $input; do
          if [[ "$num" =~ ^[0-9]+$ ]]; then
            local idx=$(( num - 1 ))
            if (( idx >= 0 && idx < ${#ALL_TOOLS[@]} )); then
              if [[ "${selected[$idx]}" == "1" ]]; then
                selected[$idx]=0
              else
                selected[$idx]=1
              fi
              toggled=true
            fi
          fi
        done
        if ! $toggled; then
          printf "  ${C_RED}Invalid. Enter a number 1-%s, or a command.${C_RESET}\n" "${#ALL_TOOLS[@]}"
          sleep 1
        fi ;;
    esac

    # Clear UI for redraw
    local lines=$(( ${#ALL_TOOLS[@]} + 14 ))
    local l
    for (( l=0; l<lines; l++ )); do printf '\033[1A\033[2K'; done
  done

  # Build output array
  SELECTED_TOOLS=()
  local i=0
  for t in "${ALL_TOOLS[@]}"; do
    [[ "${selected[$i]}" == "1" ]] && SELECTED_TOOLS+=("$t")
    (( i++ )) || true
  done
}

# ---------------------------------------------------------------------------
# Installers
# ---------------------------------------------------------------------------

install_claude_code() {
  local dest
  dest="$(resolve_dest CLAUDE_AGENTS_DIR "${HOME}/.claude/agents")"
  local count=0
  mkdir -p "$dest"
  local dir f first_line slug
  for dir in "${AGENT_DIRS[@]}"; do
    [[ -d "$REPO_ROOT/$dir" ]] || continue
    while IFS= read -r -d '' f; do
      first_line="$(head -1 "$f")"
      [[ "$first_line" == "---" ]] || continue
      slug="$(agent_file_slug "$f")"
      slug_allowed "$slug" || continue
      cp "$f" "$dest/"
      (( count++ )) || true
    done < <(find "$REPO_ROOT/$dir" -name "*.md" -type f -print0)
  done
  ok "Claude Code: $count agents -> $dest"
}

install_copilot() {
  local dest_github dest_copilot
  dest_github="$(resolve_dest GITHUB_AGENT_DIR "${HOME}/.github/agents")"
  dest_copilot="$(resolve_dest COPILOT_AGENT_DIR "${HOME}/.copilot/agents")"
  local count=0
  mkdir -p "$dest_github" "$dest_copilot"
  local dir f first_line slug
  for dir in "${AGENT_DIRS[@]}"; do
    [[ -d "$REPO_ROOT/$dir" ]] || continue
    while IFS= read -r -d '' f; do
      first_line="$(head -1 "$f")"
      [[ "$first_line" == "---" ]] || continue
      slug="$(agent_file_slug "$f")"
      slug_allowed "$slug" || continue
      cp "$f" "$dest_github/"
      cp "$f" "$dest_copilot/"
      (( count++ )) || true
    done < <(find "$REPO_ROOT/$dir" -name "*.md" -type f -print0)
  done
  ok "Copilot: $count agents -> $dest_github"
  ok "Copilot: $count agents -> $dest_copilot"
  warn "Copilot: Verify VS Code setting 'chat.agentFilesLocations' includes your install path."
  dim  "         Open Settings (Ctrl/Cmd+,) -> search 'chat.agentFilesLocations'"
}

install_antigravity() {
  local src="$INTEGRATIONS/antigravity"
  local dest
  dest="$(resolve_dest ANTIGRAVITY_SKILLS_DIR "${HOME}/.gemini/config/skills")"
  local count=0
  [[ -d "$src" ]] || { err "integrations/antigravity missing. Run convert.sh first."; return 1; }
  require_generated_count antigravity "$(find "$src" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')" || return 1
  mkdir -p "$dest"
  local d
  while IFS= read -r -d '' d; do
    local name; name="$(basename "$d")"
    slug_allowed "$name" || continue
    mkdir -p "$dest/$name"
    cp "$d/SKILL.md" "$dest/$name/SKILL.md"
    (( count++ )) || true
  done < <(find "$src" -mindepth 1 -maxdepth 1 -type d -print0)
  ok "Antigravity: $count skills -> $dest"
}

install_osaurus() {
  local src="$INTEGRATIONS/osaurus"
  local dest
  dest="$(resolve_dest OSAURUS_SKILLS_DIR "${HOME}/.osaurus/skills")"
  local count=0
  [[ -d "$src" ]] || { err "integrations/osaurus missing. Run convert.sh first."; return 1; }
  require_generated_count osaurus "$(find "$src" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')" || return 1
  mkdir -p "$dest"
  local d
  while IFS= read -r -d '' d; do
    local name; name="$(basename "$d")"
    slug_allowed "$name" || continue
    mkdir -p "$dest/$name"
    cp "$d/SKILL.md" "$dest/$name/SKILL.md"
    (( count++ )) || true
  done < <(find "$src" -mindepth 1 -maxdepth 1 -type d -print0)
  ok "Osaurus: $count skills -> $dest"
}

install_gemini_cli() {
  local src="$INTEGRATIONS/gemini-cli"
  local dest
  dest="$(resolve_dest GEMINI_EXTENSION_DIR "${HOME}/.gemini/extensions/agency-agents")"
  local count=0
  local manifest="$src/gemini-extension.json"
  local skills_dir="$src/skills"
  [[ -d "$src" ]] || { err "integrations/gemini-cli missing. Run ./scripts/convert.sh --tool gemini-cli first."; return 1; }
  [[ -f "$manifest" ]] || { err "integrations/gemini-cli/gemini-extension.json missing. Run ./scripts/convert.sh --tool gemini-cli first."; return 1; }
  [[ -d "$skills_dir" ]] || { err "integrations/gemini-cli/skills missing. Run ./scripts/convert.sh --tool gemini-cli first."; return 1; }
  require_generated_count gemini-cli "$(find "$skills_dir" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')" || return 1
  mkdir -p "$dest/skills"
  cp "$manifest" "$dest/gemini-extension.json"
  local d
  while IFS= read -r -d '' d; do
    local name; name="$(basename "$d")"
    slug_allowed "$name" || continue
    mkdir -p "$dest/skills/$name"
    cp "$d/SKILL.md" "$dest/skills/$name/SKILL.md"
    (( count++ )) || true
  done < <(find "$skills_dir" -mindepth 1 -maxdepth 1 -type d -print0)
  ok "Gemini CLI: $count skills -> $dest"
}

install_opencode() {
  local src="$INTEGRATIONS/opencode"
  local dest
  dest="$(resolve_dest OPENCODE_AGENTS_DIR "${PWD}/.opencode/agents")"
  local count=0
  [[ -d "$src" ]] || { err "integrations/opencode missing. Run convert.sh first."; return 1; }
  # Support both flat layout (integrations/opencode/*.md) and nested (integrations/opencode/agents/*.md)
  local search_dir="$src"
  [[ -d "$src/agents" ]] && search_dir="$src/agents"
  require_generated_count opencode "$(find "$search_dir" -maxdepth 1 -name "*.md" ! -name "README.md" | wc -l | tr -d ' ')" || return 1
  mkdir -p "$dest"
  local f
  while IFS= read -r -d '' f; do
    local base; base="$(basename "$f")"
    [[ "$base" == "README.md" ]] && continue
    slug_allowed "${base%.md}" || continue
    cp "$f" "$dest/"; (( count++ )) || true
  done < <(find "$search_dir" -maxdepth 1 -name "*.md" -print0)
  if (( count == 0 )); then
    warn "OpenCode: no agent files found in $search_dir. Run convert.sh --tool opencode first."
  else
    ok "OpenCode: $count agents -> $dest"
  fi
  warn "OpenCode: project-scoped. Run from your project root to install there."
}

install_openclaw() {
  local src="$INTEGRATIONS/openclaw"
  local dest
  dest="$(resolve_dest OPENCLAW_DIR "${HOME}/.openclaw/agency-agents")"
  local count=0
  local existing_agents=""
  [[ -d "$src" ]] || { err "integrations/openclaw missing. Run convert.sh first."; return 1; }
  require_generated_count openclaw "$(find "$src" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')" || return 1
  mkdir -p "$dest"
  if command -v openclaw >/dev/null 2>&1; then
    existing_agents=$'\n'"$(openclaw agents list --json 2>/dev/null | sed -n 's/^[[:space:]]*\"id\": \"\\([^\"]*\\)\".*/\\1/p')"$'\n'
  fi
  local d
  while IFS= read -r -d '' d; do
    local name; name="$(basename "$d")"
    slug_allowed "$name" || continue
    [[ -f "$d/SOUL.md" && -f "$d/AGENTS.md" && -f "$d/IDENTITY.md" ]] || continue
    mkdir -p "$dest/$name"
    cp "$d/SOUL.md" "$dest/$name/SOUL.md"
    cp "$d/AGENTS.md" "$dest/$name/AGENTS.md"
    cp "$d/IDENTITY.md" "$dest/$name/IDENTITY.md"
    if command -v openclaw >/dev/null 2>&1; then
      if [[ "$existing_agents" != *$'\n'"$name"$'\n'* ]]; then
        openclaw agents add "$name" --workspace "$dest/$name" --non-interactive || true
      fi
    fi
    (( count++ )) || true
  done < <(find "$src" -mindepth 1 -maxdepth 1 -type d -print0)
  if (( count == 0 )); then
    err "integrations/openclaw contains no generated workspaces. Run ./scripts/convert.sh --tool openclaw first."
    return 1
  fi
  ok "OpenClaw: $count workspaces -> $dest"
  if command -v openclaw >/dev/null 2>&1; then
    warn "OpenClaw: run 'openclaw gateway restart' to activate new agents"
  fi
}

install_cursor() {
  local src="$INTEGRATIONS/cursor/rules"
  local dest
  dest="$(resolve_dest CURSOR_RULES_DIR "${PWD}/.cursor/rules")"
  local count=0
  [[ -d "$src" ]] || { err "integrations/cursor missing. Run convert.sh first."; return 1; }
  require_generated_count cursor "$(find "$src" -maxdepth 1 -name "*.mdc" | wc -l | tr -d ' ')" || return 1
  mkdir -p "$dest"
  local f
  while IFS= read -r -d '' f; do
    slug_allowed "$(basename "$f" .mdc)" || continue
    cp "$f" "$dest/"; (( count++ )) || true
  done < <(find "$src" -maxdepth 1 -name "*.mdc" -print0)
  ok "Cursor: $count rules -> $dest"
  warn "Cursor: project-scoped. Run from your project root to install there."
}

install_aider() {
  local src="$INTEGRATIONS/aider/CONVENTIONS.md"
  local dest_dir="${OVERRIDE_PATH:-$PWD}"
  local dest="${dest_dir%/}/CONVENTIONS.md"
  [[ -f "$src" ]] || { err "integrations/aider/CONVENTIONS.md missing. Run convert.sh first."; return 1; }
  mkdir -p "$dest_dir"
  if [[ -f "$dest" ]]; then
    warn "Aider: CONVENTIONS.md already exists at $dest (remove to reinstall)."
    return 0
  fi
  cp "$src" "$dest"
  ok "Aider: installed -> $dest"
  warn "Aider: project-scoped. Run from your project root to install there."
}

install_windsurf() {
  local src="$INTEGRATIONS/windsurf/.windsurfrules"
  local dest_dir="${OVERRIDE_PATH:-$PWD}"
  local dest="${dest_dir%/}/.windsurfrules"
  [[ -f "$src" ]] || { err "integrations/windsurf/.windsurfrules missing. Run convert.sh first."; return 1; }
  mkdir -p "$dest_dir"
  if [[ -f "$dest" ]]; then
    warn "Windsurf: .windsurfrules already exists at $dest (remove to reinstall)."
    return 0
  fi
  cp "$src" "$dest"
  ok "Windsurf: installed -> $dest"
  warn "Windsurf: project-scoped. Run from your project root to install there."
}

install_qwen() {
  local src="$INTEGRATIONS/qwen/agents"
  local dest
  dest="$(resolve_dest QWEN_AGENTS_DIR "${PWD}/.qwen/agents")"
  local count=0

  [[ -d "$src" ]] || { err "integrations/qwen missing. Run convert.sh first."; return 1; }
  require_generated_count qwen "$(find "$src" -maxdepth 1 -name "*.md" | wc -l | tr -d ' ')" || return 1

  mkdir -p "$dest"

  local f
  while IFS= read -r -d '' f; do
    slug_allowed "$(basename "$f" .md)" || continue
    cp "$f" "$dest/"
    (( count++ )) || true
  done < <(find "$src" -maxdepth 1 -name "*.md" -print0)

  ok "Qwen Code: installed $count agents to $dest"
  warn "Qwen Code: project-scoped. Run from your project root to install there."
  warn "Tip: Run '/agents manage' in Qwen Code to refresh, or restart session"
}

install_zcode() {
  local src="$INTEGRATIONS/zcode/agents"
  local dest
  dest="$(resolve_dest ZCODE_AGENTS_DIR "${HOME}/.zcode/agents")"
  local count=0

  [[ -d "$src" ]] || { err "integrations/zcode missing. Run convert.sh first."; return 1; }
  require_generated_count zcode "$(find "$src" -maxdepth 1 -name "*.md" | wc -l | tr -d ' ')" || return 1

  mkdir -p "$dest"

  local f
  while IFS= read -r -d '' f; do
    slug_allowed "$(basename "$f" .md)" || continue
    cp "$f" "$dest/"
    (( count++ )) || true
  done < <(find "$src" -maxdepth 1 -name "*.md" -print0)

  ok "ZCode: installed $count agents to $dest"
  warn "ZCode: set ZCODE_AGENTS_DIR=.zcode/agents to install into a project."
}

install_kimi() {
  local src="$INTEGRATIONS/kimi"
  local dest
  dest="$(resolve_dest KIMI_AGENTS_DIR "${HOME}/.config/kimi/agents")"
  local count=0

  [[ -d "$src" ]] || { err "integrations/kimi missing. Run convert.sh first."; return 1; }
  require_generated_count kimi "$(find "$src" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')" || return 1

  mkdir -p "$dest"

  local d
  while IFS= read -r -d '' d; do
    local name; name="$(basename "$d")"
    slug_allowed "$name" || continue
    mkdir -p "$dest/$name"
    cp "$d/agent.yaml" "$dest/$name/agent.yaml"
    cp "$d/system.md" "$dest/$name/system.md"
    (( count++ )) || true
  done < <(find "$src" -mindepth 1 -maxdepth 1 -type d -print0)

  ok "Kimi Code: installed $count agents to $dest"
  ok "Usage: kimi --agent-file ~/.config/kimi/agents/<agent-name>/agent.yaml"
}

install_codex() {
  local src="$INTEGRATIONS/codex/agents"
  local dest
  dest="$(resolve_dest CODEX_AGENTS_DIR "${HOME}/.codex/agents")"
  local count=0

  [[ -d "$src" ]] || { err "integrations/codex missing. Run convert.sh first."; return 1; }
  require_generated_count codex "$(find "$src" -maxdepth 1 -name "*.toml" | wc -l | tr -d ' ')" || return 1

  mkdir -p "$dest"

  local f
  while IFS= read -r -d '' f; do
    slug_allowed "$(basename "$f" .toml)" || continue
    cp "$f" "$dest/"
    (( count++ )) || true
  done < <(find "$src" -maxdepth 1 -name "*.toml" -print0)

  ok "Codex: $count agents -> $dest"
}

install_vibe() {
  local src_agents="$INTEGRATIONS/vibe/agents"
  local src_prompts="$INTEGRATIONS/vibe/prompts"
  local dest
  dest="$(resolve_dest VIBE_HOME "${HOME}/.vibe")"
  local count=0

  [[ -d "$src_agents" && -d "$src_prompts" ]] || { err "integrations/vibe missing. Run convert.sh first."; return 1; }
  require_generated_count vibe "$(find "$src_agents" -maxdepth 1 -name "*.toml" | wc -l | tr -d ' ')" || return 1
  require_generated_count vibe "$(find "$src_prompts" -maxdepth 1 -name "*.md" | wc -l | tr -d ' ')" || return 1

  mkdir -p "$dest/agents" "$dest/prompts"

  local agent_file prompt_file slug
  while IFS= read -r -d '' agent_file; do
    slug="$(basename "$agent_file" .toml)"
    slug_allowed "$slug" || continue
    prompt_file="$src_prompts/$slug.md"
    [[ -f "$prompt_file" ]] || continue
    cp "$agent_file" "$dest/agents/"
    cp "$prompt_file" "$dest/prompts/"
    (( count++ )) || true
  done < <(find "$src_agents" -maxdepth 1 -name "*.toml" -print0)

  ok "Mistral Vibe: $count agents -> $dest/agents and $dest/prompts"
}

hermes_home_dir() {
  printf '%s\n' "${HERMES_HOME:-${HOME}/.hermes}"
}

ensure_hermes_plugin_enabled() {
  local hermes_home config plugin
  hermes_home="$(hermes_home_dir)"
  config="${hermes_home}/config.yaml"
  plugin="agency-agents-router"
  mkdir -p "$hermes_home"
  set +e
  python3 - "$config" "$plugin" <<'PY'
from __future__ import annotations

import sys
from pathlib import Path

config = Path(sys.argv[1])
plugin = sys.argv[2]

try:
    import yaml
except Exception:
    raise SystemExit(2)

data = {}
if config.exists():
    loaded = yaml.safe_load(config.read_text(encoding="utf-8")) or {}
    if isinstance(loaded, dict):
        data = loaded
plugins = data.setdefault("plugins", {})
if not isinstance(plugins, dict):
    plugins = {}
    data["plugins"] = plugins
enabled = plugins.setdefault("enabled", [])
if not isinstance(enabled, list):
    enabled = []
    plugins["enabled"] = enabled
if plugin not in enabled:
    enabled.append(plugin)
config.write_text(yaml.safe_dump(data, sort_keys=False, allow_unicode=True), encoding="utf-8")
PY
  local rc=$?
  set -e
  case "$rc" in
    0) ok "Hermes: enabled agency-agents-router in $config" ;;
    2) warn "Hermes: PyYAML is unavailable; add 'agency-agents-router' to plugins.enabled in $config manually." ;;
    *) warn "Hermes: plugin installed but $config was not updated." ;;
  esac
}

install_hermes() {
  local src="$INTEGRATIONS/hermes/agency-agents-router"
  local hermes_home dest count
  hermes_home="$(hermes_home_dir)"
  dest="$(resolve_dest HERMES_PLUGIN_DIR "${hermes_home}/plugins/agency-agents-router")"
  if [[ "$(basename "$dest")" != "agency-agents-router" ]]; then
    dest="${dest%/}/agency-agents-router"
  fi
  [[ -f "$src/plugin.yaml" && -f "$src/__init__.py" && -f "$src/data/agents.json" ]] || {
    err "integrations/hermes/agency-agents-router missing. Run ./scripts/convert.sh --tool hermes first."
    return 1
  }
  mkdir -p "$(dirname "$dest")"
  if [[ "$(basename "$dest")" != "agency-agents-router" ]]; then
    err "Hermes: refusing to remove '$dest' — expected an agency-agents-router directory."
    return 1
  fi
  rm -rf "$dest"
  cp -R "$src" "$dest"
  ensure_hermes_plugin_enabled
  count="$(python3 - "$src/data/agents.json" <<'PY'
import json
import sys
from pathlib import Path
print(len(json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))))
PY
)"
  ok "Hermes: installed agency-agents-router ($count agents) -> $dest"
}

install_tool() {
  ensure_converted "$1" || return 1
  case "$1" in
    claude-code) install_claude_code ;;
    copilot)     install_copilot     ;;
    antigravity) install_antigravity ;;
    gemini-cli)  install_gemini_cli  ;;
    opencode)    install_opencode    ;;
    openclaw)    install_openclaw    ;;
    cursor)      install_cursor      ;;
    aider)       install_aider       ;;
    windsurf)    install_windsurf    ;;
    qwen)        install_qwen        ;;
    zcode)       install_zcode       ;;
    kimi)        install_kimi        ;;
    codex)       install_codex       ;;
    osaurus)     install_osaurus     ;;
    hermes)      install_hermes      ;;
    vibe)        install_vibe        ;;
  esac
}

# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------
main() {
  local tool="all"
  local interactive_mode="auto"
  local use_parallel=false
  local list_target=""
  local parallel_jobs
  parallel_jobs="$(parallel_jobs_default)"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --tool)            tool="${2:?'--tool requires a value'}"; shift 2; interactive_mode="no" ;;
      --division)
        local raw_div div
        IFS=',' read -ra raw_divs <<< "${2:?'--division requires a value'}"
        for raw_div in "${raw_divs[@]}"; do
          div="$(printf '%s' "$raw_div" | xargs)"
          [[ -z "$div" ]] && continue
          validate_division "$div"
          FILTER_DIVISIONS+=("$div")
        done
        shift 2
        interactive_mode="no" ;;
      --agent)
        local raw_agent agent
        IFS=',' read -ra raw_agents <<< "${2:?'--agent requires a value'}"
        for raw_agent in "${raw_agents[@]}"; do
          agent="$(printf '%s' "$raw_agent" | xargs)"
          [[ -n "$agent" ]] && FILTER_AGENTS+=("$agent")
        done
        shift 2
        interactive_mode="no" ;;
      --agents-file)     AGENTS_FILE="${2:?'--agents-file requires a value'}"; shift 2; interactive_mode="no" ;;
      --dry-run)         DRY_RUN=true; shift; interactive_mode="no" ;;
      --path)            OVERRIDE_PATH="${2:?'--path requires a value'}"; shift 2; interactive_mode="no" ;;
      --no-convert)      AUTO_CONVERT=false; shift ;;
      --list)
        if [[ $# -ge 2 && "${2#-}" == "$2" ]]; then
          list_target="$2"
          shift 2
        else
          list_target="all"
          shift
        fi ;;
      --interactive)     interactive_mode="yes"; shift ;;
      --no-interactive)  interactive_mode="no"; shift ;;
      --parallel)        use_parallel=true; shift ;;
      --jobs)            parallel_jobs="${2:?'--jobs requires a value'}"; shift 2 ;;
      --help|-h)         usage ;;
      *)                 err "Unknown option: $1"; usage ;;
    esac
  done

  if [[ -n "$list_target" ]]; then
    do_list "$list_target"
    exit 0
  fi

  if [[ -n "${AGENCY_OVERRIDE_PATH:-}" ]]; then
    OVERRIDE_PATH="$AGENCY_OVERRIDE_PATH"
  fi
  if [[ "${AGENCY_AUTO_CONVERT:-}" == "false" ]]; then
    AUTO_CONVERT=false
  fi

  if [[ -n "${AGENCY_ALLOWED_SLUGS:-}" ]]; then
    SELECTION_ACTIVE=true
    _ALLOWED_SLUGS="$AGENCY_ALLOWED_SLUGS"
  else
    build_selection
  fi

  check_integrations

  # Validate explicit tool(s). --tool accepts comma-separated values, e.g.
  # --tool claude-code,cursor.
  local explicit_tools=()
  if [[ "$tool" != "all" ]]; then
    local raw_tool t
    IFS=',' read -ra explicit_tools <<< "$tool"
    local cleaned=()
    for raw_tool in "${explicit_tools[@]}"; do
      t="$(printf '%s' "$raw_tool" | xargs)"
      [[ -z "$t" ]] && continue
      local valid=false candidate
      for candidate in "${ALL_TOOLS[@]}"; do [[ "$candidate" == "$t" ]] && valid=true && break; done
      if ! $valid; then
        err "Unknown tool '$t'. Valid: ${ALL_TOOLS[*]}"
        exit 1
      fi
      local duplicate=false selected
      if [[ ${#cleaned[@]} -gt 0 ]]; then
        for selected in "${cleaned[@]}"; do
          [[ "$selected" == "$t" ]] && duplicate=true && break
        done
      fi
      $duplicate || cleaned+=("$t")
    done
    if [[ ${#cleaned[@]} -eq 0 ]]; then
      err "--tool requires at least one tool name. Valid: ${ALL_TOOLS[*]}"
      exit 1
    fi
    explicit_tools=("${cleaned[@]}")
  fi

  # Decide whether to show interactive UI
  local use_interactive=false
  if   [[ "$interactive_mode" == "yes" ]]; then
    use_interactive=true
  elif [[ "$interactive_mode" == "auto" && -t 0 && -t 1 && "$tool" == "all" ]]; then
    use_interactive=true
  fi

  SELECTED_TOOLS=()

  if $use_interactive; then
    interactive_select

  elif [[ "$tool" != "all" ]]; then
    SELECTED_TOOLS=("${explicit_tools[@]}")

  else
    # Non-interactive: auto-detect
    header "The Agency -- Scanning for installed tools..."
    printf "\n"
    local t
    for t in "${ALL_TOOLS[@]}"; do
      if is_detected "$t" 2>/dev/null; then
        SELECTED_TOOLS+=("$t")
        printf "  ${C_GREEN}[*]${C_RESET}  %s  ${C_DIM}detected${C_RESET}\n" "$(tool_label "$t")"
      else
        printf "  ${C_DIM}[ ]  %s  not found${C_RESET}\n" "$(tool_label "$t")"
      fi
    done
  fi

  if [[ ${#SELECTED_TOOLS[@]} -eq 0 ]]; then
    warn "No tools selected or detected. Nothing to install."
    printf "\n"
    dim "  Tip: use --tool <name> to force-install a specific tool."
    dim "  Available: ${ALL_TOOLS[*]}"
    exit 0
  fi

  validate_path_override

  if $DRY_RUN; then
    printf "\n"
    header "The Agency -- Install plan"
    printf "  Repo:    %s\n" "$REPO_ROOT"
    printf "  Tools:   %s\n" "${SELECTED_TOOLS[*]}"
    printf "  Agents:  %s\n" "$(selected_agent_count)"
    if $SELECTION_ACTIVE; then
      printf "  Filter:  active\n"
    else
      printf "  Filter:  all agents\n"
    fi
    printf "\n"
    ok "Dry run complete. No files were written."
    exit 0
  fi

  # When parent runs install.sh --parallel, it spawns workers with AGENCY_INSTALL_WORKER=1
  # so each worker only runs install_tool(s) and skips header/done box (avoids duplicate output).
  if [[ -n "${AGENCY_INSTALL_WORKER:-}" ]]; then
    local t
    for t in "${SELECTED_TOOLS[@]}"; do
      install_tool "$t"
    done
    return 0
  fi

  printf "\n"
  header "The Agency -- Installing agents"
  printf "  Repo:       %s\n" "$REPO_ROOT"
  local n_selected=${#SELECTED_TOOLS[@]}
  printf "  Installing: %s\n" "${SELECTED_TOOLS[*]}"
  if $use_parallel; then
    ok "Installing $n_selected tools in parallel (output buffered per tool)."
  fi
  printf "\n"

  local installed=0 t i=0
  if $use_parallel; then
    local install_out_dir
    install_out_dir="$(mktemp -d)"
    export AGENCY_INSTALL_OUT_DIR="$install_out_dir"
    export AGENCY_INSTALL_SCRIPT="$SCRIPT_DIR/install.sh"
    export AGENCY_ALLOWED_SLUGS="$_ALLOWED_SLUGS"
    export AGENCY_OVERRIDE_PATH="$OVERRIDE_PATH"
    export AGENCY_AUTO_CONVERT="$AUTO_CONVERT"
    printf '%s\n' "${SELECTED_TOOLS[@]}" | xargs -P "$parallel_jobs" -I {} sh -c 'AGENCY_INSTALL_WORKER=1 "$AGENCY_INSTALL_SCRIPT" --tool "{}" --no-interactive > "$AGENCY_INSTALL_OUT_DIR/{}" 2>&1'
    for t in "${SELECTED_TOOLS[@]}"; do
      [[ -f "$install_out_dir/$t" ]] && cat "$install_out_dir/$t"
    done
    rm -rf "$install_out_dir"
    installed=$n_selected
  else
    for t in "${SELECTED_TOOLS[@]}"; do
      (( i++ )) || true
      progress_bar "$i" "$n_selected"
      printf "\n"
      printf "  ${C_DIM}[%s/%s]${C_RESET} %s\n" "$i" "$n_selected" "$t"
      install_tool "$t"
      (( installed++ )) || true
    done
  fi

  # Done box
  local msg="  Done!  Installed $installed tool(s)."
  printf "\n"
  box_top
  box_row "${C_GREEN}${C_BOLD}${msg}${C_RESET}"
  box_bot
  printf "\n"
  dim "  Run ./scripts/convert.sh to regenerate after adding or editing agents."
  printf "\n"
}

main "$@"

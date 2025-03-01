AZALEAS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/azaleas"
CFG_DIR="$AZALEAS_DIR/cfg"
ONCE_TRACKER="$AZALEAS_DIR/.once_commands"

mkdir -p "$CFG_DIR"
[[ ! -f "$ONCE_TRACKER" ]] && touch "$ONCE_TRACKER"

typeset -A ALIAS_REGISTRY
typeset -a COMMAND_REGISTRY
typeset -a ONCE_COMMAND_REGISTRY

typeset -a SINGLES_ALIASES
typeset -a SINGLES_COMMANDS
typeset -a SINGLES_ONCE_COMMANDS

azaleas_once_reset() {
  if [[ "$1" == "all" ]]; then
    : > "$ONCE_TRACKER"  # Truncate file
    echo "All one-time commands reset"
  else
    sed -i "\|$1|d" "$ONCE_TRACKER"  # Remove specific command
    echo "Reset: $1"
  fi
}

dependencies_exist() {
  for dep in "$@"; do
    if ! command -v "$dep" >/dev/null 2>&1; then
      return 1
    fi
  done
  return 0
}

azaleas_register_singles() {
  # Process aliases
  for tuple in "${SINGLES_ALIASES[@]}"; do
    if [[ "$tuple" =~ "^:" ]]; then
      local dep=""
      local key="${tuple[(ws;:;)1]}"
      local value="${tuple[(ws;:;)2,-1]}"
    else
      local dep="${tuple[(ws;:;)1]}"
      local key="${tuple[(ws;:;)2]}"
      local value="${tuple[(ws;:;)3,-1]}"
    fi
    if [[ -n "$dep" ]] && dependencies_exist "$dep" || [[ -z "$dep" ]]; then
      alias "$key"="$value"
    fi
  done

  # Process recurring commands
  for tuple in "${SINGLES_COMMANDS[@]}"; do
    if [[ "$tuple" =~ "^:" ]]; then
      local dep=""
      local cmd="${tuple[(ws;:;)1,-1]}"
    else
      local dep="${tuple[(ws;:;)1]}"
      local cmd="${tuple[(ws;:;)2,-1]}"
    fi
    if [[ -n "$dep" ]] && dependencies_exist "$dep" || [[ -z "$dep" ]]; then
      eval "$cmd"
    fi
  done

  # Process one-time commands
  for tuple in "${SINGLES_ONCE_COMMANDS[@]}"; do
    if [[ "$tuple" =~ "^:" ]]; then
      local dep=""
      local cmd="${tuple[(ws;:;)1,-1]}"
    else
      local dep="${tuple[(ws;:;)1]}"
      local cmd="${tuple[(ws;:;)2,-1]}"
    fi
    if [[ -n "$dep" ]] && dependencies_exist "$dep" && ! grep -Fxq "$cmd" "$ONCE_TRACKER"; then
      eval "$cmd" && echo "$cmd" >> "$ONCE_TRACKER"
    elif [[ -z "$dep" ]] && ! grep -Fxq "$cmd" "$ONCE_TRACKER"; then
      eval "$cmd" && echo "$cmd" >> "$ONCE_TRACKER"
    fi
  done
}

azaleas_register() {
  local -a deps=()
  
  # Collect dependencies if they exist
  while [[ "$#" -gt 0 && "$1" != "--" ]]; do
    deps+=("$1")
    shift
  done
  
  # Shift past the "--" separator if dependencies were provided
  [[ "$1" == "--" ]] && shift

  # Only register aliases if dependencies exist OR if no dependencies were provided
  if [[ "${#deps[@]}" -eq 0 ]] || dependencies_exist "${deps[@]}"; then
    # Apply aliases
    for key in "${(@k)ALIAS_REGISTRY}"; do
      alias "$key"="${ALIAS_REGISTRY[$key]}"
    done

    # Run recurring commands
    for cmd in "${COMMAND_REGISTRY[@]}"; do
      eval "$cmd" || echo "Warning: Command '$cmd' failed." >&2
    done

    # Run one-time commands if not already executed
    for cmd in "${ONCE_COMMAND_REGISTRY[@]}"; do
      if ! grep -Fxq "$cmd" "$ONCE_TRACKER"; then
        eval "$cmd" && echo "$cmd" >> "$ONCE_TRACKER" || echo "Warning: One-time command '$cmd' failed" >&2
      fi
    done
  fi
}

if [[ -n $(echo "$CFG_DIR/"*.zsh(N)) ]]; then
  for file in "$CFG_DIR/"*.zsh(N); do
    source "$file"
  done
fi

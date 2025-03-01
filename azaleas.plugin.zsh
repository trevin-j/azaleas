AZALEAS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/azaleas"
ALIASES_DIR="$AZALEAS_DIR/aliases"

mkdir -p "$ALIASES_DIR"

typeset -A ALIAS_REGISTRY

dependencies_exist() {
  for dep in "$@"; do
    if ! command -v "$dep" >/dev/null 2>&1; then
      return 1
    fi
  done
  return 0
}

register_aliases() {
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
    for key in "${(@k)ALIAS_REGISTRY}"; do
      alias "$key"="${ALIAS_REGISTRY[$key]}"
    done
  fi
}


# Check if there are any .zsh files before sourcing
if [[ -n $(echo "$ALIASES_DIR/"*.zsh(N)) ]]; then
  for file in "$ALIASES_DIR/"*.zsh(N); do
    source "$file"
  done
fi

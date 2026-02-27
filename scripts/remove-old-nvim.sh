#!/usr/bin/env bash
set -euo pipefail

MIN_VERSION="0.11.2"
APPLY=0
PURGE_APT=0
REMOVE_LOCAL_DIRS=0

usage() {
  cat <<USAGE
Usage: $0 [--apply] [--purge-apt] [--remove-local-dirs] [--min-version VERSION]

Options:
  --apply              Actually delete/uninstall. Default is dry-run.
  --purge-apt          Remove apt neovim package if /usr/bin/nvim is older than min version.
  --remove-local-dirs  Remove old ~/.local/nvim* extracted directories.
  --min-version VER    Minimum version to keep (default: 0.11.2).
  -h, --help           Show this help.

Examples:
  $0
  $0 --apply
  $0 --apply --purge-apt --remove-local-dirs
USAGE
}

ver_lt() {
  local a="$1" b="$2"
  if command -v dpkg >/dev/null 2>&1; then
    dpkg --compare-versions "$a" lt "$b"
  else
    [[ "$(printf '%s\n%s\n' "$a" "$b" | sort -V | head -n1)" != "$b" ]]
  fi
}

run_cmd() {
  if [[ "$APPLY" -eq 1 ]]; then
    "$@"
  else
    echo "[dry-run] $*"
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply) APPLY=1 ;;
    --purge-apt) PURGE_APT=1 ;;
    --remove-local-dirs) REMOVE_LOCAL_DIRS=1 ;;
    --min-version)
      shift
      [[ $# -gt 0 ]] || { echo "Missing value for --min-version"; exit 1; }
      MIN_VERSION="$1"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
  shift
done

echo "Target minimum nvim version: ${MIN_VERSION}"
[[ "$APPLY" -eq 0 ]] && echo "Mode: dry-run (no changes will be made)"

NVIMS=()
while IFS= read -r p; do
  NVIMS+=("$p")
done < <(which -a nvim 2>/dev/null | awk '!seen[$0]++')
if [[ ${#NVIMS[@]} -eq 0 ]]; then
  echo "No nvim found in PATH."
  exit 0
fi

echo "Found nvim binaries:"
for b in "${NVIMS[@]}"; do
  echo "- $b"
done

for bin in "${NVIMS[@]}"; do
  if [[ ! -x "$bin" ]]; then
    continue
  fi

  ver="$($bin --version 2>/dev/null | head -n1 | awk '{print $2}' | sed 's/^v//' || true)"
  if [[ -z "$ver" ]]; then
    echo "skip $bin (cannot detect version)"
    continue
  fi

  if ver_lt "$ver" "$MIN_VERSION"; then
    echo "old: $bin (v$ver)"

    if [[ "$bin" == "$HOME/.local/bin/nvim" ]]; then
      run_cmd rm -f "$bin"
      continue
    fi

    if [[ "$bin" == /usr/bin/nvim ]]; then
      if [[ "$PURGE_APT" -eq 1 ]]; then
        run_cmd sudo apt-get remove -y neovim
      else
        echo "  keep /usr/bin/nvim for now (use --purge-apt to uninstall apt neovim)"
      fi
      continue
    fi

    if [[ "$bin" == "$HOME"/* ]]; then
      run_cmd rm -f "$bin"
    else
      echo "  skip system path: $bin (remove manually if needed)"
    fi
  else
    echo "keep: $bin (v$ver)"
  fi
done

if [[ "$REMOVE_LOCAL_DIRS" -eq 1 ]]; then
  echo "Scanning ~/.local/nvim* directories..."
  shopt -s nullglob
  for dir in "$HOME"/.local/nvim*; do
    [[ -d "$dir" ]] || continue
    if [[ -x "$dir/bin/nvim" ]]; then
      dver="$($dir/bin/nvim --version 2>/dev/null | head -n1 | awk '{print $2}' | sed 's/^v//' || true)"
      if [[ -n "$dver" ]] && ver_lt "$dver" "$MIN_VERSION"; then
        echo "old dir: $dir (v$dver)"
        run_cmd rm -rf "$dir"
      else
        echo "keep dir: $dir${dver:+ (v$dver)}"
      fi
    fi
  done
  shopt -u nullglob
fi

echo "Done."

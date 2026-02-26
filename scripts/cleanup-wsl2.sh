#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0
DEEP=0
PRUNE_BACKUPS_DAYS=""

usage() {
  cat <<USAGE
Usage: $0 [--dry-run] [--deep] [--prune-backups DAYS]

Options:
  --dry-run             Show what would be deleted, but do not delete.
  --deep                Also remove plugin/tool installs (lazy + mason).
  --prune-backups DAYS  Delete nvim backups older than DAYS from ~/.config.
  -h, --help            Show this help.

Examples:
  $0 --dry-run
  $0
  $0 --deep
  $0 --prune-backups 14
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --deep) DEEP=1 ;;
    --prune-backups)
      shift
      [[ $# -gt 0 ]] || { echo "Missing value for --prune-backups"; exit 1; }
      PRUNE_BACKUPS_DAYS="$1"
      [[ "$PRUNE_BACKUPS_DAYS" =~ ^[0-9]+$ ]] || { echo "DAYS must be an integer"; exit 1; }
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

if ! grep -qi microsoft /proc/version 2>/dev/null && [[ -z "${WSL_DISTRO_NAME:-}" ]]; then
  echo "Warning: This script is optimized for WSL2, but will continue."
fi

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

TARGETS=(
  "${CACHE_HOME}/nvim"
  "${STATE_HOME}/nvim/shada"
  "${STATE_HOME}/nvim/log"
  "${STATE_HOME}/nvim/swap"
  "${STATE_HOME}/nvim/undo"
  "/tmp/nvim"
)

if [[ "$DEEP" -eq 1 ]]; then
  TARGETS+=(
    "${DATA_HOME}/nvim/lazy"
    "${DATA_HOME}/nvim/mason"
    "${DATA_HOME}/nvim/site/pack"
  )
fi

remove_path() {
  local path="$1"
  if [[ ! -e "$path" ]]; then
    echo "skip  $path (not found)"
    return
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "would remove  $path"
  else
    rm -rf "$path"
    echo "removed      $path"
  fi
}

echo "Starting cleanup..."
[[ "$DRY_RUN" -eq 1 ]] && echo "Mode: dry-run"
[[ "$DEEP" -eq 1 ]] && echo "Mode: deep cleanup (includes lazy + mason)"

for path in "${TARGETS[@]}"; do
  remove_path "$path"
done

if [[ -n "$PRUNE_BACKUPS_DAYS" ]]; then
  echo "Pruning backups older than ${PRUNE_BACKUPS_DAYS} days in ${CONFIG_HOME}..."
  if [[ "$DRY_RUN" -eq 1 ]]; then
    find "$CONFIG_HOME" -maxdepth 1 -type d -name 'nvim.backup.*' -mtime "+${PRUNE_BACKUPS_DAYS}" -print
  else
    find "$CONFIG_HOME" -maxdepth 1 -type d -name 'nvim.backup.*' -mtime "+${PRUNE_BACKUPS_DAYS}" -exec rm -rf {} +
    echo "backup prune completed"
  fi
fi

cat <<MSG

Cleanup complete.

Recommended next steps:
1) Open Neovim: nvim
2) Run health checks: :checkhealth
3) If you used --deep, re-install tools: :Mason
MSG

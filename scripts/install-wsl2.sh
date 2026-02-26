#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -eq 0 ]]; then
  echo "Please run this script as your normal user (not root)."
  exit 1
fi

if ! grep -qi microsoft /proc/version 2>/dev/null && [[ -z "${WSL_DISTRO_NAME:-}" ]]; then
  echo "This installer is intended for WSL2."
  echo "Proceeding anyway..."
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
TARGET_DIR="${CONFIG_HOME}/nvim"
BACKUP_DIR="${CONFIG_HOME}/nvim.backup.$(date +%Y%m%d-%H%M%S)"

APT_PACKAGES=(
  git
  curl
  ca-certificates
  software-properties-common
  nodejs
  npm
  python3
  python3-pip
  python3-venv
  golang-go
  fzf
  ripgrep
  fd-find
  gcc
  g++
  make
  unzip
  xclip
)

echo "[1/5] Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y "${APT_PACKAGES[@]}"
sudo apt-get install -y neovim

if command -v nvim >/dev/null 2>&1; then
  NVIM_VERSION="$(nvim --version | head -n1 | awk '{print $2}' | sed 's/^v//')"
  if dpkg --compare-versions "$NVIM_VERSION" lt "0.9.0"; then
    echo "Detected nvim $NVIM_VERSION (< 0.9.0), upgrading via neovim PPA..."
    sudo add-apt-repository -y ppa:neovim-ppa/stable || true
    sudo apt-get update
    sudo apt-get install -y neovim
  fi
fi

echo "[2/5] Installing optional tools..."
# Optional tools used in this config; skip silently if unavailable on distro mirror
sudo apt-get install -y wslu lazygit bottom || true

if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  echo "[3/5] Creating local fd shim for fd-find..."
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi

if [[ -e "$TARGET_DIR" && ! -L "$TARGET_DIR" ]]; then
  echo "[4/5] Backing up existing config to: $BACKUP_DIR"
  mv "$TARGET_DIR" "$BACKUP_DIR"
fi

if [[ -L "$TARGET_DIR" ]]; then
  rm "$TARGET_DIR"
fi

mkdir -p "$CONFIG_HOME"
ln -s "$REPO_DIR" "$TARGET_DIR"

echo "[5/5] Bootstrapping plugins (first run may take a while)..."
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}" \
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}" \
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}" \
nvim --headless "+Lazy! sync" +qa || true

cat <<MSG

Done.

Next steps:
1) Ensure ~/.local/bin is in PATH (needed for fd shim on Ubuntu):
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc

2) Open Neovim and install Mason tools:
   nvim
   :Mason

3) Verify setup:
   :checkhealth

MSG

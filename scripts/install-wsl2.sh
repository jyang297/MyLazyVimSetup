#!/usr/bin/env bash
set -euo pipefail
MIN_NVIM_VERSION="0.11.2"
FORCE_UPDATE_NVIM=0

if [[ "${EUID}" -eq 0 ]]; then
  echo "Please run this script as your normal user (not root)."
  exit 1
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --update-nvim)
      FORCE_UPDATE_NVIM=1
      ;;
    -h|--help)
      cat <<USAGE
Usage: $0 [--update-nvim]

Options:
  --update-nvim    Force install/update Neovim from official stable release.
USAGE
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

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

install_nvim_from_release() {
  local arch tar_name tmp_dir pkg_url extracted

  arch="$(uname -m)"
  case "$arch" in
    x86_64) tar_name="nvim-linux-x86_64.tar.gz" ;;
    aarch64|arm64) tar_name="nvim-linux-arm64.tar.gz" ;;
    *)
      echo "Unsupported architecture for Neovim release fallback: $arch"
      return 1
      ;;
  esac

  pkg_url="https://github.com/neovim/neovim/releases/download/stable/${tar_name}"
  tmp_dir="$(mktemp -d)"

  echo "Downloading Neovim stable release (${tar_name})..."
  if ! curl -fL "$pkg_url" -o "${tmp_dir}/nvim.tar.gz"; then
    if [[ "$arch" == "x86_64" ]]; then
      # Older release naming fallback.
      pkg_url="https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz"
      curl -fL "$pkg_url" -o "${tmp_dir}/nvim.tar.gz"
    else
      return 1
    fi
  fi

  tar -xzf "${tmp_dir}/nvim.tar.gz" -C "$tmp_dir"
  extracted="$(find "$tmp_dir" -maxdepth 1 -type d -name 'nvim-linux*' | head -n1)"
  if [[ -z "$extracted" ]]; then
    echo "Failed to unpack Neovim release archive."
    return 1
  fi

  mkdir -p "$HOME/.local/bin"
  rm -rf "$HOME/.local/nvim"
  mv "$extracted" "$HOME/.local/nvim"
  ln -sf "$HOME/.local/nvim/bin/nvim" "$HOME/.local/bin/nvim"
}

nvim_bin() {
  if [[ -x "$HOME/.local/bin/nvim" ]]; then
    echo "$HOME/.local/bin/nvim"
    return
  fi
  command -v nvim 2>/dev/null || true
}

ensure_nvim_version() {
  local bin version
  bin="$(nvim_bin)"
  if [[ -z "$bin" ]]; then
    return 1
  fi
  version="$("$bin" --version | head -n1 | awk '{print $2}' | sed 's/^v//')"
  dpkg --compare-versions "$version" ge "$MIN_NVIM_VERSION"
}

echo "[1/5] Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y "${APT_PACKAGES[@]}"
sudo apt-get install -y neovim

if [[ "$FORCE_UPDATE_NVIM" -eq 0 ]]; then
  if ! ensure_nvim_version; then
    NVIM_BIN="$(nvim_bin)"
    NVIM_VERSION="$([[ -n "$NVIM_BIN" ]] && "$NVIM_BIN" --version | head -n1 | awk '{print $2}' | sed 's/^v//' || echo 'not-found')"
    echo "Detected nvim ${NVIM_VERSION} (< ${MIN_NVIM_VERSION}), trying neovim PPA..."
    if sudo add-apt-repository -y ppa:neovim-ppa/stable; then
      sudo apt-get update
      sudo apt-get install -y neovim
    fi
  fi
fi

if ! ensure_nvim_version; then
  echo "Installing Neovim stable release to ~/.local..."
  install_nvim_from_release
fi

if ! ensure_nvim_version; then
  echo "Error: failed to install Neovim >= ${MIN_NVIM_VERSION}."
  NVIM_BIN="$(nvim_bin)"
  echo "Current: $([[ -n "$NVIM_BIN" ]] && "$NVIM_BIN" --version | head -n1 || echo 'nvim not found')"
  exit 1
fi

echo "[2/5] Installing optional tools..."
# Optional tools used in this config; skip silently if unavailable on distro mirror
sudo apt-get install -y wslu lazygit bottom || true

if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  echo "[3/5] Creating local fd shim for fd-find..."
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi

export PATH="$HOME/.local/bin:$PATH"

echo "[4/5] Wiring config directory..."
mkdir -p "$CONFIG_HOME"

# If script is run from ~/.config/nvim itself, do not move or relink it.
if [[ "$REPO_DIR" == "$TARGET_DIR" ]]; then
  echo "Using in-place repo at $TARGET_DIR"
else
  if [[ -e "$TARGET_DIR" && ! -L "$TARGET_DIR" ]]; then
    echo "Backing up existing config to: $BACKUP_DIR"
    mv "$TARGET_DIR" "$BACKUP_DIR"
  fi

  if [[ -L "$TARGET_DIR" ]]; then
    CURRENT_LINK="$(readlink "$TARGET_DIR" || true)"
    if [[ "$CURRENT_LINK" != "$REPO_DIR" ]]; then
      rm "$TARGET_DIR"
      ln -s "$REPO_DIR" "$TARGET_DIR"
    fi
  elif [[ ! -e "$TARGET_DIR" ]]; then
    ln -s "$REPO_DIR" "$TARGET_DIR"
  fi
fi

if [[ -L "$TARGET_DIR" && ! -e "$TARGET_DIR" ]]; then
  echo "Error: $TARGET_DIR is a broken symlink."
  echo "Please remove it and rerun installer."
  exit 1
fi

echo "[5/5] Bootstrapping plugins (first run may take a while)..."
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}" \
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}" \
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}" \
"$(nvim_bin)" --headless "+Lazy! sync" +qa || true

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

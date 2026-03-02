#!/usr/bin/env bash
set -euo pipefail

MIN_NVIM_VERSION="0.11.2"
AUTO_INSTALL=1
CHECK_ONLY=0
SKIP_BOOTSTRAP=0
PRINT_FALLBACKS=0
LINK_MODE="junction"

usage() {
  cat <<USAGE
Usage: $0 [--check-only] [--skip-bootstrap] [--no-auto-install] [--print-fallbacks]

Options:
  --check-only       Run environment detection + dependency checks only.
  --skip-bootstrap   Skip headless plugin bootstrap (:Lazy! sync).
  --no-auto-install  Do not auto-install missing dependencies.
  --install-missing  Legacy alias (auto-install is already default).
  --print-fallbacks  Print corporate-restricted fallback guide and exit.
  -h, --help         Show this help.

Typical flow:
  1) One-command setup (recommended):
     $0
  2) Detect only:
     $0 --check-only
  3) Show corporate fallbacks:
     $0 --print-fallbacks
USAGE
}

is_git_bash() {
  [[ -n "${MSYSTEM:-}" ]] || uname -s | grep -qiE "mingw|msys"
}

version_ge() {
  local have="$1"
  local need="$2"
  [[ "$(printf '%s\n%s\n' "$need" "$have" | sort -V | head -n1)" == "$need" ]]
}

nvim_version() {
  if ! command -v nvim >/dev/null 2>&1; then
    return 1
  fi
  nvim --version | head -n1 | awk '{print $2}' | sed 's/^v//'
}

python_bin() {
  command -v python3 2>/dev/null || command -v python 2>/dev/null || true
}

has_winget() {
  command -v winget.exe >/dev/null 2>&1
}

has_choco() {
  command -v choco.exe >/dev/null 2>&1 || command -v choco >/dev/null 2>&1
}

has_scoop() {
  command -v scoop >/dev/null 2>&1 || command -v scoop.cmd >/dev/null 2>&1
}

winget_id_for() {
  case "$1" in
    git) echo "Git.Git" ;;
    nvim) echo "Neovim.Neovim" ;;
    node) echo "OpenJS.NodeJS.LTS" ;;
    python) echo "Python.Python.3.12" ;;
    go) echo "GoLang.Go" ;;
    rg) echo "BurntSushi.ripgrep.MSVC" ;;
    fd) echo "sharkdp.fd" ;;
    fzf) echo "junegunn.fzf" ;;
    *) echo "" ;;
  esac
}

choco_pkg_for() {
  case "$1" in
    git) echo "git" ;;
    nvim) echo "neovim" ;;
    node) echo "nodejs-lts" ;;
    python) echo "python" ;;
    go) echo "golang" ;;
    rg) echo "ripgrep" ;;
    fd) echo "fd" ;;
    fzf) echo "fzf" ;;
    *) echo "" ;;
  esac
}

scoop_pkg_for() {
  case "$1" in
    git) echo "git" ;;
    nvim) echo "neovim" ;;
    node) echo "nodejs-lts" ;;
    python) echo "python" ;;
    go) echo "go" ;;
    rg) echo "ripgrep" ;;
    fd) echo "fd" ;;
    fzf) echo "fzf" ;;
    *) echo "" ;;
  esac
}

dep_label() {
  case "$1" in
    git) echo "git" ;;
    nvim) echo "nvim >= ${MIN_NVIM_VERSION}" ;;
    node) echo "node + npm" ;;
    python) echo "python3/python" ;;
    go) echo "go" ;;
    rg) echo "ripgrep (rg)" ;;
    fd) echo "fd" ;;
    fzf) echo "fzf" ;;
    *) echo "$1" ;;
  esac
}

print_dep_status() {
  local label="$1"
  local status="$2"
  printf "  %-20s %s\n" "$label" "$status"
}

MISSING_DEPS=()

check_dependencies() {
  MISSING_DEPS=()

  if command -v git >/dev/null 2>&1; then
    print_dep_status "$(dep_label git)" "OK"
  else
    print_dep_status "$(dep_label git)" "MISSING"
    MISSING_DEPS+=("git")
  fi

  local nv=""
  if nv="$(nvim_version 2>/dev/null)"; then
    if version_ge "$nv" "$MIN_NVIM_VERSION"; then
      print_dep_status "$(dep_label nvim)" "OK (v${nv})"
    else
      print_dep_status "$(dep_label nvim)" "MISSING (found v${nv})"
      MISSING_DEPS+=("nvim")
    fi
  else
    print_dep_status "$(dep_label nvim)" "MISSING"
    MISSING_DEPS+=("nvim")
  fi

  if command -v node >/dev/null 2>&1 && command -v npm >/dev/null 2>&1; then
    print_dep_status "$(dep_label node)" "OK"
  else
    print_dep_status "$(dep_label node)" "MISSING"
    MISSING_DEPS+=("node")
  fi

  local py=""
  py="$(python_bin)"
  if [[ -n "$py" ]]; then
    print_dep_status "$(dep_label python)" "OK ($(basename "$py"))"
  else
    print_dep_status "$(dep_label python)" "MISSING"
    MISSING_DEPS+=("python")
  fi

  if command -v go >/dev/null 2>&1; then
    print_dep_status "$(dep_label go)" "OK"
  else
    print_dep_status "$(dep_label go)" "MISSING"
    MISSING_DEPS+=("go")
  fi

  if command -v rg >/dev/null 2>&1; then
    print_dep_status "$(dep_label rg)" "OK"
  else
    print_dep_status "$(dep_label rg)" "MISSING"
    MISSING_DEPS+=("rg")
  fi

  if command -v fd >/dev/null 2>&1; then
    print_dep_status "$(dep_label fd)" "OK"
  else
    print_dep_status "$(dep_label fd)" "MISSING"
    MISSING_DEPS+=("fd")
  fi

  if command -v fzf >/dev/null 2>&1; then
    print_dep_status "$(dep_label fzf)" "OK"
  else
    print_dep_status "$(dep_label fzf)" "MISSING"
    MISSING_DEPS+=("fzf")
  fi
}

install_missing_with_winget() {
  if [[ ${#MISSING_DEPS[@]} -eq 0 ]]; then
    return
  fi

  if ! has_winget; then
    echo "winget.exe not found. Skipping auto-install."
    return
  fi

  echo
  echo "Installing missing dependencies with winget..."
  for dep in "${MISSING_DEPS[@]}"; do
    local winget_id
    winget_id="$(winget_id_for "$dep")"
    if [[ -z "$winget_id" ]]; then
      echo "  - Skip ${dep}: no winget mapping configured."
      continue
    fi

    echo "  - $(dep_label "$dep") -> ${winget_id}"
    winget.exe install --id "$winget_id" -e --silent \
      --accept-source-agreements --accept-package-agreements || true
  done
}

print_dep_install_options() {
  local dep="$1"
  local printed=0

  local winget_id
  winget_id="$(winget_id_for "$dep")"
  if [[ -n "$winget_id" ]] && has_winget; then
    echo "  winget install --id ${winget_id} -e"
    printed=1
  fi

  local choco_pkg
  choco_pkg="$(choco_pkg_for "$dep")"
  if [[ -n "$choco_pkg" ]] && has_choco; then
    echo "  choco install ${choco_pkg} -y"
    printed=1
  fi

  local scoop_pkg
  scoop_pkg="$(scoop_pkg_for "$dep")"
  if [[ -n "$scoop_pkg" ]] && has_scoop; then
    echo "  scoop install ${scoop_pkg}"
    printed=1
  fi

  if [[ "$printed" -eq 0 ]]; then
    echo "  Install $(dep_label "$dep") manually and ensure it is in PATH."
  fi
}

print_manual_install_hints() {
  echo
  echo "Missing dependencies detected. Install them first:"
  for dep in "${MISSING_DEPS[@]}"; do
    echo
    echo "- $(dep_label "$dep")"
    print_dep_install_options "$dep"
  done
}

print_corporate_fallbacks() {
  local repo_dir="$1"
  local target_dir="$2"

  cat <<MSG

Corporate-restricted fallback guide:
1) If winget is blocked:
   - Use the available alternatives printed above (choco/scoop/manual installer).
   - If all package managers are blocked, ask IT to preinstall:
     Neovim, Node.js LTS, Python 3, Go, ripgrep, fd, fzf.

2) If mklink/junction creation is blocked:
   - Script falls back to copying config into:
     ${target_dir}
   - In copy mode, sync updates manually:
     rsync -a --delete --exclude '.git/' "${repo_dir}/" "${target_dir}/"
   - If rsync is unavailable:
     cmd.exe /c robocopy "$(cygpath -w "${repo_dir}")" "$(cygpath -w "${target_dir}")" /MIR /XD .git

3) If plugin bootstrap fails due proxy/network policy:
   - Set proxy for Git and shell:
     git config --global http.proxy http://proxy.company.com:8080
     git config --global https.proxy http://proxy.company.com:8080
     export HTTPS_PROXY=http://proxy.company.com:8080
     export HTTP_PROXY=http://proxy.company.com:8080
   - Then rerun bootstrap:
     nvim --headless "+Lazy! sync" +qa
MSG
}

print_bootstrap_failure_hints() {
  local repo_dir="$1"
  local target_dir="$2"

  echo
  echo "Plugin bootstrap failed (often network/proxy related on work machines)."
  print_corporate_fallbacks "$repo_dir" "$target_dir"
  echo
  echo "You can continue now and bootstrap later:"
  echo "  ./scripts/install-git-bash.sh --skip-bootstrap"
}

resolve_localappdata_unix() {
  local raw="${LOCALAPPDATA:-}"
  if [[ -z "$raw" ]]; then
    raw="$(cmd.exe /c "echo %LOCALAPPDATA%" 2>/dev/null | tr -d '\r')"
  fi
  if [[ -z "$raw" ]]; then
    echo "Failed to resolve LOCALAPPDATA. Is this Git Bash on Windows?" >&2
    exit 1
  fi
  if [[ "$raw" =~ ^[A-Za-z]:\\ ]]; then
    cygpath -u "$raw"
  else
    echo "$raw"
  fi
}

link_config() {
  local target_dir="$1"
  local backup_dir="$2"
  local repo_dir="$3"

  local repo_real target_real
  repo_real="$(cd "$repo_dir" && pwd -P)"

  mkdir -p "$(dirname "$target_dir")"

  if [[ -e "$target_dir" || -L "$target_dir" ]]; then
    if target_real="$(cd "$target_dir" 2>/dev/null && pwd -P)"; then
      if [[ "$target_real" == "$repo_real" ]]; then
        echo "Config already points to this repo: ${target_dir}"
        LINK_MODE="already-linked"
        return
      fi
    fi

    echo "Backing up existing config to: ${backup_dir}"
    mv "$target_dir" "$backup_dir"
  fi

  local win_target win_repo
  win_target="$(cygpath -w "$target_dir")"
  win_repo="$(cygpath -w "$repo_dir")"
  if cmd.exe /c mklink /J "$win_target" "$win_repo" >/dev/null 2>&1; then
    LINK_MODE="junction"
    echo "Linked ${target_dir} -> ${repo_dir}"
  else
    LINK_MODE="copy"
    echo "Warning: failed to create junction. Falling back to copy."
    cp -R "$repo_dir" "$target_dir"
    echo "Copied config to ${target_dir}"
  fi
}

find_nvim_bin() {
  if command -v nvim >/dev/null 2>&1; then
    command -v nvim
    return
  fi

  local where_out
  where_out="$(where.exe nvim 2>/dev/null | tr -d '\r' | head -n1 || true)"
  if [[ -n "$where_out" ]]; then
    cygpath -u "$where_out"
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --install-missing) AUTO_INSTALL=1 ;;
    --no-auto-install) AUTO_INSTALL=0 ;;
    --check-only) CHECK_ONLY=1 ;;
    --skip-bootstrap) SKIP_BOOTSTRAP=1 ;;
    --print-fallbacks) PRINT_FALLBACKS=1 ;;
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

if ! is_git_bash; then
  echo "This installer is for Git Bash on Windows (MSYS2/MINGW)."
  echo "Please run it inside Git Bash."
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
LOCALAPPDATA_UNIX="$(resolve_localappdata_unix)"
TARGET_DIR="${LOCALAPPDATA_UNIX}/nvim"
BACKUP_DIR="${TARGET_DIR}.backup.$(date +%Y%m%d-%H%M%S)"

echo "[1/3] Environment detection"
echo "  Repo dir: ${REPO_DIR}"
echo "  Neovim config target: ${TARGET_DIR}"

if [[ "$PRINT_FALLBACKS" -eq 1 ]]; then
  print_corporate_fallbacks "$REPO_DIR" "$TARGET_DIR"
  exit 0
fi

echo
echo "[2/3] Dependency check"
check_dependencies

if [[ ${#MISSING_DEPS[@]} -gt 0 && "$AUTO_INSTALL" -eq 1 ]]; then
  echo
  echo "Auto-installing missing dependencies (if supported)..."
  install_missing_with_winget
  hash -r || true
  echo
  echo "Re-checking dependencies..."
  check_dependencies
fi

if [[ ${#MISSING_DEPS[@]} -gt 0 ]]; then
  print_manual_install_hints
  print_corporate_fallbacks "$REPO_DIR" "$TARGET_DIR"
  exit 1
fi

if [[ "$CHECK_ONLY" -eq 1 ]]; then
  echo
  echo "Environment looks good."
  exit 0
fi

echo
echo "[3/3] Wiring config and bootstrapping plugins"
link_config "$TARGET_DIR" "$BACKUP_DIR" "$REPO_DIR"

if [[ "$SKIP_BOOTSTRAP" -eq 0 ]]; then
  NVIM_BIN="$(find_nvim_bin)"
  if [[ -n "$NVIM_BIN" ]]; then
    if ! "$NVIM_BIN" --headless "+Lazy! sync" +qa; then
      print_bootstrap_failure_hints "$REPO_DIR" "$TARGET_DIR"
    fi
  else
    echo "Warning: nvim not found in PATH. Open a new Git Bash session and rerun."
  fi
fi

cat <<MSG

Done.

Next steps:
1) Open Neovim: nvim
2) Install/verify language tools: :Mason
3) Verify full health: :checkhealth

MSG

if [[ "$LINK_MODE" == "copy" ]]; then
  cat <<MSG
Config was copied (not linked). To sync future updates:
  rsync -a --delete --exclude '.git/' "${REPO_DIR}/" "${TARGET_DIR}/"
If rsync is unavailable:
  cmd.exe /c robocopy "$(cygpath -w "${REPO_DIR}")" "$(cygpath -w "${TARGET_DIR}")" /MIR /XD .git

MSG
fi

-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local env = require("config.env")
local is_wsl = env.is_wsl
local is_mac = env.is_mac
local is_windows = env.is_windows

-- ── Clipboard ────────────────────────────────────────────────────────────────
if is_wsl then
  -- WSL2: bridge to Windows clipboard via clip.exe / PowerShell
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::In.ReadToEnd()',
      ["*"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::In.ReadToEnd()',
    },
    cache_enabled = 0,
  }
end
-- macOS clipboard works out of the box via LazyVim defaults (pbcopy/pbpaste)

-- ── Shell ─────────────────────────────────────────────────────────────────────
-- Ensure we always use the login shell so PATH includes brew / go / python bins
if is_mac then
  vim.o.shell = "/bin/zsh"
elseif is_wsl then
  vim.o.shell = "/bin/bash"
end

-- ── Open URLs / files with system default apps ───────────────────────────────
if is_wsl then
  -- Used by gx (open URL under cursor) and markdown-preview browser launch
  vim.g.netrw_browsex_viewer = "wslview"
elseif is_windows then
  vim.g.netrw_browsex_viewer = "explorer.exe"
end

-- ── Python host: keep Neovim on the local platform interpreter ───────────────
if is_wsl or is_windows then
  local python_host = env.python_executable()
  if python_host ~= "" then
    vim.g.python3_host_prog = python_host
  end
end

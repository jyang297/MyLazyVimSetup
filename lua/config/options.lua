-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local is_wsl = vim.fn.has("wsl") == 1
local is_mac = vim.fn.has("mac") == 1

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

-- ── WSL2: open URLs / files with Windows default apps ────────────────────────
if is_wsl then
  -- Used by gx (open URL under cursor) and markdown-preview browser launch
  vim.g.netrw_browsex_viewer = "wslview"
end

-- ── Python: prefer the WSL / local python3, not a Windows one ────────────────
if is_wsl then
  -- Explicitly point to the Linux python3 so DAP uses the right one
  vim.g.python3_host_prog = vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or "/usr/bin/python3"
end

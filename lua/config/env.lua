local M = {}

M.is_wsl = vim.fn.has("wsl") == 1
M.is_mac = vim.fn.has("mac") == 1
M.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
M.is_git_bash = M.is_windows and (vim.env.MSYSTEM or "") ~= ""

function M.first_executable(names)
  for _, name in ipairs(names) do
    local exe = vim.fn.exepath(name)
    if exe ~= "" then
      return exe
    end
  end
  return ""
end

function M.python_executable()
  if M.is_windows then
    return M.first_executable({ "python", "python3" })
  end
  return M.first_executable({ "python3", "python" })
end

return M

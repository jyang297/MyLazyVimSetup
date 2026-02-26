return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local auto_float_enabled = false

      local function show_line_diagnostic()
        vim.diagnostic.open_float(nil, {
          scope = "line",
          focusable = false,
          border = "rounded",
          source = "if_many",
          -- Keep it visible when entering/typing in insert mode.
          close_events = { "CursorMoved", "BufHidden", "WinLeave" },
        })
      end

      local function jump_diagnostic(next_jump, severity)
        local jump_opts = {
          severity = severity,
          float = {
            border = "rounded",
            source = "if_many",
          },
        }

        if next_jump then
          vim.diagnostic.goto_next(jump_opts)
        else
          vim.diagnostic.goto_prev(jump_opts)
        end
        vim.cmd("normal! zz")
      end

      local function is_virtual_text_enabled()
        local cfg = vim.diagnostic.config()
        local vt = cfg.virtual_text
        return vt == true or type(vt) == "table"
      end

      local function toggle_virtual_text()
        local enabled = is_virtual_text_enabled()
        vim.diagnostic.config({ virtual_text = not enabled })
        vim.notify("Diagnostic virtual text " .. (enabled and "disabled" or "enabled"))
      end

      local diag_group = vim.api.nvim_create_augroup("UserDiagnosticFloat", { clear = true })

      local function set_auto_float(enabled)
        auto_float_enabled = enabled
        vim.api.nvim_clear_autocmds({ group = diag_group })
        if enabled then
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = diag_group,
            callback = show_line_diagnostic,
          })
        end
        vim.notify("Diagnostic hover " .. (enabled and "enabled" or "disabled"))
      end

      vim.keymap.set("n", "gl", show_line_diagnostic, { desc = "Show diagnostic float" })
      vim.keymap.set("n", "]d", function()
        jump_diagnostic(true)
      end, { desc = "Next diagnostic" })
      vim.keymap.set("n", "[d", function()
        jump_diagnostic(false)
      end, { desc = "Previous diagnostic" })
      vim.keymap.set("n", "]e", function()
        jump_diagnostic(true, vim.diagnostic.severity.ERROR)
      end, { desc = "Next error" })
      vim.keymap.set("n", "[e", function()
        jump_diagnostic(false, vim.diagnostic.severity.ERROR)
      end, { desc = "Previous error" })
      vim.keymap.set("n", "<leader>dv", toggle_virtual_text, { desc = "Toggle diagnostic virtual text" })
      vim.keymap.set("n", "<leader>dh", function()
        set_auto_float(not auto_float_enabled)
      end, { desc = "Toggle diagnostic hover" })
      vim.keymap.set({ "n", "v" }, "<leader>qf", vim.lsp.buf.code_action, { desc = "Quick fix (code action)" })

      opts = opts or {}
      opts.diagnostics = opts.diagnostics or {}
      opts.diagnostics.float = vim.tbl_deep_extend("force", opts.diagnostics.float or {}, {
        border = "rounded",
        source = "if_many",
      })

      return opts
    end,
  },
}

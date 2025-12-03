return {
  -- Python LSP, formatting, linting
  { import = "lazyvim.plugins.extras.lang.python" },

  -- Debugging (DAP + Debugpy)
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      -- Path to your python venv or system python
      -- 自动检测系统 python
      local path = vim.fn.exepath("python3")
      require("dap-python").setup(path)
    end,
  },

  -- Ruff (super fast linter)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff_lsp = {},
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
      },
    },
  },

  -- Black formatter (via conform.nvim)
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft.python = { "black", "isort" }
    end,
  },
}

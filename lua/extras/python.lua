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

  -- Pyright / basedpyright with strict type checking
  -- LazyVim older versions use `pyright`, newer versions use `basedpyright`.
  -- Both server names are listed here; only the one that is installed will activate.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff = {},
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "strict",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                diagnosticSeverityOverrides = {
                  reportUnusedImport = "warning",
                  reportUnusedVariable = "warning",
                },
              },
            },
          },
        },
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "strict",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                diagnosticSeverityOverrides = {
                  reportUnusedImport = "warning",
                  reportUnusedVariable = "warning",
                },
              },
            },
          },
        },
      },
    },
  },

  -- mypy linting for strict static type analysis
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.python = { "mypy" }
    end,
  },

  -- Black formatter + isort (via conform.nvim)
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.python = { "black", "isort" }
    end,
  },

  -- Ensure Mason installs mypy
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "mypy" })
    end,
  },
}

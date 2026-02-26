return {

  { import = "lazyvim.plugins.extras.lang.go" },
  -- Go treesitter highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "go", "gomod", "gosum", "gowork" })
      end
    end,
  },

  -- Mason: gopls is handled by LazyVim's go extra; add golangci-lint and delve
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "golangci-lint",
        "delve",
        "goimports",
        "gofumpt",
      })
    end,
  },

  -- gopls setup (strict + useful)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              -- strictness / correctness
              analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              staticcheck = true,

              -- good UX
              gofumpt = true,
              completeUnimported = true,
              usePlaceholders = true,
              semanticTokens = true,

              -- in case you have big repos
              directoryFilters = { "-.git", "-node_modules" },
            },
          },
        },
      },
    },
  },

  -- Format + imports on save (uses goimports through conform)
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      -- Keep Go idiomatic: organize imports first, then run gofumpt.
      opts.formatters_by_ft.go = { "goimports", "gofumpt", "gofmt" }
      opts.format_on_save = opts.format_on_save or { timeout_ms = 3000, lsp_fallback = true }
      return opts
    end,
  },

  -- Lint on save (golangci-lint)
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        go = { "golangcilint" },
      },
    },
  },

  -- Go-specific helper commands (tests, tags, etc.)
  {
    "ray-x/go.nvim",
    dependencies = { "ray-x/guihua.lua" },
    ft = { "go", "gomod" },
    opts = {
      gofmt = "gofmt",
      goimports = "goimports",
      lsp_cfg = false, -- IMPORTANT: let lspconfig handle gopls
      lsp_inlay_hints = {
        enable = true,
      },
    },
  },

  -- Go buffers: tabs-based indentation like gofmt/goimports expect.
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local group = vim.api.nvim_create_augroup("UserGoIndent", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "go",
        callback = function()
          vim.opt_local.expandtab = false
          vim.opt_local.tabstop = 4
          vim.opt_local.softtabstop = 4
          vim.opt_local.shiftwidth = 4
        end,
      })
    end,
  },
}

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

  -- Ensure gopls and other tools are installed via Mason (optional but convenient)
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "gopls",
        "golangci-lint",
        "delve",
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
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofmt" },
      },
      format_on_save = { timeout_ms = 3000, lsp_fallback = true },
    },
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
}

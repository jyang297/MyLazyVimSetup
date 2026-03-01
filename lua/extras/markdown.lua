return {
  -- LazyVim markdown extra (includes render-markdown.nvim)
  { import = "lazyvim.plugins.extras.lang.markdown" },

  -- render-markdown.nvim - render markdown inline in the buffer
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      -- Show rendered markdown by default when opening .md files
      enabled = true,

      -- Heading styles (different color per level)
      heading = {
        enabled = true,
        sign = false,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },

      -- Code blocks - show language and styled background
      code = {
        enabled = true,
        sign = false,
        style = "full",  -- show language label + background
        border = "thin",
      },

      -- Bullet list icons
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
      },

      -- Checkbox rendering (for task lists)
      checkbox = {
        enabled = true,
        unchecked = { icon = "󰄱 " },
        checked = { icon = "󰱒 " },
      },

      -- Table rendering
      pipe_table = {
        enabled = true,
        style = "full",
      },

      -- Horizontal rule
      dash = {
        enabled = true,
        icon = "─",
      },

      -- Callout/quote blocks
      quote = {
        enabled = true,
        icon = "▋",
      },

      -- Link rendering
      link = {
        enabled = true,
        image = "󰥶 ",
        hyperlink = "󰌹 ",
      },
    },
  },

  -- Browser preview (optional, use when you need to share/check final look)
  -- On WSL2: set BROWSER to a Windows browser, e.g. export BROWSER="wslview" or "explorer.exe"
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npm install",
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown Preview (Browser)" },
    },
  },

  -- Force markdownlint-cli2 to use local markdownlint config.
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters = opts.linters or {}
      opts.linters["markdownlint-cli2"] = vim.tbl_deep_extend("force", opts.linters["markdownlint-cli2"] or {}, {
        args = { "--config", vim.fn.expand("~/.config/nvim/.markdownlint.json"), "-" },
      })
    end,
  },
}

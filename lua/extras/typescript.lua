return {
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- Add eslint support
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    dependencies = { "nvimtools/none-ls-extras.nvim" },
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      vim.list_extend(opts.sources, {
        require("none-ls.diagnostics.eslint_d"),
        require("none-ls.code_actions.eslint_d"),
      })
    end,
  },
}

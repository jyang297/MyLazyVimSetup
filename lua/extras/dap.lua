return {
  -- Require nvim-nio (needed by dap-ui)
  { "nvim-neotest/nvim-nio" },

  -- Core DAP support (includes UI, virtual text, and mason in newer LazyVim)
  { import = "lazyvim.plugins.extras.dap.core" },

  -- Go debugger
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    config = function()
      require("dap-go").setup()
    end,
  },
}

return {
  -- Require nvim-nio (needed by dap-ui)
  { "nvim-neotest/nvim-nio" },

  -- Core DAP support
  { import = "lazyvim.plugins.extras.dap.core" },

  -- UI panels
  { import = "lazyvim.plugins.extras.dap.ui" },

  -- Inline variable text
  { import = "lazyvim.plugins.extras.dap.virtual_text" },

  -- Mason dap installer
  { import = "lazyvim.plugins.extras.dap.mason" },

  -- Go debugger
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    config = function()
      require("dap-go").setup()
    end,
  },
}

return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      -- Show diagnostics in a floating window
      vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostic float" })
    end,
  },
}

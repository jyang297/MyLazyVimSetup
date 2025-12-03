return {

  -- Better diagnostics UI (VSCode-style)
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
    },
  },

  -- Show diagnostics inline + floating
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = true, -- inline error messages
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded" },
      },
    },
  },

  -- Improved code actions popup
  {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",
    opts = { autocmd = { enabled = true } },
  },
}

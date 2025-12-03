return {
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = function()
      require("git-conflict").setup({
        default_mappings = true, -- 启用内置快捷键
        highlights = { -- 颜色可调
          incoming = "DiffText",
          current = "DiffAdd",
        },
      })
    end,
  },
}

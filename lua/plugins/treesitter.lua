-- WSL2 / older glibc fix:
-- The pre-built tree-sitter CLI binary requires glibc 2.39 (Ubuntu 24.04+).
-- On Ubuntu 22.04 / 20.04, force compilation via gcc instead.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      require("nvim-treesitter.install").compilers = { "gcc" }
      return opts
    end,
  },
}

local function go_version()
  local output = vim.fn.system({ "go", "version" })
  local major, minor = output:match("go version go(%d+)%.(%d+)")
  return tonumber(major), tonumber(minor)
end

local function has_recent_go()
  local major, minor = go_version()
  return major ~= nil and (major > 1 or (major == 1 and minor >= 26))
end

local go_tools_requiring_recent_go = {
  delve = true,
  gofumpt = true,
  goimports = true,
  gopls = true,
}

local function filter_tools(tools)
  tools = tools or {}
  if has_recent_go() then
    return tools
  end

  return vim.tbl_filter(function(tool)
    return not go_tools_requiring_recent_go[tool]
  end, tools)
end

return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = filter_tools(opts.ensure_installed)
    end,
    config = function(_, opts)
      require("mason").setup(opts)

      local registry = require("mason-registry")
      registry:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      registry.refresh(function()
        for _, tool in ipairs(filter_tools(opts.ensure_installed)) do
          local ok, package = pcall(registry.get_package, tool)
          if ok and not package:is_installed() and not package:is_installing() then
            package:install()
          end
        end
      end)
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = filter_tools(opts.ensure_installed)
    end,
  },
}

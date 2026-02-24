return {
  -- Enhanced DAP keybindings for log points and conditional breakpoints
  {
    "mfussenegger/nvim-dap",
    keys = {
      -- Log point - log a message without stopping execution
      {
        "<leader>dl",
        function()
          local log_message = vim.fn.input("Log message (use {variable} for values): ")
          if log_message ~= "" then
            require("dap").set_breakpoint(nil, nil, log_message)
            vim.notify("Log point set: " .. log_message, vim.log.levels.INFO)
          end
        end,
        desc = "Set Log Point",
      },

      -- Conditional breakpoint - only break when condition is true
      {
        "<leader>dC",
        function()
          local condition = vim.fn.input("Breakpoint condition: ")
          if condition ~= "" then
            require("dap").set_breakpoint(condition)
            vim.notify("Conditional breakpoint set: " .. condition, vim.log.levels.INFO)
          end
        end,
        desc = "Set Conditional Breakpoint",
      },

      -- Clear all breakpoints in current buffer
      {
        "<leader>dD",
        function()
          require("dap").clear_breakpoints()
          vim.notify("All breakpoints cleared", vim.log.levels.INFO)
        end,
        desc = "Clear All Breakpoints",
      },

      -- List all breakpoints
      {
        "<leader>dL",
        function()
          require("dap").list_breakpoints()
        end,
        desc = "List All Breakpoints",
      },
    },
  },
}

-- VS Code-style F-key debugging, on top of LazyVim's <leader>d mappings
return {
  "mfussenegger/nvim-dap",
  keys = {
    { "<F5>", function() require("dap").continue() end, desc = "Debug: Continue" },
    { "<S-F5>", function() require("dap").terminate() end, desc = "Debug: Terminate" },
    { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
    { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
    { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
    { "<S-F11>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
  },
}

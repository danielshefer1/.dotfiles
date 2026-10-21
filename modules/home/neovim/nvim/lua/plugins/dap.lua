-- The clangd extra registers codelldb with host "localhost", which resolves to ::1 here,
-- but codelldb only listens on 127.0.0.1 -> ECONNREFUSED. Runs after the extra's opts.
return {
  "mfussenegger/nvim-dap",
  opts = function()
    local codelldb = require("dap").adapters.codelldb
    if codelldb then
      codelldb.host = "127.0.0.1"
    end
  end,
}

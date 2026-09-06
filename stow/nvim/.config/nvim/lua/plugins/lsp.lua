return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    config = function()
      local caps
      local ok, blink = pcall(require, "blink.cmp")
      if ok and blink.get_lsp_capabilities then
        caps = blink.get_lsp_capabilities()
      else
        caps = vim.lsp.protocol.make_client_capabilities()
      end
      local servers = require("lsp.servers").servers
      local enable = {}
      for name, def in pairs(servers) do
        if vim.fn.executable(def.cmd[1]) == 1 then
          def.capabilities = caps
          vim.lsp.config(name, def)
          table.insert(enable, name)
        end
      end
      if #enable > 0 then
        vim.lsp.enable(enable)
      end
    end,
  },
}

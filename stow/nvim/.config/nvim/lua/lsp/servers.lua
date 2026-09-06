-- LSP servers (native vim.lsp.config; enabled in lua/plugins/lsp.lua).
-- Provisioning: lua_ls via mise (`mise use lua-language-server`);
-- ts_ls via mise npm backend (`mise use npm:typescript-language-server`,
-- fallback: bun add -g typescript typescript-language-server);
-- pyright manual (present via bun; fallback: bun add -g pyright).
-- Missing binaries are skipped silently at enable time.
local M = {}

M.servers = {
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".git" },
    settings = { Lua = { diagnostics = { globals = { "vim" } } } },
  },
  pyright = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { ".git" },
  },
  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "typescript" },
    root_markers = { ".git" },
  },
}

return M

-- Vim Settings --
vim.opt.number = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true

vim.opt.cursorline = true

vim.opt.clipboard:append({ "unnamed", "unnamedplus" })

-- lazy.nvim --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "folke/noice.nvim",
  "cohama/lexima.vim"
})

-- Stage-2 bridge (inert, T9): lazy-split note only — still loading init.lua.
-- Stage-2 plan: lua/stage2_bridge.lua outlines plugins/LSP/treesitter/lualine/colorscheme (NOT required here).

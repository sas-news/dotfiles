-- Treesitter (main branch, new API). T3_SPEC_OK
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- Install once when the CLI exists; otherwise stay silent
      -- (missing CLI used to error on every boot).
      if vim.fn.executable("tree-sitter") ~= 1 then
        return
      end
      local parsers = { "lua", "python", "javascript", "typescript", "markdown", "bash" }
      local ok, ts = pcall(require, "nvim-treesitter")
      if ok and ts and ts.install then
        ts.install(parsers)
      end
    end,
  },
}

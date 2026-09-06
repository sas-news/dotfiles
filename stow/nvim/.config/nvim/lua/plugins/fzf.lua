return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    cmd = "FzfLua",
    opts = {},
    config = function(_, opts)
      require("fzf-lua").setup(opts)
    end,
  },
}

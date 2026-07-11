return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "VeryLazy",
  opts = {
    ensure_installed = {
      "cpp",
      "typescript",
      "javascript",
      "tsx",
      "html",
      "css",
      "python",
      "lua",
      "vim",
      "vimdoc",
    },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  },
  config = function(_, opts)
    require("nvim-treesitter").setup(opts)
  end,
}

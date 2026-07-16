return {
  "NMAC427/guess-indent.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("guess-indent").setup({
      auto_cmd = true,
      filetype_blocklist = {
        "cpp",
        "c",
        "hpp",
        "h",
      },
    })
  end,
}

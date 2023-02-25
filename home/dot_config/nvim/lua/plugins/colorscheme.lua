return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
    disable_background = true,
    on_highlights = function(hl, c)
      hl.Normal = {
        bg = "#000000",
      }
      hl.NormalFloat = {
        bg = "#000000",
      }
    end,
  },
}

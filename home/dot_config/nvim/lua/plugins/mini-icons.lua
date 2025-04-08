return {
  {
    "echasnovski/mini.icons",
    config = function()
      require("mini.icons").setup({
        extension = {
          ["sh.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
          ["fish.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
          ["yaml.tmpl"] = { glyph = "", hl = "MiniIconsPurple" },
          ["toml.tmpl"] = { glyph = "", hl = "MiniIconsOrange" },
          ["json.tmpl"] = { glyph = "󰘦", hl = "MiniIconsYellow" },
        },
      })
    end,
  },
}

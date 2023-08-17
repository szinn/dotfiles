local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({ "FiraCode Nerd Font" })
config.font_size = 12
config.color_scheme = "Dracula (Official)"
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.hide_tab_bar_if_only_one_tab = true

config.keys = {
  { key = "g", mods = "CMD", action=wezterm.action{SendString="\x14G"} },
  { key = "j", mods = "CMD", action=wezterm.action{SendString="\x14T"} },
  { key = "k", mods = "CMD", action=wezterm.action{SendString="\x14L"} },
  { key = "t", mods = "CMD", action=wezterm.action{SendString="\x14c"} },
}

return config

local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({ "FiraCode Nerd Font" })
config.font_size = 12
config.color_scheme = "Dracula (Official)"
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"

return config

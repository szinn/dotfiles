local wezterm = require 'wezterm'
local act = wezterm.action

local fish_path = '/opt/homebrew/bin/fish'

-- local workspace_switcher = wezterm.plugin.require("file:///Users/scotte/Development/Projects/smart_workspace_switcher.wezterm")
-- local workspace_switcher = wezterm.plugin.require("https://github.com/szinn/smart_workspace_switcher.wezterm")
local workspace_switcher = wezterm.plugin.require 'https://github.com/MLFlexer/smart_workspace_switcher.wezterm'
workspace_switcher.zoxide_path = '/opt/homebrew/bin/zoxide'
workspace_switcher.workspace_formatter = function(label)
  return wezterm.format {
    {
      Attribute = {
        Italic = true,
      },
    },
    {
      Foreground = {
        AnsiColor = 'Navy',
      },
    },
    {
      Background = {
        AnsiColor = 'Black',
      },
    },
    {
      Text = '󱂬: ' .. label,
    },
  }
end

-- Use config builder object if possible
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Settings
config.default_prog = { fish_path, '-l' }

config.font = wezterm.font {
  family = 'FiraCode Nerd Font',
  weight = 'Regular',
  harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
}
config.font_size = 11.0
config.line_height = 1.0

config.color_scheme = 'Dracula Pro Van Helsing'
config.window_background_opacity = 1.0
config.window_decorations = 'RESIZE'
config.window_close_confirmation = 'AlwaysPrompt'
config.scrollback_lines = 3000
config.default_workspace = 'main'
config.use_fancy_tab_bar = true

-- Dim inactive panes
config.inactive_pane_hsb = {
  saturation = 0.24,
  brightness = 0.5,
}

config.leader = {
  key = 't',
  mods = 'CTRL',
  timeout_milliseconds = 2000,
}

config.keys = { -- Send C-t when pressing C-a twice
  {
    key = 'q',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 't',
    mods = 'LEADER|CTRL',
    action = act.SendKey {
      key = 't',
      mods = 'CTRL',
    },
  },
  {
    key = 'c',
    mods = 'LEADER',
    action = act.ActivateCopyMode,
  },
  {
    key = 'phys:Space',
    mods = 'LEADER',
    action = act.ActivateCommandPalette,
  }, -- Pane keybindings
  {
    key = '-',
    mods = 'LEADER',
    action = act.SplitVertical {
      domain = 'CurrentPaneDomain',
    },
  },
  {
    key = '\\',
    mods = 'LEADER',
    action = act.SplitHorizontal {
      domain = 'CurrentPaneDomain',
    },
  },
  {
    key = 'n',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'e',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Down',
  },
  {
    key = 'i',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'o',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'q',
    mods = 'LEADER',
    action = act.CloseCurrentPane {
      confirm = true,
    },
  },
  {
    key = 'z',
    mods = 'LEADER',
    action = act.TogglePaneZoomState,
  },
  {
    key = 'l',
    mods = 'LEADER',
    action = act.RotatePanes 'Clockwise',
  }, -- We can make separate keybindings for resizing panes
  -- But Wezterm offers custom "mode" in the name of "KeyTable"
  {
    key = 'u',
    mods = 'LEADER',
    action = act.ActivateKeyTable {
      name = 'resize_pane',
      one_shot = false,
    },
  }, -- Tab keybindings
  {
    key = 't',
    mods = 'LEADER',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = ',',
    mods = 'LEADER',
    action = act.ActivateTabRelative(-1),
  },
  {
    key = '.',
    mods = 'LEADER',
    action = act.ActivateTabRelative(1),
  },
  {
    key = 'j',
    mods = 'LEADER',
    action = act.ShowTabNavigator,
  },
  {
    key = 'r',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = wezterm.format {
        {
          Attribute = {
            Intensity = 'Bold',
          },
        },
        {
          Foreground = {
            AnsiColor = 'Fuchsia',
          },
        },
        {
          Text = 'Renaming Tab Title...:',
        },
      },
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  }, -- Key table for moving tabs around
  {
    key = 'm',
    mods = 'LEADER',
    action = act.ActivateKeyTable {
      name = 'move_tab',
      one_shot = false,
    },
  }, -- Or shortcuts to move tab w/o move_tab table. SHIFT is for when caps lock is on
  {
    key = '{',
    mods = 'LEADER|SHIFT',
    action = act.MoveTabRelative(-1),
  },
  {
    key = '}',
    mods = 'LEADER|SHIFT',
    action = act.MoveTabRelative(1),
  }, -- Lastly, workspace
  {
    key = 'j',
    mods = 'CMD',
    action = workspace_switcher.switch_workspace(),
  },
  {
    key = 's',
    mods = 'LEADER',
    action = act.ShowLauncherArgs {
      flags = 'FUZZY|WORKSPACES',
    },
  },
}

-- Configure for Colemak keyboard
config.key_tables = {
  resize_pane = {
    {
      key = 'n',
      action = act.AdjustPaneSize { 'Left', 1 },
    },
    {
      key = 'e',
      action = act.AdjustPaneSize { 'Down', 1 },
    },
    {
      key = 'i',
      action = act.AdjustPaneSize { 'Up', 1 },
    },
    {
      key = 'o',
      action = act.AdjustPaneSize { 'Right', 1 },
    },
    {
      key = 'Escape',
      action = 'PopKeyTable',
    },
    {
      key = 'Enter',
      action = 'PopKeyTable',
    },
  },
  move_tab = {
    {
      key = 'n',
      action = act.MoveTabRelative(-1),
    },
    {
      key = 'e',
      action = act.MoveTabRelative(-1),
    },
    {
      key = 'i',
      action = act.MoveTabRelative(1),
    },
    {
      key = 'o',
      action = act.MoveTabRelative(1),
    },
    {
      key = 'Escape',
      action = 'PopKeyTable',
    },
    {
      key = 'Enter',
      action = 'PopKeyTable',
    },
  },
}

config.ssh_domains = {
  {
    name = 'ragnar',
    remote_address = 'ragnar',
    username = 'scotte',
    multiplexing = 'None',
  },
  {
    name = 'hera',
    remote_address = 'hera',
    username = 'scotte',
    multiplexing = 'None',
  },
  {
    name = 'titan',
    remote_address = 'titan',
    username = 'scotte',
    multiplexing = 'None',
  },
  {
    name = 'styx',
    remote_address = 'styx',
    username = 'root',
    multiplexing = 'None',
  },
}

local function basename(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

local function update_right_status(window)
  title = basename(window:active_workspace())
  if window:is_focused() then
    window:set_right_status(wezterm.format {
      { Foreground = { Color = '#AAAAAA' } },
      { Background = { Color = '#333333' } },
      { Text = '  ' .. title .. '  ' },
    })
  end
end

wezterm.on('window-focus-changed', function(window, pane)
  update_right_status(window)
end)

wezterm.on('update-right-status', function(window, pane)
  update_right_status(window)
end)

return config

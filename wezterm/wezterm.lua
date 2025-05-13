-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme_dirs = { "./schemas" }
config.enable_tab_bar = false
config.font_size = 25
config.color_scheme = "nord"
config.colors = {
	background = "#000000",
}

local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

config.freetype_load_target = "Light"
config.freetype_load_flags = "NO_HINTING"
config.window_decorations = "RESIZE"

config.keys = {
	-- Turn off the default CMD-m Hide action, allowing CMD-m to
	-- be potentially recognized and handled by the tab
	{
		key = "y",
		mods = "CMD",
		action = wezterm.action.QuickSelect,
	},
}
-- and finally, return the configuration to wezterm
return config

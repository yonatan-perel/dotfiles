-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.enable_tab_bar = false
config.font = wezterm.font("Iosevka")
config.font_size = 20
--config.colors = wezterm.color.load_scheme("/Users/yonatan.perel/.config/wezterm/schemes/alabaster.toml")
--local dimmer = { brightness = 0.012 }
--config.background = {
--	{
--		source = { File = "/Users/yonatan.perel/Downloads/IMG_3962-EDIT.jpg" },
--		hsb = dimmer,
--		vertical_align = "Middle",
--		vertical_offset = "2cell",
--	},
--}
--local dimmer = { brightness = 0.1 }
--config.background = {
--	{
--		source = { File = "/Users/yonatan.perel/Downloads/IMG_3721.png" },
--		hsb = dimmer,
--	},
--}
--local dimmer = { brightness = 0.12 }
--config.background = {
--	{
--		source = { File = "/Users/yonatan.perel/Downloads/IMG_3765 (1).png" },
--		hsb = dimmer,
--	},
--}
config.color_scheme = "Everforest Dark Hard (Gogh)"
config.colors = {
	background = "#16161D",
	--background = "#111111",
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

-- Pull in the wezterm API
local wezterm = require("wezterm")

-- local k = require("utils/keys")
-- this will load the configuration
local config = wezterm.config_builder()
config.color_scheme = "Tokyo Night"

config.term = "xterm-kitty"
config.enable_kitty_graphics = true
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 14
config.max_fps = 120

config.window_close_confirmation = "NeverPrompt"

config.enable_tab_bar = false

config.window_decorations = "RESIZE"
-- config.window_background_opacity = 0.8
config.macos_window_background_blur = 10
config.native_macos_fullscreen_mode = false
config.hide_tab_bar_if_only_one_tab = true
--0 keep adding configuration options
-- my coolnight colorscheme:
-- config.colors = {
-- 	foreground = "#CBE0F0",
-- 	background = "#011423",
-- 	cursor_bg = "#47FF9C",
-- 	cursor_border = "#47FF9C",
-- 	cursor_fg = "#011423",
-- 	selection_bg = "#033259",
-- 	selection_fg = "#CBE0F0",
-- 	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
-- 	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
-- }

-- keybindings
config.keys = {

	-- quick select keybing (ctrl-shift-space) gets captured by something else on the mac
	-- {
	-- 	key = "A",
	-- 	mods = "CTRL|SHIFT",
	-- 	action = wezterm.action.QuickSelect,
	-- },
}
return config

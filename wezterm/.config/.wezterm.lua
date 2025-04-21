local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Bamboo Multiplex'
config.window_decorations = "RESIZE"
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.inactive_pane_hsb = {
		brightness = 0.7,
}


config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#c4FF9C",
	cursor_border = "#c7FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#c4EAF7", "#c4EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#c4EAF7", "#c4EAF7" },
}

config.macos_window_background_blur = 100
-- config.background = {
--   {
--       source = {
--           File = "~/.config/wezterm/backgrounds/white.png",
--       },
--      opacity = .6,
--      hsb = { brightness = 0.9 },
--    },
--   {
--       source = {
--           File = "~/.config/wezterm/backgrounds/overlay.png",
--       },
--      opacity = .9,
--      hsb = { brightness = 0.4 },
--    },
--   {
--       source = {
--           File = "~/.config/wezterm/backgrounds/jellyfish2.jpg",
--       },
--       opacity = .2,
--       hsb = { brightness = 0.2 },
--       attachment = { Parallax = 0.1 },
--       width = '100%',
--    },
--   {
--       source = {
--           File = "~/.config/wezterm/backgrounds/white.png",
--       },
--      opacity = .05,
--      hsb = { brightness = 0.3 },
--    },
-- }

return config

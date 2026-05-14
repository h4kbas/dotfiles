local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Combined Color Palette
local colors = {
  bg1      = "#3E313C", -- Primary Background
  bg2      = "#261C25", -- Darker background (Title bar/Tabs)
  bg3      = "#4F384A", -- Lighter UI / Hover
  bg4      = "#523F4D", -- Selection background
  text     = "#F6F6F4", -- Primary Foreground
  textDim1 = "#B9B9B9", -- Muted text
  alpha    = "#82AAFF", -- Blue
  beta     = "#80CBC4", -- Cyan
  delta    = "#F44C5E", -- Red
  epsilon  = "#FFCB6B", -- Yellow
  zeta     = "#F78C6C", -- Orange
  eta      = "#C3E88D", -- Green
  iota     = "#C792EA", -- Magenta
  accent1  = "#3E9689", -- Teal Accent
}

--- Window & Font Settings ---
-- config.initial_cols = 120
-- config.initial_rows = 28
config.font_size = 13
config.font = wezterm.font("Hack Nerd Font")
config.window_decorations = "RESIZE"
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false

-- Title bar styling
config.window_frame = {
  active_titlebar_bg = colors.bg2,
  inactive_titlebar_bg = colors.bg2,
}

--- Color Configuration ---
config.colors = {
  background = colors.bg1,
  foreground = colors.text,

  -- Cursor and Selection
  cursor_bg = colors.zeta,
  cursor_fg = colors.bg1,
  cursor_border = colors.zeta,
  selection_fg = 'none',
  selection_bg = colors.bg4,

  scrollbar_thumb = colors.bg3,
  split = colors.bg2,

  -- Terminal ANSI Colors
  ansi = {
    colors.bg2,     -- black
    colors.delta,   -- red
    colors.eta,     -- green
    colors.epsilon, -- yellow
    colors.alpha,   -- blue
    colors.iota,    -- magenta
    colors.beta,    -- cyan
    colors.text,    -- white
  },
  brights = {
    colors.textDim1, -- bright black
    colors.delta,
    colors.eta,
    colors.epsilon,
    colors.alpha,
    colors.iota,
    colors.beta,
    colors.text,
  },

  -- Tab Bar Styling
  tab_bar = {
    background = colors.bg2,
    active_tab = {
      bg_color = colors.bg1,
      fg_color = colors.text,
    },
    inactive_tab = {
      bg_color = colors.bg2,
      fg_color = colors.textDim1,
    },
    inactive_tab_hover = {
      bg_color = colors.bg3,
      fg_color = colors.text,
    },
    new_tab = {
      bg_color = colors.bg2,
      fg_color = colors.textDim1,
    },
    new_tab_hover = {
      bg_color = colors.accent1,
      fg_color = colors.text,
    },
  },
}

return config

-- DESCRIPTION
-- ========================================================================
-- Dark arrow theme for Awesome WM

-- REQUIRED LIBRARY
-- ========================================================================
-- General library
-- ------------------------------------------------------------------------
local os      = os
local string  = string
local tonumber = tonumber

-- Awesome library
-- ------------------------------------------------------------------------
local awful   = require("awful")
local gears   = require("gears")
local wibox   = require("wibox")
local dpi     = require("beautiful.xresources").apply_dpi
local colors  = require("widgets.colors")
local theme_assets = require("beautiful.theme_assets")


-- THEME VARIABLES
-- ========================================================================
-- Set theme variable
-- ------------------------------------------------------------------------
local theme   = {}

-- Theme directory
-- ------------------------------------------------------------------------
theme_name = "powerarrow-dark"
theme.dir  = os.getenv("HOME") .. "/.config/awesome/theme/" .. theme_name

-- Colors
-- ------------------------------------------------------------------------

-- Default colors
-- ------------------------------------------------------------------------
theme.fg_normal   = colors.grey_300
theme.bg_normal   = colors.green_700
theme.fg_urgent   = colors.black
theme.bg_urgent   = colors.red_500
theme.fg_occupied = colors.black
theme.bg_occupied = colors.orange_a400
theme.fg_focus    = colors.black
theme.bg_focus    = colors.light_green_a400
theme.fg_volatile = colors.black
theme.bg_volatile = colors.cyan_a400
theme.bg_darkest  = colors.grey_900
theme.bg_darker   = colors.grey_800
theme.bg_dark     = colors.grey_700

-- Base beautiful variables
-- ------------------------------------------------------------------------
-- https://awesomewm.org/doc/api/libraries/beautiful.html
theme.font        = "FiraCode Nerd Font 10"
theme.useless_gap = dpi(5)

-- Border variables
-- ------------------------------------------------------------------------
theme.border_width  = dpi(2)
theme.border_normal = colors.grey_900
theme.border_focus  = theme.bg_focus
theme.border_urgent = theme.bg_urgent

-- Wallpaper configuration
-- ------------------------------------------------------------------------
-- Method to set a wallpaper based on current time
local function time_based_wallpaper()
  local wallpaper = theme.dir .. "/wallpapers/landscape/"
  local hour = os.date("%H")
  local minute = tonumber(os.date("%M"))
  if minute < 15 then
    minute = "00"
  elseif minute < 30 then
    minute = "15"
  elseif minute < 45 then
    minute = "30"
  elseif minute < 60 then
    minute = "45"
  end
  theme.wallpaper = wallpaper .. string.format("%02d_%02d.png",hour,minute)
  for s = 1, screen.count() do
    gears.wallpaper.maximized(theme.wallpaper, s, true)
  end
end
-- theme.wallpaper     = themes_dir .. "/wallpapers/XXXX.png"

-- Hotkeys
-- ------------------------------------------------------------------------
-- https://awesomewm.org/apidoc/popups_and_bars/awful.hotkeys_popup.widget.html

theme.hotkeys_bg               = colors.grey_900
theme.hotkeys_fg               = colors.grey_a100
theme.hotkeys_border_width     = 5
theme.hotkeys_border_color     = colors.green_a700
theme.hotkeys_shape            = gears.shape.rect
theme.hotkeys_modifiers_fg     = colors.yellow_a700
theme.hotkeys_label_bg         = colors.black
theme.hotkeys_label_fg         = colors.black
theme.hotkeys_font             = "FiraCode Nerd Font 11"
theme.hotkeys_description_font = "FiraCode Nerd Font 11"
theme.hotkeys_group_margin     = 10

-- Naughty notification beautiful variables
-- ------------------------------------------------------------------------
-- https://awesomewm.org/doc/api/libraries/naughty.html
theme.notification_font         = theme.font
theme.notification_bg           = theme.bg_normal
theme.notification_fg           = theme.fg_normal
theme.notification_border_width = 5
theme.notification_border_color = theme.focus
theme.notification_shape        = gears.shape.rect
theme.notification_opacity      = 90
theme.notification_margin       = 50

-- Default Wibar
-- ------------------------------------------------------------------------
theme.wibar_height = 20
--theme.
theme.wibar_fg     = theme.fg_normal
theme.wibar_bg     = theme.bg_normal .. "44"

local powerline = gears.shape.powerline
local powerline_inv = function(cr, width, height)
    gears.shape.powerline(cr, width, height, -theme.wibar_height/2)
  end

-- Taglist
-- ------------------------------------------------------------------------
-- https://awesomewm.org/doc/api/classes/awful.widget.taglist.html
theme.taglist_font        = theme.font
theme.taglist_fg_focus    = theme.fg_focus
theme.taglist_bg_focus    = theme.bg_focus
theme.taglist_fg_urgent   = theme.fg_urgent
theme.taglist_bg_urgent   = theme.bg_urgent
theme.taglist_fg_occupied = theme.fg_occupied
theme.taglist_bg_occupied = theme.bg_occupied
theme.taglist_fg_empty    = theme.fg_normal
theme.taglist_bg_empty    = theme.bg_normal .. "44"
theme.taglist_fg_volatile = theme.fg_volatile
theme.taglist_bg_volatile = theme.bg_volatile
theme.taglist_shape       = powerline
theme.taglist_spacing     = -dpi(5)

-- Tasklist
-- ------------------------------------------------------------------------
-- https://awesomewm.org/doc/api/classes/awful.widget.tasklist.html
theme.tasklist_fg_normal                    = colors.black
theme.tasklist_bg_normal                    = colors.grey_300
theme.tasklist_fg_focus                     = colors.black
theme.tasklist_bg_focus                     = colors.green_a700
theme.tasklist_fg_urgent                    = colors.black
theme.tasklist_bg_urgent                    = colors.red_a700
theme.tasklist_fg_minimize                  = colors.black
theme.tasklist_bg_minimize                  = colors.purple_a700
theme.tasklist_disable_icon                 = false
theme.tasklist_disable_task_name            = false
theme.tasklist_plain_task_name              = false
theme.tasklist_font                         = theme.font
theme.tasklist_align                        = center
theme.tasklist_font_focus                   = theme.font
theme.tasklist_font_minimized               = theme.font
theme.tasklist_font_urgent                  = theme.font
theme.tasklist_sticky                       = " "
theme.tasklist_ontop                        = "ﱓ "
theme.tasklist_floating                     = " "
theme.tasklist_maximized                    = " "


-- Keyboard Layout widget variables
-- ------------------------------------------------------------------------
-- Keyboard Layout widget
theme.keyboardlayout_fg = colors.yellow_500
theme.keyboardlayout_bg = theme.bg_dark
theme.keyboardlayout_icon = " "
theme.keyboardlayout_shape = powerline_inv
local keyboardlayout_widget = wibox.widget
  {
    {
      {
        {
          markup = ""..
            "<span foreground='" .. theme.keyboardlayout_fg.. "'>" ..
              theme.keyboardlayout_icon ..
            "</span>",
          widget = wibox.widget.textbox,
        },
        awful.widget.keyboardlayout,
        layout = wibox.layout.align.horizontal,
      },
      widget = wibox.container.margin(_, 15, 15, 0, 0),
    },
    fg           = theme.keyboardlayout_fg,
    bg           = theme.keyboardlayout_bg,
    font         = theme.font,
    shape        = theme.keyboardlayout_shape,
    widget       = wibox.container.background,
  }

-- IP widget variables
-- ------------------------------------------------------------------------
-- IP widget
theme.ip_bg = theme.bg_darker
theme.ip_fg = colors.purple_300
theme.ip_shape = powerline_inv
theme.ip_icon = " "
theme.ip_icon=" "
theme.ip_icon_vpn="旅"
local ip_widget = require("widgets.ip")

-- Uptime widget variables
-- ------------------------------------------------------------------------
-- Uptime widget
theme.uptime_bg = theme.bg_dark
theme.uptime_fg = theme.fg_normal
theme.uptime_shape = powerline_inv
theme.uptime_icon = " "
local uptime_widget = require("widgets.uptime")

-- Battery widget variables
-- ------------------------------------------------------------------------
-- Battery widget
--local bat_widget = require("widgets.bat")

-- Disk widget variables
-- ------------------------------------------------------------------------
-- Disk widget
theme.disk_bg=theme.bg_darker
theme.disk_fg=theme.fg_normal
theme.disk_shape=powerline_inv
theme.disk_icon=" "
theme.disk_bar_bg = theme.bg_darkest

theme.disk_tier1_clr=colors.green_500
theme.disk_tier2_clr=colors.yellow_500
theme.disk_tier3_clr=colors.orange_500
theme.disk_tier4_clr=colors.red_500
local disk_widget = require("widgets.disk")

-- Net widget variables
-- ------------------------------------------------------------------------
-- Net widget
theme.net_bg = theme.bg_dark
theme.net_fg = theme.fg_normal
theme.net_shape = powerline_inv
theme.net_up_icon = " "
theme.net_down_icon = " "
theme.net_online_icon = " "
theme.net_offline_icon = " "

theme.net_tier1_clr=colors.green_500
theme.net_tier2_clr=colors.yellow_500
theme.net_tier3_clr=colors.orange_500
theme.net_tier4_clr=colors.red_500
local net_widget = require("widgets.net")

-- Ram widget variables
-- ------------------------------------------------------------------------
-- Ram widget
theme.ram_bg=theme.bg_darker
theme.ram_fg=theme.fg_normal
theme.ram_shape=powerline_inv
theme.ram_icon=" "
theme.ram_bar_bg = theme.bg_darkest

theme.ram_tier1_clr=colors.green_500
theme.ram_tier2_clr=colors.yellow_500
theme.ram_tier3_clr=colors.orange_500
theme.ram_tier4_clr=colors.red_500
local ram_widget = require("widgets.ram")

-- CPU widget variables
-- ------------------------------------------------------------------------
-- CPU widget
theme.cpu_fg = theme.fg_normal
theme.cpu_bg = theme.bg_dark
theme.cpu_shape = powerline_inv
theme.cpu_icon = "  "
theme.cpu_bar_bg = theme.bg_darkest

theme.cpu_tier1_clr=colors.green_500
theme.cpu_tier2_clr=colors.yellow_500
theme.cpu_tier3_clr=colors.orange_500
theme.cpu_tier4_clr=colors.red_500
local cpu_widget = require("widgets.cpu")

-- Date widget variables
-- ------------------------------------------------------------------------
-- Date widget
theme.date_format = " %a %d %b | %H:%M"
theme.date_fg = theme.fg_normal
theme.date_bg = theme.bg_darker
theme.date_shape = powerline_inv
local date_widget = require("widgets.date")

-- Systray widget variables
-- ------------------------------------------------------------------------
theme.bg_systray           = colors.brown_500
theme.systray_icon_spacing = dpi(0)
local systray_widget = {
  {
    wibox.widget.systray(),
    left = dpi(theme.wibar_height),
    right = dpi(theme.wibar_height),
    widget = wibox.container.margin,
  },
  bg = theme.bg_systray,
  shape = powerline_inv,
  widget = wibox.container.background,
}

-- Layout widget variables
-- ------------------------------------------------------------------------
local layoutbox_widget = require("widgets.layouts")
-- Layout image
layout_img_dir          = theme.dir .. "/img/layouts/"
theme.layout_cornernw   = layout_img_dir .. "cornernw.png"
theme.layout_cornerne   = layout_img_dir .. "cornerne.png"
theme.layout_cornersw   = layout_img_dir .. "cornersw.png"
theme.layout_cornerse   = layout_img_dir .. "cornerse.png"
theme.layout_fairh      = layout_img_dir .. "fairh.png"
theme.layout_fairv      = layout_img_dir .. "fairv.png"
theme.layout_floating   = layout_img_dir .. "floating.png"
theme.layout_magnifier  = layout_img_dir .. "magnifier.png"
theme.layout_max        = layout_img_dir .. "max.png"
theme.layout_fullscreen = layout_img_dir .. "fullscreen.png"
theme.layout_tile       = layout_img_dir .. "tile.png"
theme.layout_tiletop    = layout_img_dir .. "tiletop.png"
theme.layout_tilebottom = layout_img_dir .. "tilebottom.png"
theme.layout_tileleft   = layout_img_dir .. "tileleft.png"
-- Layout widget
theme.layout_fg        = theme.fg_normal
theme.layout_bg        = theme.bg_normal .. "00"
theme.layout_shape     = powerline_inv
theme_assets.recolor_layout(theme, theme.fg_normal)


function theme.at_screen_connect(s)
  -- Time based wallpaper configuration
  gears.timer {
    timeout = 300,
    call_now = true,
    autostart = true,
    callback = time_based_wallpaper
  }
  screen.connect_signal("request::wallpaper", time_based_wallpaper)
  -- Static wallpaper configuration
  -- gears.wallpaper.maximized(theme.wallpaper, nil, false)

  s.mypromptbox = awful.widget.prompt()

  -- TAGS
  -- ========================================================================
  awful.tag(awful.util.tagnames, s, awful.layout.layouts)
  -- Create a taglist widget
  -- ------------------------------------------------------------------------
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = awful.util.taglist_buttons,
    layout = {
      spacing = -dpi(theme.wibar_height/2),
      layout  = wibox.layout.flex.horizontal,
    },
    widget_template = {
      {
        {
        {
          id     = 'tag_content',
          widget = wibox.widget.textbox,
        },
          left   = 18,
          widget = wibox.container.margin,
        },
        layout   = wibox.layout.flex.horizontal,
      },
      id           = 'background_role',
      forced_width = dpi(theme.wibar_height * 4),
      widget       = wibox.container.background,
      -- Add support for hover colors and an index label
      create_callback = function(self, tag, index, objects)
        nb_client = tag:clients().n
        if tag.selected then
          fg_color = theme.taglist_fg_focus
        elseif next(tag:clients()) == nil then
          fg_color = theme.taglist_fg_empty
        elseif next(tag:clients()) ~= nil then
          fg_color = theme.taglist_fg_occupied
        elseif tag.volatile then
          fg_color = theme.green_a400
        else
          fg_color = theme.white
        end
        self:get_children_by_id('tag_content')[1].markup =
          "<span foreground='"..fg_color.."'>"..index.." "..tag.name.. " </span>"
      end,
      update_callback = function(self, tag, index, objects) --luacheck: no unused args
        if tag.selected then
          fg_color = theme.taglist_fg_focus
        elseif next(tag:clients()) == nil then
          fg_color = theme.taglist_fg_empty
        elseif next(tag:clients()) ~= nil then
          fg_color = theme.taglist_fg_occupied
        elseif tag.volatile then
          fg_color = theme.taglist_fg_volatile
        else
          fg_color = theme.white
        end
        self:get_children_by_id('tag_content')[1].markup =
          "<span foreground='"..fg_color.."'>"..index.." "..tag.name.. " </span>"
      end,
    },
  }

  -- TASKLIST
  -- ========================================================================
  -- Create a tasklist widget
  -- ------------------------------------------------------------------------
  s.mytasklist = awful.widget.tasklist {
    screen   = s,
    filter   = awful.widget.tasklist.filter.currenttags,
    buttons  = awful.util.tasklist_buttons,
    style    = {
      shape_border_width = 0,
      shape  = gears.shape.powerline,
    },
    layout   = {
      spacing = dpi(10),
      spacing_widget = {
        {
          forced_width = 5,
          widget       = wibox.widget.separator,
          color = theme.tasklist_bg_normal,
        },
        valign = 'center',
        halign = 'center',
        widget = wibox.container.place,
      },
      layout  = wibox.layout.flex.horizontal
    },
    widget_template = {
      {
        {
          {
            id     = 'icon_role',
            widget = wibox.widget.imagebox,
          },
          margins = 2,
          widget  = wibox.container.margin,
        },
        layout = wibox.layout.fixed.horizontal,
      },
      left  = 10,
      right = 10,
      widget = wibox.container.margin
    },
    id     = 'background_role',
    forced_width = theme.wibar_height,
    widget = wibox.container.background,
  }

  -- THE TOP WIBAR
  -- ========================================================================
  -- Initialize top wibar
  -- ------------------------------------------------------------------------
  s.empty_top_bar = awful.wibar({
    position = "top",
    screen   = s,
    height   = dpi(2 * theme.useless_gap),
    bg       = "#00000000",
  })
  s.top_bar = awful.wibar({
    position = "top",
    screen   = s,
    height   = dpi(theme.wibar_height),
    width    = dpi(s.geometry.width - 4 * theme.useless_gap),
    fg       = theme.wibar_fg,
    bg       = theme.wibar_bg,
  })

  -- Add widgets to the wibar
  -- ------------------------------------------------------------------------
  systray = nil
  if s == screen[1] then systray = systray_widget end
  s.top_bar:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      s.mytaglist,                            -- Add taglist
      spacing = -dpi(theme.wibar_height/4),   -- Set spacing between widget
      layout  = wibox.layout.fixed.horizontal, -- Set layout of the widget
    },
    { -- Middle widgets
      s.mytasklist,
      layout  = wibox.layout.flex.horizontal,-- Set the widget to separator
    },
    { -- Right widgets
      spacing = -dpi(theme.wibar_height/4),   -- Set spacing between widget
      layout  = wibox.layout.fixed.horizontal, -- Set layout of the widget
      keyboardlayout_widget,
      ip_widget(),
      uptime_widget(),                        -- Add uptime widget
      disk_widget(),                          -- Add disk widget
      --bat_widget(),                           -- Add bat widget
      net_widget(),                           -- Add network widget
      ram_widget(),                           -- Add ram widget
      cpu_widget(),
      date_widget(),                          -- Add date widget
      systray,
      layoutbox_widget(s,tag),                    -- Add layoubox widget
    },
  }

end


return theme

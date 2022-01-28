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
local shape   = require("gears.shape")
local wibox   = require("wibox")
local dpi     = require("beautiful.xresources").apply_dpi
local colors  = require("widgets.colors")
local theme_assets = require("beautiful.theme_assets")

--  UTILITY METHODS
-- ========================================================================
-- OS command method
function os.capture( cmd, raw)
  local f = assert(io.popen(cmd,'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
    s = string.gsub(s, '^%s+', '')
    s = string.gsub(s, '%s+$', '')
    s = string.gsub(s, '[\n\r]+', '')
  return s
end

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

-- Base beautiful variables
-- ------------------------------------------------------------------------
-- https://awesomewm.org/doc/api/libraries/beautiful.html
theme.font        = "FiraCode Nerd Font 12"
theme.useless_gap = dpi(5)

-- Border variables
-- ------------------------------------------------------------------------
theme.border_width  = dpi(2)
theme.border_normal = colors.grey_900
theme.border_focus  = theme.bg_focus
theme.border_urgent = theme.bg_urgent

-- Default Wibar
-- ------------------------------------------------------------------------
theme.wibar_height = 18
--theme.
theme.wibar_fg     = colors.fg_normal
theme.wibar_bg     = colors.bg_normal

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
theme.taglist_bg_empty    = theme.bg_normal
theme.taglist_fg_volatile = theme.fg_volatile
theme.taglist_bg_volatile = theme.bg_volatile

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

-- Systray widget variables
-- ------------------------------------------------------------------------
theme.bg_systray           = theme.fg_normal
theme.systray_icon_spacing = dpi(0)
local systray_widget       = require("widgets.systray")

-- Layout widget variables
-- ------------------------------------------------------------------------
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
theme.layout_fg        = theme.bg_normal
theme.layout_bg        = theme.fg_normal

local layoutbox_widget = require("widgets.layouts")

-- CPU widget variables
-- ------------------------------------------------------------------------
-- CPU widget
--local cpu_widget = require("widgets.cpu")

-- Battery widget variables
-- ------------------------------------------------------------------------
-- Battery widget
local bat_widget = require("widgets.bat")

-- Ram widget variables
-- ------------------------------------------------------------------------
-- Ram widget
local ram_widget = require("widgets.ram")

-- Net widget variables
-- ------------------------------------------------------------------------
-- Net widget
local net_widget = require("widgets.net")

-- Uptime widget variables
-- ------------------------------------------------------------------------
-- Uptime widget
local uptime_widget = require("widgets.uptime")

-- Date widget variables
-- ------------------------------------------------------------------------
-- Date widget
local date_widget = require("widgets.date")

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
    style = {
      shape = function(cr, width, height)
        gears.shape.parallelogram (cr, dpi(width), height, dpi(width-height/2))
      end,
    },
    layout = {
      spacing = -dpi(theme.wibar_height/2),
      layout  = wibox.layout.flex.horizontal
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
      forced_width = dpi(theme.wibar_height * 5),
      widget       = wibox.container.background,
      -- Add support for hover colors and an index label
      create_callback = function(self, tag, index, objects) --luacheck: no unused args
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
      shape  = gears.shape.hexagon,
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
            {
              id     = 'icon_role',
              widget = wibox.widget.imagebox,
            },
            margins = 2,
            widget  = wibox.container.margin,
          },
          {
            id     = 'text_role',
            widget = wibox.widget.textbox,
          },
          layout = wibox.layout.fixed.horizontal,
        },
        left  = 10,
        right = 10,
        widget = wibox.container.margin
      },
      id     = 'background_role',
      widget = wibox.container.background,
    },
  }

  -- THE TOP WIBAR
  -- ========================================================================
  -- Initialize top wibar
  -- ------------------------------------------------------------------------
  s.top_bar = awful.wibar({
    position = "top",
    screen = s,
    height = dpi(theme.wibar_height),
    fg = theme.wibar_fg,
    bg = theme.wibar_bg,
  })

  -- Add widgets to the wibar
  -- ------------------------------------------------------------------------
  s.top_bar:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      spacing = -dpi(theme.wibar_height/2),   -- Set spacing between widget
      layout = wibox.layout.fixed.horizontal, -- Set layout of the widget
      s.mytaglist,                            -- Add taglist
      systray_widget(),                       -- Add Systray widget
    },
    { -- Middle widgets
      opacity = 0,                            -- Hide the sperator
      widget  = wibox.widget.separator,       -- Set the widget to separator
    },
    { -- Right widgets
      spacing = -dpi(theme.wibar_height/2),   -- Set spacing between widget
      layout = wibox.layout.fixed.horizontal, -- Set layout of the widget
      uptime_widget(),                        -- Add uptime widget
      --cpu_widget(),                           -- Add cpu widget
      bat_widget(),                           -- Add bat widget
      ram_widget(),                           -- Add ram widget
      net_widget(),                           -- Add network widget
      date_widget(),                          -- Add date widget
      layoutbox_widget(s,tag),                    -- Add layoubox widget
    },
  }

  -- THE BOTTOM WIBAR
  -- ========================================================================
  -- Initialize bottom wibar
  -- ------------------------------------------------------------------------
  s.bot_bar = awful.wibar({
    position = "bottom",
    screen = s,
    height = 16,
    bg = theme.normal_dark,
    fg = theme.normal_light })

  -- Add widgets to the wibar
  -- ------------------------------------------------------------------------
  local botlayout = wibox.layout.align.horizontal()
  botlayout:set_middle(s.mytasklist)
  s.bot_bar:set_widget(botlayout)

end

theme_assets.recolor_layout(theme, theme.bg_normal)

return theme

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

--  UTILITY METHODS
-- ========================================================================
--  Shapes method use for notification, widget, etc.
local rounded_shape = function(cr, width, height)
  shape.partially_rounded_rect(cr, width, height, true, false, true, true, 15)
end

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
theme.red_A100         = "#FF8A80"
theme.red_A200         = "#FF5252"
theme.red_A400         = "#FF1744"
theme.red_A700         = "#D50000"
theme.pink_A100        = "#FF80AB"
theme.pink_A200        = "#FF4081"
theme.pink_A400        = "#F50057"
theme.pink_A700        = "#C51162"
theme.purple_A100      = "#EA80FC"
theme.purple_A200      = "#E040FB"
theme.purple_A400      = "#D500F9"
theme.purple_A700      = "#AA00FF"
theme.deep_purple_A100 = "#B388FF"
theme.deep_purple_A200 = "#7C4DFF"
theme.deep_purple_A400 = "#651FFF"
theme.deep_purple_A700 = "#6200EA"
theme.indigo_A100      = "#8C9EFF"
theme.indigo_A200      = "#536DFE"
theme.indigo_A400      = "#3D5AFE"
theme.indigo_A700      = "#304FFE"
theme.blue_A100        = "#82B1FF"
theme.blue_A200        = "#448AFF"
theme.blue_A400        = "#2979FF"
theme.blue_A700        = "#2962FF"
theme.light_blue_A100  = "#80D8FF"
theme.light_blue_A200  = "#40C4FF"
theme.light_blue_A400  = "#00B0FF"
theme.light_blue_A700  = "#0091EA"
theme.cyan_A100        = "#84FFFF"
theme.cyan_A200        = "#18FFFF"
theme.cyan_A400        = "#00E5FF"
theme.cyan_A700        = "#00B8D4"
theme.teal_A100        = "#A7FFEB"
theme.teal_A200        = "#64FFDA"
theme.teal_A400        = "#1DE9B6"
theme.teal_A700        = "#00BFA5"
theme.green_A100       = "#B9F6CA"
theme.green_A200       = "#69F0AE"
theme.green_A400       = "#00E676"
theme.green_A700       = "#00C853"
theme.light_green_A100 = "#CCFF90"
theme.light_green_A200 = "#B2FF59"
theme.light_green_A400 = "#76FF03"
theme.light_green_A700 = "#64DD17"
theme.lime_A100        = "#F4FF81"
theme.lime_A200        = "#EEFF41"
theme.lime_A400        = "#C6FF00"
theme.lime_A700        = "#AEEA00"
theme.yellow_A100      = "#FFFF8D"
theme.yellow_A200      = "#FFFF00"
theme.yellow_A400      = "#FFEA00"
theme.yellow_A700      = "#FFD600"
theme.amber_A100       = "#FFE57F"
theme.amber_A200       = "#FFD740"
theme.amber_A400       = "#FFC400"
theme.amber_A700       = "#FFAB00"
theme.orange_A100      = "#FFD180"
theme.orange_A200      = "#FFAB40"
theme.orange_A400      = "#FF9100"
theme.orange_A700      = "#FF6D00"
theme.deep_orange_A100 = "#FF9E80"
theme.deep_orange_A200 = "#FF6E40"
theme.deep_orange_A400 = "#FF3D00"
theme.deep_orange_A700 = "#DD2C00"
theme.brown_A100       = "#D7CCC8"
theme.brown_A200       = "#BCAAA4"
theme.brown_A400       = "#8D6E63"
theme.brown_A700       = "#5D4037"
theme.gray_A100        = "#F5F5F5"
theme.gray_A200        = "#EEEEEE"
theme.gray_A400        = "#BDBDBD"
theme.gray_A700        = "#616161"
theme.black            = "#000000"
theme.white            = "#FFFFFF"

-- Default colors
-- ------------------------------------------------------------------------
theme.fg_normal   = theme.gray_A400
theme.bg_normal   = theme.black
theme.fg_urgent   = theme.black
theme.bg_urgent   = theme.red_A700
theme.fg_occupied = theme.black
theme.bg_occupied = theme.amber_A700
theme.fg_focus    = theme.black
theme.bg_focus    = theme.green_A700
theme.fg_volatile = theme.black
theme.bg_volatile = theme.cyan_A700

-- Base beautiful variables
-- ------------------------------------------------------------------------
-- https://awesomewm.org/doc/api/libraries/beautiful.html
theme.font        = "FiraCode Nerd Font 11"
theme.useless_gap = dpi(3)

-- Border variables
-- ------------------------------------------------------------------------
theme.border_width  = dpi(5)
theme.border_normal = theme.gray_A700
theme.border_focus  = theme.green_A700
theme.border_urgent = theme.red_A700
theme.border_marked = theme.orange_A700

-- Default Wibar
-- ------------------------------------------------------------------------
theme.wibar_height = dpi(18)
theme.wibar_fg     = theme.fg_normal
theme.wibar_bg     = theme.bg_normal

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
theme.tasklist_fg_normal                    = theme.black
theme.tasklist_bg_normal                    = theme.gray_A700
theme.tasklist_fg_focus                     = theme.black
theme.tasklist_bg_focus                     = theme.green_A700
theme.tasklist_fg_urgent                    = theme.black
theme.tasklist_bg_urgent                    = theme.red_A700
theme.tasklist_fg_minimize                  = theme.black
theme.tasklist_bg_minimize                  = theme.purple_A700
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

theme.hotkeys_bg                = theme.gray_A700
theme.hotkeys_fg                = theme.gray_A100
--beautiful.hotkeys_border_width      int                                  Hotkeys widget border width.
--beautiful.hotkeys_border_color      color                                Hotkeys widget border color.
--beautiful.hotkeys_shape             gears.shape                          Hotkeys widget shape.
theme.hotkeys_modifiers_fg      = theme.yellow_A700
--beautiful.hotkeys_label_bg          color                                Background color used for miscellaneous labels of hotkeys widget.
theme.hotkeys_label_fg          = theme.green_A700
--beautiful.hotkeys_font              string or lgi.Pango.FontDescription  Main hotkeys widget font.
--beautiful.hotkeys_description_font  string or lgi.Pango.FontDescription  Font used for hotkeys' descriptions.
--beautiful.hotkeys_group_margin      int                                  Margin between hotkeys groups.

-- Naughty notification beautiful variables
-- ------------------------------------------------------------------------
-- https://awesomewm.org/doc/api/libraries/naughty.html
theme.notification_font         = theme.font
theme.notification_bg           = theme.bg_normal
theme.notification_fg           = theme.fg_normal
theme.notification_border_width = 5
theme.notification_border_color = theme.focus
theme.notification_shape        = rounded_shape
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
      forced_width = dpi(70),
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
          fg_color = theme.green_A400
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
    height = theme.wibar_height,
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
      layoutbox_widget(s),                    -- Add layoubox widget
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

return theme

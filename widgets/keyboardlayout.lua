-- DESCRIPTION
-- ========================================================================
-- Widget to show the current keyboard layout

-- LIBRARY
-- ========================================================================
local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local dpi       = require("beautiful.xresources").apply_dpi
local rofi      = require("modules.rofi")

-- VARIABLES
-- ========================================================================
local keyboardlayout = {}

-- METHOD
-- ========================================================================
local function factory(screen)
  return wibox.widget {
    {
      {
        {
          markup = ""..
            "<span foreground='" .. beautiful.keyboardlayout_fg.. "'>" ..
              beautiful.keyboardlayout_icon ..
            "</span>",
          widget = wibox.widget.textbox,
        },
        awful.widget.keyboardlayout,
        layout = wibox.layout.align.horizontal,
      },
      widget = wibox.container.margin(_, 15, 15, 0, 0),
    },
    fg           = beautiful.keyboardlayout_fg,
    bg           = beautiful.keyboardlayout_bg,
    buttons      = require("config.buttons.keyboardlayout"),
    font         = beautiful.font,
    shape        = beautiful.keyboardlayout_shape,
    widget       = wibox.container.background,
  }
end

return setmetatable(keyboardlayout, { __call = function(_, ...)
    return factory(...)
  end })

-- vim: fdm=indent

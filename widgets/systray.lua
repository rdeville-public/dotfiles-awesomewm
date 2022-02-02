-- DESCRIPTION
-- ========================================================================
-- Widget to show the systray

-- LIBRARY
-- ========================================================================
local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local dpi       = require("beautiful.xresources").apply_dpi

-- VARIABLES
-- ========================================================================
local systray = {}

-- WIDGET
-- ========================================================================
local function factory(args)
  local args = args or {}
  args.bg    = args.bg    or beautiful.systray_bg    or gears.bg.rect
  args.shape = args.shape or beautiful.systray_shape or gears.shape.rect

  return wibox.container.background {
    {
      wibox.widget.systray(),
      left = dpi(beautiful.wibar_height),
      right = dpi(beautiful.wibar_height),
      widget = wibox.container.margin,
    },
    bg = args.bg,
    shape = args.shape,
    widget = wibox.container.background,
  }
end

return setmetatable(systray, { __call = function(_, ...)
    return factory(...)
  end })

-- vim: fdm=indent

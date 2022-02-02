-- DESCRIPTION
-- ========================================================================
-- Widget to show the tasklist

-- LIBRARY
-- ========================================================================
local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local dpi          = require("beautiful.xresources").apply_dpi

-- VARIABLES
-- ========================================================================
local tasklist = {}

-- WIDGET
-- ========================================================================
local function factory(screen)
  return awful.widget.tasklist {
    screen   = screen,
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
          color = beautiful.tasklist_bg_normal,
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
    forced_width = beautiful.wibar_height,
    widget = wibox.container.background,
  }
end

return setmetatable(tasklist, { __call = function(_, ...)
    return factory(...)
  end })

-- vim: fdm=indent

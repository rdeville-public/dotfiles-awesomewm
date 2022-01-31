-- DESCRIPTION
-- ========================================================================
-- Widget to show the date

-- LIBRARY
-- ========================================================================
-- Required library
local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful")

-- VARIABLES
-- ========================================================================
local dpi                 = require("beautiful.xresources").apply_dpi
-- Directory
local date_dir = awful.util.getdir("config") .. "widgets/date"
local date = {}

-- WIDGET
-- ========================================================================
local function factory(args)
  local args = args or {}

  args.format = args.format or beautiful.date_format or "%a %d %b | %H:%M"
  args.font   = args.font   or beautiful.date_font   or beautiful.font
  args.fg     = args.fg     or beautiful.date_fg     or "#000000"
  args.bg     = args.bg     or beautiful.date_bg     or "#FFFFFF"
  args.shape  = args.shape  or beautiful.date_shape  or gears.shape.rect

  date = wibox.widget {
    {
      {
        {
          format = "<span"  ..
            " font_desc='"  .. args.font .. "'>"  ..
            args.format     ..
            "</span>",
          widget = wibox.widget.textclock,
        },
        layout = wibox.layout.align.horizontal,
      },
      widget = wibox.container.margin(_,15, 15, 0, 0),
    },
    fg = args.fg,
    bg = args.bg,
    shape = args.shape,
    widget = wibox.container.background,
  }

  return date
end

return setmetatable(date, { __call = function(_, ...)
    return factory(...)
  end })

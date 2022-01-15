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
local date_img = date_dir .. "/img/date.svg"
local date = {}

-- METHODS
-- ========================================================================
local parallelogram_left = function(cr, width, height)
  gears.shape.transform(gears.shape.parallelogram)
    :scale(1,-1)
    :translate(0,-height)(cr, dpi(width), dpi(height), dpi(width-height/2))
end

-- WIDGET
-- ========================================================================
local function factory(args)
  local args = args or {}

  args.format = args.format or "%a %d %b | %H:%M"
  args.font   = args.font   or beautiful.date_font  or beautiful.font
  args.fg     = args.fg     or beautiful.date_fg    or "#000000"
  args.bg     = args.bg     or beautiful.date_bg    or "#FFFFFF"
  args.shape  = args.shape  or beautiful.date_shape or parallelogram_left
  args.img    = args.img    or beautiful.date_img   or date_img

  date = wibox.widget {
    {
      {
        {
          {
            widget        = wibox.widget.imagebox,
            image         = args.img,
            resize        = true,
            forced_height = beautiful.wibar_height - dpi(4),
            forced_width  = beautiful.wibar_height - dpi(4),

            opacity       = 100,
            visible       = true,
          },
          widget = wibox.container.margin(_, 0, 5, 2, 2),
        },
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

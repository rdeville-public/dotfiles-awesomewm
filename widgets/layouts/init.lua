-- DESCRIPTION
-- ========================================================================
-- Widget to show the layout

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
local layout_dir = awful.util.getdir("config") .. "widgets/layouts"
local layout_img_dir = layout_dir .. "/img/"
local layout = {}

-- METHODS
-- ========================================================================
local parallelogram_left = function(cr, width, height)
  gears.shape.transform(gears.shape.parallelogram)
    :scale(1,-1)
    :translate(0,-height)(cr, dpi(width), dpi(height), dpi(width-height/2))
end

-- WIDGET
-- ========================================================================
local function factory(s,args)
  local args = args or {}

  args.bg    = args.layout_bg    or beautiful.layout_bg    or "#000000"
  args.fg    = args.layout_fg    or beautiful.layout_fg    or "#FFFFFF"
  args.shape = args.layout_shape or beautiful.layout_shape or parallelogram_left

  layout = wibox.widget {
    {
      awful.widget.layoutbox(s),
      left   = dpi(10),
      widget = wibox.container.margin,
    },
    shape = args.shape,
    fg = args.fg,
    bg = args.bg,
    forced_width = dpi(beautiful.wibar_height+20),
    widget = wibox.container.background,
  }

  return layout

end

return setmetatable(layout, { __call = function(_, ...)
    return factory(...)
  end })

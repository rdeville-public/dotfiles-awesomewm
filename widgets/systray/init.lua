-- DESCRIPTION
-- ========================================================================
-- Widget to show the systray

-- LIBRARY
-- ========================================================================
-- Required library
local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful")
local cairo     = require("lgi").cairo

-- VARIABLES
-- ========================================================================
local dpi                 = require("beautiful.xresources").apply_dpi
-- Directory
local systray_dir = awful.util.getdir("config") .. "widgets/systray"
local systray_img = systray_dir .. "/img/systray.svg"
local systray = {}

-- WIDGET
-- ========================================================================
local function factory(args)
  local args = args or {}

  args.systray_icon_spacing = args.systray_icon_spacing or beautiful.systray_icon_spacing or dpi(10)
  args.bg_systray           = args.bg_systray           or beautiful.bg_systray           or "#000000"

  local function right_img(height)
    -- Create a surface
    local img = cairo.ImageSurface.create(cairo.Format.ARGB32, dpi(height/2), dpi(height))
    -- Create a context
    cr  = cairo.Context(img)
    -- Alternative:
    cr:set_source(gears.color(args.bg_systray))
    -- Add a 10px square path to the context at x=10, y=10
    cr:move_to(dpi(height/2),0)
    cr:line_to(0,dpi(height))
    cr:line_to(0,0)
    cr:close_path()
    -- Actually draw the rectangle on img
    cr:fill()
    return img
  end

  local function left_img(height)
    -- Create a surface
    local img = cairo.ImageSurface.create(cairo.Format.ARGB32, dpi(height/2), dpi(height))
    -- Create a context
    cr  = cairo.Context(img)
    -- Alternative:
    cr:set_source(gears.color(args.bg_systray))
    -- Add a 10px square path to the context at x=10, y=10
    cr:move_to(0,dpi(height))
    cr:line_to(dpi(height/2),dpi(height))
    cr:line_to(dpi(height/2),0)
    cr:close_path()
    cr:rotate(dpi(height/4),dpi(height/2),math.pi)
    -- Actually draw the rectangle on img
    cr:fill()
    return img
  end

  local systray = wibox.widget{
    {
      image = left_img(beautiful.wibar_height),
      widget = wibox.widget.imagebox,
    },
    wibox.container.place(wibox.widget.systray(true)),
    {
      image = right_img(beautiful.wibar_height),
      widget = wibox.widget.imagebox,
    },
    layout = wibox.layout.align.horizontal,
  }

  return systray

end

return setmetatable(systray, { __call = function(_, ...)
    return factory(...)
  end })

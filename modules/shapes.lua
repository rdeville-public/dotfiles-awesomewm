local cairo = require("lgi").cairo
local beautiful = require("beautiful")
local gears = require("gears")

local circle_filled_text = function (color, size, icon_str)
  local surface = cairo.ImageSurface.create("ARGB32",size,size)
  local cr = cairo.Context.create(surface)
  cr:arc(size / 2, size / 2, size / 2, 0, math.pi/2)
  cr:set_source_rgba(color)
  cr.antialias = cairo.Antialias.BEST
  cr:fill()
  cr:move_to(size/2, size/2)
  cr:show_text(icon_str)
  return surface
end

local powerline = gears.shape.powerline

local powerline_inv = function(cr, width, height)
  gears.shape.powerline(cr, width, height, -beautiful.wibar_height/2)
end

return {
  circle_filled_text = circle_filled_text,
  powerline = powerline,
  powerline_inv = powerline_inv,
}

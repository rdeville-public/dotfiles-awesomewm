local cairo = require("lgi").cairo
local beautiful = require("beautiful")
local gears = require("gears")

local function split(string_to_split, separator)
    if separator == nil then separator = "%s" end
    local t = {}

    for str in string.gmatch(string_to_split, "([^".. separator .."]+)") do
        table.insert(t, str)
    end

    return t
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

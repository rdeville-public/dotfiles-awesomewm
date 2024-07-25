local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi

local layout = {}

local function factory(screen, _, args)
  args = args or {}
  args.bg = args.layout_bg or beautiful.layout_bg or "#000000"
  args.fg = args.layout_fg or beautiful.layout_fg or "#ffffff"
  args.timeout = args.timeout or beautiful.layout_timeout or 1
  args.shape = args.layout_shape or beautiful.layout_shape or gears.shape.rect
  args.layout = awful.layout.get(screen).name

  layout = wibox.widget({
    {
      awful.widget.layoutbox(screen),
      left = beautiful.wibar_height,
      widget = wibox.container.margin,
    },
    buttons = require("config.buttons.layout"),
    shape = args.shape,
    fg = args.fg,
    bg = args.bg,
    forced_width = dpi(beautiful.wibar_height * 3),
    widget = wibox.container.background,
  })

  return layout
end

return setmetatable(layout, {
  __call = function(_, ...)
    return factory(...)
  end,
})

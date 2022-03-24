local wibox     = require("wibox")
local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi

-- icon
local widget_icon = wibox.widget{
  {
    {
      id            = "icon",
      image         = beautiful.cc_brightness_icon_path,
      resize        = true,
      forced_height = dpi(16),
      forced_width  = dpi(16),
      widget        = wibox.widget.imagebox
    },
    margins = dpi(4),
    widget  = wibox.container.margin
  },
  bg     = beautiful.cc_brightness_bg_button,
  shape  = gears.shape.circle,
  widget = wibox.container.background
}

-- slider var
local widget_slider = wibox.widget {
  bar_shape        = gears.shape.rounded_rect,
  bar_height       = dpi(3),
  bar_color        = beautiful.bg_focus .. "55",
  bar_active_color = beautiful.bg_focus,

  handle_shape = gears.shape.circle,
  handle_width = dpi(12),
  handle_color = beautiful.bg_focus,

  value = 100,
  minimum = 0,
  maximum = 100,
  forced_height = dpi(20),
  widget = wibox.widget.slider
}

local widget_value = wibox.widget {
  text = "100%" ,
  widget = wibox.widget.textbox,
}

local slider_wrapped = wibox.widget{
    {
      widget_icon,
      right = dpi(25),
      widget = wibox.container.margin,
    },
    widget_slider,
    {
      widget_value,
      left = dpi(25),
      widget = wibox.container.margin,
    },
    spacing = dpi(15),
    layout = wibox.layout.align.horizontal
}

local set_brightness = function(value)
  awful.spawn.with_shell('xbacklight -set ' .. value)
  widget_value.text = value .. "%"
end


local update_brightness = function ()
  awful.spawn.easy_async_with_shell(
    "xbacklight -get",
    function(stdout)
      widget_slider.value = tonumber(stdout)
      widget_value.text = math.floor(tonumber(stdout)) .. "%"
    end
  )
end

-- Hover thingy
widget_slider:connect_signal("mouse::enter", function(c)
  local wb = mouse.current_wibox
  old_cursor, old_wibox = wb.cursor, wb
  wb.cursor = "hand1"
end)

widget_slider:connect_signal("mouse::leave", function(c)
  if old_wibox then
      old_wibox.cursor = old_cursor
      old_wibox = nil
  end
end)

-- When sliding happens
widget_slider:connect_signal(
  "property::value",
  function(_,value)
    set_brightness(value)
  end
)

awesome.connect_signal("update::brightness", function ()
  update_brightness()
end)

update_brightness()

return slider_wrapped






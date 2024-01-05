local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local awesome = awesome

-- Slider
local widget_icon  = wibox.widget{
  id            = "icon",
  image         = beautiful.cc_volume_normal_icon_path,
  resize        = true,
  forced_height = dpi(16),
  forced_width  = dpi(16),
  widget        = wibox.widget.imagebox
}
local widget_button = wibox.widget{
  {
    widget_icon,
    margins = dpi(4),
    widget  = wibox.container.margin
  },
  bg     = beautiful.cc_volume_bg_button,
  shape  = gears.shape.circle,
  widget = wibox.container.background
}
-- slider var
local widget_slider = wibox.widget {
  bar_shape        = gears.shape.rounded_rect,
  bar_height       = dpi(3),
  bar_color        = beautiful.bg_focus .. "55",
  bar_active_color = beautiful.bg_focus,

  handle_shape     = gears.shape.circle,
  handle_width     = dpi(12),
  handle_color     = beautiful.bg_focus,

  value            = 40,
  minimum          = 0,
  maximum          = 100,
  forced_height    = dpi(20),
  widget           = wibox.widget.slider
}

local widget_value = wibox.widget {
  text = "100%" ,
  widget = wibox.widget.textbox,
}

local slider_wrapped = wibox.widget{
  {
    widget_button,
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

local update_volume = function ()
  awful.spawn.easy_async_with_shell(
    [[bash -c "amixer -D pulse sget Master"]],
    function (stdout)
      local volume = string.match(stdout, '(%d?%d?%d)%%')
      widget_slider.value = tonumber(volume)
    end
  )
end


local update_volume_icon = function()
  awful.spawn.easy_async(
    [[ sh -c "pacmd list-sinks | awk '/muted/ { print \$2 }'"]],
    function(stdout)
      if stdout:match("yes") then
        widget_icon:set_image(beautiful.cc_volume_muted_icon_path)
        widget_slider:set_bar_color(beautiful.cc_volume_muted_color .. "55" )
        widget_slider:set_bar_active_color(beautiful.cc_volume_muted_color)
        widget_slider:set_handle_color(beautiful.cc_volume_muted_color)
      elseif stdout:match("no") then
        update_volume()
        widget_icon:set_image(beautiful.cc_volume_normal_icon_path)
        widget_slider:set_bar_color(beautiful.cc_volume_normal_color .. "55" )
        widget_slider:set_bar_active_color(beautiful.cc_volume_normal_color)
        widget_slider:set_handle_color(beautiful.cc_volume_normal_color)
      end
    end
  )
end

local toggle_mute = function()
  awful.spawn.easy_async(
    'amixer -D pulse set Master 1+ toggle',
    function(_)
      update_volume_icon()
    end
  )
end

local set_volume = function(vol)
  awful.spawn.with_shell('amixer -D pulse sset Master ' .. vol .. '%')
  widget_value.text = vol .. "%"
end


-- Hover thingy
local old_cursor, old_wibox
widget_button:connect_signal("mouse::enter", function(c)
  local wb = mouse.current_wibox
  old_cursor, old_wibox = wb.cursor, wb
  wb.cursor = "hand1"
end)

widget_button:connect_signal("mouse::leave", function(c)
  if old_wibox then
      old_wibox.cursor = old_cursor
      old_wibox = nil
  end
end)
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
    --local v = math.floor((value-0)/(170-0) * (100-0) + 0)
    set_volume(value)
  end
)


widget_button:connect_signal(
  "button::press",
  function(_,_,_, button)
    if (button == 1) then
      toggle_mute()
    end
  end
)

awesome.connect_signal("update::volume", function ()
  update_volume()
end)

awesome.connect_signal("toggle::mute", function ()
  toggle_mute()
end)

update_volume()
update_volume_icon()

return slider_wrapped

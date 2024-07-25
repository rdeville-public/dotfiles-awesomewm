local awful = require("awful")
local beautiful = require("beautiful")
local create_button = require("widgets.control_center.buttons.create-button")

local initial_action = function(button)
  local background = button:get_children_by_id("background")[1]
  local label = button:get_children_by_id("label")[1]

  awful.spawn.easy_async_with_shell("rfkill list all -o SOFT", function(stdout)
    if stdout:match("blocked") then
      if stdout:match("unblocked") then
        background:set_bg(beautiful.cc_button_airplaine_inactive)
        label:set_text("Off")
      else
        background:set_bg(beautiful.cc_button_airplaine_active)
        label:set_text("On")
      end
    end
  end)
end

local onclick_action = function(button)
  local background = button:get_children_by_id("background")[1]
  local label = button:get_children_by_id("label")[1]

  awful.spawn.easy_async("rfkill list all -o SOFT", function(stdout)
    if stdout:match("blocked") then
      if stdout:match("unblocked") then
        awful.spawn.with_shell("rfkill block all")
        background:set_bg(beautiful.cc_button_airplaine_active)
        label:set_text("On")
      else
        awful.spawn.with_shell("rfkill unblock all")
        background:set_bg(beautiful.cc_button_airplaine_inactive)
        label:set_text("Off")
      end
    end
  end)
end

local airplane_button =
  create_button.circle_big(beautiful.cc_airplaine_icon_path)

airplane_button:connect_signal("button::press", function(self)
  onclick_action(self)
end)

initial_action(airplane_button)

return airplane_button

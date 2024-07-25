---@diagnostic disable undefined-global
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi

local create_button = require("widgets.control_center.buttons.create-button")

local power_button = create_button.small({
  icon = beautiful.cc_icon_power_path,
  bg = beautiful.cc_popup_default_btn_bg .. "44",
  width = dpi(50),
  height = dpi(50),
})

power_button:connect_signal("button::press", function(_, _, _, button)
  if button == 1 then
    awesome.emit_signal("control-center::hide")
    awesome.emit_signal("module::exit_screen:show")
  end
end)

return power_button

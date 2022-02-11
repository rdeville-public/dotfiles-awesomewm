-- DESCRIPTION
-- ========================================================================
-- Widget allowing to logout when clicked
-- Greatly inspired from : https://github.com/Mofiqul/awesome-shell

-- LIBRARY
-- ========================================================================
-- Awesome library
-- ------------------------------------------------------------------------
local gears     = require("gears")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local awful     = require("awful")
local dpi       = require("beautiful.xresources").apply_dpi

-- Control Center library
-- ------------------------------------------------------------------------
local create_button    = require("widgets.control_center.buttons.create-button")

-- WIDGET
-- ========================================================================
-- Power button
local power_button = create_button.small({
  icon   = beautiful.cc_icon_power_path,
  bg     = beautiful.cc_popup_default_btn_bg .. "44",
  width  = dpi(50),
  height = dpi(50),
})

power_button:connect_signal("button::press",
  function (_, _, _, button)
    if button == 1 then
      awesome.emit_signal("control-center::hide")
      awesome.emit_signal('module::exit_screen:show')
    end
  end
)

return power_button

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

-- WIDGET
-- ========================================================================
-- Sign Out Button
local logout_button = wibox.widget{
  {
    {
      align  = "center",
      valign = "center",
      widget = wibox.widget.textbox,
      font   = beautiful.font_name .. " " .. beautiful.font_size * 1.25,
      text   = "Sign out",
    },
    widget = wibox.container.margin(_, dpi(15), dpi(15), 0, 0)
  },
  fg     = beautiful.cc_logout_fg,
  bg     = beautiful.cc_logout_bg,
  shape  = gears.shape.rounded_bar,
  widget = wibox.container.background,
}

logout_button:connect_signal("button::press", function (_, _, _, button)
  if button == 1 then
    awesome.quit()
  end
end)

return logout_button

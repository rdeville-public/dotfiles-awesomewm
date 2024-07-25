---@diagnostic disable undefined-global
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi

local logout_button = wibox.widget({
  {
    {
      align = "center",
      valign = "center",
      widget = wibox.widget.textbox,
      font = beautiful.font_name .. " " .. beautiful.font_size * 1.25,
      text = "Sign out",
    },
    widget = wibox.container.margin(nil, dpi(15), dpi(15), 0, 0),
  },
  fg = beautiful.cc_logout_fg,
  bg = beautiful.cc_logout_bg,
  shape = gears.shape.rounded_bar,
  widget = wibox.container.background,
})

logout_button:connect_signal("button::press", function(_, _, _, button)
  if button == 1 then
    awesome.quit()
  end
end)

return logout_button

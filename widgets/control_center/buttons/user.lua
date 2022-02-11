-- DESCRIPTION
-- ========================================================================
-- Widget showing user information in the control center
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
-- Username
local username = wibox.widget{
  text   = beautiful.cc_user_name or "Devops",
  font   = beautiful.font_name .. " " .. beautiful.font_size * 1.25,
  valign = "center",
  align  = "center",
  widget = wibox.widget.textbox,
}

if not beautiful.cc_user_name then
  awful.spawn.easy_async(
    "whoami",
    function(stdout)
      username:set_text(stdout:gsub("^%l", string.upper):gsub("%s+", ""))
    end
  )
end

-- User image and name
local user = wibox.widget{
  {
    {
      {
        image         = beautiful.cc_user_icon or gears.filesystem.get_configuration_dir() ..  "theme/icons/control_center/default_user.svg",
        resize        = true,
        forced_width  = dpi(42),
        forced_height = dpi(42),
        clip_shape    = gears.shape.circle,
        widget        = wibox.widget.imagebox,
      },
      username,
      spacing = dpi(10),
      layout  = wibox.layout.fixed.horizontal,
    },
    widget = wibox.container.margin(_, dpi(15), dpi(15), dpi(5), dpi(5)),
  },
  bg     = beautiful.cc_user_bg,
  fg     = beautiful.cc_user_fg,
  shape  = gears.shape.rounded_bar,
  widget = wibox.container.background,
}

return user

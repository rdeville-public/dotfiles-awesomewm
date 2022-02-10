-- DESCRIPTION
-- ========================================================================
-- Widget to show a notification button to show the notification center

-- LIBRARY
-- ========================================================================
local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local dpi       = require("beautiful.xresources").apply_dpi
local rofi      = require("modules.rofi")

-- VARIABLES
-- ========================================================================
local notif_center = {}

local notif_center_button = gears.table.join(
  awful.button({ }, 1,         --Left click
    function(screen)
      local notif_center_popup = require("widgets.notif_center.notif_popup")
      notif_center_popup(screen).visible = not notif_center_popup().visible
    end
  )
)

-- METHOD
-- ========================================================================
local function factory(args)
  local args = args or {}
  args.font    = args.font              or beautiful.notif_center_font    or beautiful.font
  args.fg      = args.fg                or beautiful.notif_center_fg      or "#000000"
  args.bg      = args.bg                or beautiful.notif_center_bg      or "#FFFFFF"
  args.shape   = args.shape             or beautiful.notif_center_shape   or gears.shape.rect
  args.icon    = args.icon              or beautiful.notif_center_icon    or ""

  notif_center = wibox.widget {
    {
      {
        {
          text = args.icon,
          widget = wibox.widget.textbox,
        },
        layout = wibox.layout.align.horizontal,
      },
      widget = wibox.container.margin(_, 15, 15, 0, 0),
    },
    fg           = args.fg,
    bg           = args.bg,
    buttons      = notif_center_button,
    font         = args.font,
    shape        = args.shape,
    widget       = wibox.container.background,
  }

  return notif_center
end

return setmetatable(notif_center, { __call = function(_, ...)
    return factory(...)
  end })

-- vim: fdm=indent

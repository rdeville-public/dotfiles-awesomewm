
-- DESCRIPTION
-- ========================================================================
-- Widget to show the notification center

-- LIBRARY
-- ========================================================================
local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local dpi       = require("beautiful.xresources").apply_dpi
local rofi      = require("modules.rofi")

-- METHOD
-- ========================================================================
local notif_center_popup = function(screen, args)
  local args = args or {}
  args.font    = beautiful.notif_center_popup_font    or beautiful.font
  args.fg      = beautiful.notif_center_popup_fg      or "#000000"
  args.bg      = beautiful.notif_center_popup_bg      or "#FFFFFF"
  args.shape   = beautiful.notif_center_popup_shape   or gears.shape.rect
  args.icon    = beautiful.notif_center_popup_icon    or ""
  args.width   = beautiful.notif_center_popup_width   or 400
  args.x       = beautiful.notif_center_popup_x       or 0
  args.y       = beautiful.notif_center_popup_y       or beautiful.wibar_height
  args.height  = beautiful.notif_center_popup_height  or 800

  popup = wibox.widget {
    {
      {
        {
          {
            {
              {
                markup = '<b>Notification Center</b>',
                font   = beautiful.font,
                align  = "center",
                valign = "center",
                widget = wibox.widget.textbox,
              },
              nil,
              --require("widgets.notif_center.clear-all"),
              expand = "none",
              spacing = dpi(10),
              layout = wibox.layout.align.horizontal,
            },
            --require('widgets.notif_center.build-notifbox'),
            spacing = dpi(10),
            layout = wibox.layout.fixed.vertical,
          },
          expand = "none",
          layout = wibox.layout.fixed.horizontal,
        },
        widget = wibox.container.margin(_, 10, 10, 10, 10),
      },
      forced_height = args.height,
      forced_width  = args.width,
      layout = wibox.layout.fixed.vertical,
    },
    --[[
    fg      = args.fg,
    bg      = args.bg,
    font    = args.font,
    shape   = args.shape,
    ontop   = true,
    width   = args.width,
    height  = args.height,
    widget  = wibox.container.background,
    visible = false,
    --]]
    visible = false,
    ontop = true,
    x = args.x,
    y = args.y,
  }

  local mouseInPopup = false

  local timer = gears.timer {
    timeout   = 1.25,
    single_shot = true,
    callback  = function()
      if not mouseInPopup then
        popup.visible = false
      end
    end
  }

  popup:connect_signal("mouse::leave", function()
    if popup.visible then
      mouseInPopup = false
      timer:again()
    end
  end)

  popup:connect_signal("mouse::enter", function()
    mouseInPopup = true
  end)

  function popup:toggle()
    self.visible = not self.visible
  end

  return popup
end

return notif_center_popup

-- vim: fdm=indent

--[[
local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = require('beautiful').xresources.apply_dpi

local popupLib = {}

popupLib.create = function(x, y, height, width, widget)
  local popupWidget = awful.popup {
    {
      {
        {
          {
            {
              {
                markup = '<b>Notification Center</b>',
                font   = beautiful.font,
                align  = "center",
                valign = "center",
                widget = wibox.widget.textbox,
              },
              nil,
              require("widgets.notif_center.clear-all"),
              expand = "none",
              spacing = dpi(10),
              layout = wibox.layout.align.horizontal,
            },
            require('widgets.notif_center.build-notifbox'),
            spacing = dpi(10),
            layout = wibox.layout.fixed.vertical,
          },
          notif_center,
          expand = "none",
          layout = wibox.layout.fixed.horizontal,
        },
        margins = dpi(10),
        widget = wibox.container.margin,
      },
      forced_height = height,
      forced_width = width,
      layout = wibox.layout.fixed.vertical,
    },
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
    end,
    visible = false,
    ontop = true,
    x = x,
    y = y,
  }

  local mouseInPopup = false
  local timer = gears.timer {
    timeout   = 1.25,
    single_shot = true,
    callback  = function()
      if not mouseInPopup then
        popupWidget.visible = false
      end
    end
  }

  popupWidget:connect_signal("mouse::leave", function()
    if popupWidget.visible then
      mouseInPopup = false
      timer:again()
    end
  end)

  popupWidget:connect_signal("mouse::enter", function()
    mouseInPopup = true
  end)

  return popupWidget
end

local width = 400
local margin = 10

local popup = popupLib.create(awful.screen.focused().geometry.width - width - 10, beautiful.wibar_height + 5, nil, width, popupWidget)

return popup

--]]

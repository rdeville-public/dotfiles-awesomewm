-- DESCRIPTION
-- ========================================================================
-- Configuration of the control center
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

-- Personal library
-- ------------------------------------------------------------------------
local shapes    = require("modules.shapes")

-- Control Center library
-- ------------------------------------------------------------------------
local create_button    = require("widgets.control_center.buttons.create-button")
local btn_container    = require("widgets.clickable-container")

--local network_widget = require("widgets.buttons.network-button")
--local battery_widget = require("widgets.buttons.battery")
--local volume_widget = require("widgets.volume-slider-and-indicator")

local control_center = function (s)
  -- Widget to show on panel
  local control_widget = wibox.widget{
    {
      {
        {
          {
            text = beautiful.control_center_icon or " ",
            widget = wibox.widget.textbox,
          },
          spacing = dpi(4),
          layout = wibox.layout.fixed.horizontal
        },
        widget = wibox.container.place
      },
      id = "background",
      widget = wibox.container.margin(_,15,15,0,0)
    },
    bg     = beautiful.control_center_bg or "#000000",
    fg     = beautiful.control_center_fg or "#FFFFFF",
    shape  = beautiful.control_center_shape or gears.shape.powerline,
    widget = wibox.container.background,
  }

  --- Session and user widget
  local session_widget = wibox.widget{
    require("widgets.control_center.buttons.user"),
    nil,
    {
      nil,
      require("widgets.control_center.buttons.logout"),
      require("widgets.control_center.buttons.power"),
      layout = wibox.layout.align.horizontal,
    },
    layout = wibox.layout.align.horizontal,
  }

  --- Control buttons
  local button_row_1= wibox.widget{
    --network_widget.network_button,
    --require("widgets.buttons.dnd"),
    --require("widgets.buttons.redshift"),
    --require("widgets.buttons.airplane"),
    spacing = beautiful.widget_margin,
    layout = wibox.layout.fixed.horizontal
  }
  local button_row_2 = wibox.widget{
    --require("widgets.buttons.bluetooth-button"),
    --require("widgets.buttons.global-floating-mode"),
    --require("widgets.buttons.screen-shot")(s),
    --require("widgets.buttons.microphone"),
    --require("widgets.buttons.software-update"),
    spacing = beautiful.widget_margin,
    layout = wibox.layout.fixed.horizontal
  }


  local control_buttons = wibox.widget{
    {
      {
        button_row_1,
        widget = wibox.container.place
      },
      {
        button_row_2,
        widget = wibox.container.place
      },
      spacing = beautiful.useless_gap * 2 ,
      layout = wibox.layout.fixed.vertical
    },
    top = dpi(15),
    bottom = dpi(15),
    widget = wibox.container.margin
  }

  --[[
  -- Function to split sting
  function str_split (inputstr, sep)
     if sep == nil then
         sep = "%s"
     end
     local t={}
     for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
         table.insert(t, str)
     end
     return t
  end
  --]]

  local slider_contols = wibox.widget{
    layout = wibox.layout.fixed.vertical,
    spacing = dpi(10),
    --volume_widget.slider,
    --require("widgets.brightness-slider"),
  }


  local space = wibox.widget{
    widget = wibox.container.margin,
    top = dpi(10)
  }

  --[[
  table.insert(rows, session_widget)
  table.insert(rows, control_buttons)
  table.insert(rows, space)
  table.insert(rows, slider_contols)
  --]]

  local notif_center = wibox.widget{
    require("widgets.control_center.notif_center"),
    top = dpi(20),
    widget = wibox.container.margin
  }

  notification = require("naughty").notify({
    preset     = fs_notification_preset,
    text       = "Notitication text",
    title      = "Notification Title",
    icon       = beautiful.cc_popup_default_btn_icon,
    timeout    = 5,
    screen     = mouse.screen,
  })

  local rows = {
    session_widget,
    control_buttons,
    space,
    slider_contols,
    notif_center,
    layout = wibox.layout.fixed.vertical,
  }


  local control_popup = awful.popup{
    widget    = {},
    bg        = beautiful.cc_popup_bg,
    fg        = beautiful.cc_popup_fg,
    shape     = beautiful.cc_popup_shape,
    width     = beautiful.cc_popup_width,
    ontop     = true,
    visible   = true,
    screen    = s,
    placement = function (w)
      awful.placement.top_right(w, {
        margins  = {
          left   = 0,
          top    = beautiful.wibar_height * 1.75,
          bottom = 0,
          right  = beautiful.useless_gap,
        }
      })
    end
  }

  control_popup:setup({
    {
      rows,
      widget = wibox.container.margin(_, 25, 25, 25, 25),
    },
    forced_width  = s.geometry.width / 5,
    forced_height = s.geometry.height - (beautiful.wibar_height * 2),
    widget        = wibox.container.background,
  })

  control_widget:connect_signal("button::press", function (self, _, _, button)
    if button == 1 then
        if control_popup.visible then
          control_popup.visible = not control_popup.visible
        else
          control_popup.visible = true
        end
    end
  end)


  awesome.connect_signal("control-center::hide", function ()
    control_popup.visible = false
  end)

  awesome.connect_signal("control-center::show", function ()
    control_popup.visible = true
  end)

  return control_widget
end


return control_center

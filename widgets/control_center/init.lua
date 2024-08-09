local awful = require("awful")
local beautiful = require("beautiful")
local colors = require("utils.colors")
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")
local shapes = require("utils.shapes")
local wibox = require("wibox")

local control_center = function(s)
  -- Widget to show on wibar
  local control_widget = wibox.widget({
    {
      {
        text = beautiful.cc_icon or "󰉺 ",
        widget = wibox.widget.textbox,
      },
      widget = wibox.container.margin(nil, 15, 15, 0, 0),
    },
    bg = beautiful.cc_bg or colors.grey_800,
    fg = beautiful.cc_fg or colors.grey_300,
    shape = beautiful.cch_shape or shapes.powerline_inv,
    widget = wibox.container.background,
  })

  local control_popup = awful.popup({
    widget = {},
    bg = beautiful.cc_popup_bg or beautiful.cc_bg or colors.grey_900,
    fg = beautiful.cc_popup_fg or beautiful.cc_fg or colors.grey_300,
    shape = beautiful.cc_popup_shape or gears.shape.rounded_rect,
    ontop = true,
    -- Hide control center by default
    visible = false,
    screen = s,
    placement = function(w)
      awful.placement.top_right(w, {
        margins = {
          left = 0,
          top = beautiful.wibar_height * 1.75,
          bottom = 0,
          right = beautiful.useless_gap,
        },
      })
    end,
  })

  control_popup:setup({
    {
      {
        require("widgets.control_center.buttons.user"),
        {
          {
            -- Session buttons
            require("widgets.control_center.buttons.lock"),
            require("widgets.control_center.buttons.logout"),
            require("widgets.control_center.buttons.power"),
            layout = wibox.layout.flex.horizontal,
          },
          {
            -- Connectivity buttons
            require("widgets.control_center.buttons.airplane"),
            require("widgets.control_center.buttons.bluetooth"),
            require("widgets.control_center.buttons.network"),
            widget = wibox.layout.flex.horizontal,
          },
          {
            -- Other buttons
            require("widgets.control_center.buttons.microphone"),
            require("widgets.control_center.buttons.do_not_disturb"),
            require("widgets.control_center.buttons.redshift"),
            widget = wibox.layout.flex.horizontal,
          },
          spacing = dpi(25),
          layout = wibox.layout.fixed.vertical,
        },
        {
          -- require("widgets.control_center.sliders.brightness"),
          -- require("widgets.control_center.sliders.volume"),
          layout = wibox.layout.fixed.vertical,
          spacing = dpi(10),
        },
        {
          require("widgets.control_center.notif_center"),
          top = dpi(20),
          widget = wibox.container.margin,
        },
        spacing = dpi(20),
        layout = wibox.layout.fixed.vertical,
      },
      widget = wibox.container.margin(nil, 25, 25, 25, 25),
    },
    forced_width = s.geometry.width / 5,
    forced_height = s.geometry.height - (beautiful.wibar_height * 2),
    widget = wibox.container.background,
  })

  control_widget:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
      if control_popup.visible then
        control_popup.visible = not control_popup.visible
      else
        control_popup.visible = true
      end
    end
  end)

  ---@diagnostic disable-next-line:undefined-global
  awesome.connect_signal("control-center::toggle", function()
    control_popup.visible = not control_popup.visible
  end)

  ---@diagnostic disable-next-line:undefined-global
  awesome.connect_signal("control-center::hide", function()
    control_popup.visible = false
  end)

  ---@diagnostic disable-next-line:undefined-global
  awesome.connect_signal("control-center::show", function()
    control_popup.visible = true
  end)

  return control_widget
end

return control_center

---@diagnostic disable undefined-global
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")

client.connect_signal("request::titlebars", function(c)
  local titlebar_button = gears.table.join(
    awful.button({}, 1, function()
      c:emit_signal("request::activate", "titlebar", { raise = true })
      awful.mouse.client.move(c)
    end),
    awful.button({}, 3, function()
      c:emit_signal("request::activate", "titlebar", { raise = true })
      awful.mouse.client.resize(c)
    end)
  )

  awful
    .titlebar(c, {
      size = dpi(beautiful.titlebar_size) or dpi(20),
    })
    :setup({
      {
        -- Left
        {
          {
            -- add margin around titlebar icons
            awful.titlebar.widget.iconwidget(c),
            layout = wibox.container.margin,
            left = beautiful.titlebar_size / 2,
            top = 2,
            bottom = 2,
            right = beautiful.titlebar_size * 2,
          },
          widget = wibox.container.background,
          bg = beautiful.titlebar_left_bg or beautiful.titlebar_bg or "#000000",
          shape = beautiful.titlebar_left_shape,
        },
        buttons = titlebar_button,
        layout = wibox.layout.fixed.horizontal,
      },
      {
        -- Middle
        {
          -- Title
          align = "center",
          widget = awful.titlebar.widget.titlewidget(c),
        },
        buttons = titlebar_button,
        layout = wibox.layout.flex.horizontal,
      },
      {
        -- Right
        {
          {
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.minimizebutton(c),
            awful.titlebar.widget.closebutton(c),
            spacing = beautiful.titlebar_size / 4,
            layout = wibox.layout.fixed.horizontal(),
          },
          widget = wibox.container.margin,
          top = dpi(beautiful.titlebar_size / 5),
          bottom = dpi(beautiful.titlebar_size / 5),
          right = dpi(beautiful.titlebar_size / 2),
          left = dpi(beautiful.titlebar_size * 2),
        },
        widget = wibox.container.background,
        bg = beautiful.titlebar_right_bg or beautiful.titlebar_bg or "#000000",
        shape = beautiful.titlebar_right_shape,
      },
      layout = wibox.layout.align.horizontal,
    })
end)

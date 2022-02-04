-- DESCRIPTION
-- ========================================================================
-- Widget to show the titlebar

-- LIBRARY
-- ========================================================================
local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = require("beautiful.xresources").apply_dpi

-- WIDGET
-- ========================================================================
client.connect_signal("request::titlebars",
  function(c)
    awful.titlebar(c,
      {
        size = dpi(beautiful.titlebar_size) or dpi(20),
      }
    ) : setup {
      {
        -- Left
        {
          -- add margin around titlebar icons
          awful.titlebar.widget.iconwidget(c),
          layout = wibox.container.margin,
          top = 5,
          left = 5,
          bottom = 5
        },
        buttons = buttons,
        layout  = wibox.layout.fixed.horizontal
      },
      {
          -- Middle
        {
          -- Title
          align  = "center",
          widget = awful.titlebar.widget.titlewidget(c)
        },
        buttons = buttons,
        layout  = wibox.layout.flex.horizontal
      },
      {
        -- Right
        {
          awful.titlebar.widget.floatingbutton(c),
          awful.titlebar.widget.stickybutton(c),
          awful.titlebar.widget.ontopbutton(c),
          awful.titlebar.widget.maximizedbutton(c),
          awful.titlebar.widget.minimizebutton(c),
          awful.titlebar.widget.closebutton(c),
          layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.container.margin,
        top = 3,
        left = 3,
        right = 3,
        bottom = 3
      },
      layout = wibox.layout.align.horizontal
    }
  end)

local beautiful = require("beautiful")
local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local dpi       = require("beautiful.xresources").apply_dpi

-- Signal function to execute when a new client appears.
client.connect_signal("mouse::enter",
  function(c)
    -- Enable focus when mouse enter client
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
      and awful.client.focus.filter(c) then
      client.focus = c
    end
  end
)

client.connect_signal("request::manage",
  function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then
      awful.client.setslave(c)
    end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
    --[[ if c.first_tag.layout.name == "floating" then
       [   if not c.floating then
       [     c.floating = true
       [     awful.titlebar.show(c)
       [   end
       [ end ]]
  end)

client.connect_signal("request::activate",
  -- Color border of newly activated client
  function(c)
    c.border_color = beautiful.border_focus
  end
)

client.connect_signal("focus",
  -- Color border of focus client
    function(c)
    c.border_color = beautiful.border_focus
  end
)

client.connect_signal("unfocus",
  -- Uncolor border of unfocus client
  function(c)
    c.border_color = beautiful.border_normal
  end
)

client.connect_signal("property::floating",
  function(c)
    if c.floating then
      -- awful.titlebar.show(c)
      c.shape = function(cr, width, height)
        return gears.shape.rounded_rect(cr,width,height,dpi(5))
      end
    else
      -- awful.titlebar.hide(c)
      c.shape = gears.shape.rect
    end
  end)

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)
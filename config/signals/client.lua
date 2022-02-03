local beautiful = require("beautiful")
local awful     = require("awful")
local gears     = require("gears")

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
      awful.titlebar.show(c)
      c.shape = function(cr, width, height)
        return gears.shape.rounded_rect(cr,width,height,10)
      end
    else
      awful.titlebar.hide(c)
      c.shape = nil
    end
  end)


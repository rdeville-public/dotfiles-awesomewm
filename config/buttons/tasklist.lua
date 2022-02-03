local awful = require("awful")
local gears = require("gears")

return gears.table.join(
  awful.button({ }, 1,
    function(c)
      -- LMB on task will (un)minized and give focus
      if c == client.focus then
        c.minimized = true
      else
        -- Without this, the following :isvisible() makes no sense
        c.minimized = false
        if not c:isvisible() and c.first_tag then
          c.first_tag:view_only()
        end
      -- This will also un-minimize the client, if needed
      client.focus = c
      c:raise()
      end
    end,
    {
      description = "\t\tToggle Minimized",
      group = "Tasklist"
    }),
  -- Mouse scroll wheel switch to previous or next task
  awful.button({ }, 4,
    function ()
      awful.client.focus.byidx(1)
    end,
    {
      description = "\t\tSwitch to next task",
      group = "Tasklist"
    }),
  awful.button({ }, 5,
    function ()
      awful.client.focus.byidx(-1)
    end,
    {
      description = "\t\tSwitch to prev task",
      group = "Tasklist"
    })
  )

-- vim: fdm=indent

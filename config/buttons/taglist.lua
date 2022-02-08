local awful = require("awful")
local gears = require("gears")

local modkey        = require("config.keys.mod").modkey
local altkey        = require("config.keys.mod").altkey
local shiftkey      = require("config.keys.mod").shiftkey
local ctrlkey       = require("config.keys.mod").ctrlkey

return gears.table.join(
  awful.button({ }, 1,         --Left click
    function(t)
      t:view_only()
    end),
    --[[
    {
      description = "\t\tView Tag",
      group       = "Taglist",
    },
    --]]
  awful.button({ modkey }, 1,  --Left click
    function(t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
    end),
    --[[
    {
      description = "\t\tMove client to  Tag",
      group       = "Taglist",
    },
    --]]
  awful.button({ }, 3,        -- Right click
    awful.tag.viewtoggle),
    --[[
    {
      description = "\t\tView client of the tag",
      group       = "Taglist",
    },
    --]]
  awful.button({ }, 4,      -- Scroll up
    function(t)
      awful.tag.viewnext(t.screen)
    end),
    --[[
    {
      description = "\t\tView next tag",
      group       = "Taglist",
    }),
    --]]
  awful.button({ }, 5,      -- Scroll down
    function(t)
      awful.tag.viewprev(t.screen)
    end)
    --[[
    {
      description = "\t\tView previous tag",
      group       = "Taglist",
    }
    --]]
)

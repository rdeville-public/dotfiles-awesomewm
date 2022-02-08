local awful = require("awful")
local gears = require("gears")

local modkey        = require("config.keys.mod").modkey
local altkey        = require("config.keys.mod").altkey
local shiftkey      = require("config.keys.mod").shiftkey
local ctrlkey       = require("config.keys.mod").ctrlkey

return gears.table.join(
  awful.button({ }, 1,  --Left click
    function () awful.layout.inc( 1) end),
  awful.button({ }, 3,  --Right Click
    function () awful.layout.inc(-1) end),
  awful.button({ }, 4,  --Scroll up
    function () awful.layout.inc( 1) end),
  awful.button({ }, 5,  --Scroll down
    function () awful.layout.inc(-1) end)
)

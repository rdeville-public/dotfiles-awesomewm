local rofi  = require("modules.rofi")
local awful = require("awful")
local gears = require("gears")

return gears.table.join(
  awful.button({ }, 1,         --Left click
    function()
      rofi.prompt(
        {
          p    = "New keyboard layout",
          dmenu = true,
        },
        function(new_kbl)
          awful.spawn.with_shell("setxkbmap " .. new_kbl)
        end)
    end)
)


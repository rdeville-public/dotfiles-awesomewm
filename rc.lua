-- DESCRIPTION
-- ========================================================================
-- Main configuration files for awesome WM

-- LIBRARY
-- ========================================================================
-- Awesome libraries
-- Main awesome widget library
require("awful.autofocus")
local awful         = require("awful")
-- Awesome wm utility box
local gears         = require("gears")
-- Awesome wm notification library
local naughty       = require("naughty")
-- Main awesome rules library
local ruled         = require("awful.rules")
-- Awesome wm theme library
local beautiful     = require("beautiful")

-- Personal tools, mainly for run_once method
require("modules.utility")

-- GLOBAL CONFIGURATION
-- ========================================================================
-- Set awful sh application
awful.util.shell = "sh"
-- Set prefered icon size
awesome.set_preferred_icon_size(24)
-- Initialize theme variables
beautiful.init(require("theme"))

-- Set taglist, layous and tasklist
awful.util.tagnames         = require("config.tags").tags
awful.layout.layouts        = require("config.layouts")
awful.util.tasklist_buttons = require("config.buttons.tasklist")

-- Set titlebar
require("config.titlebars")

-- Virtual Desktop
-- ------------------------------------------------------------------------
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
  -- Apply theme to each screen
  beautiful.at_screen_connect(s)
end)


-- Set key bindings
local globalkeys = require("config.keys.global")
local clientkeys = require("config.keys.client")
root.keys(globalkeys)

-- Set Signals
require("config.signals.naughty")
require("config.signals.screen")
require("config.signals.tag")
require("config.signals.client")
require("config.signals.ruled")

-- Set rules for client and notification
require("config.ruled.client")

-- STARTUP RUN ONCE
-- ========================================================================
run_once({
  "picom",
  --"redshift",        -- redshift to avoid blue light at night
  --"keynav",          -- manipulation of mouse with keyboard
  "nextcloud",       -- nextcloud client
  "AgentAntidote",        -- Antidote client
  --"xautolock -time 180 -locker ~/.bin/lock &" , -- lock the screen after 180 sec on inactivity
})
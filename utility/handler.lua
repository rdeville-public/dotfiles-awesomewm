-- |========================================================================| --
-- |                                                                        | --
-- | HANDLERS for Awesome 4.0.1                                             | --
-- |                                                                        | --
-- |========================================================================| --
-- |                                                                        | --
-- | Author: Romain Deville                                                 | --
-- | Version: 1.1                                                           | --
-- | Last modified: 2018-12-29                                              | --
-- |                                                                        | --
-- |========================================================================| --

-- | LIBRARY                                                                | --
-- |========================================================================| --
local awful                                 = require("awful")
local naughty                               = require("naughty")
local beautiful                             = require("beautiful")

-- | Error Handling | ---------------------------------------------------------
if awesome.startup_errors
then
  naughty.notify({ preset = naughty.config.presets.critical,
                   title  = "Oops, there were errors during startup!",
                   text   = awesome.startup_errors })
end

do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    if in_error then return end
    in_error = true
    naughty.notify({ preset = naughty.config.presets.critical,
                     title  = "Oops, an error happened!",
                     text   = err })
    in_error = false
  end)
end


-- DESCRIPTION
-- ========================================================================
-- Main configuration files for awesome WM

-- LIBRARY
-- ========================================================================
-- Awesome libraries
-- Main awesome widget library
local awful         = require("awful")
                      require("awful.autofocus")
local hotkeys_popup = require("awful.hotkeys_popup.widget")
-- Awesome wm utility box
local gears         = require("gears")
-- Awesome wm notification library
local naughty       = require("naughty")
-- Awesome wm windows management library
local wibox         = require("wibox")
-- Main awesome rules library
local rules         = require("awful.rules")
local ruled         = require("ruled")
-- Awesome wm theme library
local beautiful     = require("beautiful")

-- Personal tools, mainly for run_once method
                      require("modules.utility")

-- FUNCTIONS
-- ========================================================================
-- Handlers
-- ------------------------------------------------------------------------
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)

-- VARIABLES
-- ========================================================================
-- Global Key
-- ------------------------------------------------------------------------
local modkey   = "Mod4"    -- "Windows" key
local altkey   = "Mod1"    -- "Alt" key
local ctrlkey  = "Control" -- "Ctrl" key
local shiftkey = "Shift"   -- "Shift" key
-- Programs
-- ------------------------------------------------------------------------
local terminal   = "st" or "terminator" or "xterm"
local editor     = os.getenv("EDITOR") or "vim" or "vi" or "nano"
local gui_editor = os.getenv("GUI_EDITOR") or "gvim"
local browser    = os.getenv("BROWSER") or "firefox" or "chromium-browser"
local explorer   = "pcmanfm" or "thunar"

local dpi                 = require("beautiful.xresources").apply_dpi
local theme_name          = "powerdark"
local mouse_raise_windows = false

-- GLOBAL CONFIGURATION
-- ========================================================================
-- Set awful terminal application
awful.util.terminal = terminal
-- Set prefered icon size
awesome.set_preferred_icon_size(24)
-- Set local
os.setlocale(os.getenv("LANG"))
-- Initialize theme variables
beautiful.init(require("theme"))
-- Initialize notification center // From https://github.com/raven2cz/awesomewm-config.git
local popup = require("modules.notifs.notif_center.notif_popup")

-- STARTUP RUN ONCE
-- ========================================================================
run_once({
  "xcompmgr",        -- Composite manager, make term transparent
  --"picom -b --experimental-backends --dbus --config " .. config_path .. '/picom.conf',
  "redshift",        -- redshift to avoid blue light at night
  "unclutter -root", -- hide mouse after 5 sec of inactivity
  "keynav",          -- manipulation of mouse with keyboard
  "nextcloud",       -- nextcloud client
  "xautolock -time 180 -locker ~/.bin/lock &" , -- lock the screen after 180 sec on inactivity
})

-- CONFIGURATION
-- ========================================================================
-- Layout
-- ------------------------------------------------------------------------
local layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
}

local tag_terminal=" "
local tag_browser="爵"
local tag_mail=" "
local tag_pass=" "
local tag_monitor=" "
local tag_filemanager=" "
local tag_steam=" "
local tag_inkscape="縉"
local tag_gimp=" "
local tags = {
  tag_terminal,
  tag_browser,
  tag_mail,
  tag_pass,
  tag_monitor,
}

-- Tag
-- ------------------------------------------------------------------------
-- Set awful taglist
awful.util.tagnames = tags
awful.layout.layouts = layouts

-- Tasklist mouse button management
-- ------------------------------------------------------------------------
awful.util.tasklist_buttons = awful.util.table.join(
  awful.button({ }, 1, function (c)
    -- Right click on task will unminized if minized and give focus to clicked
    -- task
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
  end),
  -- Mouse scroll wheel switch to previous or next task
  awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
  awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)



-- Screen
-- ------------------------------------------------------------------------
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end)

-- Virtual Desktop
-- ------------------------------------------------------------------------
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
  -- Apply theme to each screen
  beautiful.at_screen_connect(s)
end)

-- Key bindings
-- ------------------------------------------------------------------------
local globalkeys = require("config.keys.global")
local clientkeys = require("config.keys.client")
-- Set Global Keys
-- -----------------------------------------------------------------------------
root.keys(globalkeys)

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties =
    {
      border_width     = beautiful.border_width,
      border_color     = beautiful.border_normal,
      focus            = awful.client.focus.filter,
      raise            = true,
      keys             = clientkeys,
      buttons          = clientbuttons,
      screen           = awful.screen.preferred,
      placement        = awful.placement.no_overlap+awful.placement.no_offscreen,
      size_hints_honor = false
   }
  },
  {
    rule_any = { class = { "st", "terminator", "xterm" } },
    properties = { tag = tag_terminal, switch_to_tags = true }
  },
  {
    rule_any = { class = { "firefox", "chromium-browser" } },
    properties = { tag = tag_browser, switch_to_tags = true }
  },
  {
    rule = { class = "thunderbird" },
    properties = { tag = tag_mail, switch_to_tags = true }
  },
  {
    rule = { class = "keepass" },
    properties = { tag = tag_pass, switch_to_tags = true }
  },
  --[[
  {
    rule_any = { TODO Monitor},
    properties = { tag = tag_monitor, switch_to_tags = true }
  },
  --]]
  {
    rule_any = { class = { "explorer" }, instance = { "Thunar", "pcmanfm" } },
    properties = {
      tag = tag_filemanager,
      switch_to_tags = true ,
      new_tag = {
        name = tag_filemanager,
        layout = awful.layout.suit.tile,
        volatile = true,
      },
    }
  },
  {
    rule_any = { class = { "Steam" } },
    properties = {
      tag = tag_steam,
      switch_to_tags = true,
      new_tag = {
        name = tag_steam,
        layout = awful.layout.suit.tile,
        volatile = true,
      },
    },
  },
  {
    rule_any = { class = { "Inkscape" } },
    properties = {
      tag = tag_inkscape,
      new_tag = {
        name = tag_inkscape,
        layout = awful.layout.suit.tile,
        volatile = true,
      },
      switch_to_tags = true
    },
  },
  {
    rule_any = { class = { "Gimp" } },
    properties = {
      tag = tag_gimp,
      new_tag = {
        name = tag_gimp,
        layout = awful.layout.suit.tile,
        volatile = true,
      },
      switch_to_tags = true
    },
  },
}

-- Signals
-- -----------------------------------------------------------------------------
-- Signal function to execute when a new client appears.
client.connect_signal("mouse::enter", function(c)
  -- Enable focus when mouse enter client
  if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
    and awful.client.focus.filter(c) then
    client.focus = c
  end
end)
client.connect_signal("request::activate",
  -- Color border of newly activated client
  function(c)
    c.border_color = beautiful.border_focus
end)
client.connect_signal("focus",
  -- Color border of focus client
  function(c)
    c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus",
  -- Uncolor border of unfocus client
  function(c)
    c.border_color = beautiful.border_normal
end)

-- Notifications
ruled.notification.connect_signal('request::rules', function()
  -- All notifications will match this rule.
  ruled.notification.append_rule {
    rule       = { },
    properties = {
      screen  = awful.screen.focused,
      timeout = 5,
    }
  }
end)

-- Store notifications to the file
naughty.connect_signal("added", function(n)
  local file = io.open(os.getenv("HOME") .. "/.cache/awesome/naughty_history", "a")
  file:write(n.title .. ": " .. n.message .. "\n")
  file:close()
end)

-- vim: fdm=indent

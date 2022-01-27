#!/usr/bin/env lua

-- DESCRIPTION
-- ========================================================================
-- Main configuration files for awesome WM

-- LIBRARY
-- ========================================================================
-- Required libraries
-- ------------------------------------------------------------------------
local os       = os
local string   = string
local ipairs   = ipairs
local tostring = tostring
local tonumber = tonumber
local type     = type

local awesome  = awesome
local client   = client
local mouse    = mouse
local screen   = screen
local tag      = tag

-- Awesome module libraries
-- ------------------------------------------------------------------------
-- Main awesome wm library
local awful         = require("awful")
                      require("awful.autofocus")
local hotkeys_popup = require("awful.hotkeys_popup.widget")
local rules         = require("awful.rules")
-- Awesome wm utility box
local gears         = require("gears")
-- Awesome wm theme library
local beautiful     = require("beautiful")
-- Awesome wm notification library
local naughty       = require("naughty")
-- Awesome wm windows management library
local wibox         = require("wibox")

-- PERSONNAL LIBRARY
-- ========================================================================
-- Update config path to load personnal widgets
local config_path   = awful.util.getdir("config")
package.path        = config_path .. "?.lua;"     .. package.path
package.path        = config_path .. "?/?.lua;"   .. package.path
package.path        = config_path .. "?/?/?.lua;" .. package.path

-- Personal tools, mainly for run_once method
require("utility")

-- FUNCTIONS
-- ========================================================================
-- Handlers
-- ------------------------------------------------------------------------
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, there were errors during startup!",
      text = awesome.startup_errors
    })
end
-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal(
    "debug::error",
    function (err)
      if in_error then return end
      in_error = true
      naughty.notify({ preset = naughty.config.presets.critical,
                       title = "Oops, an error happened!",
                       text = tostring(err) })
      in_error = false
    end)
end

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
local theme_name          = "powerarrow-dark"
local mouse_raise_windows = false

-- GLOBAL CONFIGURATION
-- ========================================================================
-- Set awful terminal application
awful.util.terminal = terminal
-- Set prefered icon size
awesome.set_preferred_icon_size(24)
-- Set local
os.setlocale(os.getenv("LANG"))

-- STARTUP RUN ONCE
-- ========================================================================
run_once({
  "xcompmgr",        -- Composite manager, make term transparent
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

-- Tag
-- ------------------------------------------------------------------------
-- Set awful taglist
awful.util.tagnames = { " ", "爵", " ", " ", " " }
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

beautiful.init(string.format("%s/.config/awesome/theme/%s/theme.lua", os.getenv("HOME"), theme_name))

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
--local globalkeys = awful.util.table.join(
local globalkeys = gears.table.join(
  -- Take a screenshot
  -- https://github.com/lcpz/dots/blob/master/bin/screenshot
  awful.key({ modkey            }, "p",
    function() os.execute("screenshot") end,
    {
      description = "Take a screenshot",
      group = "Hotkeys"
    }),

  -- Hotkeys
  awful.key({ modkey, shiftkey  }, "h",
    hotkeys_popup.show_help,
    {
      description = "Show help",
      group="Awesome"}),
  -- Tag browsing
  awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
            {description = "view previous", group = "tag"}),
  awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
            {description = "view next", group = "tag"}),
  awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
            {description = "go back", group = "tag"}),

  -- Non-empty tag browsing
  --awful.key({ altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end,
  --          {description = "view  previous nonempty", group = "tag"}),
  --awful.key({ altkey }, "Right", function () lain.util.tag_view_nonempty(1) end,
  --          {description = "view  previous nonempty", group = "tag"}),

  -- By direction client focus
  awful.key({ modkey }, "j",
      function()
          awful.client.focus.global_bydirection("down")
          if client.focus then client.focus:raise() end
      end,
      {description = "focus down", group = "client"}),
  awful.key({ modkey }, "k",
      function()
          awful.client.focus.global_bydirection("up")
          if client.focus then client.focus:raise() end
      end,
      {description = "focus up", group = "client"}),
  awful.key({ modkey }, "h",
      function()
          awful.client.focus.global_bydirection("left")
          if client.focus then client.focus:raise() end
      end,
      {description = "focus left", group = "client"}),
  awful.key({ modkey }, "l",
      function()
          awful.client.focus.global_bydirection("right")
          if client.focus then client.focus:raise() end
      end,
      {description = "focus right", group = "client"}),
  awful.key({ modkey,           }, "w", function () awful.util.mymainmenu:show() end,
            {description = "show main menu", group = "awesome"}),

  -- Layout manipulation
  awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
            {description = "swap with next client by index", group = "client"}),
  awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
            {description = "swap with previous client by index", group = "client"}),
  awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
            {description = "focus the next screen", group = "screen"}),
  awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
            {description = "focus the previous screen", group = "screen"}),
  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
            {description = "jump to urgent client", group = "client"}),
  -- Show/Hide Wibox
  awful.key({ modkey }, "b", function ()
          for s in screen do
              s.mywibox.visible = not s.mywibox.visible
              if s.mybottomwibox then
                  s.mybottomwibox.visible = not s.mybottomwibox.visible
              end
          end
      end,
      {description = "toggle wibox", group = "awesome"}),

  -- On the fly useless gaps change
  --awful.key({ altkey, "Control" }, "+", function () lain.util.useless_gaps_resize(1) end,
  --          {description = "increment useless gaps", group = "tag"}),
  --awful.key({ altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end,
  --          {description = "decrement useless gaps", group = "tag"}),

  -- Dynamic tagging
  --[[
  awful.key({ modkey, "Shift" }, "n", function () lain.util.add_tag() end,
            {description = "add new tag", group = "tag"}),
  awful.key({ modkey, "Shift" }, "r", function () lain.util.rename_tag() end,
            {description = "rename tag", group = "tag"}),
  awful.key({ modkey, "Shift" }, "Left", function () lain.util.move_tag(-1) end,
            {description = "move tag to the left", group = "tag"}),
  awful.key({ modkey, "Shift" }, "Right", function () lain.util.move_tag(1) end,
            {description = "move tag to the right", group = "tag"}),
  awful.key({ modkey, "Shift" }, "d", function () lain.util.delete_tag() end,
            {description = "delete tag", group = "tag"}),
  ]]--

  -- Standard program
  awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
            {description = "open a terminal", group = "launcher"}),
  awful.key({ modkey, "Control" }, "r", awesome.restart,
            {description = "reload awesome", group = "awesome"}),
  awful.key({ modkey, "Shift"   }, "q", awesome.quit,
            {description = "quit awesome", group = "awesome"}),

  awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incmwfact( 0.01)          end,
            {description = "increase master width factor", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incmwfact(-0.01)          end,
            {description = "decrease master width factor", group = "layout"}),
  --[[
  awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
            {description = "increase the number of master clients", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
            {description = "decrease the number of master clients", group = "layout"}),
  awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
            {description = "increase the number of columns", group = "layout"}),
  awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
            {description = "decrease the number of columns", group = "layout"}),
  --]]
  awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
            {description = "select next", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
            {description = "select previous", group = "layout"}),

  awful.key({ modkey, "Control" }, "n",
            function ()
                local c = awful.client.restore()
                -- Focus restored client
                if c then
                    client.focus = c
                    c:raise()
                end
            end,
            {description = "restore minimized", group = "client"}),

  -- Dropdown application
  awful.key({ modkey, }, "z", function () awful.screen.focused().quake:toggle() end,
            {description = "dropdown application", group = "launcher"}),

  -- Widgets popups
  --[[
  awful.key({ altkey, }, "h", function () if beautiful.fs then beautiful.fs.show(7) end end,
             {description = "show filesystem", group = "widgets"}),
  awful.key({ altkey, }, "w", function () if beautiful.weather then beautiful.weather.show(7) end end,
            {description = "show weather", group = "widgets"}),
  --]]

  -- Brightness
  awful.key({ }, "XF86MonBrightnessUp", function () os.execute("xbacklight -inc 10") end,
            {description = "+10%", group = "hotkeys"}),
  awful.key({ }, "XF86MonBrightnessDown", function () os.execute("xbacklight -dec 10") end,
            {description = "-10%", group = "hotkeys"}),

  -- ALSA volume control
  --[[
  awful.key({ altkey }, "Up",
      function ()
          os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel))
          beautiful.volume.update()
      end,
      {description = "volume up", group = "hotkeys"}),
  awful.key({ altkey }, "Down",
      function ()
          os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel))
          beautiful.volume.update()
      end,
      {description = "volume down", group = "hotkeys"}),
  awful.key({ altkey }, "m",
      function ()
          os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
          beautiful.volume.update()
      end,
      {description = "toggle mute", group = "hotkeys"}),
  awful.key({ altkey, "Control" }, "m",
      function ()
          os.execute(string.format("amixer -q set %s 100%%", beautiful.volume.channel))
          beautiful.volume.update()
      end,
      {description = "volume 100%", group = "hotkeys"}),
  awful.key({ altkey, "Control" }, "0",
      function ()
          os.execute(string.format("amixer -q set %s 0%%", beautiful.volume.channel))
          beautiful.volume.update()
      end,
      {description = "volume 0%", group = "hotkeys"}),
  --]]

  -- Copy primary to clipboard (terminals to gtk)
  awful.key({ modkey }, "c", function () awful.spawn.with_shell("xsel | xsel -i -b") end,
            {description = "copy terminal to gtk", group = "hotkeys"}),
  -- Copy clipboard to primary (gtk to terminals)
  awful.key({ modkey }, "v", function () awful.spawn.with_shell("xsel -b | xsel") end,
            {description = "copy gtk to terminal", group = "hotkeys"}),

  -- User programs
  awful.key({ modkey }, "q", function () awful.spawn(browser) end,
            {description = "run browser", group = "launcher"}),
  awful.key({ modkey }, "a", function () awful.spawn(gui_editor) end,
            {description = "run gui editor", group = "launcher"}),

  -- Default
  --[[ Menubar
  awful.key({ modkey }, "p", function() menubar.show() end,
            {description = "show the menubar", group = "launcher"})
  --]]
  --[[ dmenu
  awful.key({ modkey }, "x", function ()
          os.execute(string.format("dmenu_run -fn 'Monospace' -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
          beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
      end,
      {description = "show dmenu", group = "launcher"})
  --]]
  -- alternatively use rofi, a dmenu-like application with more features
  -- check https://github.com/DaveDavenport/rofi for more details
  --[[ rofi
  awful.key({ modkey }, "x", function ()
          os.execute(string.format("rofi -show %s -theme %s",
          'run', 'dmenu'))
      end,
      {description = "show rofi", group = "launcher"}),
  --]]
  --
  awful.key({ modkey,          }, "r",
    function ()
        awful.spawn("rofi -show drun")
    end,
            { description = "\tRun dmenu", group = "Awesome"}),
  awful.key({ modkey,          }, "i",
    function ()
        awful.spawn.with_shell("~/.local/bin/dmenu_unicode")
    end,
            { description = "\tRun dmenu to select unicode char", group = "Awesome"}),
  -- Prompt
  awful.key({ modkey }, "x",
            function ()
                awful.prompt.run {
                  prompt       = "Run Lua code: ",
                  textbox      = awful.screen.focused().mypromptbox.widget,
                  exe_callback = awful.util.eval,
                  history_path = awful.util.get_cache_dir() .. "/history_eval"
                }
            end,
            {description = "lua execute prompt", group = "awesome"})
  --]]
)

local clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)



local clientkeys = awful.util.table.join(
-- awful.key({ modkey, ctrlkey  }, "m",      lain.util.magnify_client ),
    awful.key({ modkey, ctrlkey  }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
              {description = "\t Toggle fullscreen", group = "Client"}),
    awful.key({ modkey, ctrlkey   }, "c",      function (c) c:kill() end,
              {description = "\t Send SIGKILL", group = "Client"}),
    awful.key({ modkey, ctrlkey   }, "space",  awful.client.floating.toggle,
              {description = "Toggle floating", group = "Client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen() end,
              {description = "\t Move to screen", group = "Client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop end,
              {description = "\t Toggle keep on top", group = "Client"}),
    awful.key({ modkey,           }, "s",     function (c) c.sticky = not c.sticky          end,
              {description = "\t Toggle sticky client", group = "Client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
              {description = "\t Minimize", group = "Client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
              {description = "\t Maximize", group = "Client"}),
    awful.key({ modkey , shiftkey }, "r",
        function () screen.focused().mypromptbox:run() end,
            {description = "\t Run prompt", group = "Client"})
)


-- Bind all key numbers to tags.
-- ------------------------------------------------------------------------
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
      awful.key({ modkey,         }, "#" .. i + 9,
      function ()
            local screen = mouse.screen
            local tag = awful.tag.gettags(screen)[i]
            if tag then
              awful.tag.viewonly(tag)
            end
      end),
      awful.key({ modkey, ctrlkey }, "#" .. i + 9,
      function ()
          local screen = mouse.screen
          local tag = awful.tag.gettags(screen)[i]
          if tag then
             awful.tag.viewtoggle(tag)
          end
      end),
      awful.key({ modkey, shiftkey }, "#" .. i + 9,
      function ()
          local tag = awful.tag.gettags(client.focus.screen)[i]
          if client.focus and tag then
              awful.client.movetotag(tag)
           end
      end)
  )
end

-- Set Global Keys
-- -----------------------------------------------------------------------------
root.keys(globalkeys)

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
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


--[[

  -- Global Key bindings
  local globalkeys = awful.util.table.join(
    -- Show Hotkeys
    awful.key({ modkey, ctrlkey }, "h", awful.hotkeys_popup.show_help,
              { description="\tShow this help", group="Awesome" }),
    -- Take a screenshot
    -- https://github.com/copycat-killer/dots/blob/master/bin/screenshot
    awful.key({ altkey,          }, "p",
      function()
        awful.spawn.with_shell("~/.bin/screenshot")
      end,
              { description="\t\tTake screenshot", group="Awesome" }),
    awful.key({ modkey, shiftkey }, "r",
      function ()
          screen.focused().mypromptbox:run()
      end,
              { description = "\tRun prompt", group = "Awesome"}),
    awful.key({ modkey,          }, "F2",       function () screen.focus(2) end,
              { description = "\tSwitch focus to screen", group = "Awesome"}),
    awful.key({ modkey,          }, "F1",       function () screen.focus(1) end,
              { description = "\tSwitch focus to screen", group = "Awesome"}),
    awful.key({ modkey,          }, "F3",       function () screen.focus(3) end,
              { description = "\tSwitch focus to screen", group = "Awesome"}),

    -- Tag browsing
    awful.key({ modkey,          }, "h",     awful.tag.viewprev,
              { description = "\tSwitch tag", group = "Awesome"}),
    awful.key({ modkey,          }, "Left",     awful.tag.viewprev,
              { description = "\tSwitch tag", group = "Awesome"}),
    awful.key({ modkey,          }, "l",    awful.tag.viewnext,
              { description = "\tSwitch tag", group = "Awesome"}),
    awful.key({ modkey,          }, "Right",    awful.tag.viewnext,
              { description = "\tSwitch tag", group = "Awesome"}),

    -- Non-empty tag browsing
    awful.key({ altkey,          }, "Left",  function () lain.util.tag_view_nonempty(-1) end,
              { description = "\tSwitch non-empty tag", group = "Awesome"}),
    awful.key({ altkey,          }, "Right", function () lain.util.tag_view_nonempty(1) end,
              { description = "\tSwitch non-empty tag", group = "Awesome"}),

    -- Default client focus
    awful.key({ modkey,          }, "k",
      function ()
        awful.client.focus.byidx( 1) if client.focus then client.focus:raise() end
      end,
              { description = "\tSwitch client focus", group = "Awesome"}),
    awful.key({ modkey }, "j",
      function ()
        awful.client.focus.byidx(-1) if client.focus then client.focus:raise() end
        end,
              { description = "\tSwitch client focus", group = "Awesome"}),
    -- Keyboard layout switcher
    awful.key({ modkey, ctrlkey }, "Left",  function () kbdcfg:prev() end,
              { description = "\tSwitch keyboard layout", group = "Awesome"}),
    awful.key({ modkey, ctrlkey }, "Right",  function () kbdcfg:next() end,
              { description = "\tSwitch keyboard layout", group = "Awesome"}),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b",
      function ()
        for s in screen do
          s.mywibox.visible = not s.mywibox.visible
          s.mybotwibox.visible = not s.mybotwibox.visible
        end
      end,
              { description = "\tHide wibox", group = "Awesome"}),

    -- Layout manipulation
    ---- Change windows position in grid
    awful.key({ modkey, shiftkey }, "j", function () awful.client.swap.byidx(  1) end,
              { description = "Switch client position", group = "Awesome"}),
    awful.key({ modkey, shiftkey }, "k", function () awful.client.swap.byidx( -1) end,
              { description = "Switch client position", group = "Awesome"}),
    ---- Change windows size in grid
    awful.key({ modkey, shiftkey }, "h", function () awful.tag.incmwfact( 0.025) end,
              { description = "Switch client size", group = "Awesome"}),
    awful.key({ modkey, shiftkey }, "l", function () awful.tag.incmwfact(-0.025) end,
              { description = "Switch client size", group = "Awesome"}),

    -- Change layout
    awful.key({ modkey,          }, "u",  awful.client.urgent.jumpto,
              { description = "\tJump to urgent client", group = "Awesome"}),
    awful.key({ modkey,          }, "space", function () awful.layout.inc(layouts,  1)  end,
              { description = "\tChange layout", group = "Awesome"}),
    awful.key({ modkey, shiftkey }, "space", function () awful.layout.inc(layouts, -1)  end),
  -- Standard program
    awful.key({ modkey,          }, "q",       function () quake:toggle() end,
              { description = "\tToggle quake terminal", group = "Tools"}),
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end,
              { description = "\tStart terminal", group = "Tools"}),
    awful.key({ modkey, altkey    }, "l",      function () awful.spawn.with_shell("~/.bin/lock") end,
              { description = "\tLock session", group = "Session"}),
    awful.key({ modkey, ctrlkey   }, "r",      awesome.restart,
              { description = "\tReload awesome config", group = "Session"}),
    awful.key({ modkey, "Shift"   }, "q",      awesome.quit,
              { description = "\tQuit session", group = "Session"}),

  -- Media Key
  -- XF86AudioLowerVolume Decrease Volume
  -- XF86AudioMute        Volume Mute
  -- XF86AudioRaiseVolume Increase Volume
  -- XF86AudioPrev        Previous Song
  -- XF86AudioPlay        Play Song
  -- XF86AudioNext        Next Song
  -- XF86Calcultor        Calculator
  -- XF86Mail             Mail
  -- XF86HomePage         Home Page
  -- XF86Sleep Volume Less
  -- ALSA volume control
  awful.key({                 }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer -q set Master 1%-") end), awful.key({                 }, "XF86AudioMute",        function ()
      awful.util.spawn("amixer set Master toggle; amixer set Speaker toggle; amixer set 'Bass Speaker' toggle;" ) end),
  awful.key({                 }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer -q set Master 1%+") end),

  awful.key({ altkey,         }, "Up",                   function () awful.util.spawn("amixer -q set Master 1%+") end,
            { description = "\t\tIncrease Volume", group = "Tools"}),
  awful.key({ altkey,         }, "Down",                 function () awful.util.spawn("amixer -q set Master 1%-") end,
            { description = "\t\tDecrease Volume", group = "Tools"}),
  awful.key({ altkey,         }, "m",                    function ()
      awful.util.spawn("amixer set Master toggle;  amixer set Speaker toggle;  amixer set 'Bass Speaker' toggle;" ) end,
            { description = "\t\tMute/Unmute", group = "Tools"}),

  -- Copy primary to clipboard (terminals to gtk)
  awful.key({ modkey,         }, "c", function () awful.spawn("xsel | xsel -i -b") end,
            { description = "\tCopy/Paste main clipboard", group = "Tools"}),
  -- Copy clipboard to primary (gtk to terminals)
  awful.key({ modkey,         }, "v", function () awful.spawn("xsel -b | xsel") end,
            { description = "\tCopy/Paste main clipboard", group = "Tools"}),

  -- User programs
  awful.key({ modkey,         }, "e", function () awful.util.spawn(explorer) end,
            { description = "\tOpen file explorer", group = "Application"}),
  awful.key({ modkey,         }, "f", function () awful.spawn(browser) end,
            { description = "\tOpen web browser", group = "Application"}),
  awful.key({ modkey,         }, "a", function () awful.util.spawn(terminal .. " -e pulsemixer") end,
            { description = "\tOpen pulsemixer", group = "Application"}),
  awful.key({ modkey,         }, "p", function () awful.util.spawn("pavucontrol") end,
            { description = "\tOpen pavucontrol", group = "Application"}),
  awful.key({ modkey,         }, "d", function () awful.util.spawn("qtcreator") end,
            { description = "\tOpen QtCreator", group = "Application"}),
  awful.key({ modkey, altkey  }, "a", function () awful.util.spawn("mono ~/.keepass/KeePass.exe --auto-type") end)
)



--]]

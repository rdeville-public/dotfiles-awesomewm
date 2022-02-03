--[[
local awful         = require("awful")

local modkey   = require("config.keys.mod").modkey
local altkey   = require("config.keys.mod").altkey
local shiftkey = require("config.keys.mod").shiftkey
local ctrlkey  = require("config.keys.mod").ctrlkey

return awful.util.table.join(
  awful.key({ modkey }, "f",
    function (c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    {
      description = "\t\tToggle fullscreen",
      group = "Client"
    }),
  awful.key({ modkey, ctrlkey   }, "c",
    function (c) c:kill() end,
    {
      description = "\t\tSend SIGKILL",
      group = "Client"
    }),
  awful.key({ modkey, ctrlkey   }, "space",
    awful.client.floating.toggle,
    {
      description = "\tToggle floating",
      group = "Client"
    }),
  awful.key({ modkey }, "o",
    function (c, t)
      -- Get idx of current tag of client
      local stop = false
      local idx = 1
      local tag = c.screen.tags[c.first_tag.index]
      -- Restore last tag visited
      awful.tag.history.restore()
      -- Move client to next screen
      c:move_to_screen()
      while idx < #c.screen.tags and not stop
      do
        if c.screen.tags[idx].name == tag.name
        then
          stop = true
        else
          idx = idx + 1
        end
      end
      if not stop
      then
        awful.tag.add(
          tag.name,
          {
            volatile = true,
            screen = c.screen,
            layout = awful.layout.suit.tile
          }
        )
        idx = idx + 1
      end
      tag = c.screen.tags[idx]
      c:move_to_tag(tag)
      c:jump_to()
      awful.tag.history.update(c.screen)
    end,
    {
      description = "\t\tMove to screen",
      group = "Client"
    }),
  awful.key({ modkey }, "t",
    function (c) c.ontop = not c.ontop end,
    {
      description = "\t\tToggle keep on top",
      group = "Client"
    }),
  awful.key({ modkey }, "s",
    function (c) c.sticky = not c.sticky end,
    {
      description = "\t\tToggle sticky client",
      group = "Client"
    }),
  awful.key({ modkey }, "n",
    function (c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
    end ,
    {
      description = "\t\tMinimize",
      group = "Client"
    }),
  awful.key({ modkey }, "m",
    function (c)
      c.maximized = not c.maximized
      c:raise()
    end ,
    {
      description = "\t\tMaximize",
      group = "Client"
    }),
  awful.key({ modkey , shiftkey }, "r",
    function () screen.focused().mypromptbox:run() end,
    {
      description = "\t\tRun prompt",
      group = "Client"
    })
)
--]]
-- vim: fdm=indent

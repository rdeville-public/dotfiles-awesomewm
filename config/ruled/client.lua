
local awful         = require("awful")
local beautiful     = require("beautiful")
local ruled         = require("ruled")
local gears         = require("gears")

local clientkeys    = require("config.keys.client")
local clientbuttons = require("config.buttons.client")
local tagname       = require("config.tags").name

ruled.client.append_rules {
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
      --buttons          = clientbuttons,
      screen           = awful.screen.preferred,
      placement        = awful.placement.no_overlap+awful.placement.no_offscreen,
      size_hints_honor = false,
      titlebars_enabled = true,
    }
  },
  {
    rule_any = { class = { "st", "terminator", "xterm" } },
    properties = { tag = tagname.terminal, switch_to_tags = true }
  },
  {
    rule_any = { class = { "firefox", "chromium-browser" } },
    properties = { tag = tagname.browser, switch_to_tags = true }
  },
  {
    rule = { class = "thunderbird" },
    properties = { tag = tagname.mail, switch_to_tags = true }
  },
  {
    rule_any = { class = {"keepassxc" } },
    properties = { tag = tagname.pass, switch_to_tags = true }
  },
  --[[
  {
    rule_any = { TODO Monitor},
    properties = { tag = tagname.monitor, switch_to_tags = true }
  },
  --]]
  {
    rule_any = { class = { "explorer" }, instance = { "Thunar", "pcmanfm" } },
    properties = {
      tag = tagname.filemanager,
      switch_to_tags = true ,
      new_tag = {
        name = tagname.filemanager,
        layout = awful.layout.suit.tile,
        volatile = true,
      },
    }
  },
  {
    rule_any = { class = { "Steam" } },
    properties = {
      tag = tagname.steam,
      switch_to_tags = true,
      new_tag = {
        name = tagname.steam,
        layout = awful.layout.suit.tile,
        volatile = true,
      },
    },
  },
  {
    rule_any = { class = { "Inkscape" } },
    properties = {
      tag = tagname.inkscape,
      new_tag = {
        name = tagname.inkscape,
        layout = awful.layout.suit.tile,
        volatile = true,
      },
      switch_to_tags = true
    },
  },
  {
    rule_any = { class = { "Gimp" } },
    properties = {
      tag = tagname.gimp,
      new_tag = {
        name = tagname.gimp,
        layout = awful.layout.suit.tile,
        volatile = true,
      },
      switch_to_tags = true
    },
  },
  -- Add titles bars to dialog client
  {
    rule_any = { type = { "dialog" } },
    properties = {
      floating = true,
      titlebars_enabled = true,
      shape = function(cr, width, height)
        return gears.shape.rounded(cr, width, height, dpi(20))
      end,
    },
    callback = function(c)
      awful.placement.centered(c, nil)
    end,
  },
  -- Add titles bars to floating client
  {
    rule_any = { type = { "floating" } },
    properties = {
      titlebars_enabled = true,
      shape = function(cr, width, height)
        return gears.shape.rounded(cr, width, height, dpi(20))
      end,
    },
  },
}

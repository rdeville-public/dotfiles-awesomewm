-- DESCRIPTION
-- ========================================================================
-- Widget to show the taglist

-- LIBRARY
-- ========================================================================
local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local dpi          = require("beautiful.xresources").apply_dpi

-- VARIABLES
-- ========================================================================
local taglist = {}

local function factory(screen)
  return awful.widget.taglist {
    screen  = screen,
    filter  = awful.widget.taglist.filter.all,
    buttons = awful.util.taglist_buttons,
    layout = {
      spacing = -dpi(beautiful.wibar_height/2),
      layout  = wibox.layout.flex.horizontal,
    },
    widget_template = {
      {
        {
          id     = 'tag_content',
          widget = wibox.widget.textbox,
        },
        left   = 18,
        widget = wibox.container.margin,
      },
      id           = 'background_role',
      forced_width = dpi(beautiful.wibar_height * 4),
      widget       = wibox.container.background,
      -- Add support for hover colors and an index label
      create_callback = function(self, tag, index, objects)
        self:update_callback(tag,index,objects)
      end,
      update_callback = function(self, tag, index, objects) --luacheck: no unused args
        if tag.selected then
          fg_color = beautiful.taglist_fg_focus
        elseif next(tag:clients()) == nil then
          fg_color = beautiful.taglist_fg_empty
        elseif next(tag:clients()) ~= nil then
          fg_color = beautiful.taglist_fg_occupied
        elseif tag.volatile then
          fg_color = beautiful.taglist_fg_volatile
        else
          fg_color = beautiful.taglist_fg_empty
        end
        self:get_children_by_id('tag_content')[1].markup =
          "<span foreground='"..fg_color.."'>"..index.." "..tag.name.. " </span>"
      end,
    },
  }
end

return setmetatable(taglist, { __call = function(_, ...)
    return factory(...)
  end })

-- vim: fdm=indent

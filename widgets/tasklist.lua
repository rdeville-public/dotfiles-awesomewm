-- DESCRIPTION
-- ========================================================================
-- Widget to show the tasklist

-- LIBRARY
-- ========================================================================
local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local dpi       = require("beautiful.xresources").apply_dpi

-- VARIABLES
-- ========================================================================
local tasklist = {}

-- WIDGET
-- ========================================================================
local function factory(screen)
  return awful.widget.tasklist {
    screen   = screen,
    filter   = awful.widget.tasklist.filter.currenttags,
    buttons  = tasklist_buttons,
    layout   = {
      layout  = wibox.layout.fixed.horizontal,
      spacing = dpi(2)
    },
    -- Notice that there is *NO* wibox.wibox prefix, it is a template,
    -- not a widget instance.
    widget_template = {
      {
        {
          nil,
          {
            {
              awful.widget.clienticon,
              left = dpi(5),
              right = dpi(2.5),
              widget = wibox.container.margin
            },
            {
              id     = 'text',
              text   = "",
              widget = wibox.widget.textbox
            },
            spacing = dpi(2),
            widget = wibox.layout.fixed.horizontal
          },
          {
            widget = wibox.container.background,
            id = "background_role",
            forced_height = dpi(beautiful.wibar_height / 5)
          },
          widget = wibox.layout.align.vertical,
        },
        widget = wibox.container.background,
        id = "background"
      },
      widget = wibox.layout.fixed.horizontal,
      --widget = wibox.container.place,
      create_callback = function (self, c, index, objects)
        self:update_callback(c, index, objects)
      end,
      update_callback = function (self, c, index, objects)
        local widget_background = self:get_children_by_id("background_role")[1]
        local text = ""
        if c.active then
          widget_background.bg = beautiful.tasklist_bg_focus
        elseif c.minimized then
          widget_background.bg = beautiful.tasklist_bg_minimize
        elseif c.urgent then
          widget_background.bg = beautiful.tasklist_bg_urgent
        else
          widget_background.bg = beautiful.tasklist_bg_normal
        end

        if c.sticky then
          text = text .. beautiful.tasklist_sticky
        end

        if c.ontop then
          text = text .. beautiful.tasklist_ontop
        end

        if c.floating then
          text = text .. beautiful.tasklist_floating
        end

        if c.maximized then
          text = text .. beautiful.tasklist_maximized
        end
        self:get_children_by_id("text")[1].text = text

      end
    },
  }
end

return setmetatable(tasklist, { __call = function(_, ...)
    return factory(...)
  end })

-- vim: fdm=indent

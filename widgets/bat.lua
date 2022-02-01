--[[

-- DESCRIPTION
-- ========================================================================
-- Widget to show the batwork

-- LIBRARY
-- ========================================================================
-- Global libraries
local math =  math
local string = string
-- Required library
local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful")
local naughty   = require("naughty")

-- VARIABLES
-- ========================================================================
local dpi                       = require("beautiful.xresources").apply_dpi
-- Directory
local bat_dir                   = awful.util.getdir("config") .. "widgets/bat"
local bat_img_charging_prefix   = bat_dir .. "/img/charging_"
local bat_img_uncharging_prefix = bat_dir .. "/img/uncharging_"
local bat_img_full_prefix       = bat_dir .. "/img/full"
local bat_img_prefix            = bat_dir .. "/img/bat_"
local bat_img_full              = "full"
local bat_img_suffix            = ".svg"
local bat                       = {}

-- METHODS
-- ========================================================================
local parallelogram_left = function(cr, width, height)
  gears.shape.transform(gears.shape.parallelogram)
    :scale(1,-1)
    :translate(0,-height)(cr, dpi(width), dpi(height), dpi(width - height/2))
end

local function factory(args)
  local default_command_type     = "cat /sys/class/power_supply/BAT1/type"
  local default_command_status   = "cat /sys/class/power_supply/BAT1/status"
  local default_command_capacity = "cat /sys/class/power_supply/BAT1/capacity"
  local default_alert_value      = 15
  local args                     = args                                   or {}

  args.interface          = args.format            or "*"
  args.font               = args.font              or beautiful.bat_font             or beautiful.font
  args.bg                 = args.bg                or beautiful.bat_bg               or "#DDDDDD"
  args.shape              = args.shape             or beautiful.bat_shape            or parallelogram_left
  args.timeout            = args.timeout           or beautiful.bat_timeout          or 1
  args.width              = args.width             or beautiful.bat_width            or dpi(100)
  args.bat_font           = args.bat_font          or beautiful.bat_font             or args.font
  args.bat_bar_fg         = args.bat_fg            or beautiful.bat_fg               or "#FFFFFF"
  args.bat_bar_bg         = args.bat_bg            or beautiful.bat_bg               or "#000000"
  args.bat_bar_fill_shape = args.bat_bg            or beautiful.bat_bg               or args.shape
  args.bat_bar_shape      = args.bat_bg            or beautiful.bat_bg               or args.shape
  args.bat_bar_width      = args.bat_bar_width     or beautiful.bat_bar_width        or 100
  args.command_type       = args.command_type      or beautiful.bat_command_type     or default_command_type
  args.command_status     = args.command_status    or beautiful.bat_command_status   or default_command_status
  args.command_capacity   = args.command_capacity  or beautiful.bat_command_capacity or default_command_capacity
  args.alert_value        = args.alert_value       or beautiful.bat_alert_value      or default_alert_value
  args.height             = beautiful.wibar_height

  local bat = wibox.widget
  {
    {
      {
        {
          {
            {
              id            = "bat_icon_status",
              -- https://awesomewm.org/apidoc/classes/wibox.widget.imagebox.html
              widget        = wibox.widget.imagebox,
              -- DEBUG
              image         = bat_img_full_prefix .. bat_img_suffix,
              resize        = true,
              forced_height = 12,
              forced_width  = 12,
              opacity       = 100,
              visible       = true,
            },
            layout = wibox.container.margin(_, 5, 2, 2, 2),
          },
          {
            {
              id            = "bat_icon_capacity",
              -- https://awesomewm.org/apidoc/classes/wibox.widget.imagebox.html
              widget        = wibox.widget.imagebox,
              -- DEBUG
              image         = bat_img_prefix .. bat_img_full .. bat_img_suffix,
              resize        = true,
              forced_height = 12,
              forced_width  = 12,
              opacity       = 100,
              visible       = true,
            },
            layout = wibox.container.margin(_, 5, 2, 2, 2),
          },
          {
            {
              {
                id               = "bat_bar",
                -- DEBUG
                value            = 50,
                widget           = wibox.widget.progressbar,
                -- https://awesomewm.org/apidoc/classes/wibox.widget.progressbar.html
                clip         = true,
                color            = args.bat_bar_cached_color,
                background_color = args.bat_bar_bg,
                bar_shape        = args.bat_bar_fill_shape,
                shape            = args.bat_bar_shape,
                max_value        = 100,
                forced_width     = args.bat_bar_width,
                opacity          = 100,
                visible          = true,
              },
              layout = wibox.container.margin(_, 0, 0, 2, 2),
            },
            {
              id            = "bat_value",
              widget        = wibox.widget.textbox,
              -- https://awesomewm.org/apidoc/classes/wibox.widget.textbox.html
              -- DEBUG
              markup        = "<span foreground='#FFFFFF'>".. string.format("%02d %%", 50) .. "</span>",
              --text          = "50%",
              ellipsize     = "end", -- start, middle, end
              wrap          = "word_char", -- word, char, word_char
              valign        = "center", -- top, center, bottom
              align         = "center", -- lefte, center, right
              font          = args.bat_font,
              forced_height = args.height,
              forced_width  = args.height*2,
              opacity       = 100,
              visible       = true,
            },
            layout = wibox.layout.stack,
          },
          layout = wibox.layout.align.horizontal,
        },
        layout = wibox.layout.align.horizontal,
      },
      widget = wibox.container.margin(_, 5, 5, 0, 0),
    },
    bg           = args.bg,
    shape        = args.shape,
    widget       = wibox.container.background,
    set_bat_used = function(self, used, status)
      local clr_bar   = gradient(100,0, used)
      local clr_value = gradient_black_white(100,0, used)
      local clr_icon  = gradient(0,100, used)
      if ( status == "Full")
      then
        path_icon_status   = bat_img_full_prefix .. bat_img_suffix
        path_icon_capacity = bat_img_prefix .. bat_img_full .. bat_img_suffix
      elseif ( status == "Charging" )
      then
        path_icon_status   = bat_img_charging_prefix .. used .. bat_img_suffix
        path_icon_capacity = bat_img_prefix .. used .. bat_img_suffix
      elseif ( status == "Discharging" )
      then
        if ( used <= args.alert_value )
        then
          naughty.notify({
            preset  = naughty.config.presets.critical,
            timeout = 15,
            title   = "Battery Alert !",
            text    = "<span foreground= '#FFFFFF'>Warning, Battery below "..alert_value.."% !</span>"
          })
        end
        path_icon_status   = bat_img_uncharging_prefix .. used .. bat_img_suffix
        path_icon_capacity = bat_img_prefix .. used .. bat_img_suffix
      end
      -- Update widget values
      self:get_children_by_id("bat_icon_status")[1].image   = path_icon_status
      self:get_children_by_id("bat_icon_capacity")[1].image = path_icon_capacity
      self:get_children_by_id("bat_bar")[1].value           = used
      self:get_children_by_id("bat_bar")[1].color           = clr_bar
      self:get_children_by_id("bat_value")[1].markup        = "<span foreground  = '" .. clr_value .."'>".. used.. "%</span>"
    end,
  }

  local update_widget_used = function (widget, stdout, stderr, exitcode, exitreason)
    local used   = tonumber(os.capture(args.command_capacity))
    local status = os.capture(args.command_status)
    widget:set_bat_used(used, status)
  end

  awful.widget.watch(args.command_capacity, args.timeout, update_widget_used, bat)

  return bat

end

return setmetatable(bat, { __call = function(_, ...)
  return factory(...)
end })
--]]

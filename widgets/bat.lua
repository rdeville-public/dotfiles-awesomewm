-- DESCRIPTION
-- ========================================================================
-- Widget to show the battery remaining information

-- LIBRARY
-- ========================================================================
local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local dpi       = require("beautiful.xresources").apply_dpi

-- VARIABLES
-- ========================================================================
local bat = {}

local function factory(args)
  local default_commands = {}
  local power_info_dir      = "/sys/class/power_supply/"
  local bat_info_dir        = scandir(power_info_dir)
  local default_alert_value = 25
  local args                = args or {}

  if #bat_info_dir > 0 then
    local found = false
    local idx   = 1
    while not found do
      if string.find(bat_info_dir[idx],"BAT") then
        found = true
        bat_info_dir = bat_info_dir[idx]
      end
      idx = idx + 1
    end
    if not found then
      return nil
    end
  else
    return nil
  end

  default_commands = {}
  default_commands.status = "cat " .. power_info_dir .. bat_info_dir .. "/status"
  default_commands.capacity = "cat " .. power_info_dir .. bat_info_dir .. "/capacity"

  args.font                  = args.font                  or beautiful.bat_font                  or beautiful.font
  args.bg                    = args.bg                    or beautiful.bat_bg                    or "#000000"
  args.fg                    = args.fg                    or beautiful.bat_fg                    or "#FFFFFF"
  args.height                = args.height                or beautiful.bat_height                or 24
  args.icon                  = args.icon                  or beautiful.bat_icon                  or "BAT: "
  args.timeout               = args.timeout               or beautiful.bat_timeout               or 1

  args.shape                 = args.shape                 or beautiful.bat_shape                 or gears.shape.rect

  args.bar_shape             = args.bar_shape             or beautiful.bat_bar_shape             or default_shape
  args.bar_width             = args.bar_width             or beautiful.bat_bar_width             or 10
  args.bar_fg                = args.bar_fg                or beautiful.bat_bar_fg                or args.fg
  args.bar_bg                = args.bar_bg                or beautiful.bat_bar_bg                or args.bg

  args.alert_value           = args.alert_value           or beautiful.bat_alert_value           or 25

  args.tier1_val             = args.tier1_val             or beautiful.bat_tier1_val             or 20
  args.tier2_val             = args.tier2_val             or beautiful.bat_tier2_val             or 40
  args.tier3_val             = args.tier3_val             or beautiful.bat_tier3_val             or 60
  args.tier4_val             = args.tier4_val             or beautiful.bat_tier4_val             or 80
  args.tier5_val             = args.tier5_val             or beautiful.bat_tier5_val             or 100

  args.tier1_clr_discharging = args.tier1_clr_discharging or beautiful.bat_tier1_clr_discharging or args.fg
  args.tier2_clr_discharging = args.tier2_clr_discharging or beautiful.bat_tier2_clr_discharging or args.fg
  args.tier3_clr_discharging = args.tier3_clr_discharging or beautiful.bat_tier3_clr_discharging or args.fg
  args.tier4_clr_discharging = args.tier4_clr_discharging or beautiful.bat_tier4_clr_discharging or args.fg

  args.icon_discharging      = args.icon_discharging      or beautiful.bat_icon_discharging      or " "
  args.icon_discharging_0    = args.icon_discharging_0    or beautiful.bat_icon_discharging_0    or args.icon_discharging
  args.icon_discharging_1    = args.icon_discharging_1    or beautiful.bat_icon_discharging_1    or args.icon_discharging
  args.icon_discharging_2    = args.icon_discharging_2    or beautiful.bat_icon_discharging_2    or args.icon_discharging
  args.icon_discharging_3    = args.icon_discharging_3    or beautiful.bat_icon_discharging_3    or args.icon_discharging
  args.icon_discharging_4    = args.icon_discharging_4    or beautiful.bat_icon_discharging_4    or args.icon_discharging
  args.icon_discharging_5    = args.icon_discharging_5    or beautiful.bat_icon_discharging_5    or args.icon_discharging

  args.tier1_clr_charging    = args.tier1_clr_charging    or beautiful.bat_tier1_clr_charging    or args.fg
  args.tier2_clr_charging    = args.tier2_clr_charging    or beautiful.bat_tier2_clr_charging    or args.fg
  args.tier3_clr_charging    = args.tier3_clr_charging    or beautiful.bat_tier3_clr_charging    or args.fg
  args.tier4_clr_charging    = args.tier4_clr_charging    or beautiful.bat_tier4_clr_charging    or args.fg

  args.icon_charging         = args.icon_charging         or beautiful.bat_icon_charging         or " "
  args.icon_charging_0       = args.icon_charging_0       or beautiful.bat_icon_charging_0       or args.icon_charging
  args.icon_charging_1       = args.icon_charging_1       or beautiful.bat_icon_charging_1       or args.icon_charging
  args.icon_charging_2       = args.icon_charging_2       or beautiful.bat_icon_charging_2       or args.icon_charging
  args.icon_charging_3       = args.icon_charging_3       or beautiful.bat_icon_charging_3       or args.icon_charging
  args.icon_charging_4       = args.icon_charging_4       or beautiful.bat_icon_charging_4       or args.icon_charging
  args.icon_charging_5       = args.icon_charging_5       or beautiful.bat_icon_charging_5       or args.icon_charging

  args.command_status        = args.command_status        or beautiful.bat_command_status        or default_commands.status
  args.command_capacity      = args.command_capacity      or beautiful.bat_command_capacity      or default_commands.capacity

  local function compute_tier_clr(value)
    if status == "Discharging" then
      key = "_clr_discharging"
    else
      key = "_clr_charging"
    end
    if value <= args.tier1_val then
      return args["tier1" .. key]
    elseif value <= args.tier2_val then
      return args["tier2" .. key]
    elseif value <= args.tier3_val then
      return args["tier3" .. key]
    elseif value <= args.tier4_val then
      return args["tier4" .. key]
    else
      return args["tier5" .. key]
    end
  end

  local function compute_tier_icon(value, status)
    local key = ""
    if status == "Discharging" then
      key = "icon_discharging_"
    else
      key = "icon_charging_"
    end
    if value <= args.tier1_val then
      return args[key .. "1"]
    elseif value <= args.tier2_val then
      return args[key .. "2"]
    elseif value <= args.tier3_val then
      return args[key .. "3"]
    elseif value <= args.tier4_val then
      return args[key .. "4"]
    else
      return args[key .. "5"]
    end
  end

  local function get_battery_value()
    return {
      remain   = tonumber(os.capture(args.command_capacity)),
      status = os.capture(args.command_status),
    }
  end

  bat = wibox.widget
  {
    {
      {
        {
          id     = "bat_icon",
          text   = compute_tier_icon(50),
          font   = args.font,
          widget = wibox.widget.textbox,
        },
        {
          {
            id               = "bat_bar",
            -- DEBUG
            value            = 50,
            widget           = wibox.widget.progressbar,
            -- https://awesomewm.org/apidoc/classes/wibox.widget.progressbar.html
            clip             = true,
            color            = compute_tier_clr(50),
            background_color = args.bar_bg,
            bar_shape        = args.bar_fill_shape,
            shape            = args.bar_shape,
            max_value        = 100,
            forced_width     = args.bar_width,
            visible          = true,
          },
          forced_width = args.bar_width,
          forced_height = args.height,
          direction = "east",
          layout = wibox.container.rotate,
        },
        {
          id            = "bat_value",
          widget        = wibox.widget.textbox,
          text          = string.format(" %03.1f%% ", 50.0),
          ellipsize     = "end",
          wrap          = "word_char",
          valign        = "center",
          align         = "center",
          font          = args.bat_font,
          forced_height = args.height,
          visible       = true,
        },
        layout = wibox.layout.align.horizontal,
      },
      widget = wibox.container.margin(_, 15, 15, 0, 0),
    },
    fg           = compute_tier_clr(50),
    bg           = args.bg,
    shape        = args.shape,
    widget       = wibox.container.background,
    set_bat_remain = function(self, remain, status)
      local clr = compute_tier_clr(remain)
      local icon = compute_tier_icon(remain, status)
      if status == "Discharging"  and remain <= args.alert_value then
        naughty.notify({
          preset  = naughty.config.presets.critical,
          timeout = 15,
          title   = "Battery Alert !",
          text    = "<span foreground= '#FFFFFF'>Warning, Battery below "..alert_value.."% !</span>"
        })
      end
      -- Update widget values
      self.fg = clr
      self:get_children_by_id("bat_icon")[1].text  = icon
      self:get_children_by_id("bat_bar")[1].value  = remain
      self:get_children_by_id("bat_bar")[1].color  = clr
      self:get_children_by_id("bat_value")[1].text = string.format(" %03.1f%% ", remain)
    end,
  }

  local update_widget_remain = function (widget, stdout, stderr, exitcode, exitreason)
    local bat_value = get_battery_value()
    widget:set_bat_remain(bat_value.remain, bat_value.status)
  end

  awful.widget.watch(default_commands.capacity, args.timeout, update_widget_remain, bat)

  return bat

end

return setmetatable(bat, { __call = function(_, ...)
  return factory(...)
end })

-- vim: fdm=indent

-- DESCRIPTION
-- ========================================================================
-- Widget to show the ramwork

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
local dpi            = require("beautiful.xresources").apply_dpi
-- Directory
local ram            = {}

-- METHODS
-- ========================================================================
local function factory(args)
  local args = args or {}

  local function split(string_to_split, separator)
    if separator == nil then separator = "%s" end
    local t = {}

    for str in string.gmatch(string_to_split, "([^".. separator .."]+)") do
        table.insert(t, str)
    end

    return t
  end

  local function content(used)
    local dim
    if used < 10^3 then
      dim = 'KB'
    elseif used < 10^6 then
      used = used/10^3
      dim = 'MB'
    elseif used < 10^9 then
      used = used/10^6
      dim = 'Gb'
    else
      used = tonumber(used)
      dim = 'B'
    end
    return string.format("%1.2f",used) .. dim
  end

  local function get_ram_value(stat_line)
    local ram = {}
    local raw_data = {}

    -- Get RAM stats
    ------------------------------------------------------------
    raw_data = split(stat_line,' ')

    -- Calculate usage
    ------------------------------------------------------------
    ram.active = tonumber(raw_data[3]) + tonumber(raw_data[5])
    ram.buffer = tonumber(raw_data[6])
    ram.total  = tonumber(raw_data[2])
    ram.pourcent = math.floor((ram.active / ram.total) * 1000) / 10

    return ram
  end

  local function compute_tier_clr(value)
    if value <= args.tier1_val then
      return args.tier1_clr
    elseif value <= args.tier2_val then
      return args.tier2_clr
    elseif value <= args.tier3_val then
      return args.tier3_clr
    else
      return args.tier4_clr
    end
  end

  args.max_value = get_ram_value(os.capture("free | grep 'Mem:'")).total

  args.font        = args.font        or beautiful.ram_font        or beautiful.font
  args.bg          = args.bg          or beautiful.ram_bg          or "#000000"
  args.fg          = args.fg          or beautiful.ram_fg          or "#FFFFFF"
  args.height      = args.height      or beautiful.ram_height      or 24
  args.icon        = args.icon        or beautiful.ram_icon        or "RAM: "
  args.timeout     = args.timeout     or beautiful.ram_timeout     or 1

  args.shape       = args.shape       or beautiful.ram_shape       or parallelogram_left

  args.bar_shape   = args.bar_shape   or beautiful.ram_bar_shape   or default_shape
  args.bar_width   = args.bar_width   or beautiful.ram_bar_width   or 10
  args.bar_fg      = args.bar_fg      or beautiful.ram_bar_fg      or args.fg
  args.bar_bg      = args.bar_bg      or beautiful.ram_bar_bg      or args.bg

  args.alert_value = args.alert_value or beautiful.ram_alert_value or args.max_value * 0.8
  args.tier1_clr   = args.tier1_clr   or beautiful.ram_tier1_clr   or args.fg
  args.tier2_clr   = args.tier2_clr   or beautiful.ram_tier2_clr   or args.fg
  args.tier3_clr   = args.tier3_clr   or beautiful.ram_tier3_clr   or args.fg
  args.tier4_clr   = args.tier4_clr   or beautiful.ram_tier4_clr   or args.fg
  args.tier1_val   = args.tier1_val   or beautiful.ram_tier1_val   or args.max_value * 0.25
  args.tier2_val   = args.tier2_val   or beautiful.ram_tier2_val   or args.max_value * 0.50
  args.tier3_val   = args.tier3_val   or beautiful.ram_tier3_val   or args.max_value * 0.75
  args.tier4_val   = args.tier4_val   or beautiful.ram_tier4_val   or args.max_value

  ram = wibox.widget
  {
    {
      {
        {
          id     = "ram_icon",
          markup = "<span"  .. " foreground = '"  .. args.fg .. "'>"  .. args.icon .. "</span>",
          font   = args.font,
          widget = wibox.widget.textbox,
        },
        {
          {
            id               = "ram_bar",
            -- DEBUG
            value            = 25,
            widget           = wibox.widget.progressbar,
            -- https://awesomewm.org/apidoc/classes/wibox.widget.progressbar.html
            clip             = true,
            color            = args.bar_fg,
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
          id            = "ram_value",
          widget        = wibox.widget.textbox,
          markup        = "<span foreground='" .. args.fg .. "'>".. string.format(" %05.2f ", 50.0) .. "</span>",
          ellipsize     = "end",
          wrap          = "word_char",
          valign        = "center",
          align         = "center",
          font          = args.ram_font,
          forced_width  = dpi(args.height*3),
          visible       = true,
        },
        layout = wibox.layout.align.horizontal,
      },
      widget = wibox.container.margin(_, 15, 15, 0, 0),
    },
    bg           = args.bg,
    shape        = args.shape,
    widget       = wibox.container.background,
    set_ram_used = function(self, stdout)
      -- Compute values
      local ram = get_ram_value(stdout)
      local clr_value   = compute_tier_clr(ram.active)
      local alert_value = args.alert_value
      local text_value  = content(ram.active)

      -- Update widget values
      self:get_children_by_id("ram_icon")[1].markup     = "<span foreground='" .. clr_value .."'>".. args.icon .. "</span>"
      self:get_children_by_id("ram_bar")[1].value   = ram.pourcent
      self:get_children_by_id("ram_bar")[1].color   = clr_value
      self:get_children_by_id("ram_value")[1].markup     = "<span foreground='" .. clr_value .."'>".. text_value .. "</span>"
--      -- Show alert if usage above specified threshold
--      if ( used > args.alert_value )
--      then
--        naughty.notify({
--          preset  = naughty.config.presets.critical,
--          timeout = args.timeout,
--          title   = "Ram Alert !",
--          text    = "<span foreground= '#FFFFFF'>Warning, ram usage above "..alert_value.." !</span>"
--        })
--      end
    end,
  }

  local update_widget_used = function (widget, stdout, stderr, exitcode, exitreason)
    for _,line in ipairs(split(stdout,'\r\n')) do
      if string.find(line, "Mem:") then
        widget:set_ram_used(line)
      end
    end
  end

  awful.widget.watch("free", args.timeout, update_widget_used, ram)

  return ram

end

return setmetatable(ram, { __call = function(_, ...)
  return factory(...)
end })

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local cpu = {}
local old_cpu = { 50, 50 }

local function factory(args)
  args = args or {}

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

  local function get_cpu_value(stat_line)
    local curr_data = {}
    local loadavg_file = "/proc/loadavg"
    local cpu_data = {
      raw_data = {},
      total = 0,
      active = 0,
    }

    -- Get CPU stats
    ------------------------------------------------------------
    for i in string.gmatch(stat_line, "[%s]+([^%s]+)") do
      table.insert(cpu_data.raw_data, i)
    end

    -- Calculate usage
    ------------------------------------------------------------
    cpu_data.active = cpu_data.raw_data[1]
      + cpu_data.raw_data[2]
      + cpu_data.raw_data[3]
      + cpu_data.raw_data[6]
      + cpu_data.raw_data[7]
      + cpu_data.raw_data[8]
      + cpu_data.raw_data[9]
      + cpu_data.raw_data[10]
    cpu_data.total = cpu_data.active
      + cpu_data.raw_data[4]
      + cpu_data.raw_data[5]

    curr_data.active = cpu_data.active - old_cpu[1]
    curr_data.total = cpu_data.total - old_cpu[2]

    old_cpu[1] = cpu_data.active
    old_cpu[2] = cpu_data.total

    curr_data.pourcent = math.floor((curr_data.active / curr_data.total) * 1000)
      / 10

    curr_data.loadavg = {}
    for line in io.lines(loadavg_file) do
      for i in string.gmatch(line, "([^ ]+)") do
        table.insert(curr_data.loadavg, i)
      end
    end

    return curr_data
  end

  args.max_value = args.max_value or beautiful.cpu_max_value or 100

  args.font = args.font or beautiful.cpu_font or beautiful.font
  args.bg = args.bg or beautiful.cpu_bg or "#000000"
  args.fg = args.fg or beautiful.cpu_fg or "#FFFFFF"
  args.height = args.height or beautiful.cpu_height or 24
  args.icon = args.icon or beautiful.cpu_icon or "CPU: "
  args.timeout = args.timeout or beautiful.cpu_timeout or 1

  args.shape = args.shape or beautiful.cpu_shape or gears.shape.rect

  args.bar_shape = args.bar_shape or beautiful.cpu_bar_shape
  args.bar_width = args.bar_width or beautiful.cpu_bar_width or 10
  args.bar_fg = args.bar_fg or beautiful.cpu_bar_fg or args.fg
  args.bar_bg = args.bar_bg or beautiful.cpu_bar_bg or args.bg

  args.alert_value = args.alert_value or beautiful.cpu_alert_value or 90

  args.tier1_clr = args.tier1_clr or beautiful.cpu_tier1_clr or args.fg
  args.tier2_clr = args.tier2_clr or beautiful.cpu_tier2_clr or args.fg
  args.tier3_clr = args.tier3_clr or beautiful.cpu_tier3_clr or args.fg
  args.tier4_clr = args.tier4_clr or beautiful.cpu_tier4_clr or args.fg
  args.tier1_val = args.tier1_val or beautiful.cpu_tier1_val or 25
  args.tier2_val = args.tier2_val or beautiful.cpu_tier2_val or 50
  args.tier3_val = args.tier3_val or beautiful.cpu_tier3_val or 75
  args.tier4_val = args.tier4_val or beautiful.cpu_tier4_val or args.max_value

  cpu = wibox.widget({
    {
      {
        {
          id = "cpu_icon",
          markup = "<span"
            .. " foreground = '"
            .. args.fg
            .. "'>"
            .. args.icon
            .. "</span>",
          font = args.font,
          widget = wibox.widget.textbox,
        },
        {
          {
            id = "cpu_bar",
            -- DEBUG
            value = 25,
            widget = wibox.widget.progressbar,
            -- https://awesomewm.org/apidoc/classes/wibox.widget.progressbar.html
            clip = true,
            color = args.bar_fg,
            background_color = args.bar_bg,
            bar_shape = args.bar_fill_shape,
            shape = args.bar_shape,
            max_value = 100,
            forced_width = args.bar_width,
            visible = true,
          },
          forced_width = args.bar_width,
          forced_height = args.height,
          direction = "east",
          layout = wibox.container.rotate,
        },
        {
          {
            id = "cpu_value",
            widget = wibox.widget.textbox,
            markup = "<span foreground='" .. args.fg .. "'>" .. string.format(
              " %03.1f%% ",
              50.0
            ) .. "</span>",
            ellipsize = "end",
            wrap = "word_char",
            valign = "center",
            align = "center",
            font = args.cpu_font,
            forced_height = args.height,
            visible = true,
          },
          {
            id = "cpu_load",
            widget = wibox.widget.textbox,
            markup = "<span foreground='" .. args.fg .. "'>" .. string.format(
              " %03.2f",
              0.75
            ) .. "</span>",
            ellipsize = "end",
            wrap = "word_char",
            valign = "center",
            align = "center",
            font = args.cpu_font,
            forced_height = args.height,
            visible = true,
          },
          layout = wibox.layout.align.horizontal,
        },
        layout = wibox.layout.align.horizontal,
      },
      widget = wibox.container.margin(nil, 15, 15, 0, 0),
    },
    bg = args.bg,
    shape = args.shape,
    widget = wibox.container.background,
    set_cpu_used = function(self, cpu_stdout)
      local cpu_value = get_cpu_value(cpu_stdout)
      local clr_value = compute_tier_clr(cpu_value.pourcent)
      local pourcent = string.format(" %04.1f%%", cpu_value.pourcent)
      local loadavg = string.format(" %03.2f", cpu_value.loadavg[1])
      -- Update widget values
      self:get_children_by_id("cpu_icon")[1].markup = "<span foreground  = '"
        .. clr_value
        .. "'>"
        .. args.icon
        .. "</span>"
      self:get_children_by_id("cpu_bar")[1].value = cpu_value.pourcent
      self:get_children_by_id("cpu_bar")[1].color = clr_value
      self:get_children_by_id("cpu_value")[1].markup = "<span foreground  = '"
        .. clr_value
        .. "'>"
        .. pourcent
        .. "</span>"
      self:get_children_by_id("cpu_load")[1].markup = "<span foreground  = '"
        .. clr_value
        .. "'>"
        .. loadavg
        .. "</span>"
    end,
  })

  local update_widget_used = function(widget, stdout, _, _, _)
    widget:set_cpu_used(stdout)
  end

  awful.widget.watch(
    "head -1 /proc/stat",
    args.timeout,
    update_widget_used,
    cpu
  )

  return cpu
end

return setmetatable(cpu, {
  __call = function(_, ...)
    return factory(...)
  end,
})

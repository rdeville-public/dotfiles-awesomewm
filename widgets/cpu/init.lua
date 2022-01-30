-- DESCRIPTION
-- ========================================================================
-- Widget to show the cpuwork

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
local cpu_dir        = awful.util.getdir("config") .. "widgets/cpu"
local nbcpu          = tonumber(os.capture("nproc",false))
local cpu            = {}

local function factory(args)

  local args = args                                   or {}
  args.font                = args.font                 or  beautiful.cpu_font             or  beautiful.font
  args.bg                  = args.bg                   or  beautiful.cpu_bg               or  "#000000"
  args.fg                  = args.fg                   or  beautiful.cpu_fg               or  "#FFFFFF"
  args.height              = args.height               or  beautiful.cpu_height           or  beautiful.wibar_height
  args.icon                = args.icon                 or  beautiful.cpu_icon             or  "CPU:"
  args.alert_value         = args.alert_value          or  beautiful.cpu_alert_value      or  0.8
  args.timeout             = args.timeout              or  beautiful.cpu_timeout          or 1

  args.shape               = args.shape                or  beautiful.cpu_shape            or  gears.shape.rect

  args.cpu_bar_shape       = args.cpu_bar_shape        or  beautiful.cpu_bar_shape        or  default_shape
  args.cpu_bar_width       = args.cpu_bar_width        or  beautiful.cpu_bar_width        or  10
  args.cpu_bar_fg          = args.cpu_bar_fg           or  beautiful.cpu_bar_fg           or  args.fg
  args.cpu_bar_bg          = args.cpu_bar_bg           or  beautiful.cpu_bar_bg           or  args.bg
  args.cpu_bar_tier1_color = args.cpu_bar_tier1_color  or  beautiful.cpu_bar_tier1_color  or  args.tier1_color
  args.cpu_bar_tier2_color = args.cpu_bar_tier2_color  or  beautiful.cpu_bar_tier2_color  or  args.tier2_color
  args.cpu_bar_tier3_color = args.cpu_bar_tier3_color  or  beautiful.cpu_bar_tier3_color  or  args.tier3_color
  args.cpu_bar_tier4_color = args.cpu_bar_tier4_color  or  beautiful.cpu_bar_tier4_color  or  args.tier4_color

  args.cpu_order = args.cpu_order or beautiful.cpu_order or {"icon", "bar", "pourcent", "load"}

  local tmp_stat_file="/tmp/awesome.old_proc_stat.tmp"
  local loadavg_file="/proc/loadavg"
  local curr_data = {}

  function get_cpu_value(stat_line)
    local cpu = {}
    local old_cpu = {}
    local curr_data = {}
    local file = nil

    cpu = {
      raw_data = {},
      total = 0,
      active = 0,
    }

    -- Get CPU stats
    ------------------------------------------------------------
    for i in string.gmatch(stat_line, "[%s]+([^%s]+)") do
      table.insert(cpu.raw_data, i)
    end

    file = io.open(tmp_stat_file,"r")
    if file ~= nil
    then
      for line in io.lines(tmp_stat_file) do
        for i in string.gmatch(line, "([^ ]+)") do
          table.insert(old_cpu, i)
        end
      end
      io.close(file)
    else
      old_cpu = { 0 , 0 }
    end

    -- Calculate usage
    ------------------------------------------------------------
    cpu.active = cpu.raw_data[1] + cpu.raw_data[2] + cpu.raw_data[3] + cpu.raw_data[6] + cpu.raw_data[7] + cpu.raw_data[8] + cpu.raw_data[9] + cpu.raw_data[10]
    cpu.total = cpu.active + cpu.raw_data[4] + cpu.raw_data[5]

    file = assert(io.open(tmp_stat_file, "w"))
    file:write(cpu.active .. " " .. cpu.total)

    curr_data.active =  cpu.active - old_cpu[1] or 0
    curr_data.total = cpu.total - old_cpu[2] or 0

    curr_data.pourcent = math.floor((curr_data.active / curr_data.total) * 1000) / 10

    show(10," " .. old_cpu[1] .. "-" .. old_cpu[2])
    show(10," " .. curr_data.total .. "-" .. curr_data.active)

    curr_data.loadavg = {}
    for line in io.lines(loadavg_file) do
      for i in string.gmatch(line, "([^ ]+)") do
        table.insert(curr_data.loadavg, i)
      end
    end

    return curr_data
  end


  local cpu = wibox.widget
  {
    {
      {
        {
          markup = "<span"  ..
            " font_desc='"  .. args.font .. "'>"  ..
            args.icon     ..
            "</span>",
          widget = wibox.widget.textbox,
        },
        {
          {
            id               = "cpu_bar",
            -- DEBUG
            value            = 25,
            widget           = wibox.widget.progressbar,
            -- https://awesomewm.org/apidoc/classes/wibox.widget.progressbar.html
            clip             = true,
            color            = "#00ff00", --args.curr_color,
            background_color = "#000000", --args.cpu_bar_bg,
            bar_shape        = args.cpu_bar_fill_shape,
            shape            = args.cpu_bar_shape,
            max_value        = 100,
            forced_width     = args.cpu_bar_width,
            opacity          = 100,
            visible          = true,
          },
          forced_width = args.cpu_bar_width,
          forced_height = args.height,
          direction = "east",
          layout = wibox.container.rotate,
        },
        {
          id            = "cpu_value",
          widget        = wibox.widget.textbox,
          markup        = "<span foreground='#FFFFFF'>".. string.format("%02d %%", 50) .. "</span>",
          ellipsize     = "end",
          wrap          = "word_char",
          valign        = "center",
          align         = "center",
          font          = args.cpu_font,
          forced_height = args.height,
          --forced_width  = args.height*2,
          opacity       = 100,
          visible       = true,
        },
        spacing = dpi(10),
        layout = wibox.layout.align.horizontal,
      },
      widget = wibox.container.margin(_, 15, 15, 0, 0),
    },
    bg           = args.bg,
    width = 100,
    shape        = args.shape,
    widget       = wibox.container.background,

    set_cpu_used = function(self, cpu_value)
      local cpu_value = get_cpu_value(cpu_value)
      local clr_value   = gradient_black_white(0,100,cpu_value.pourcent)
      local text_value  = string.format("%02.1f %%", cpu_value.pourcent)
      local alert_value = args.alert_value
--      -- Update widget values
        self:get_children_by_id("cpu_value")[1].markup     = "<span foreground='" .. clr_value .."'>".. text_value.. "</span>"
        self:get_children_by_id("cpu_bar")[1].value   = cpu_value.pourcent
--      -- Show alert if usage above specified threshold
--      if ( cpu_value.core[tostring(0)].usage_active > args.alert_value )
--      then
--        naughty.notify({
--          preset  = naughty.config.presets.critical,
--          title   = "cpu Alert !",
--          text    = "<span foreground= '#FFFFFF'>Warning, cpu usage above "..args.alert_value.." !</span>"
--        })
--      end
    end,
  }

  local update_widget_used = function (widget, stdout, stderr, exitcode, exitreason)
    widget:set_cpu_used(stdout)
  end

  awful.widget.watch("head -1 /proc/stat", args.timeout, update_widget_used, cpu)

  return cpu
end

return setmetatable(cpu, { __call = function(_, ...)
  return factory(...)
end })


--  local cpubars = wibox.layout
--  {
--    item = {},
--    widget = wibox.layout.fixed.horizontal(),
--  }
--  bar = wibox.widget
--  {
----    {
----      {
----        {
----          id               = "cpu_bar_nice",
----          -- DEBUG
----          value            = args.max_value/10*8,
----          widget           = wibox.widget.progressbar,
----          -- https://awesomewm.org/apidoc/classes/wibox.widget.progressbar.html
----          clip             = true,
----          color            = args.cpu_bar_nice_color,
----          background_color = args.cpu_bar_bg,
----          bar_shape        = args.cpu_bar_fill_shape,
----          shape            = args.cpu_bar_shape,
----          max_value        = args.max_value,
----          forced_width     = args.height,
----          opacity          = 100,
----          visible          = true,
----        },
----        direction = 'east',
----        widget    = wibox.container.rotate,
----        forced_width = 5,
----      },
----      {
----        {
----          id               = "cpu_bar_normal_" .. i,
----          -- DEBUG
----          value            = args.max_value/10*6,
----          widget           = wibox.widget.progressbar,
----          -- https://awesomewm.org/apidoc/classes/wibox.widget.progressbar.html
----          clip         = true,
----          color            = args.cpu_bar_normal_color,
----          background_color = "#00000000",
----          bar_shape        = args.cpu_bar_fill_shape,
----          shape            = args.cpu_bar_shape,
----          max_value        = args.max_value,
----          forced_width     = args.height,
----          opacity          = 100,
----          visible          = true,
----        },
----        direction = 'east',
----        widget    = wibox.container.rotate,
----        forced_width = 5,
----      },
----      {
----        {
----          id               = "cpu_bar_system_" .. i,
----          -- DEBUG
----          value            = args.max_value/10*4,
----          widget           = wibox.widget.progressbar,
----          -- https://awesomewm.org/apidoc/classes/wibox.widget.progressbar.html
----          clip         = true,
----          color            = args.cpu_bar_system_color,
----          background_color = "#00000000",
----          bar_shape        = args.cpu_bar_fill_shape,
----          shape            = args.cpu_bar_shape,
----          max_value        = args.max_value,
----          forced_width     = args.height,
----          opacity          = 100,
----          visible          = true,
----        },
----        direction = 'east',
----        widget    = wibox.container.rotate,
----        forced_width = 5,
----      },
----      {
----        {
----          id               = "cpu_bar_virt_" .. i,
----          -- DEBUG
----          value            = args.max_value/10*2,
----          widget           = wibox.widget.progressbar,
----          -- https://awesomewm.org/apidoc/classes/wibox.widget.progressbar.html
----          clip         = true,
----          color            = args.cpu_bar_virt_color,
----          background_color = "#00000000",
----          bar_shape        = args.cpu_bar_fill_shape,
----          shape            = args.cpu_bar_shape,
----          max_value        = args.max_value,
----          forced_width     = args.height,
----          opacity          = 100,
----          visible          = true,
----        },
----        direction = 'east',
----        widget    = wibox.container.rotate,
----        forced_width = 50,
----      },
----      layout = wibox.layout.stack,
----    },
--    widget = wibox.container.margin(_, 2, 2, 2, 2),
--  }
--  table.insert(cpubars.item, bar)
--  cpubars:add(bar)
--
--  local cpu = wibox.widget
--  {
--    {
--      {
--        cpubars,
--        {
--          id            = "cpu_value",
--          widget        = wibox.widget.textbox,
--          markup        = "<span foreground='#FFFFFF'>".. string.format("%02d %%", 50) .. "</span>",
--          ellipsize     = "end",
--          wrap          = "word_char",
--          valign        = "center",
--          align         = "center",
--          font          = args.cpu_font,
--          forced_height = args.height,
--          --forced_width  = args.height*2,
--          opacity       = 100,
--          visible       = true,
--        },
--        layout = wibox.layout.align.horizontal,
--      },
--      widget = wibox.container.margin(_, 5, 5, 0, 0),
--    },
--    bg           = args.bg,
--    shape        = args.shape,
--    widget       = wibox.container.background,
--
--    set_cpu_used = function(self, cpu_value)
--      local cpu_value = get_cpu_value(cpu_value)
--      local clr_value   = gradient_black_white(0,args.max_value,cpu_value.core[tostring(0)].usage_active)
--      local clr_value   = "#000000"
--      local text_value  = string.format("%02d %%", cpu_value.core[tostring(0)].usage_active)
--      local alert_value = args.alert_value
--      for i_cpu = 1, tonumber(os.capture("nproc"))
--      do
--        naughty.notify({
--          preset  = naughty.config.presets.critical,
--          title   = "cpu Alert !",
--          text = self:get_child_by_id("cpu_bar_nice_" .. i_cpu).value
--        })
--        self:get_children_by_id("cpu_bar_nice_" .. i_cpu).value   = tonumber(cpu_value.core[tostring(i_cpu)].usage_nice)
--        self:get_children_by_id("cpu_bar_normal_" .. i_cpu).value = tonumber(cpu_value.core[tostring(i_cpu)].usage_normal)
--        self:get_children_by_id("cpu_bar_system_" .. i_cpu).value = tonumber(cpu_value.core[tostring(i_cpu)].usage_system)
--        self:get_children_by_id("cpu_bar_virt_" .. i_cpu).value   = tonumber(cpu_value.core[tostring(i_cpu)].usage_virt)
--      end
--
--      -- Update widget values
--      self:get_children_by_id("cpu_value")[1].markup     = "<span foreground='" .. clr_value .."'>".. text_value.. "</span>"
--      -- Show alert if usage above specified threshold
--      if ( cpu_value.core[tostring(0)].usage_active > args.alert_value )
--      then
--        naughty.notify({
--          preset  = naughty.config.presets.critical,
--          title   = "cpu Alert !",
--          text    = "<span foreground= '#FFFFFF'>Warning, cpu usage above "..args.alert_value.." !</span>"
--        })
--      end
--    end,
--  }
--
--

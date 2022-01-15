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
local cpu_img        = cpu_dir .. "/img/cpu_"
local cpu_img_suffix = ".svg"
local nbcpu          = tonumber(os.capture("nproc",false))
local cpu            = {}

-- METHODS
-- ========================================================================
local parallelogram_left = function(cr, width, height)
  gears.shape.transform(gears.shape.parallelogram)
    :scale(1,-1)
    :translate(0,-height)(cr, dpi(width), dpi(height), dpi(width - height/2))
end

local cpu = { core = {} }

local function factory(args)
  local args = args                                   or {}
  args.interface            = args.format                                 or "*"
  args.font                 = args.font                                   or beautiful.cpu_font             or beautiful.font
  args.bg                   = args.bg                                     or beautiful.cpu_bg               or "#DDDDDD"
  args.shape                = args.shape                                  or beautiful.cpu_shape            or parallelogram_left
  args.timeout              = args.timeout                                or beautiful.cpu_timeout          or 1
  args.width                = args.width                                  or beautiful.cpu_width            or dpi(100)
  args.cpu_font             = args.cpu_font                               or beautiful.cpu_font             or args.font
  args.cpu_bar_nice_color   = args.cpu_bar_nice_color                     or beautiful.cpu_bar_nice_color   or "#0000FFFF"
  args.cpu_bar_normal_color   = args.cpu_bar_normal_color                 or beautiful.cpu_bar_normal_color or "#00FF00FF"
  args.cpu_bar_system_color   = args.cpu_bar_system_color                 or beautiful.cpu_bar_system_color or "#FF0000FF"
  args.cpu_bar_virt_color   = args.cpu_bar_virt_color                     or beautiful.cpu_bar_virt_color   or "#FFFF00FF"
  args.cpu_bar_bg           = args.cpu_bar_bg                             or beautiful.cpu_bar_bg           or "#000000FF"
  args.cpu_bar_fill_shape   = args.cpu_bar_fill_shape                     or beautiful.cpu_bar_fill_shape   or rectangle
  args.cpu_bar_shape        = args.cpu_bar_shape                          or beautiful.cpu_bar_shape        or rectangle
  args.cpu_bar_width        = args.cpu_bar_width                          or beautiful.cpu_bar_width        or args.width
  args.command_used         = args.command_used                           or beautiful.cpu_command_used     or default_command_used
  args.command_free         = args.command_free                           or beautiful.cpu_command_free     or default_command_free
  args.command_cached       = args.command_cached                         or beautiful.cpu_command_cached   or default_command_cached
  args.command_buffer       = args.command_buffer                         or beautiful.cpu_command_buffer   or default_command_buffer
  args.height               = beautiful.wibar_height
  args.max_value            = args.max_value                              or beautiful.cpu_alert_value      or 100
  args.alert_value          = args.alert_value                            or beautiful.cpu_alert_value      or args.max_value*0.8


  local function split(string_to_split, separator)
    if separator == nil then separator = "%s" end
    local t = {}

    for str in string.gmatch(string_to_split, "([^".. separator .."]+)") do
        table.insert(t, str)
    end

    return t
  end

  local function lines_match(string_table, regexp)
    local lines = {}
    for index, value in ipairs(string_table) do

      if string.match(value, regexp) then
        table.insert(lines, value)
      end
    end
    return lines
  end

  local function get_child_by_id(widget)
    for _,child in pairs(self:get_children())
    do
      if not child.id == nil
      then
        naughty.notify({
          preset  = naughty.config.presets.critical,
          timeout = args.timeout,
          title   = "cpu Alert !",
          text = child.id
        })
      else
        for _,sub_child in pairs(child:get_children())
        do
          if not child.id == nil
          then
            naughty.notify({
              preset  = naughty.config.presets.critical,
              timeout = args.timeout,
              title   = "cpu Alert !",
              text = child.id
            })
          end
        end
      end
    end
  end


  local function get_cpu_value(stats)

    local vals = split(stats,"\r\n")
    local lines = lines_match(vals,"cpu")

    for index,time in ipairs(lines) do
      local coreid = index - 1
      local core   = cpu.core[tostring(coreid)] or
                    {
                      last_active = 0,
                      last_user   = 0,
                      last_nice   = 0,
                      last_normal = 0,
                      last_system = 0,
                      last_virt   = 0,
                      last_total  = 0,
                      usage       = 0
                    }
      local at     = 1
      local normal = 0
      local user   = 0
      local nice   = 0
      local system = 0
      local virt   = 0
      local idle   = 0
      local total  = 0

      for field in string.gmatch(time, "[%s]+([^%s]+)") do
        if at == 1 then
          user = user + field
        elseif  at == 2 then
          nice = nice + field
        elseif at == 3 then
          system = system + field
        elseif at == 4 or at == 5 then
          idle = idle + field
        elseif at == 9 or at == 10 then
          virt = virt + field
        else
          normal = normal + field
        end
        total = total + field
        at = at + 1
      end

      local active = total - idle

      if core.last_active ~= active or core.last_total ~= total
      then
        local diff_active = active - core.last_active
        local diff_total  = total  - core.last_total
        local diff_normal = normal - core.last_normal
        local diff_user   = user   - core.last_user
        local diff_nice   = nice   - core.last_nice
        local diff_system = system - core.last_system
        local diff_virt   = virt   - core.last_virt

        local usage_active = math.ceil(( diff_active / diff_total) * 100)
        local usage_normal = math.ceil(( diff_normal / diff_total) * 100)
        local usage_user   = math.ceil(( diff_user   / diff_total) * 100)
        local usage_nice   = math.ceil(( diff_nice   / diff_total) * 100)
        local usage_system = math.ceil(( diff_system / diff_total) * 100)
        local usage_virt   = math.ceil(( diff_virt   / diff_total) * 100)

        core.last_active = active
        core.last_total  = total
        core.last_normal = normal
        core.last_user   = user
        core.last_nice   = nice
        core.last_system = system
        core.last_virt   = virt
        core.usage_active = usage_active
        core.usage_normal = usage_normal
        core.usage_user = usage_user
        core.usage_nice = usage_nice
        core.usage_system = usage_system
        core.usage_virt = usage_virt

        -- Save current data for the next run.
        cpu.core[tostring(coreid)] = core
      end
    end
    return cpu
  end

  local cpubars = wibox.layout
  {
    item = {},
    widget = wibox.layout.fixed.horizontal(),
  }
  for i = 1,nbcpu
  do
    bar = wibox.widget
    {
      {
        {
          {
            id               = "cpu_bar_nice_" .. i,
            -- DEBUG
            value            = args.max_value/10*8,
            widget           = wibox.widget.progressbar,
            -- https://awesomewm.org/apidoc/classes/wibox.widget.progressbar.html
            clip             = true,
            color            = args.cpu_bar_nice_color,
            background_color = args.cpu_bar_bg,
            bar_shape        = args.cpu_bar_fill_shape,
            shape            = args.cpu_bar_shape,
            max_value        = args.max_value,
            forced_width     = args.height,
            opacity          = 100,
            visible          = true,
          },
          direction = 'east',
          widget    = wibox.container.rotate,
          forced_width = 5,
        },
        {
          {
            id               = "cpu_bar_normal_" .. i,
            -- DEBUG
            value            = args.max_value/10*6,
            widget           = wibox.widget.progressbar,
            -- https://awesomewm.org/apidoc/classes/wibox.widget.progressbar.html
            clip         = true,
            color            = args.cpu_bar_normal_color,
            background_color = "#00000000",
            bar_shape        = args.cpu_bar_fill_shape,
            shape            = args.cpu_bar_shape,
            max_value        = args.max_value,
            forced_width     = args.height,
            opacity          = 100,
            visible          = true,
          },
          direction = 'east',
          widget    = wibox.container.rotate,
          forced_width = 5,
        },
        {
          {
            id               = "cpu_bar_system_" .. i,
            -- DEBUG
            value            = args.max_value/10*4,
            widget           = wibox.widget.progressbar,
            -- https://awesomewm.org/apidoc/classes/wibox.widget.progressbar.html
            clip         = true,
            color            = args.cpu_bar_system_color,
            background_color = "#00000000",
            bar_shape        = args.cpu_bar_fill_shape,
            shape            = args.cpu_bar_shape,
            max_value        = args.max_value,
            forced_width     = args.height,
            opacity          = 100,
            visible          = true,
          },
          direction = 'east',
          widget    = wibox.container.rotate,
          forced_width = 5,
        },
        {
          {
            id               = "cpu_bar_virt_" .. i,
            -- DEBUG
            value            = args.max_value/10*2,
            widget           = wibox.widget.progressbar,
            -- https://awesomewm.org/apidoc/classes/wibox.widget.progressbar.html
            clip         = true,
            color            = args.cpu_bar_virt_color,
            background_color = "#00000000",
            bar_shape        = args.cpu_bar_fill_shape,
            shape            = args.cpu_bar_shape,
            max_value        = args.max_value,
            forced_width     = args.height,
            opacity          = 100,
            visible          = true,
          },
          direction = 'east',
          widget    = wibox.container.rotate,
          forced_width = 50,
        },
        layout = wibox.layout.stack,
      },
      widget = wibox.container.margin(_, 2, 2, 2, 2),
    }
    table.insert(cpubars.item, bar)
    cpubars:add(bar)
  end

  local cpu = wibox.widget
  {
    {
      {
        {
          {
            id            = "cpu_icon",
            -- https://awesomewm.org/apidoc/classes/wibox.widget.imagebox.html
            widget        = wibox.widget.imagebox,
            -- DEBUG
            image         = cpu_img .. "0" .. cpu_img_suffix,
            resize        = true,
            forced_height = 12,
            forced_width  = 12,
            opacity       = 100,
            visible       = true,
          },
          layout = wibox.container.margin(_, 5, 2, 2, 2),
        },
        cpubars,
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
        layout = wibox.layout.align.horizontal,
      },
      widget = wibox.container.margin(_, 5, 5, 0, 0),
    },
    bg           = args.bg,
    shape        = args.shape,
    widget       = wibox.container.background,

    set_cpu_used = function(self, cpu_value)
      local cpu_value = get_cpu_value(cpu_value)
      local clr_value   = gradient_black_white(0,args.max_value,cpu_value.core[tostring(0)].usage_active)
      local clr_value   = "#000000"
      local ratio       = math.min( math.floor(cpu_value.core[tostring(0)].usage_active/args.max_value * 100), 100)
      local text_value  = string.format("%02d %%", cpu_value.core[tostring(0)].usage_active)
      local alert_value = args.alert_value
      local img         = cpu_img .. ratio .. cpu_img_suffix
      for i_cpu = 1, tonumber(os.capture("nproc"))
      do
        naughty.notify({
          preset  = naughty.config.presets.critical,
          timeout = args.timeout,
          title   = "cpu Alert !",
          text = self:get_child_by_id("cpu_bar_nice_" .. i_cpu).value
        })
        self:get_children_by_id("cpu_bar_nice_" .. i_cpu).value   = tonumber(cpu_value.core[tostring(i_cpu)].usage_nice)
        self:get_children_by_id("cpu_bar_normal_" .. i_cpu).value = tonumber(cpu_value.core[tostring(i_cpu)].usage_normal)
        self:get_children_by_id("cpu_bar_system_" .. i_cpu).value = tonumber(cpu_value.core[tostring(i_cpu)].usage_system)
        self:get_children_by_id("cpu_bar_virt_" .. i_cpu).value   = tonumber(cpu_value.core[tostring(i_cpu)].usage_virt)
      end

      -- Update widget values
      self:get_children_by_id("cpu_icon")[1].image       = img
      self:get_children_by_id("cpu_value")[1].markup     = "<span foreground='" .. clr_value .."'>".. text_value.. "</span>"
      -- Show alert if usage above specified threshold
      if ( cpu_value.core[tostring(0)].usage_active > args.alert_value )
      then
        naughty.notify({
          preset  = naughty.config.presets.critical,
          timeout = args.timeout,
          title   = "cpu Alert !",
          text    = "<span foreground= '#FFFFFF'>Warning, cpu usage above "..args.alert_value.." !</span>"
        })
      end
    end,
  }

  local update_widget_used = function (widget, stdout, stderr, exitcode, exitreason)

    widget:set_cpu_used(stdout)
  end

  awful.widget.watch("cat /proc/stat", args.timeout, update_widget_used, cpu)

  return cpu

end

return setmetatable(cpu, { __call = function(_, ...)
  return factory(...)
end })

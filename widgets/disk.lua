-- DESCRIPTION
-- ========================================================================
-- Widget to show the diskwork

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
local dpi      = require("beautiful.xresources").apply_dpi
-- Directory
local disk_dir = awful.util.getdir("config") .. "widgets/disk"
local disk     = {}
local excluded = {
  "Filesystem",
  "dev",
  "run",
  "tmpfs",
  "cdrom",
}

local function factory(args)
  local args       = args              or {}

  local function split(string_to_split, separator)
    if separator == nil then separator = "%s" end
    local t = {}

    for str in string.gmatch(string_to_split, "([^".. separator .."]+)") do
        table.insert(t, str)
    end

    return t
  end

  local function compute_tier_clr(value)
    local value = tonumber(value)
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

  local function get_disk_value(stat_lines)
    local disk = {}

    -- Get disk stats
    ------------------------------------------------------------
    for _,line in ipairs(split(stat_lines,"\r\n")) do
      local disk_raw_data = split(line," ")
      local curr_disk = {
        name = disk_raw_data[1],
        value = disk_raw_data[5]:gsub("%%",""),
      }

      local find = false
      for _,name in ipairs(args.excluded) do
        if curr_disk.name == name then
          find = true
        end
      end
      if not find then
        find = false
        for _,i_disk in ipairs(disk) do
          if i_disk.name == curr_disk.name then
            find = true
          end
        end
        if not find then
          table.insert(disk,curr_disk)
        end
      end
    end

    return disk
  end

  args.font        = args.font        or beautiful.disk_font        or beautiful.font
  args.bg          = args.bg          or beautiful.disk_bg          or "#000000"
  args.fg          = args.fg          or beautiful.disk_fg          or "#FFFFFF"
  args.height      = args.height      or beautiful.disk_height      or beautiful.wibar_height
  args.icon        = args.icon        or beautiful.disk_icon        or "Disk: "
  args.alert_value = args.alert_value or beautiful.disk_alert_value or 90
  args.timeout     = args.timeout     or beautiful.disk_timeout     or 1
  args.excluded    = args.excluded    or beautiful.disk_excluded    or excluded

  args.shape       = args.shape       or beautiful.disk_shape       or gears.shape.rect

  args.bar_shape   = args.bar_shape   or beautiful.disk_bar_shape   or default_shape
  args.bar_width   = args.bar_width   or beautiful.disk_bar_width   or 10
  args.bar_fg      = args.bar_fg      or beautiful.disk_bar_fg      or args.fg
  args.bar_bg      = args.bar_bg      or beautiful.disk_bar_bg      or args.bg

  args.tier1_clr   = args.tier1_clr   or beautiful.disk_tier1_clr   or args.fg
  args.tier2_clr   = args.tier2_clr   or beautiful.disk_tier2_clr   or args.fg
  args.tier3_clr   = args.tier3_clr   or beautiful.disk_tier3_clr   or args.fg
  args.tier4_clr   = args.tier4_clr   or beautiful.disk_tier4_clr   or args.fg
  args.tier1_val   = args.tier1_val   or beautiful.disk_tier1_val   or 25
  args.tier2_val   = args.tier2_val   or beautiful.disk_tier2_val   or 50
  args.tier3_val   = args.tier3_val   or beautiful.disk_tier3_val   or 75
  args.tier4_val   = args.tier4_val   or beautiful.disk_tier4_val   or args.max_value

  args.disks_value = get_disk_value(os.capture("df -H", true))

  disk_bars = wibox.widget {
    item = {},
    layout = wibox.layout.flex.horizontal,
  }

  for idx in pairs(args.disks_value) do
    local disk_template = wibox.widget {
      {
        {
          id               = "disk_bar_" .. tostring(idx),
          -- DEBUG
          value            = idx * 10,
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
     -- layout = wibox.layout.align.horizontal,
      widget = wibox.container.margin(_,5,5,0,0),
    }
    table.insert(disk_bars.item,disk_template)
    disk_bars:add(disk_template)
  end


  disk = wibox.widget
  {
    {
      {
        {
          id     = "disk_icon",
          markup = "<span"  .. " foreground = '"  .. args.fg .. "'>"  .. args.icon .. "</span>",
          font   = args.font,
          widget = wibox.widget.textbox,
        },
        {
          {
            item = disk_bars,
            id = "disk_bars",
            layout = wibox.layout.fixed.horizontal,
          },
          widget = wibox.container.margin(_,0,0,0,0),
        },
        layout = wibox.layout.align.horizontal,
      },
      widget = wibox.container.margin(_, 20, 20, 0, 0),
    },
    bg           = args.bg,
    shape        = args.shape,
    widget       = wibox.container.background,
    set_disk_used = function(self, disk_stdout)
      local disks_value = get_disk_value(disk_stdout)
      local clr_value  =  ""
      local alert_value = args.alert_value
      for idx=1,#disks_value do
        clr_value   = compute_tier_clr(disks_value[idx].value)
        widget = self:get_children_by_id("disk_bar_" .. idx)
        local str = "=="
        for idx, data in pairs(widget) do
          str = str .. " " .. tostring(idx) .. "++" .. tostring(data)
        end
        str = str .. "??"
          --v:get_children_by_id("disk_bar_" .. idx)[1].value = disks_value[idx].value
          --v:get_children_by_id("disk_bar_" .. idx)[1].color = clr_value
        show(10,str)

        --self:get_children_by_id("disk_bars")[idx].value   = disks_value[idx].value
        --self:get_children_by_id("disk_bars")[idx].color   = clr_value
        --self:get_children_by_id("disk_bar_" .. idx).value   = disks_value[idx].value
        --self:get_children_by_id("disk_bar_" .. idx).color   = clr_value
      end
      -- Update widget values
      --self:get_children_by_id("disk_icon")[1].markup     = "<span foreground='" .. clr_value .."'>".. args.icon .. "</span>"
      --self:get_children_by_id("disk_bar")[1].value   = disk_value.pourcent
      --self:get_children_by_id("disk_bar")[1].color   = clr_value
      --self:get_children_by_id("disk_value")[1].markup     = "<span foreground='" .. clr_value .."'>".. pourcent .. "</span>"
      --self:get_children_by_id("disk_load")[1].markup     = "<span foreground='" .. clr_value .."'>".. loadavg .. "</span>"
      -- Show alert if usage above specified threshold
--      if ( disk_value.pourcent > args.alert_value )
--      then
--        naughty.notify({
--          preset  = naughty.config.presets.critical,
--          title   = "disk Alert !",
--          text    = "<span foreground= '#FFFFFF'>Warning, disk usage above "..args.alert_value.." !</span>"
--        })
--      end
    end,
  }

  local update_widget_used = function (widget, stdout, stderr, exitcode, exitreason)
    widget:set_disk_used(stdout)
  end

  awful.widget.watch("df -H", args.timeout, update_widget_used, disk)

  return disk
end

return setmetatable(disk, { __call = function(_, ...)
  return factory(...)
end })

-- vim: fdm=indent
-- o
--
--
--
--
-- local disks = {}
--    watch([[bash -c "df | tail -n +2"]], _config.refresh_rate,
--            function(widget, stdout)
--                for line in stdout:gmatch("[^\r\n$]+") do
--                    local filesystem, size, used, avail, perc, mount =
--                        line:match('([%p%w]+)%s+([%d%w]+)%s+([%d%w]+)%s+([%d%w]+)%s+([%d]+)%%%s+([%p%w]+)')
--
--                    disks[mount] = {}
--                    disks[mount].filesystem = filesystem
--                    disks[mount].size = size
--                    disks[mount].used = used
--                    disks[mount].avail = avail
--                    disks[mount].perc = perc
--                    disks[mount].mount = mount
--
--                    if disks[mount].mount == _config.mounts[1] then
--                        widget:set_value(tonumber(disks[mount].perc))
--                    end
--                end
--
--                for k, v in ipairs(_config.mounts) do
--
--                    local row = wibox.widget {
--                        {
--                            text = disks[v].mount,
--                            forced_width = 150,
--                            widget = wibox.widget.textbox
--                        },
--                        {
--                            color = _config.popup_bar_color,
--                            max_value = 100,
--                            value = tonumber(disks[v].perc),
--                            forced_height = 20,
--                            paddings = 1,
--                            margins = 4,
--                            border_width = 1,
--                            border_color = _config.popup_bar_border_color,
--                            background_color = _config.popup_bar_background_color,
--                            bar_border_width = 1,
--                            bar_border_color = _config.popup_bar_border_color,
--                            widget = wibox.widget.progressbar,
--                        },
--                        {
--                            text = math.floor(disks[v].used / 1024 / 1024)
--                                    .. '/'
--                                    .. math.floor(disks[v].size / 1024 / 1024) .. 'GB('
--                                    .. math.floor(disks[v].perc) .. '%)',
--                            widget = wibox.widget.textbox
--                        },
--                        layout = wibox.layout.ratio.horizontal
--                    }
--                    row:ajust_ratio(2, 0.3, 0.3, 0.4)
--
--                    disk_rows[k] = row
--                end
--                popup:setup {
--                    {
--                        disk_header,
--                        disk_rows,
--                        layout = wibox.layout.fixed.vertical,
--                    },
--                    margins = 8,
--                    widget = wibox.container.margin
--                }
--            end,
--            storage_bar_widget
--    )

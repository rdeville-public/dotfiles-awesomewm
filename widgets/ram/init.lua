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
local ram_dir        = awful.util.getdir("config") .. "widgets/ram"
local ram_img        = ram_dir .. "/img/ram_"
local ram_img_suffix = ".svg"
local ram            = {}

-- METHODS
-- ========================================================================
local parallelogram_left = function(cr, width, height)
  gears.shape.transform(gears.shape.parallelogram)
    :scale(1,-1)
    :translate(0,-height)(cr, dpi(width), dpi(height), dpi(width - height/2))
end

local function factory(args)
  local default_command_total  = "cat /proc/meminfo | awk '/^MemTotal/{print $2}'"
  local default_command_free   = "cat /proc/meminfo | awk '/^MemFree/{print $2}'"
  local default_command_buffer = "cat /proc/meminfo | awk '/^Buffers/{print $2}'"
  local default_command_cached = "cat /proc/meminfo | awk '/^Cached/{print $2}'"
  local max_mem
  local args = args                                   or {}
  args.interface            = args.format                                 or "*"
  args.font                 = args.font                                   or beautiful.ram_font             or beautiful.font
  args.bg                   = args.bg                                     or beautiful.ram_bg               or "#FFFFFF"
  args.shape                = args.shape                                  or beautiful.ram_shape            or parallelogram_left
  args.timeout              = args.timeout                                or beautiful.ram_timeout          or 1
  args.width                = args.width                                  or beautiful.ram_width            or dpi(100)
  args.ram_font             = args.ram_font                               or beautiful.ram_font             or args.font
  args.ram_bar_used_color   = args.ram_bar_used_color                     or beautiful.ram_bar_used_color   or "#00FF00"
  args.ram_bar_cached_color = args.ram_bar_cached_color                   or beautiful.ram_bar_cached_color or "#FFFF00"
  args.ram_bar_buffer_color = args.ram_bar_buffer_color                   or beautiful.ram_bar_buffer_color or "#0000FF"
  args.ram_bar_bg           = args.ram_bar_bg                             or beautiful.ram_bar_bg           or "#000000"
  args.ram_bar_fill_shape   = args.ram_bar_fill_shape                     or beautiful.ram_bar_fill_shape   or args.shape
  args.ram_bar_shape        = args.ram_bar_shape                          or beautiful.ram_bar_shape        or args.shape
  args.ram_bar_width        = args.ram_bar_width                          or beautiful.ram_bar_width        or args.width
  args.command_total        = args.command_total                          or beautiful.ram_command_total    or default_command_total
  args.command_used         = args.command_used                           or beautiful.ram_command_used     or default_command_used
  args.command_free         = args.command_free                           or beautiful.ram_command_free     or default_command_free
  args.command_cached       = args.command_cached                         or beautiful.ram_command_cached   or default_command_cached
  args.command_buffer       = args.command_buffer                         or beautiful.ram_command_buffer   or default_command_buffer
  args.height               = beautiful.wibar_height
  args.max_value            = tonumber(os.capture(default_command_total))
  args.alert_value          = args.alert_value                            or beautiful.ram_alert_value      or args.max_value*0.8

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
    return string.format("%1.2f ",used) .. dim
  end

  ram = wibox.widget
  {
    {
      {
        {
          {
            {
              id            = "ram_icon",
              -- https://awesomewm.org/apidoc/classes/wibox.widget.imagebox.html
              widget        = wibox.widget.imagebox,
              -- DEBUG
              image         = ram_img .. "0" .. ram_img_suffix,
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
                id               = "ram_cached_bar",
                -- DEBUG
                value            = args.max_value/8*6,
                widget           = wibox.widget.progressbar,
                -- https://awesomewm.org/apidoc/classes/wibox.widget.progressbar.html
                clip         = true,
                color            = args.ram_bar_cached_color,
                background_color = args.ram_bar_bg,
                bar_shape        = args.ram_bar_fill_shape,
                shape            = args.ram_bar_shape,
                max_value        = args.max_value,
                forced_width     = args.ram_bar_width,
                opacity          = 100,
                visible          = true,
              },
              layout = wibox.container.margin(_, 0, 0, 2, 2),
            },
            {
              {
                id               = "ram_buffer_bar",
                -- DEBUG
                value            = args.max_value/8*5,
                widget           = wibox.widget.progressbar,
                -- https://awesomewm.org/apidoc/classes/wibox.widget.progressbar.html
                clip         = true,
                color            = args.ram_bar_buffer_color,
                background_color = "#00000000",
                bar_shape        = args.ram_bar_fill_shape,
                shape            = args.ram_bar_shape,
                max_value        = args.max_value,
                forced_width     = args.ram_bar_width,
                opacity          = 100,
                visible          = true,
              },
              layout = wibox.container.margin(_, 0, 0, 2, 2),
            },
            {
              {
                id               = "ram_used_bar",
                -- DEBUG
                value            = args.max_value/8*3,
                widget           = wibox.widget.progressbar,
                -- https://awesomewm.org/apidoc/classes/wibox.widget.progressbar.html
                clip         = true,
                color            = args.ram_bar_used_color,
                background_color = "#00000000",
                bar_shape        = args.ram_bar_fill_shape,
                shape            = args.ram_bar_shape,
                max_value        = args.max_value,
                forced_width     = args.ram_bar_width,
                opacity          = 100,
                visible          = true,
              },
              layout = wibox.container.margin(_, 0, 0, 2, 2),
            },
            {
              id            = "ram_value",
              widget        = wibox.widget.textbox,
              -- https://awesomewm.org/apidoc/classes/wibox.widget.textbox.html
              -- DEBUG
              markup        = "<span foreground='#FFFFFF'>".. string.format("%02d %%", 50) .. "</span>",
              --text          = "50%",
              ellipsize     = "end", -- start, middle, end
              wrap          = "word_char", -- word, char, word_char
              valign        = "center", -- top, center, bottom
              align         = "center", -- lefte, center, right
              font          = args.ram_font,
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
    set_ram_used = function(self, used, buffer, cached)
      -- Compute values
      local clr_value   = gradient_black_white(args.max_value,0,used)
      local ratio       = math.min( math.floor(used/args.max_value * 100), 100)
      local text_value  = content(used)
      local alert_value = content(args.alert_value)
      local img         = ram_img .. ratio .. ram_img_suffix
      -- Update widget values
      self:get_children_by_id("ram_used_bar")[1].value   = tonumber(used)
      self:get_children_by_id("ram_cached_bar")[1].value = tonumber(used + cached)
      self:get_children_by_id("ram_buffer_bar")[1].value = tonumber(used + buffer)
      self:get_children_by_id("ram_icon")[1].image       = img
      self:get_children_by_id("ram_value")[1].markup     = "<span foreground = '" .. clr_value .."'>".. text_value.. "</span>"
      -- Show alert if usage above specified threshold
      if ( used > args.alert_value )
      then
        naughty.notify({
          preset  = naughty.config.presets.critical,
          timeout = args.timeout,
          title   = "Ram Alert !",
          text    = "<span foreground= '#FFFFFF'>Warning, ram usage above "..alert_value.." !</span>"
        })
      end
    end,
  }

  local update_widget_used = function (widget, stdout, stderr, exitcode, exitreason)
    total  = tonumber(os.capture(args.command_total))
    free   = tonumber(os.capture(args.command_free))
    cached = tonumber(os.capture(args.command_cached))
    buffer = tonumber(os.capture(args.command_buffer))
    used   = total - free - cached - buffer
    widget:set_ram_used( used, buffer, cached)
  end

  awful.widget.watch("cat /proc/meminfo", args.timeout, update_widget_used, ram)

  return ram

end

return setmetatable(ram, { __call = function(_, ...)
  return factory(...)
end })

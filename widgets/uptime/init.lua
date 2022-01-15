-- DESCRIPTION
-- ========================================================================
-- Widget to show the uptime

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

-- VARIABLES
-- ========================================================================
local dpi        = require("beautiful.xresources").apply_dpi
-- Directory
local uptime_dir = awful.util.getdir("config") .. "widgets/uptime"
local uptime_img = uptime_dir .. "/img/uptime.svg"
local uptime     = {}

-- METHODS
-- ========================================================================
local parallelogram_left = function(cr, width, height)
  gears.shape.transform(gears.shape.parallelogram)
    :scale(1,-1)
    :translate(0,-height)(cr, dpi(width), dpi(height), dpi(width-height/2))
end

-- WIDGET
-- ========================================================================
local function factory(args)
  local default_command = "cat /proc/uptime"
  local args = args or {}
  args.format  = args.format            or " %a %d %b | %H:%M "
  args.font    = args.font              or beautiful.uptime_font    or beautiful.font
  args.fg      = args.fg                or beautiful.uptime_fg      or "#000000"
  args.bg      = args.bg                or beautiful.uptime_bg      or "#FFFFFF"
  args.shape   = args.shape             or beautiful.uptime_shape   or parallelogram_left
  args.img     = args.img               or beautiful.uptime_img     or uptime_img
  args.timeout = args.timeout           or beautiful.uptime_timeout or 10
  args.height  = beautiful.wibar_height
  args.command = args.command           or beautiful.command        or default_command

  local uptime = wibox.widget {
    {
      {
        {
          {
            -- https://awesomewm.org/apidoc/classes/wibox.widget.imagebox.html
            widget        = wibox.widget.imagebox,
            image         = uptime_img,
            --clip_shape    = ,
            resize        = true,
            forced_height = args.height-4,
            forced_width  = args.height-4,
            opacity       = 100,
            visible       = true,
          },
          widget = wibox.container.margin(_, 0, 5, 2, 2)
        },
        {
          id            = "text_value",
          widget        = wibox.widget.textbox,
          -- https://awesomewm.org/apidoc/classes/wibox.widget.textbox.html
          markup        = "<span foreground='"..args.fg.."'>"..string.format("%02d %%", 75).."</span>",
          ellipsize     = "end",       -- start, middle, end
          wrap          = "word_char", -- word, char, word_char
          valign        = "center",    -- top, center, bottom
          align         = "center",    -- left, center, right
          font          = font,
          opacity       = 100,
          visible       = true,
        },
        layout = wibox.layout.align.horizontal,
      },
      widget = wibox.container.margin(_, 15, 15, 0, 0),
    },
    fg           = args.fg,
    bg           = args.bg,
    shape        = args.shape,
    widget       = wibox.container.background,
    set_uptime = function(self, uptime)
      self:get_children_by_id("text_value")[1].markup = uptime
    end
  }

  local update_widget = function (widget, stdout, stderr, exitcode, exitreason)
    -- Get system uptime
    local up_t = math.floor(string.match(stdout, "[%d]+"))
    local up_d = math.floor(up_t   / (3600 * 24))
    local up_h = math.floor((up_t  % (3600 * 24)) / 3600)
    local up_m = math.floor(((up_t % (3600 * 24)) % 3600) / 60)

    local color_1
    if ( up_m == 0 ) and ( up_h == 0 ) and ( up_d == 0 )
    then
      color_1 = gradient(0, 15*24, 0)
    else
      color_1 = gradient(0, 15*24, up_d*24 + up_h)
    end
    -- Update color of svg icon
    os.capture(
      "sed -i " ..
      "-e 's/fill:\\#[[:xdigit:]]*/fill:" .. color_1 .. "/g' " ..
      "-e 's/stroke:\\#[[:xdigit:]]*/stroke:" .. color_1 .. "/g' " .. uptime_img,
      false)
    if up_d > 0
    then
      uptime.uptime = "<span foreground='"..color_1.."'>"
        ..string.format("%02d Days %02d:%02d", up_d, up_h, up_m)
        .."</span>"
    else
      uptime.uptime = "<span foreground='"..color_1.."'>"
        ..string.format("%02d:%02d", up_h, up_m)
        .."</span>"
    end
  end

  awful.widget.watch(args.command, args.timeout, update_widget)

  return uptime

end

return setmetatable(uptime, { __call = function(_, ...)
    return factory(...)
  end })

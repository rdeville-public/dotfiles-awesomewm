-- DESCRIPTION
-- ========================================================================
-- Widget to show the ip

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
local dpi = require("beautiful.xresources").apply_dpi
local ip  = {}

-- WIDGET
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


  args.font     = args.font              or beautiful.ip_font     or beautiful.font
  args.fg       = args.fg                or beautiful.ip_fg       or "#000000"
  args.bg       = args.bg                or beautiful.ip_bg       or "#FFFFFF"
  args.shape    = args.shape             or beautiful.ip_shape    or gears.shape.rect

  args.icon     = args.icon              or beautiful.ip_icon     or ""
  args.icon_vpn = args.icon_vpn          or beautiful.ip_icon_vpn or ""

  args.timeout = args.timeout           or beautiful.ip_timeout   or 30
  args.height  = args.height            or beautiful.ip_height    or beautiful.wibar_height

  local ip = wibox.widget {
    {
      {
        {
          id            = "ip_value",
          widget        = wibox.widget.textbox,
          -- https://awesomewm.org/apidoc/classes/wibox.widget.textbox.html
          markup        = "<span foreground='"..args.fg.."'>"..string.format("%s %s", args.icon, "0.0.0.0").."</span>",
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
    set_ip = function(self, ip)
      self:get_children_by_id("ip_value")[1].markup = "" ..
        "<span foreground='" .. args.fg .. "'>" ..
          string.format("%s %s", args.icon, ip) ..
        "</span>"
    end
  }

  local update_widget = function (widget, stdout, stderr, exitcode, exitreason)
    local route = {}
    for _,line in ipairs(split(stdout,'\r\n')) do
      if string.find(line, "src") then
        route = split(line," ")
        widget:set_ip(route[7])
        return
      end
    end
  end

  awful.widget.watch('ip route get 8.8.8.8', args.timeout, update_widget, ip)

  return ip

end

return setmetatable(ip, { __call = function(_, ...)
    return factory(...)
  end })

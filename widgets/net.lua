-- DESCRIPTION
-- ========================================================================
-- Widget to show the network

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
local net_dir        = awful.util.getdir("config") .. "widgets/net"
local up_net_img     = net_dir .. "/img/upload_"
local down_net_img   = net_dir .. "/img/download_"
local net_img_suffix = ".svg"
local net            = {}
local prev_rx        = 0
local prev_tx        = 0

-- METHODS
-- ========================================================================
local function factory(args)
  local args = args                                   or {}
  args.interface    = args.format             or "*"
  args.font         = args.font               or beautiful.net_font          or beautiful.font
  args.bg           = args.bg                 or beautiful.net_bg
  args.shape        = args.shape              or beautiful.net_shape         or gears.shape.rect
  args.timeout      = args.timeout            or beautiful.net_timeout       or 1
  args.max_value    = args.max_value          or beautiful.net_max_value     or 10 * 1024 * 1024
  args.alert_value  = args.alert_value        or beautiful.net_alert_value   or 7.5 * 1024 * 1024
  args.width        = args.width              or beautiful.net_width         or dpi(10)
  args.height       = beautiful.wibar_height

  args.up_icon      = args.up_icon            or beautiful.net_up_icon       or ""
  args.down_icon    = args.down_icon          or beautiful.net_down_icon     or ""

  args.online_icon  = args.online_icon        or beautiful.net_online_icon   or ""
  args.online_fg    = args.online_fg          or beautiful.net_online_fg     or "#00ff00"

  args.offline_icon = args.offline_icon       or beautiful.net_offline_icon  or ""
  args.offline_fg   = args.offline_fg         or beautiful.net_offline_fg    or "#ff0000"

  args.ping_timeout = args.ping_timeout       or beautiful.net_ping_timeout  or "3"
  args.ping_route   = args.ping_route         or beautiful.net_ping_route    or "wikipedia.org"

  args.tier1_clr    = args.tier1_clr          or beautiful.net_tier1_clr     or args.fg
  args.tier2_clr    = args.tier2_clr          or beautiful.net_tier2_clr     or args.fg
  args.tier3_clr    = args.tier3_clr          or beautiful.net_tier3_clr     or args.fg
  args.tier4_clr    = args.tier4_clr          or beautiful.net_tier4_clr     or args.fg
  args.tier1_val    = args.tier1_val          or beautiful.net_tier1_val     or 2.5 * 1024 * 1024
  args.tier2_val    = args.tier2_val          or beautiful.net_tier2_val     or 5 * 1024 * 1024
  args.tier3_val    = args.tier3_val          or beautiful.net_tier3_val     or 7.5 * 1024 * 1024
  args.tier4_val    = args.tier4_val          or beautiful.net_tier4_val     or args.max_value

  local default_command = string.format([[bash -c "cat /sys/class/net/%s/statistics/*_bytes"]], args.interface)
  args.command        = args.command        or beautiful.net_command    or default_command

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

  local function content(bytes, format)
    local format = format or "%03.0f %s"
    local speed
    local dim
    if bytes < 1024 then
        speed = bytes
        dim = 'b'
    elseif bytes < 1024^2 then
        speed = bytes/1024
        dim = 'kb'
    elseif bytes < 1024^3 then
        speed = bytes/1024^2
        dim = 'Mb'
    elseif bytes < 1024^4 then
        speed = bytes/1024^3
        dim = 'Gb'
    else
        speed = tonumber(bits)
        dim = 'b'
    end
    return string.format(format,math.floor(speed + 0.5), dim)
  end

  local function ping()
    local return_code = os.execute("ping -c 1 -w " .. args.ping_timeout .. " " .. args.ping_route)
    if return_code == 0 then
      return true
    end
    return false
  end

  local function split(string_to_split, separator)
    if separator == nil then separator = "%s" end
    local t = {}

    for str in string.gmatch(string_to_split, "([^".. separator .."]+)") do
        table.insert(t, str)
    end

    return t
  end

  local net = wibox.widget
  {
    {
      {
        {
          id            = "down_value",
          widget        = wibox.widget.textbox,
          -- https://awesomewm.org/apidoc/classes/wibox.widget.textbox.html
          -- DEBUG
          markup        = "<span foreground='#FFFFFF'>".. string.format("%04.1f%s", 50, args.up_icon) .. "</span>",
          --text          = "50%",
          ellipsize     = "end", -- start, middle, end
          wrap          = "word_char", -- word, char, word_char
          valign        = "center", -- top, center, bottom
          align         = "right", -- lefte, center, right
          font          = args.down_font,
          forced_height = dpi(args.height),
          forced_width  = dpi(args.height * 4),
          opacity       = 100,
          visible       = true,
        },
        {
          id = "online_status",
          widget = wibox.widget.textbox,
          markup        = "<span foreground='#FFFFFF'>".. string.format(" %s ", args.online_icon) .. "</span>",
        },
        {
          id            = "up_value",
          widget        = wibox.widget.textbox,
          -- https://awesomewm.org/apidoc/classes/wibox.widget.textbox.html
          -- DEBUG
          markup        = "<span foreground='#FFFFFF'>".. string.format("%s%04.1f", args.down_icon, 50) .. "</span>",
          --text          = "50%",
          ellipsize     = "end", -- start, middle, end
          wrap          = "word_char", -- word, char, word_char
          valign        = "center", -- top, center, bottom
          align         = "left", -- lefte, center, right
          font          = args.up_font,
          forced_height = dpi(args.height),
          forced_width  = dpi(args.height * 4),
          opacity       = 100,
          visible       = true,
        },
        layout = wibox.layout.align.horizontal,
      },
      widget = wibox.container.margin(_, 15, 15, 0, 0),
    },
    font = args.font,
    bg           = args.bg,
    shape        = args.shape,
    widget       = wibox.container.background,
    set_net = function(self, bytes, widget_name )
      -- Compute values
      local speed       = bytes
      local clr_value   = compute_tier_clr(speed)
      local text_value  = content(speed, "%04.1f%s")
      local alert_value = content(args.alert_value, "%1.0f %s")
      -- Update widget values
      if widget_name == "up" then
        self:get_children_by_id("up_value")[1].markup =
          "<span foreground='" .. clr_value .."'>"
          .. string.format("%s%s", args.up_icon, text_value)
          .. "</span>"
      elseif widget_name == "down" then
        self:get_children_by_id("down_value")[1].markup =
          "<span foreground='" .. clr_value .."'>"
          .. string.format("%s %s", text_value, args.down_icon)
          .. "</span>"
      end

      if ping then
        self:get_children_by_id("online_status")[1].markup =
          "<span foreground='" .. args.online_fg .."'>"
          .. string.format(" %s ", args.online_icon)
          .. "</span>"
      else
        self:get_children_by_id("online_status")[1].markup =
          "<span foreground='" .. args.offline_fg .."'>"
          .. string.format(" %s ", args.online_icon)
          .. "</span>"
      end

      -- Show alert if usage above specified threshold
--      if ( speed > args.alert_value )
--      then
--        if widget_name == "up" then
--          net_way = "UPLOAD"
--        elseif widget_name == "down" then
--          net_way = "DOWNLOAD"
--        end
--        naughty.notify({
--          preset  = naughty.config.presets.critical,
--          timeout = args.timeout,
--          title   = "Network Alert !",
--          text    = "<span foreground                = '#FFFFFF'>Warning, network " .. net_way .. " usage above "..alert_value.." !</span>"
--        })
--      end
    end,
  }

  local update_widget = function (widget, stdout, stderr, exitcode, exitreason)
    local cur_vals = split(stdout, '\r\n')
    local cur_rx   = 0
    local cur_tx   = 0
    local speed_rx = 0
    local speed_tx = 0

    for i, v in ipairs(cur_vals) do
        if i%2 == 1 then cur_rx = cur_rx + cur_vals[i] end
        if i%2 == 0 then cur_tx = cur_tx + cur_vals[i] end
    end

    speed_rx = cur_rx - prev_rx
    speed_tx = cur_tx - prev_tx

    widget:set_net(speed_rx,"down")
    widget:set_net(speed_tx,"up")

    prev_rx = cur_rx
    prev_tx = cur_tx
  end

  awful.widget.watch(args.command, args.timeout, update_widget, net)

  return net

end

return setmetatable(net, { __call = function(_, ...)
  return factory(...)
end })

-- vim: fdm=indent

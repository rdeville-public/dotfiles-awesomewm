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
local parallelogram_left = function(cr, width, height)
  gears.shape.transform(gears.shape.parallelogram)
    :scale(1,-1)
    :translate(0,-height)(cr, dpi(width), dpi(height), dpi(width - height/2))
end

local function factory(args)
  local args = args                                   or {}
  args.interface           = args.format              or "*"
  args.font                = args.font                or beautiful.net_font                or beautiful.font
  args.bg                  = args.bg                  or beautiful.net_bg                  or "#FFFFFF"
  args.shape               = args.shape               or beautiful.net_shape               or parallelogram_left
  args.timeout             = args.timeout             or beautiful.net_timeout             or 1
  args.max_value           = args.max_value           or beautiful.net_max_value           or 10*10^6
  args.alert_value         = args.alert_value         or beautiful.net_alert_value         or args.max_value*0.8
  args.width               = args.width               or beautiful.net_width               or dpi(100)
  args.up_font             = args.up_font             or beautiful.net_up_font             or args.font
  args.up_fg               = args.up_fg               or beautiful.net_up_fg               or "#FFFFFF"
  args.up_bar_fg           = args.up_bar_fg           or beautiful.net_up_bar_fg           or "#FFFFFF"
  args.up_bar_bg           = args.up_bar_bg           or beautiful.net_up_bar_bg           or "#000000"
  args.up_bar_fill_shape   = args.up_bar_fill_shape   or beautiful.net_up_bar_fill_shape   or args.shape
  args.up_bar_shape        = args.up_bar_shape        or beautiful.net_up_bar_shape        or args.shape
  args.up_bar_width        = args.up_bar_width        or beautiful.net_up_bar_width        or args.width
  args.down_font           = args.down_font           or beautiful.net_down_font           or args.font
  args.down_fg             = args.down_fg             or beautiful.net_down_fg             or "#FFFFFF"
  args.down_bar_fg         = args.down_bar_fg         or beautiful.net_down_bar_fg         or "#FFFFFF"
  args.down_bar_bg         = args.down_bar_bg         or beautiful.net_down_bar_bg         or "#000000"
  args.down_bar_fill_shape = args.down_bar_fill_shape or beautiful.net_down_bar_fill_shape or args.shape
  args.down_bar_shape      = args.down_bar_shape      or beautiful.net_down_bar_shape      or args.shape
  args.down_bar_width      = args.down_bar_width      or beautiful.net_down_bar_width      or args.width
  args.height              = beautiful.wibar_height

  local default_command = string.format([[bash -c "cat /sys/class/net/%s/statistics/*_bytes"]], args.interface)
  args.command        = args.command        or beautiful.net_command    or default_command

  local function content(bytes)
    local speed
    local dim
    local bits = bytes * 8
    if bits < 10^3 then
        speed = bits
        dim = 'b/s'
    elseif bits < 10^6 then
        speed = bits/10^3
        dim = 'kb/s'
    elseif bits < 10^9 then
        speed = bits/10^6
        dim = 'mb/s'
    elseif bits < 10^12 then
        speed = bits/10^9
        dim = 'gb/s'
    else
        speed = tonumber(bits)
        dim = 'b/s'
    end
    return string.format("%1.1f ",math.floor(speed + 0.5)) .. dim
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
          {
            {
              {
                id               = "down_bar",
                -- DEBUG
                value            = args.max_value/2,
                widget           = wibox.widget.progressbar,
                -- https://awesomewm.org/apidoc/classes/wibox.widget.progressbar.html
                color            = args.down_bar_fg,
                background_color = args.down_bar_bg,
                bar_shape        = args.down_bar_fill_shape,
                shape            = args.down_bar_shape,
                max_value        = args.max_value,
                forced_width     = args.down_bar_width,
                opacity          = 100,
                visible          = true,
              },
              layout = wibox.container.margin(_, 0, 0, 2, 2),
            },
            {
              id            = "down_value",
              widget        = wibox.widget.textbox,
              -- https://awesomewm.org/apidoc/classes/wibox.widget.textbox.html
              -- DEBUG
              markup        = "<span foreground='" .. args.down_fg .."'>".. string.format("%02d %%", 50) .. "</span>",
              --text          = "50%",
              ellipsize     = "end", -- start, middle, end
              wrap          = "word_char", -- word, char, word_char
              valign        = "center", -- top, center, bottom
              align         = "center", -- lefte, center, right
              font          = args.down_font,
              forced_height = args.height,
              forced_width  = args.height*2,
              opacity       = 100,
              visible       = true,
            },
            layout = wibox.layout.stack,
          },
          {
            {
              id            = "down_icon",
              -- https://awesomewm.org/apidoc/classes/wibox.widget.imagebox.html
              widget        = wibox.widget.imagebox,
              -- DEBUG
              image         = down_net_img .. "0" .. net_img_suffix,
              resize        = true,
              forced_height = 12,
              forced_width  = 12,
              opacity       = 100,
              visible       = true,
            },
            layout = wibox.container.margin(_, 5, 2, 2, 2),
          },
          layout = wibox.layout.align.horizontal,
        },
        {
          {
            {
              id            = "up_icon",
              -- https://awesomewm.org/apidoc/classes/wibox.widget.imagebox.html
              widget        = wibox.widget.imagebox,
              -- DEBUG
              image         = up_net_img .. "0" .. net_img_suffix,
              resize        = true,
              forced_height = 12,
              forced_width  = 12,
              opacity       = 100,
              visible       = true,
            },
            layout = wibox.container.margin(_, 2, 5, 2, 2),
          },
          {
            {
              {
                id               = "up_bar",
                -- DEBUG
                value            = args.max_value/2,
                widget           = wibox.widget.progressbar,
                -- https://awesomewm.org/apidoc/classes/wibox.widget.progressbar.html
                color            = args.up_bar_fg,
                background_color = args.up_bar_bg,
                bar_shape        = args.up_bar_fill_shape,
                shape            = args.up_bar_shape,
                max_value        = args.max_value,
                forced_width     = args.up_bar_width,
                opacity          = 100,
                visible          = true,
              },
              layout = wibox.container.margin(_, 0, 0, 2, 2),
            },
            {
              id            = "up_value",
              widget        = wibox.widget.textbox,
              -- https://awesomewm.org/apidoc/classes/wibox.widget.textbox.html
              -- DEBUG
              markup        = "<span foreground='" .. args.up_fg .."'>".. string.format("%02d %%", 50) .. "</span>",
              --text          = "50%",
              ellipsize     = "end", -- start, middle, end
              wrap          = "word_char", -- word, char, word_char
              valign        = "center", -- top, center, bottom
              align         = "center", -- lefte, center, right
              font          = args.up_font,
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
    set_net = function(self, bytes, widget_name )
      -- Compute values
      local speed       = bytes * 8
      local clr_bar     = gradient(0, args.max_value, speed)
      local clr_value   = gradient_black_white(args.max_value,0,speed)
      local ratio       = math.min( math.floor(speed/args.max_value * 100), 100)
      local text_value  = content(bytes)
      local alert_value = content(args.alert_value)
      local img
      if widget_name == "up" then
        img         = down_net_img .. ratio .. net_img_suffix
      elseif widget_name == "down" then
        img         = up_net_img .. ratio .. net_img_suffix
      end
      -- Update widget values
      self:get_children_by_id(widget_name .. "_bar")[1].value    = tonumber(speed)
      self:get_children_by_id(widget_name .. "_bar")[1].color    = clr_bar
      self:get_children_by_id(widget_name .. "_icon")[1].image   = img
      self:get_children_by_id(widget_name .. "_value")[1].markup = "<span foreground    = '" .. clr_value .."'>".. text_value.. "</span>"
      -- Show alert if usage above specified threshold
      if ( speed > args.alert_value )
      then
        if widget_name == "up" then
          net_way = "UPLOAD"
        elseif widget_name == "down" then
          net_way = "DOWNLOAD"
        end
        naughty.notify({
          preset  = naughty.config.presets.critical,
          timeout = args.timeout,
          title   = "Network Alert !",
          text    = "<span foreground                = '#FFFFFF'>Warning, network " .. net_way .. " usage above "..alert_value.." !</span>"
        })
      end
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

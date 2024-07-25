local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local uptime = {}

local function factory(args)
  local default_command = "cat /proc/uptime"
  args = args or {}
  args.font = args.font or beautiful.uptime_font or beautiful.font
  args.fg = args.fg or beautiful.uptime_fg or "#000000"
  args.bg = args.bg or beautiful.uptime_bg or "#FFFFFF"
  args.shape = args.shape or beautiful.uptime_shape or gears.shape.rect
  args.icon = args.icon or beautiful.uptime_icon or ""
  args.timeout = args.timeout or beautiful.uptime_timeout or 30
  args.height = args.height or beautiful.uptime_height or beautiful.wibar_height
  args.command = args.command or beautiful.command or default_command

  uptime = wibox.widget({
    {
      {
        {
          id = "text_value",
          widget = wibox.widget.textbox,
          -- https://awesomewm.org/apidoc/classes/wibox.widget.textbox.html
          markup = "<span foreground='" .. args.fg .. "'>" .. string.format(
            "%02d %%",
            75
          ) .. "</span>",
          ellipsize = "end", -- start, middle, end
          wrap = "word_char", -- word, char, word_char
          valign = "center", -- top, center, bottom
          align = "center", -- left, center, right
          opacity = 100,
          visible = true,
        },
        layout = wibox.layout.align.horizontal,
      },
      widget = wibox.container.margin(nil, 15, 15, 0, 0),
    },
    fg = args.fg,
    bg = args.bg,
    shape = args.shape,
    widget = wibox.container.background,
    set_uptime = function(self, data)
      self:get_children_by_id("text_value")[1].markup = data
    end,
  })

  local update_widget = function(_, stdout, _, _, _)
    -- Get system uptime
    local up_t = math.floor(string.match(stdout, "[%d]+"))
    local up_d = math.floor(up_t / (3600 * 24))
    local up_h = math.floor((up_t % (3600 * 24)) / 3600)
    local up_m = math.floor(((up_t % (3600 * 24)) % 3600) / 60)

    local color_1
    if (up_m == 0) and (up_h == 0) and (up_d == 0) then
      color_1 = gradient(0, 15 * 24, 0)
    else
      color_1 = gradient(0, 15 * 24, up_d * 24 + up_h)
    end
    if up_d > 0 then
      uptime.uptime = "<span foreground='"
        .. color_1
        .. "'>"
        .. string.format("%s %02d Days %02d:%02d", args.icon, up_d, up_h, up_m)
        .. "</span>"
    else
      uptime.uptime = "<span foreground='"
        .. color_1
        .. "'>"
        .. string.format("%s %02d:%02d", args.icon, up_h, up_m)
        .. "</span>"
    end
  end

  awful.widget.watch(args.command, args.timeout, update_widget)

  return uptime
end

return setmetatable(uptime, {
  __call = function(_, ...)
    return factory(...)
  end,
})

-- vim: fdm=indent

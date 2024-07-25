local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local keyboardlayout = {}

local function factory(args)
  args = args or {}

  return wibox.widget({
    {
      {
        {
          markup = ""
            .. "<span foreground='"
            .. beautiful.keyboardlayout_fg
            .. "'>"
            .. beautiful.keyboardlayout_icon
            .. "</span>",
          widget = wibox.widget.textbox,
        },
        awful.widget.keyboardlayout,
        layout = wibox.layout.align.horizontal,
      },
      widget = wibox.container.margin(nil, 15, 15, 0, 0),
    },
    fg = beautiful.keyboardlayout_fg,
    bg = beautiful.keyboardlayout_bg,
    --buttons      = require("config.buttons.keyboardlayout"),
    font = beautiful.font,
    shape = beautiful.keyboardlayout_shape,
    widget = wibox.container.background,
  })
end

return setmetatable(keyboardlayout, {
  __call = function(_, ...)
    return factory(...)
  end,
})

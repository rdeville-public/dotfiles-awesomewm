local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")

local button = {}

button.create = function(
  image,
  size,
  radius,
  margin,
  bg,
  bg_hover,
  bg_press,
  command
)
  local button_image = wibox.widget({
    image = image,
    forced_height = size,
    forced_width = size,
    widget = wibox.widget.imagebox,
  })

  local btn = wibox.widget({
    {
      button_image,
      margins = dpi(margin),
      widget = wibox.container.margin,
    },
    bg = bg,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, dpi(radius))
    end,
    widget = wibox.container.background,
  })

  btn:connect_signal("button::press", function()
    btn.bg = bg_press
    command()
  end)
  btn:connect_signal("button::leave", function()
    btn.bg = bg
  end)
  btn:connect_signal("mouse::enter", function()
    btn.bg = bg_hover
  end)
  btn:connect_signal("mouse::leave", function()
    btn.bg = bg
  end)
  btn.update_image = function(img)
    button_image.image = img
  end

  return button
end

button.create_widget = function(widget, command)
  local btn = wibox.widget({
    {
      widget,
      margins = dpi(10),
      widget = wibox.container.margin,
    },
    bg = beautiful.bg_normal,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, dpi(10))
    end,
    widget = wibox.container.background,
  })

  btn:connect_signal("button::press", function()
    btn.bg = beautiful.bg_very_light
    command()
  end)

  btn:connect_signal("button::leave", function()
    btn.bg = beautiful.bg_normal
  end)
  btn:connect_signal("mouse::enter", function()
    btn.bg = beautiful.bg_light
  end)
  btn:connect_signal("mouse::leave", function()
    btn.bg = beautiful.bg_normal
  end)

  return button
end

button.create_image = function(image, image_hover)
  local image_widget = wibox.widget({
    image = image,
    widget = wibox.widget.imagebox,
  })

  image_widget:connect_signal("mouse::enter", function()
    image_widget.image = image_hover
  end)
  image_widget:connect_signal("mouse::leave", function()
    image_widget.image = image
  end)

  return image_widget
end

button.create_image_onclick = function(image, image_hover, onclick)
  image = button.create_image(image, image_hover)

  local container = wibox.widget({
    image,
    widget = wibox.container.background,
  })

  container:connect_signal("button::press", onclick)

  return container
end

button.create_text = function(color, color_hover, text, font)
  local textWidget = wibox.widget({
    font = font,
    markup = "<span foreground='" .. color .. "'>" .. text .. "</span>",
    widget = wibox.widget.textbox,
  })

  textWidget:connect_signal("mouse::enter", function()
    textWidget.markup = "<span foreground='"
      .. color_hover
      .. "'>"
      .. text
      .. "</span>"
  end)
  textWidget:connect_signal("mouse::leave", function()
    textWidget.markup = "<span foreground='"
      .. color
      .. "'>"
      .. text
      .. "</span>"
  end)

  return textWidget
end

return button

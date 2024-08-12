-- DESCRIPTION
-- ========================================================================
-- Powerdark theme for Awesome WM.
-- Heavily inspired by powerarrow themes.

-- REQUIRED LIBRARY
-- ========================================================================
-- Awesome library
-- ------------------------------------------------------------------------
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi
local colors = require("widgets.colors")
local theme_assets = require("beautiful.theme_assets")
local shapes = require("utils.shapes")

-- THEME VARIABLES
-- ========================================================================
-- Init theme variable
-- ------------------------------------------------------------------------
local theme = {}
theme.dir = os.getenv("HOME") .. "/.config/awesome/theme/"

-- COLORS
-- ========================================================================
-- Default colors
-- ------------------------------------------------------------------------
theme.bg_main = colors.green_500
theme.fg_normal = colors.grey_300
theme.bg_normal = colors.green_700
theme.fg_urgent = colors.black
theme.bg_urgent = colors.red_500
theme.fg_occupied = colors.black
theme.bg_occupied = colors.orange_a400
theme.fg_focus = colors.black
theme.bg_focus = colors.light_green_a400
theme.fg_volatile = colors.black
theme.bg_volatile = colors.cyan_a400
theme.bg_darkest = colors.grey_900
theme.bg_darker = colors.grey_800
theme.bg_dark = colors.grey_700

-- Base beautiful variables
-- ------------------------------------------------------------------------
theme.font_name = "FiraCode Nerd Font"
theme.font_size = 10
theme.font = theme.font_name .. " " .. theme.font_size
theme.useless_gap = dpi(5)

-- Wallpaper configuration
-- ------------------------------------------------------------------------
-- Method to set a wallpaper based on current time
local function time_based_wallpaper()
  local path = theme.wallpaper_path
  if not string.sub(path, -1) == "/" then
    theme.wallpaper = path
    return theme.wallpaper
  else
    local hour = os.date("%H")
    local minute = tonumber(os.date("%M"))
    if minute < 15 then
      minute = 00
    elseif minute < 30 then
      minute = 15
    elseif minute < 45 then
      minute = 30
    elseif minute < 60 then
      minute = 45
    end
    theme.wallpaper = path .. string.format("%02d_%02d.png", hour, minute)
  end

  for s = 1, screen.count() do
    gears.wallpaper.maximized(theme.wallpaper, s, true)
  end
end
-- Set wallpaper
-- Dynamic, i.e. path a folder with last char being "/"
-- Static, i.e. path to the image
theme.wallpaper_path = theme.dir .. "/wallpapers/landscape/"
theme.wallpaper = time_based_wallpaper

-- Border variables
-- ------------------------------------------------------------------------
theme.border_width = dpi(2)
theme.border_normal = colors.grey_900
theme.border_focus = bg_focus
theme.border_urgent = bg_urgent

-- Hotkeys
-- ------------------------------------------------------------------------
theme.hotkeys_bg = colors.grey_900
theme.hotkeys_fg = colors.grey_a100
theme.hotkeys_border_width = theme.border_width
theme.hotkeys_border_color = colors.green_a700
theme.hotkeys_shape = gears.shape.rect
theme.hotkeys_modifiers_fg = colors.yellow_a700
theme.hotkeys_label_bg = colors.black
theme.hotkeys_label_fg = colors.black
theme.hotkeys_font = theme.font
theme.hotkeys_description_font = theme.font
theme.hotkeys_group_margin = 10

-- Naughty notification
-- ------------------------------------------------------------------------
theme.notification_font = theme.font
theme.notification_bg = theme.bg_normal
theme.notification_fg = theme.fg_normal
theme.notification_border_width = 5
theme.notification_border_color = theme.focus
theme.notification_shape = gears.shape.rect
theme.notification_opacity = 90
theme.notification_margin = 10
theme.notification_icon_size = 64

-- Wibar
-- ------------------------------------------------------------------------
theme.wibar_height = 20
theme.wibar_fg = theme.fg_normal
theme.wibar_bg = theme.bg_main .. "44"

-- Systray widget variables
-- ------------------------------------------------------------------------
theme.systray_bg = colors.brown_500
theme.bg_systray = theme.systray_bg
theme.systray_icon_spacing = dpi(0)
theme.systray_shape = shapes.rectangular_tag_inv
local systray_widget = require("widgets.systray")

-- Taglist
-- ------------------------------------------------------------------------
theme.taglist_font = theme.font
theme.taglist_fg_focus = theme.fg_focus
theme.taglist_bg_focus = theme.bg_focus
theme.taglist_fg_urgent = theme.fg_urgent
theme.taglist_bg_urgent = theme.bg_urgent
theme.taglist_fg_occupied = theme.fg_occupied
theme.taglist_bg_occupied = theme.bg_occupied
theme.taglist_fg_empty = theme.fg_normal
theme.taglist_bg_empty = theme.bg_main .. "44"
theme.taglist_fg_volatile = theme.fg_volatile
theme.taglist_bg_volatile = theme.bg_volatile
theme.taglist_shape = shapes.powerline
theme.taglist_spacing = -dpi(5)

-- Tasklist
-- ------------------------------------------------------------------------
theme.tasklist_fg_normal = colors.black
theme.tasklist_bg_normal = colors.grey_700
theme.tasklist_fg_focus = colors.black
theme.tasklist_bg_focus = colors.green_a700
theme.tasklist_fg_urgent = colors.black
theme.tasklist_bg_urgent = colors.red_a700
theme.tasklist_fg_minimize = colors.black
theme.tasklist_bg_minimize = colors.purple_a700
theme.tasklist_disable_icon = false
theme.tasklist_disable_task_name = true
theme.tasklist_plain_task_name = false
theme.tasklist_font = theme.font
theme.tasklist_align = "center"
theme.tasklist_font_focus = theme.font
theme.tasklist_font_minimized = theme.font
theme.tasklist_font_urgent = theme.font
theme.tasklist_close = " "
theme.tasklist_minimize = " "
theme.tasklist_sticky = " "
theme.tasklist_ontop = "󰝕 "
theme.tasklist_floating = " "
theme.tasklist_maximized = " "

-- Battery widget
-- ------------------------------------------------------------------------
theme.bat_fg = theme.fg_normal
theme.bat_bg = theme.bg_darker
theme.bat_shape = shapes.powerline_inv
theme.bat_icon = ""
theme.bat_bar_bg = theme.bg_darkest

theme.bat_tier1_clr_discharging = colors.red_500
theme.bat_tier2_clr_discharging = colors.orange_500
theme.bat_tier3_clr_discharging = colors.yellow_500
theme.bat_tier4_clr_discharging = colors.green_500
theme.bat_icon_discharging_1 = " "
theme.bat_icon_discharging_2 = " "
theme.bat_icon_discharging_3 = " "
theme.bat_icon_discharging_4 = " "

theme.bat_tier1_clr_charging = colors.red_500
theme.bat_tier2_clr_charging = colors.orange_500
theme.bat_tier3_clr_charging = colors.yellow_500
theme.bat_tier4_clr_charging = colors.green_500
theme.bat_icon_charging_1 = " "
theme.bat_icon_charging_2 = " "
theme.bat_icon_charging_3 = "  "
theme.bat_icon_charging_4 = " "

-- Keyboard Layout widget
-- ------------------------------------------------------------------------
theme.keyboardlayout_fg = colors.yellow_500
theme.keyboardlayout_bg = theme.bg_dark
theme.keyboardlayout_icon = " "
theme.keyboardlayout_shape = shapes.powerline_inv

-- IP widget
-- ------------------------------------------------------------------------
theme.ip_bg = theme.bg_darker
theme.ip_fg = colors.purple_300
theme.ip_shape = shapes.powerline_inv
theme.ip_icon = " "
theme.ip_icon = " "
theme.ip_icon_vpn = "旅"

-- Uptime widget
-- ------------------------------------------------------------------------
theme.uptime_bg = theme.bg_dark
theme.uptime_fg = theme.fg_normal
theme.uptime_shape = shapes.powerline_inv
theme.uptime_icon = " "

-- Disk widget
-- ------------------------------------------------------------------------
theme.disk_bg = theme.bg_darker
theme.disk_fg = theme.fg_normal
theme.disk_shape = shapes.powerline_inv
theme.disk_icon = " "
theme.disk_bar_bg = theme.bg_darkest

theme.disk_tier1_clr = colors.green_500
theme.disk_tier2_clr = colors.yellow_500
theme.disk_tier3_clr = colors.orange_500
theme.disk_tier4_clr = colors.red_500

-- Net widget variables
-- ------------------------------------------------------------------------
theme.net_bg = theme.bg_dark
theme.net_fg = theme.fg_normal
theme.net_shape = shapes.powerline_inv
theme.net_up_icon = " "
theme.net_down_icon = " "
theme.net_online_icon = "󰲝 "
theme.net_offline_icon = "󰲜 "

theme.net_tier1_clr = colors.green_500
theme.net_tier2_clr = colors.yellow_500
theme.net_tier3_clr = colors.orange_500
theme.net_tier4_clr = colors.red_500

-- Ram widget variables
-- ------------------------------------------------------------------------
theme.ram_bg = theme.bg_darker
theme.ram_fg = theme.fg_normal
theme.ram_shape = shapes.powerline_inv
theme.ram_icon = "  "
theme.ram_bar_bg = theme.bg_darkest

theme.ram_tier1_clr = colors.green_500
theme.ram_tier2_clr = colors.yellow_500
theme.ram_tier3_clr = colors.orange_500
theme.ram_tier4_clr = colors.red_500

-- CPU widget variables
-- ------------------------------------------------------------------------
theme.cpu_bg = theme.bg_dark
theme.cpu_fg = theme.fg_normal
theme.cpu_shape = shapes.powerline_inv
theme.cpu_icon = " "
theme.cpu_bar_bg = theme.bg_darkest

theme.cpu_tier1_clr = colors.green_500
theme.cpu_tier2_clr = colors.yellow_500
theme.cpu_tier3_clr = colors.orange_500
theme.cpu_tier4_clr = colors.red_500

-- Date widget variables
-- ------------------------------------------------------------------------
theme.date_format = " %a %d %b | %H:%M"
theme.date_fg = theme.fg_normal
theme.date_bg = theme.bg_darker
theme.date_shape = shapes.powerline_inv

-- Control Center widget variables
-- ------------------------------------------------------------------------
theme.control_center_icon = " "
theme.control_center_fg = theme.fg_normal
theme.control_center_bg = theme.bg_dark
theme.control_center_shape = shapes.powerline_inv

cc_img_dir = theme.dir .. "icons/control_center/"
theme.cc_popup_fg = theme.fg_normal
theme.cc_popup_bg = theme.bg_darkest .. "AA"
theme.cc_popup_shape = shapes.rounded_rect
theme.cc_popup_default_btn_bg = theme.bg_darkest
theme.cc_popup_default_btn_bg_active = theme.bg_darker
theme.cc_popup_default_btn_icon = cc_img_dir .. "add.svg"

theme.cc_user_fg = theme.bg_normal
theme.cc_user_bg = theme.bg_darkest .. "88"
theme.cc_user_name = "Tikka"
theme.cc_user_icon = cc_img_dir .. "user_light.svg"

theme.cc_logout_fg = theme.bg_normal
theme.cc_logout_bg = theme.bg_darkest .. "88"
theme.cc_icon_power_path = cc_img_dir .. "system-shutdown.svg"

theme.cc_default_bg_button = colors.grey_500 .. "88"
theme.cc_default_bg_button_inactive = colors.grey_700 .. "88"
theme.cc_default_bg_button_active = colors.green_500 .. "88"
theme.cc_default_bg_button_connected = colors.red_500 .. "88"

theme.cc_button_do_not_disturb_inactive = theme.cc_default_bg_button_inactive
theme.cc_button_do_not_disturb_active = theme.cc_default_bg_button_active
theme.cc_do_not_disturb_icon_path = cc_img_dir .. "notifications.svg"

theme.cc_button_redshift_inactive = theme.cc_default_bg_button_inactive
theme.cc_button_redshift_active = theme.cc_default_bg_button_active
theme.cc_redshift_icon_path = cc_img_dir .. "redshift.svg"

theme.cc_button_airplaine_inactive = theme.cc_default_bg_button_inactive
theme.cc_button_airplaine_active = theme.cc_default_bg_button_active
theme.cc_airplaine_icon_path = cc_img_dir .. "airplane.svg"

theme.cc_button_bluetooth_presence = true
theme.cc_button_bluetooth_inactive = theme.cc_default_bg_button_inactive
theme.cc_button_bluetooth_active = theme.cc_default_bg_button_active
theme.cc_button_bluetooth_paired = theme.cc_default_bg_button_connected
theme.cc_bluetooth_icon_path = cc_img_dir .. "bluetooth.svg"

theme.cc_button_network_inactive = theme.cc_default_bg_button_inactive
theme.cc_button_network_active = theme.cc_default_bg_button_active
theme.cc_button_network_paired = theme.cc_default_bg_button_connected
theme.cc_network_wlan_interface = "wlp170s0"
theme.cc_network_lan_interface = ""
theme.cc_network_lan_down_icon_path = cc_img_dir .. "network-lan-down.svg"
theme.cc_network_lan_up_icon_path = cc_img_dir .. "network-lan-up.svg"
theme.cc_network_wifi_down_icon_path = cc_img_dir .. "network-wifi-down.svg"
theme.cc_network_wifi_up_icon_path = cc_img_dir .. "network-wifi-up.svg"

theme.cc_micro_active = theme.cc_default_bg_button_active
theme.cc_micro_inactive = theme.cc_default_bg_button_inactive
theme.cc_micro_icon_path = cc_img_dir .. "microphone.svg"

theme.cc_brightness_icon_path = cc_img_dir .. "brightness.svg"
theme.cc_brightness_bg_button = theme.cc_default_bg_button

theme.cc_volume_normal_icon_path = cc_img_dir .. "volume-normal.svg"
theme.cc_volume_normal_color = theme.bg_focus
theme.cc_volume_muted_icon_path = cc_img_dir .. "volume-muted.svg"
theme.cc_volume_muted_color = theme.cc_default_bg_button
theme.cc_volume_bg_button = theme.cc_default_bg_button

theme.cc_notif_clear_all_icon = cc_img_dir .. "clear-all.svg"
theme.cc_notif_empty_icon = cc_img_dir .. "notifications.svg"
theme.cc_notif_dismiss = cc_img_dir .. "remove.svg"
theme.cc_notif_dismiss_bg = colors.red_500 .. "88"
theme.cc_notif_default_bg = theme.bg_normal .. "44"

-- Layoutbox widget variables
-- ------------------------------------------------------------------------
--
-- Image location
local layout_img_dir = theme.dir .. "/icons/layouts/"
theme.layout_cornernw = layout_img_dir .. "cornernw.png"
theme.layout_cornerne = layout_img_dir .. "cornerne.png"
theme.layout_cornersw = layout_img_dir .. "cornersw.png"
theme.layout_cornerse = layout_img_dir .. "cornerse.png"
theme.layout_fairh = layout_img_dir .. "fairhorizontal.png"
theme.layout_fairv = layout_img_dir .. "fair.png"
theme.layout_floating = layout_img_dir .. "floating.png"
theme.layout_magnifier = layout_img_dir .. "magnifier.png"
theme.layout_max = layout_img_dir .. "max.png"
theme.layout_fullscreen = layout_img_dir .. "maxfullscreen.png"
theme.layout_tile = layout_img_dir .. "tile.png"
theme.layout_tiletop = layout_img_dir .. "tiletop.png"
theme.layout_tilebottom = layout_img_dir .. "tilebottom.png"
theme.layout_tileleft = layout_img_dir .. "tileleft.png"
-- Layout widget
theme.layout_fg = theme.fg_normal
theme.layout_bg = theme.bg_main .. "00"
theme.layout_shape = shapes.powerline_inv
theme_assets.recolor_layout(theme, theme.fg_normal)

local top_left_wibar = function(screen)
  return { -- Left widgets
    systray,
    require("widgets.taglist")(screen),
    spacing = -dpi(theme.wibar_height / 4),
    layout = wibox.layout.fixed.horizontal,
  }
end

local top_center_wibar = function(screen)
  return { -- Middle widgets
    require("widgets.tasklist")(screen),
    layout = wibox.layout.flex.horizontal,
  }
end

local top_right_wibar = function(screen, tag)
  return { -- Right widgets
    spacing = -dpi(theme.wibar_height / 4),
    layout = wibox.layout.fixed.horizontal,
    require("widgets.keyboardlayout")(),
    require("widgets.bat")(),
    --require("widgets.ip")(),
    require("widgets.uptime")(),
    --require("widgets.disk")(),
    --require("widgets.net")(),
    --require("widgets.ram")(),
    --require("widgets.cpu")(),
    require("widgets.date")(),
    require("widgets.control_center")(screen),
    require("widgets.layouts")(screen, tag),
  }
end

function theme.at_screen_connect(s)
  -- Time based wallpaper configuration
  gears.timer({
    timeout = 300,
    call_now = true,
    autostart = true,
    callback = time_based_wallpaper,
  })
  screen.connect_signal("request::wallpaper", time_based_wallpaper)
  -- Init tags
  awful.tag(awful.util.tagnames, s, awful.layout.layouts)

  -- THE TOP WIBAR
  -- ========================================================================
  -- Empty top wibar to create a "margin"
  s.empty_top_bar = awful.wibar({
    position = "top",
    screen = s,
    height = dpi(theme.wibar_height / 2),
    bg = "#00000000",
  })
  -- The real top wibar
  s.top_bar = awful.wibar({
    position = "top",
    screen = s,
    height = dpi(theme.wibar_height),
    width = s.geometry.width - 4 * theme.useless_gap,
    fg = theme.wibar_fg,
    bg = theme.wibar_bg,
  })

  -- Add widgets to the wibar
  -- ------------------------------------------------------------------------
  systray = nil
  if s == screen[1] then
    systray = systray_widget()
  end
  s.top_bar:setup({
    layout = wibox.layout.align.horizontal,
    top_left_wibar(s),
    top_center_wibar(s),
    top_right_wibar(s, tag),
  })
end

return theme

-- vim: ft=lua: fdm=indent

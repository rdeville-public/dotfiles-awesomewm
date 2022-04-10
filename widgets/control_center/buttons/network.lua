local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")

local apps          = require("config.apps")
local create_button    = require("widgets.control_center.buttons.create-button")

-- Network button for control center
local network_button = create_button.circle_big(beautiful.cc_network_wifi_up_icon_path)
local background = network_button:get_children_by_id("background")[1]
local label = network_button:get_children_by_id("label")[1]
local icon = network_button:get_children_by_id("icon")[1]

network_button.curr_state = {}
network_button.curr_state.wireless = ""
network_button.state = {}

function network_button.notify(message, title, app_name, icon)
  naughty.notification({
    message = message,
    title = title,
    app_name = app_name,
    icon = icon
  })
end

-- Create wireless connection notification
function network_button.notify_wireless_connected(essid)
  local message = 'Wireless connected to <b>\"' .. essid .. '\"</b>'
  local title = 'Connection Established'
  local app_name = 'System Notification'
  local icon = beautiful.cc_network_wifi_up_icon_path
  network_button.notify(message, title, app_name, icon)
end

-- Create wired connection notification
function network_button.notify_wired_connected()
  local message = 'Ethernet connected with <b>\"' .. beautiful.cc_network_lan_interface .. '\"</b>'
  local title = 'Connection Established'
  local app_name = 'System Notification'
  local icon = beautiful.cc_network_lan_up_icon_path
  network_button.notify(message, title, app_name, icon)
end

function network_button.notify_wireless_disconnected ()
  local message = 'Wi-Fi network has been disconnected'
  local title = 'Connection Disconnected'
  local app_name = 'System Notification'
  local icon = beautiful.cc_network_wifi_down_icon_path
  network_button.notify(message, title, app_name, icon)
end

function network_button.notify_wired_disconnected()
  local message = 'Ethernet network has been disconnected'
  local title = 'Connection Disconnected'
  local app_name = 'System Notification'
  local icon = beautiful.cc_network_lan_down_icon_path
  network_button.notify(message, title, app_name, icon)
end

-- Get wifi essid
function network_button.set_essid(widget)
  return awful.spawn.easy_async_with_shell(
    "iw dev " .. beautiful.cc_network_wlan_interface .. " link",
    function(stdout)
      local essid = stdout:match('SSID: (.-)\n') or 'N/A'
      widget:set_text(essid)
    end
  )
end

local update_button = function()
  awful.spawn.easy_async_with_shell(
    [=[
    wireless="]=] .. tostring(beautiful.cc_network_wlan_interface) .. [=["
    wired="]=] .. tostring(beautiful.cc_network_lan_interface) .. [=["
    net="/sys/class/net/"
    wired_state="down"
    wireless_state="down"
    network_mode=""
    # Check network state
    function check_network_state() {
      # Check what interface is up
      network_mode=''
      if [[ "${wireless_state}" == "up" ]];
      then
        network_mode+="wireless\n"
        if iw dev "${wireless}" link | grep -q "Not"
        then
          network_mode+="No internet connection\n"
        else
          network_mode+="$(iw dev ${wireless} link | grep SSID | cut -d ":" -f 2)"
        fi
      fi
      if [[ "${wired_state}" == "up" ]];
      then
        network_mode+='wired\n'
      fi
      if [[ "${wireless_state}" == "down" && "${wired_state}" == "down" ]]
      then
        network_mode+='No internet connection\n'
      fi
    }
    # Check if network directory exist
    function check_network_directory() {
      if rfkill list wlan | grep -q "Soft blocked: no"
      then
        wireless_state="up"
      else
        wireless_state="down"
      fi
      if [[ -n "${wired}" && -d "${net}${wired}" ]]; then
        wired_state="$(cat "${net}${wired}/operstate")"
      fi
      check_network_state
    }
    # Start script
    function print_network_mode() {
      # Call to check network dir
      check_network_directory
      # Print network mode
      printf "${network_mode}"
    }
    print_network_mode
    ]=],
    function(stdout)
      local mode = {}
      for match in (stdout):gmatch("(.-)"..'%\n') do
        table.insert(mode, match);
      end
      for idx_mode = 1, #mode do
        if idx_mode == 1 then
          if not mode[idx_mode] == "wireless" then
            network_button.curr_state.wireless = "down"
          elseif mode[idx_mode + 1] == "wired" then
              network_button.curr_state.wireless = "up"
          else
            idx_mode = idx_mode + 1
            network_button.curr_state.wireless = mode[idx_mode]
          end
          if mode[idx_mode] == "wired" then
            network_button.curr_state.wired = "up"
          end
        end
      end
      if stdout:match('No internet connection') then
        network_button.curr_state.is_connected = false
        label:set_text("Offline")
        if stdout:match('wireless') then
          background:set_bg(beautiful.cc_button_network_active)
          icon:set_image(beautiful.cc_network_wifi_down_icon_path)
        elseif stdout:match('wired') then
          background:set_bg(beautiful.cc_button_network_inactive)
          icon:set_image(beautiful.cc_network_lan_down_icon_path)
        end
      else
        network_button.curr_state.is_connected = true
        if stdout:match('wireless') then
          network_button.set_essid(label)
          background:set_bg(beautiful.cc_button_network_paired)
          icon:set_image(beautiful.cc_network_wifi_up_icon_path)
        else
          background:set_bg(beautiful.cc_button_network_paired)
          label:set_text("Connected")
          icon:set_image(beautiful.cc_network_lan_up_icon_path)
        end
      end
      if network_button.state.is_connected == nil then
         for key,val in pairs(network_button.curr_state) do
            network_button.state[key] = val
        end
      else
        if not network_button.state.is_connected == network_button.curr_state.is_connected then
          if network_button.curr_state.is_connected then
            --if not network_button.state.wireless == network_button.curr_state.wireless then
            if not network_button.curr_state.wireless == network_button.state.wireless then
              network_button.notify_wired_connected()
            else
              network_button.notify_wireless_connected(network_button.curr_state.wireless)
            end
          else
            if not network_button.curr_state.wireless == network_button.state.wireless then
              network_button.notify_wired_disconnected()
            else
              network_button.notify_wireless_disconnected()
            end
          end
        end
      end
      for key,val in pairs(network_button.curr_state) do
        network_button.state[key] = val
      end
    end
  )
end

gears.timer {
  timeout = 5,
  autostart = true,
  call_now = true,
  callback = function ()
    update_button()
  end
}

update_button()

network_button:connect_signal(
  "button::press",
  function (_,_,_,button)
    if button == 1 then
      awful.spawn.easy_async_with_shell("rfkill list wifi", function (stdout)
        if stdout:match("Soft blocked: yes") then
          awful.spawn.single_instance("rfkill unblock wifi")
          label:set_text("Go on...")
        else
          awful.spawn.single_instance("rfkill block wifi")
          label:set_text("Go off...")
        end
      end)
    end

    if button == 3 then
      awful.spawn.single_instance(apps.network_manager)
    end
  end
)

return network_button


local awful                                 = require("awful")
local naughty                               = require("naughty")
local beautiful                             = require("beautiful")

-- | Functions | --------------------------------------------------------------
-- | Hide notification | FOR DEBUG PURPOSE
function hide()
    if notification ~= nil then
        naughty.destroy(notification)
        notification = nil
    end
end
-- | Show notification | FOR DEBUG PURPOSE
function show(t_out, text_out)
    hide()
    notification = naughty.notify({
      preset     = fs_notification_preset,
      text       = text_out,
      timeout    = t_out,
      screen     = mouse.screen,
    })
end
-- | Check file | FOR DEBUG PURPOSE
function file_exists(name)
     local f=io.open(name,"r")
     if f~=nil then io.close(f) return true else return false end
end
-- | Autostart Application
function run_once(cmd_arr)
  for _, cmd in ipairs(cmd_arr) do
    findme = cmd
    firstspace = cmd:find(" ")
    if firstspace then
      findme = cmd:sub(0, firstspace-1)
    end
    awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd))
    end
end
-- | Round function for display
function round(num)
    under = math.floor(num)
    upper = math.floor(num) + 1
    underV = -(under - num)
    upperV = upper - num
    if (upperV > underV) then
        return under
    else
        return upper
    end
end

-- | Gradient color
function gradient_black_white(min, max, val)
  local white = 0
  if ( min >= max ) then
    temp =  min
    min = max
    max = temp
  end
  white = math.abs(round(255 - (255 * val) / (max - min)))
  if white > 255 then
    white = 255
  end
  return string.format("#%02x%02x%02x", white, white, white)
end

function gradient(min, max, val)
  local v,d,red,green
  if ( min >= max ) then
    if (val > min) then val = min end
    if (val < max) then val = max end

    v = val - max
    d = (min - max) * 0.5

    if (v <= d) then
      red = 255
      green = round((255 * v) / d)
    else
      red = round(255 - (255 * (v-d)) / (min - max - d))
      green = 255
    end
  else
    if (val > max) then val = max end
    if (val < min) then val = min end

    v = val - min
    d = (max - min) * 0.5

    if (v <= d) then
      red = round((255 * v) / d)
      green = 255
    else
      red = 255
      green = round(255 - (255 * (v-d)) / (max - min - d))
    end
  end

  return string.format("#%02x%02x00", red, green)
end
-- | Get CPU/HDD/GPU Temperature
local function getTemp()
    temp = {}
    temp.cpu = {}

    f = io.popen("sensors | grep '°C' | grep 'high' | grep -e 'Core' -e 'Physical'")
    for line in f:lines() do
        cpu = {}
        cpu.curr  = tonumber(string.sub(string.match(line, "[%d]+.[%d]+°C"), 0, 4))
        cpu.high  = tonumber(string.sub(string.match(line, "[%d]+.[%d]+°C,"), 0, 4))
        cpu.crit  = tonumber(string.sub(string.match(line, "[%d]+.[%d]+°C%)"), 0, 4))
        table.insert(temp.cpu, cpu )
    end
    return temp
end


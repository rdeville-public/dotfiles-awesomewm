
local awful                                 = require("awful")
local naughty                               = require("naughty")
local beautiful                             = require("beautiful")

-- FUNCTIONS
-- ============================================================================
-- Hide notification
function hide()
  if notification ~= nil then
    naughty.destroy(notification)
    notification = nil
  end
end

-- Show notification
function show(t_out, text_out)
  notification = naughty.notify({
    preset     = fs_notification_preset,
    text       = text_out,
    timeout    = t_out,
    screen     = mouse.screen,
  })
end

-- Check file
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

-- Return list of files in directory
function scandir(directory)
  local ext = ext or ""
  local i, t, popen = 0, {}, io.popen
  local pfile = popen("ls '" .. directory.. "'")
  for filename in pfile:lines() do
    i = i + 1
    t[i] = filename
  end
  pfile:close()
  return t
end

-- Autostart Application
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

-- Round function for display
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

-- On the fly useless gaps change
function useless_gaps_resize(thatmuch, s, t)
    local scr = s or awful.screen.focused()
    local tag = t or scr.selected_tag
    tag.gap = tag.gap + tonumber(thatmuch)
    awful.layout.arrange(scr)
end

-- Gradient black and white
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

-- Gradient Green to red colors
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

-- OS command method
function os.capture(cmd, raw)
  local f = assert(io.popen(cmd,'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
    s = string.gsub(s, '^%s+', '')
    s = string.gsub(s, '%s+$', '')
    s = string.gsub(s, '[\n\r]+', '')
  return s
end

function hex2rgba(hex,alpha)
  local hex = hex:gsub("#","")
  if alpha then
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6), tonumber("0x"..alpha))
  else
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
  end
end

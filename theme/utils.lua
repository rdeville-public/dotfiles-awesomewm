local gears = require("gears")

-- Method to set a wallpaper based on current time
---@diagnostic disable-next-line lowercase-global
local function time_based_wallpaper()
  local path = script_path() .. "/wallpapers/landscape/"
  if not string.sub(path, -1) == "/" then
    return path
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
    path = path .. string.format("%02d_%02d.png", hour, minute)
    ---@diagnostic disable-next-line undefined-global
    for idx = 1, screen.count() do
      gears.wallpaper.maximized(path, idx, true)
    end
    return path
  end
end

---@diagnostic disable-next-line lowercase-global
local function merge_config(src, update)
  if update == nil then
    return src
  end
  for key, val in pairs(update) do
    src[key] = val
  end
  return src
end

local function hostname()
  local f = io.popen("hostname")
  if f ~= nil then
    local content = f:read("*a") or ""
    f:close()
    return string.gsub(content, "\n$", "")
  end
end

return {
  time_based_wallpaper = time_based_wallpaper,
  merge_config = merge_config,
  hostname = hostname,
}

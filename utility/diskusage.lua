--[[

     Licensed under GNU General Public License v2
     Diskusage
      * (c) 2015, Deville Romain
      * (c) 2011, Peter J. Kranz (Absurd-Mind, peter@myref.net)
      http://www.jasonmaur.com/awesome-wm-widgets-configuration/
    Lain.widget.fs
      * (c) 2013, Luke Bonham
      * (c) 2010, Adrian C.      <anrxc@sysphere.org>
      * (c) 2009, Lucas de Vries <lucas@glacicle.com>

    WARNING !!!!
    REQUIRE Lain
    https://github.com/copycat-killer/lain
--]]

-- | Init Environment | --------------------------------------------------------
local helpers      = require("lain.helpers")
local beautiful    = require("beautiful")
local wibox        = require("wibox")
local naughty      = require("naughty")
local markup       = require("lain.util.markup")

-- Unit definitions
local units = { "KB", "MB", "GB", "TB" }

-- | File system disk space usage | --------------------------------------------
local du = {}
local notification  = nil
du_notification_preset = { fg = beautiful.fg_normal }

-- | Local Functions | ---------------------------------------------------------
-- | Hide notification
function du:hide()
    if notification ~= nil then
        naughty.destroy(notification)
        notification = nil
    end
end
-- | Show notification
function du:show(t_out, text_out)
    du:hide()
    notification = naughty.notify({
        preset   = fs_notification_preset,
        text     = text_out,
        timeout  = t_out,
        screen   = mouse.screen,
    })
end

-- | Format data
local function uformat(value)
    local ret = tonumber(value)
    for i, u in pairs(units) do
        if ret < 1024 then
            local value = string.format("%.1f " .. u, ret)
            return string.rep(" ", 8 - value:len()) .. value
        end
        ret = ret / 1024;
    end
    return "N/A"
end
-- | Get data for all partition
local function getData(onlyLocal)
    -- Fallback to listing local filesystems
    local warg = ""
    if onlyLocal == true then
        warg = "-l"
    end

    local fs_info = {} -- Get data from df
    local f = io.popen("LC_ALL=C df -kP " .. warg)

    fs_info = {}
    for line in f:lines() do -- Match: (size) (used)(avail)(use%) (mount)
        local s     = string.match(line, "^.-[%s]([%d]+)")
        local u,a,p = string.match(line, "([%d]+)[%D]+([%d]+)[%D]+([%d]+)%%")
        local m     = string.match(line, "%%[%s]([%p%w]+)")
        if u and m then -- Handle 1st line and broken regexp
            info = {}
            info.partition = m
            info.size      = s
            info.used      = u
            info.avail     = a
            info.used_p    = tonumber(p)
            info.avail_p   = 100 - tonumber(p)
            table.insert(fs_info,info)
        end
    end
    f:close()
    return fs_info
end
-- | Get data for specific partition
local function getDataPartition(partition)
    local fs_info = {} -- Get data from df
    local f = io.popen("LC_ALL=C df -kP " .. partition)

    for line in f:lines() do -- Match: (size) (used)(avail)(use%) (mount)
        local s     = string.match(line, "^.-[%s]([%d]+)")
        local u,a,p = string.match(line, "([%d]+)[%D]+([%d]+)[%D]+([%d]+)%%")
        local m     = string.match(line, "%%[%s]([%p%w]+)")
        info = {}
        if m == partition then
            if u and m then -- Handle 1st line and broken regexp
                info["partition"] = m
                info["size"]      = s
                info["used"]      = u
                info["avail"]     = a
                info["used_p"]    = tonumber(p)
                info["avail_p"]   = 100 - tonumber(p)
            end
        end
        fs_info[1] = info
    end
    f:close()
    return fs_info
end
-- | Compute line to display
local function display(onlyLocal, exclude)
    data = getData(onlyLocal)
    local diskusage     = "Linux Disks Usage:"
    local mountusage    = "Mounted Disk Usage :"
    local used          = "Used"
    local free          = "Free"
    local total         = "Total"
    local longest       = 0
    local longestSize   = 0;
    local longestUsed   = 0;
    local mounted       = false
    -- By Partition name
    table.sort(data, function(a,b) return a.partition < b.partition end)

    for i,m in pairs(data) do
        local mnt = m.partition
        if mnt:len() > longest then
            longest = mnt:len()
        end

        local s = uformat(m.size)
        if s:len() > longestSize then
            longestSize = s:len()
        end

        local u = uformat(m.used)
        if u:len() > longestUsed then
            longestUsed = u:len()
        end
    end
    longest = longest + 8

    local lines = markup("#49B1F3", diskusage
        .. string.rep(" ", longest - diskusage:len())
        .. "|*********|*********|*********|*********|*********|"
        .. string.rep(" ", 10 - used:len())
        .. used
        .. string.rep(" ", 10 - free:len())
        .. free
        .. string.rep(" ", 10 - total:len())
        .. total
        .. "\n")

    for i, m in pairs(data) do
        if not exclude[m.partition]
        then
            local mnt = m.partition
            local u = uformat(m.used)
            local s = uformat(m.size)
            local a = uformat(m.avail)
            local up = m.used_p

            if ( string.match(m.partition, "/mnt")
                or string.match(m.partition, "/media") )
                and not mounted
            then
                lines = lines .. markup("#49B1F3", "\n"
                    .. mountusage
                    .. string.rep(" ", longest - mountusage:len())
                    .. "|*********|*********|*********|*********|*********|"
                    .. string.rep(" ", 10 - used:len())
                    .. used
                    .. string.rep(" ", 10 - free:len())
                    .. free
                    .. string.rep(" ", 10 - total:len())
                    .. total
                    .. "\n")
                mounted = true
            end
        lines = lines .. markup( gradient(0, 100, up), mnt
                .. string.rep(" ", longest - mnt:len() )
                .. "|"
                .. string.rep("▋", round(m.used/m.size*100/2) )
                .. string.rep("-", round((m.size-m.used)/m.size*100/2)-1 )
                .. "|"
                .. string.rep(" ", 10 - u:len() )
                .. u
                .. string.rep(" ", 10 - a:len() )
                .. a
                .. string.rep(" ", 10 - u:len() )
                .. s
                .. string.rep(" ", 5 - string.format("%d", m["used_p"]):len() )
                .. " (" .. up .. "%)\n" )
        end
    end
    return lines
end

-- | Worker adapt  from lain.widgets.fs | --------------------------------------
local function worker(args)
    local args      = args or {}
    local timeout   = args.timeout or 3600
    local partition = args.partition or "/"
    local settings  = args.settings or function() end
    local widget    = args.widget or wibox.widget.textbox('du')
    local exclude   = args.exclude or {}
    local notpath   = {}

    for i, m in pairs(exclude) do
        notpath[m] = true
    end

    du.widget = widget
    helpers.set_map("du", false)

    function update()
        du_info = {}
        du_now  = {}

        du_info = getDataPartition(partition)

        local idx   = 1
        local found = false
        du_now.partition = du_info[idx]["partition"]
        du_now.size      = tonumber(du_info[idx]["size"]) or 0
        du_now.used      = tonumber(du_info[idx]["used"]) or 0
        du_now.avail     = tonumber(du_info[idx]["avail"]) or 0
        du_now.used_p    = tonumber(du_info[idx]["used_p"])  or 0
        du_now.avail_p   = tonumber(du_info[idx]["avail_p"]) or 0

        widget = du.widget
        settings()

        if du_now.used_p >= 99 and not helpers.get_map("du")
        then
            naughty.notify({
                title   = "warning",
                text    = partition .. " ran out !\nMake some room.",
                timeout = 8,
                fg      = "#000000",
                bg      = "#FFFFFF",
            })
            helpers.set_map("du", true)
        else
            helpers.set_map("du", false)
        end
    end

    widget:connect_signal('mouse::enter', function ()
        du:show(0,display(onlyLocal, notpath)) end)
    widget:connect_signal('mouse::leave', function () du:hide() end)

    helpers.newtimer(partition, timeout, update)
    return setmetatable(du, { __index = du.widget })
end

return setmetatable(du, { __call = function(_, ...) return worker(...) end })

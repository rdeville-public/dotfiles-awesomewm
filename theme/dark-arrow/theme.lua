-- | DESCRIPTION
-- |========================================================================| --
-- | Dark arrow theme for Awesome WM                                        | --

-- | REQUIRED LIBRARY                                                       | --
-- |========================================================================| --
-- | Awesome library                                                        | --
-- |------------------------------------------------------------------------| --
local awful      = require("awful")
local gears      = require("gears")
local shape      = require("gears.shape")
local wibox      = require("wibox")
local vicious    = require("vicious")
local os         = os
local math       = math
local string     = string

-- | UTILITY METHODS                                                        | --
-- |========================================================================| --
-- | Shapes method use for notification, widget, etc. | ------------------------
local rounded_shape = function(cr, width, height)
  shape.partially_rounded_rect(cr, width, height, true, true, false, true, 10)
end

-- | OS command method | -------------------------------------------------------
function os.capture( cmd, raw)
  local f = assert(io.popen(cmd,'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
    s = string.gsub(s, '^%s+', '')
    s = string.gsub(s, '%s+$', '')
    s = string.gsub(s, '[\n\r]+', '')
  return s
end


-- | THEME VARIABLES                                                        | --
-- |========================================================================| --
-- Set theme variable
local theme   = {}

-- | Theme dir & wallpapers | --------------------------------------------------
awesome_dir     = os.getenv("HOME") .. "/.config/awesome"
themes_dir      = os.getenv("HOME") .. "/.config/awesome/theme"
themes_icons    = themes_dir .. "/icons"
themes_panel    = themes_dir .. "/icons/panel"
themes_layouts  = themes_dir .. "/icons/panel/layouts"
themes_taglist  = themes_dir .. "/icons/panel/taglist"
themes_tasklist = themes_dir .. "/icons/panel/tasklist"
theme.icons     = themes_dir .. "/icons"
theme.panel     = "png:" .. theme.icons .. "/panel/panel.png"

-- | Theme size and height | ---------------------------------------------------
themes_panel_height          = 20
themes_bar_horizontal_height = 14
themes_bar_horizontal_width  = 50
themes_default_spacing       = 0
themes_border_width          = 0

-- | Colors | ------------------------------------------------------------------
theme.white        = "#F6F6F6"
theme.grey         = "#D5D5D5"
theme.light_grey   = "#9F9F9F"
theme.dark_grey    = "#505050"
theme.black        = "#181818"
theme.red          = "#CC8888"
theme.green        = "#88CC00"
theme.blue         = "#8888CC"
theme.yellow       = "#CCCC88"
theme.orange       = "#CC8800"
theme.cyan         = "#88CCCC"
theme.magenta      = "#CC88CC"
theme.normal       = theme.grey
theme.normal_light = theme.light_grey
theme.normal_dark  = theme.dark_grey
theme.focus        = theme.green
theme.urgent       = theme.red
theme.occupied     = theme.orange
theme.empty        = theme.dark_grey
theme.volatile     = theme.cyan
theme.minimized    = theme.blue

-- | Base beautiful variables | ------------------------------------------------
-- https://awesomewm.org/doc/api/libraries/beautiful.html
theme.font          = "Monospace 8"
--theme.useless_gap   = 0
theme.border_width  = 3
theme.border_normal = theme.normal_dark
theme.border_focus  = theme.focus
-- theme.border_marked =
theme.wallpaper     = themes_dir .. "/wallpapers/wallpaper.png"
-- theme.wallpaper     = themes_dir .. "/wallpapers/wall.png"
-- theme.wallpaper     = themes_dir .. "/wallpapers/white_background.png"
-- theme.wallpaper     = themes_dir .. "/wallpapers/black_wallpaper.png"
-- theme.awesome_icon  =

-- | Taglist beautiful variables | ---------------------------------------------
-- https://awesomewm.org/apidoc/classes/awful.widget.taglist.html
theme.taglist_fg_focus                    = theme.normal_dark
theme.taglist_bg_focus                    = theme.focus
theme.taglist_fg_urgent                   = theme.normal_dark
theme.taglist_bg_urgent                   = theme.urgent
theme.taglist_fg_occupied                 = theme.normal_dark
theme.taglist_bg_occupied                 = theme.occupied
theme.taglist_fg_empty                    = theme.normal_dakr
theme.taglist_bg_empty                    = theme.empty
theme.taglist_fg_volatile                 = theme.normal_dark
theme.taglist_bg_volatile                 = theme.volatile
--theme.taglist_squares_sel                 =
--theme.taglist_squares_unsel               =
--theme.taglist_squares_sel_empty           =
--theme.taglist_squares_unsel_empty         =
--theme.taglist_squares_resize              =
--theme.taglist_disable_icon                =
theme.taglist_font                        = theme.font
theme.taglist_spacing                     = themes_default_spacing
theme.taglist_shape                       = shape.powerline
theme.taglist_shape_border_width          = themes_border_width
theme.taglist_shape_border_color          = theme.normal_dark
theme.taglist_shape_empty                 = shape.powerline
theme.taglist_shape_border_width_empty    = themes_border_width
theme.taglist_shape_border_color_empty    = theme.empty
theme.taglist_shape_focus                 = shape.powerline
theme.taglist_shape_border_width_focus    = themes_border_width
theme.taglist_shape_border_color_focus    = theme.focus
theme.taglist_shape_urgent                = shape.powerline
theme.taglist_shape_border_width_urgent   = themes_border_width
theme.taglist_shape_border_color_urgent   = theme.urgent
theme.taglist_shape_volatile              = shape.powerline
theme.taglist_shape_border_width_volatile = themes_border_width
theme.taglist_shape_border_color_volatile = theme.volatile

-- | Tasklist beautiful variables | --------------------------------------------
-- https://awesomewm.org/apidoc/classes/awful.widget.tasklist.html
theme.tasklist_fg_normal                    = theme.normal_light
theme.tasklist_bg_normal                    = theme.normal_dark
theme.tasklist_fg_focus                     = theme.normal_dark
theme.tasklist_bg_focus                     = theme.focus
theme.tasklist_fg_urgent                    = theme.normal_light
theme.tasklist_bg_urgent                    = theme.urgent
theme.tasklist_fg_minimize                  = theme.normal_light
theme.tasklist_bg_minimize                  = theme.minimized
--theme.tasklist_bg_image_normal              =
--theme.tasklist_bg_image_focus               =
--theme.tasklist_bg_image_urgent              =
--theme.tasklist_bg_image_minimize            =
theme.tasklist_disable_icon                 = false
theme.tasklist_disable_task_name            = false
theme.tasklist_plain_task_name              = false
theme.tasklist_font                         = theme.font
theme.tasklist_align                        = center
theme.tasklist_font_focus                   = theme.font
theme.tasklist_font_minimized               = theme.font
theme.tasklist_font_urgent                  = theme.font
theme.tasklist_spacing                      = themes_default_spacing
theme.tasklist_shape                        = shape.octogon
theme.tasklist_shape_border_width           = themes_border_width
theme.tasklist_shape_border_color           = theme.normal_dark
theme.tasklist_shape_focus                  = shape.octogon
theme.tasklist_shape_border_width_focus     = themes_border_width
theme.tasklist_shape_border_color_focus     = theme.focus
theme.tasklist_shape_minimized              = shape.octogone
theme.tasklist_shape_border_width_minimized = themes_border_width
theme.tasklist_shape_border_color_minimized = theme.minimized
theme.tasklist_shape_urgent                 = shape.octogone
theme.tasklist_shape_border_width_urgent    = themes_border_width
theme.tasklist_shape_border_color_urgent    = theme.urgent
--theme.tasklist_sticky                       = ""
--theme.tasklist_ontop                        = ""
--theme.tasklist_above                        = ""
--theme.tasklist_below                        = ""
--theme.tasklist_floating                     = ""
--theme.tasklist_maximized                    = ""
--theme.tasklist_maximized_horizontal         = ""
--theme.tasklist_maximized_vertical           = ""

-- | Naughty notification beautiful variables | --------------------------------
-- https://awesomewm.org/doc/api/libraries/naughty.html
theme.notification_font         = theme.font
theme.notification_bg           = theme.normal_dark
theme.notification_fg           = theme.white
theme.notification_border_width = 2
theme.notification_border_color = theme.focus
theme.notification_shape        = rounded_shape
theme.notification_opacity      = 90
theme.notification_margin       = 50
--theme.notification_width        =
--theme.notification_height       =

-- | Icons - Layout | ----------------------------------------------------------
theme.layout_dwindle    = themes_layouts .. "/dwindle.png"
theme.layout_fairh      = themes_layouts .. "/fairh.png"
theme.layout_fairv      = themes_layouts .. "/fairv.png"
theme.layout_floating   = themes_layouts .. "/floating.png"
theme.layout_magnifier  = themes_layouts .. "/magnifier.png"
theme.layout_max        = themes_layouts .. "/max.png"
theme.layout_spiral     = themes_layouts .. "/spiral.png"
theme.layout_tile       = themes_layouts .. "/tile.png"
theme.layout_tilebottom = themes_layouts .. "/tilebottom.png"
theme.layout_tileleft   = themes_layouts .. "/tileleft.png"
theme.layout_tiletop    = themes_layouts .. "/tiletop.png"

-- | Icons - Keyboard | --------------------------------------------------------
-- | CPU / TMP | --
theme.widget_temp  = theme.icons .. "/panel/widgets/widget_temp.png"

theme.bg_systray           =  theme.normal_light
theme.systray_icon_spacing = 3

-- | WIDGETS                                                                | --
-- |========================================================================| --
-- | Widget Display Variables
local markup    = lain.util.markup
local separator = lain.util.separators
local space     = wibox.widget.textbox(" ")

-- | Keyboard layout | ---------------------------------------------------------
-- | Icons
theme.widget_kbd        = theme.icons .. "/panel/widgets/widget_kbd.png"
-- | Possible keyboard layouts
local kbdlayout = require("keyboard-layout-indicator")
local kbdicon   = wibox.widget.imagebox(theme.widget_kbd)
local kbdcfg    = kbdlayout({
  layouts = {
    { name="fr-pc",   layout="fr", variant="latin9", options="ctrl:nocaps"},
    { name="fr-mac",  layout="fr", variant="mac", options="ctrl:nocaps"},
    { name="fr-bépo", layout="fr", variant="bepo", options="ctrl:nocaps"},
    { name="en-us",   layout="us", variant="intl", options="ctrl:nocaps"},
  }
})

---- Binary clock
local binclock = require("binclock"){
    height = 16,
    show_seconds = false,
    color_active = theme.white,
    color_inactive = theme.black
}

local textclock = wibox.widget.textclock(
                    markup.font( theme.font,
                    markup(theme.black, " %a %d %b | %H:%M ")))
clockwidget = wibox.container.background()
clockwidget:set_widget(textclock)

-- | PACKAGE | -----------------------------------------------------------------
function get_distrib()
  local out = os.capture("cat /etc/issue",true)
  if string.match(out,"Ubuntu")
  then
    out="Ubuntu"
  elseif string.match(out,"Debian")
  then
    out="Debian"
  elseif string.match(out,"Arch")
  then
    out="Arch"
  end
  return out
end

local pkgtext = wibox.widget.textbox()
vicious.register( pkgtext, vicious.widgets.pkg, function( widget, args )
    return markup.font(theme.font,
      markup(gradient(0,10,args[1]),
      string.format("| %d ", args[1]) ))
  end, 3600, get_distrib() )
local pkgwidget = wibox.container.background()
pkgwidget:set_widget(pkgtext)

-- | PERSONAL WIDGET                                                        | --
-- |========================================================================| --
-- | UPTIME | ------------------------------------------------------------------
local uptimewidget = require("uptime")
-- | CPU | ---------------------------------------------------------------------
local cpuwidget    = require("cpu")
-- | RAM | ---------------------------------------------------------------------
local ramwidget    = require("ram")
-- | HDD | ---------------------------------------------------------------------
local hddwidget    = require("hdd")
-- | BAT | ---------------------------------------------------------------------
local batwidget    = require("bat")
-- | NETWORK | -----------------------------------------------------------------
local netwidget    = require("network")
-- Separators
local arrow_l = separator.arrow_left
local arrow_r = separator.arrow_right

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ height = 0.5, followtag = true })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)
    -- Taglist mouse button binding (Scroll, toggle view ...)
    s.mytaglist.buttons = awful.util.table.join(
      awful.button({        }, 1, awful.tag.viewonly),
      awful.button({ modkey }, 1, awful.client.movetotag),
      awful.button({        }, 3, awful.tag.viewtoggle),
      awful.button({ modkey }, 3, awful.client.toggletag),
      awful.button({        }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
      awful.button({        }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
    )

    -- Create tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)
--    -- Tasklist mouse button binding (Scroll, minimize ...)
    s.mytasklist.buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
      if c == client.focus then
          c.minimized = true
      else
          -- Without this, the following
          -- :isvisible() makes no sense
          c.minimized = false
          if not c:isvisible() then
            awful.tag.viewonly(c:tags()[1])
          end
          -- This will also un-minimize
          -- the client, if needed
          client.focus = c
          c:raise()
      end
    end),
    awful.button({ }, 3, function ()
      if instance then
          instance:hide()
          instance = nil
      else
          instance = awful.menu.clients({ width=250 })
      end
    end),
    awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end)
)

  -- Create the top wibox
  s.mywibox = awful.wibar({
      position = "top",
      screen = s,
      height = 16,
      bg = theme.normal_dark,
      fg = theme.normal_light })

  local left_layout = wibox.layout.fixed.horizontal()
  left_layout:add( s.mytaglist )
  left_layout:add( arrow_r(theme.normal_dark, theme.normal) )
  left_layout:add( wibox.container.background(space,theme.normal) )
  left_layout:add( wibox.container.background(space,theme.normal) )
  left_layout:add( wibox.container.background(kbdicon,theme.normal) )
  left_layout:add( wibox.container.background(kbdcfg.widget,theme.normal) )
  left_layout:add( wibox.container.background(space,theme.normal) )
  left_layout:add( wibox.container.background(wibox.widget.systray(), theme.normal))
  left_layout:add( arrow_r(theme.normal, theme.normal_dark) )
  left_layout:add( wibox.container.background(space,theme.normal_dark) )
  left_layout:add( wibox.container.background(s.mypromptbox,theme.normal_dark) )

  local right_layout = wibox.layout.fixed.horizontal()
  -- Uptime & Package Widget
  right_layout:add( arrow_l(theme.normal_dark, theme.normal_light))
  right_layout:add( wibox.container.background( uptimewidget, theme.normal_light ))
  right_layout:add( wibox.container.background( pkgwidget, theme.normal_light ))
  -- CPU Widget
  right_layout:add( arrow_l(theme.normal_light, theme.normal_dark))
  right_layout:add( wibox.container.background( cpuwidget,theme.normal_dark) )
  -- Memory Widget
  right_layout:add( arrow_l(theme.normal_dark, theme.normal_light))
  right_layout:add( wibox.container.background( ramwidget,theme.normal_light) )

  -- Disk Usage Widget
  right_layout:add( arrow_l(theme.normal_light, theme.normal_dark))
  right_layout:add( wibox.container.background(hddwidget, theme.normal_dark) )
  -- Network Widget
  right_layout:add( arrow_l(theme.normal_dark, theme.normal_light))
  right_layout:add( wibox.container.background(netwidget, theme.normal_light))
  -- Clock/Calendar Widget
  right_layout:add( arrow_l(theme.normal_light, theme.normal_dark))
  right_layout:add( wibox.container.background(batwidget, theme.normal_dark))
  right_layout:add( arrow_l(theme.normal_dark, theme.normal_light))
  right_layout:add( wibox.container.background(clockwidget, theme.normal_light))
  right_layout:add( wibox.container.background(binclock.widget, theme.normal_light))
  -- Layout Box
  right_layout:add( arrow_l(theme.normal_light, theme.normal_dark))
  right_layout:add( wibox.container.background(s.mylayoutbox, theme.normal_dark))
  local top_layout = wibox.layout.align.horizontal()
  top_layout:set_left(left_layout)
  top_layout:set_right(right_layout)

  s.mywibox:set_widget(top_layout)

  -- Create the bottom wibox
  s.mybotwibox = awful.wibar({
    position = "bottom",
    screen = s,
    height = 16,
    bg = theme.normal_dark,
    fg = theme.normal_light })

  -- Add widgets to the bot wiboxwibox
  local botlayout = wibox.layout.align.horizontal()
  botlayout:set_middle(s.mytasklist)
  s.mybotwibox:set_widget(botlayout)

]]--
end

return theme

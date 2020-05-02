-- WARNING: Unmainteined code, now handled with fizzy. See configs/awesome repo
-- Requires ────────────────────────────────────────────────────────────────────

-- Standard awesome library.
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")

-- Widget and layout library.
local wibox = require("wibox")

-- Theme handling library.
local beautiful = require("beautiful")

-- Notification library.
local naughty = require("naughty")
local menubar = require("menubar")

-- Awesome WM complements library.
local lain = require("lain")

-- Custom utilities.
local run   = require("utils/run")
local quake = require("quake")
local menugen = require("menugen")

-- Variables ───────────────────────────────────────────────────────────────────

local modkey = "Mod4"
local altkey = "Mod1"

local terminal_cmd = "urxvtc -e /bin/zsh -c 'tmux -2'"
local terminal_noscreen = "urxvt256c"

local browser = "firefox"

local editor = os.getenv("EDITOR") or "nvim" or "vim" or "vi" or "nano"
local editor_cmd  = terminal_cmd .. " -e " .. editor

local audiocard = '@DEFAULT_SINK@'


-- Available layouts.

-- Tags information: tag names and default layouts.
local layouts = {
  awful.layout.suit.max,
  awful.layout.suit.tile,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.floating
}
local tags_info = {
  names = {
    "1:main",
    "2:⚓",
    "3:☕",
    "4:v",
    "5:♪",
    "6:supp",
    "7:supp",
    "8:☢",
    "9:tmp"
  },
  layout = {
    layouts[2],
    layouts[1],
    layouts[4],
    layouts[4],
    layouts[2],
    layouts[2],
    layouts[3],
    layouts[6],
    layouts[5]
  }
}

-- Error handling ──────────────────────────────────────────────────────────────

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config).
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title  = "Oops, there were errors during startup!",
    text   = awesome.startup_errors
  })
end

-- Handle runtime errors after startup.
do
  local in_err = false
  awesome.connect_signal("debug::error", function (err)
    if in_err then return end -- Make sure don't go into an endless error loop.
    in_err = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title  = "Oops, an error happened!",
      text   = err
    })

    in_err = false
  end)
end

-- Theme ───────────────────────────────────────────────────────────────────────

beautiful.init(awful.util.getdir("config") ..
               "/themes/powerline/theme.lua")

-- Wallpaper ───────────────────────────────────────────────────────────────────

if beautiful.wallpaper then
  for s = 1, screen.count() do
    gears.wallpaper.maximized(beautiful.wallpaper, s, true)
  end
end

-- Tags ────────────────────────────────────────────────────────────────────────

tags = {}
for s = 1, screen.count() do
  tags[s] = awful.tag(tags_info.names, s, tags_info.layout)
end

-- Quake ───────────────────────────────────────────────────────────────────────

local quakeconsole = {}
for s = 1, screen.count() do
  quakeconsole[s] = quake({ app = terminal_noscreen })
end

-- Menu ────────────────────────────────────────────────────────────────────────

local awesome_menu = {
  { "manual",      terminal_cmd .. " -e man awesome" },
  { "edit config", editor_cmd .. " " .. awesome.conffile },
  { "restart",     awesome.restart },
  { "quit",        awesome.quit }
}

local menu_items = menugen.build_menu()
table.insert(menu_items, 0, { "awesome", awesome_menu, beautiful.awesome_icon })
table.insert(menu_items, 0, { "open terminal", terminal_cmd })

-- Main menu.
local main_menu = awful.menu.new({
  items = menu_items,
  theme = { height = 16, width = 130 }
})

-- Launcher widget to open the `main_menu`.
local main_menu_launcher = awful.widget.launcher({
  image = beautiful.awesome_icon,
  menu = main_menu
})

-- Menubar configuration.
menubar.utils.terminal = terminal_cmd -- Set terminal for apps that require it.

-- Keyboard layout indicator
local klayout = { "us", "il" }
local klidx = 1

-- Wibox ───────────────────────────────────────────────────────────────────────

markup = lain.util.markup

-- Separators
separators = lain.util.separators
spr = wibox.widget.textbox(' ')
arrl_dl = separators.arrow_left(beautiful.bg_focus, "alpha")
arrl_ld = separators.arrow_left("alpha", beautiful.bg_focus)


-- Textclock
mytextclock = lain.widgets.abase({
  timeout  = 60,
  cmd      = "date +'%a %d %b %R'",
  settings = function()
    widget:set_text(" " .. output)
  end
})
-- Calendar
lain.widgets.calendar:attach(mytextclock, { font_size = 9 })



memicon = wibox.widget.imagebox(beautiful.widget_mem)
memwidget = lain.widgets.mem({
  settings = function()
    widget:set_text(" " .. mem_now.used .. "MB ")
  end
})



cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)
cpuwidget = lain.widgets.cpu({
  settings = function()
    widget:set_text(" " .. cpu_now.usage .. "% ")
  end
})



tempicon = wibox.widget.imagebox(beautiful.widget_temp)
tempwidget = lain.widgets.temp({
  settings = function()
    widget:set_text(" " .. coretemp_now .. "°C ")
  end
})



fsicon = wibox.widget.imagebox(beautiful.widget_hdd)
fswidget = lain.widgets.fs({
    settings  = function()
        widget:set_text(" " .. fs_now.used .. "% ")
    end
  })



baticon = wibox.widget.imagebox(beautiful.widget_battery)
batwidget = lain.widgets.bat({
  settings = function()
    if bat_now.status ~= "N/A" then
      if bat_now.ac_status == 1 then
        widget:set_markup(" AC ")
        baticon:set_image(beautiful.widget_ac)
        return
      elseif tonumber(bat_now.perc) <= 5 then
        baticon:set_image(beautiful.widget_battery_empty)
      elseif tonumber(bat_now.perc) <= 15 then
        baticon:set_image(beautiful.widget_battery_low)
      else
        baticon:set_image(beautiful.widget_battery)
      end
      widget:set_markup(" " .. bat_now.perc .. "% ")
    else
      baticon:set_image(beautiful.widget_ac)
    end
  end
})



volicon = wibox.widget.imagebox(beautiful.widget_vol)

volumewidget = lain.widgets.pulseaudio({
 settings = function()
    local _vl, _vr = tonumber(volume_now.left), tonumber(volume_now.right)
    local vl, vr = _vl == nil and 0 or _vl,
                   _vr == nil and 0 or _vr
    if volume_now.muted == "yes" then
      volicon:set_image(beautiful.widget_vol_mute)
    elseif vl == 0 and vr == 0 then
      volicon:set_image(beautiful.widget_vol_no)
    elseif vl + vr <= 50 then
      volicon:set_image(beautiful.widget_vol_low)
    else
      volicon:set_image(beautiful.widget_vol)
    end

    widget:set_text(vl .. "-" .. vr .. "%")
  end
})


neticon = wibox.widget.imagebox(beautiful.widget_net)
neticon:buttons(awful.util.table.join(awful.button({ }, 1, function ()
  awful.util.spawn_with_shell(iptraf)
end)))
netwidget = lain.widgets.net({
  settings = function()
    widget:set_markup(markup("#7AC82E", " " .. net_now.received)
                      .. " " ..
                      markup("#46A8C3", " " .. net_now.sent .. " "))
  end
})

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
  awful.button({ }, 1, awful.tag.viewonly),
  awful.button({ modkey }, 1, awful.client.movetotag),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, awful.client.toggletag),
  awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
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
  end))

for s = 1, screen.count() do

  -- Create a promptbox for each screen
  mypromptbox[s] = awful.widget.prompt()

  -- We need one layoutbox per screen.
  mylayoutbox[s] = awful.widget.layoutbox(s)
  mylayoutbox[s]:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
    awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
    awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
    awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
  ))

  -- Create a taglist widget
  mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

  -- Create a tasklist widget
  mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

  -- Create the wibox
  mywibox[s] = awful.wibox({ position = "top", screen = s, height = 18 })

  -- Widgets that are aligned to the upper left
  local left_layout = wibox.layout.fixed.horizontal()
  left_layout:add(spr)
  left_layout:add(mytaglist[s])
  left_layout:add(mypromptbox[s])
  left_layout:add(spr)

  -- Widgets that are aligned to the upper right
  local right_layout_toggle = true
  local function right_layout_add (...)
    local arg = {...}
    if right_layout_toggle then
      right_layout:add(arrl_ld)
      for i, n in pairs(arg) do
        right_layout:add(wibox.widget.background(n ,beautiful.bg_focus))
      end
    else
      right_layout:add(arrl_dl)
      for i, n in pairs(arg) do
        right_layout:add(n)
      end
    end
    right_layout_toggle = not right_layout_toggle
  end

  right_layout = wibox.layout.fixed.horizontal()
  if s == 1 then right_layout:add(wibox.widget.systray()) end
  right_layout:add(spr)

  right_layout_add(volicon, volumewidget)


  right_layout_add(memicon, memwidget)


  right_layout_add(cpuicon, cpuwidget)


  right_layout_add(tempicon, tempwidget)


  right_layout_add(fsicon, fswidget)


  right_layout_add(baticon, batwidget)


  right_layout_add(neticon,netwidget)


  right_layout_add(mytextclock, spr)

  right_layout_add(mylayoutbox[s])

  -- Now bring it all together (with the tasklist in the middle)
  local layout = wibox.layout.align.horizontal()
  layout:set_left(left_layout)
  layout:set_middle(mytasklist[s])
  layout:set_right(right_layout)
  mywibox[s]:set_widget(layout)

end

-- Mouse bindings ──────────────────────────────────────────────────────────────

root.buttons(awful.util.table.join(
  awful.button({ }, 3, function () main_menu:toggle() end),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))

-- Key bindings ────────────────────────────────────────────────────────────────

globalkeys = awful.util.table.join(
  -- Tags navigation.
  awful.key({ modkey,        }, "Escape", awful.tag.history.restore),
  awful.key({ modkey,        }, "u",      awful.client.urgent.jumpto),
  awful.key({ modkey,        }, "Left",   awful.tag.viewprev),
  awful.key({ modkey,        }, "Right",  awful.tag.viewnext),
  awful.key({ modkey, altkey }, "Left",   function ()
                                            lain.util.tag_view_nonempty(-1)
                                          end),
  awful.key({ modkey, altkey }, "Right",  function ()
                                            lain.util.tag_view_nonempty(1)
                                          end),
  awful.key({ modkey,        }, "k",      function ()
                                            awful.client.focus.byidx(-1)
                                            if client.focus then
                                              client.focus:raise()
                                            end
                                          end),
  awful.key({ modkey,        }, "j",      function ()
                                            awful.client.focus.byidx(1)
                                            if client.focus then
                                              client.focus:raise()
                                            end
                                          end),

  -- Layout management.
  awful.key({ modkey,           }, "l",     function ()
                                              awful.tag.incmwfact(0.05)
                                            end),
  awful.key({ modkey,           }, "h",     function ()
                                              awful.tag.incmwfact(-0.05)
                                            end),
  awful.key({ modkey, "Shift"   }, "l",     function ()
                                              os.execute(string.format(
                                                "$HOME/personal_stuff/scripts/keyboard_swap_enit.sh"
                                              ))
                                            end),
  awful.key({ modkey, "Shift"   }, "0",     function()
                                              klidx = klidx % #(klayout) + 1
                                              os.execute(string.format(
                                                "setxkbmap " .. klayout[klidx]
                                              ))
                                              pic = "$HOME/.config/awesome/il-keyboard-layout.png"
                                              if klidx == 2 then
                                                awful.util.spawn_with_shell(string.format(
                                                  "sxiv -g $(identify -format '%%wx%%h' %s) %s &", pic, pic
                                                ))
                                              else
                                                os.execute(string.format("pkill -f il-keyboard-layout"))
                                              end
                                            end),
  awful.key({ modkey, "Control" }, "l",     function ()
                                              awful.tag.incncol(-1)
                                            end),
  awful.key({ modkey, "Control" }, "h",     function ()
                                              awful.tag.incncol(1)
                                            end),
  awful.key({ modkey, "Shift"   }, "space", function ()
                                              awful.layout.inc(layouts, -1)
                                            end),
  awful.key({ modkey,           }, "space", function ()
                                              awful.layout.inc(layouts, 1)
                                            end),
  awful.key({ modkey, "Control" }, "n",     awful.client.restore),

  -- Windows navigation / management.
  awful.key({ modkey, "Shift"   }, "k",   function ()
                                            awful.client.swap.byidx(-1)
                                          end),
  awful.key({ modkey, "Shift"   }, "j",   function ()
                                            awful.client.swap.byidx(1)
                                          end),
  awful.key({ modkey, "Control" }, "k",   function ()
                                            awful.screen.focus_relative(-1)
                                          end),
  awful.key({ modkey, "Control" }, "j",   function ()
                                            awful.screen.focus_relative(1)
                                          end),
  awful.key({ modkey,           }, "Tab", function ()
                                            awful.client.focus.history.previous()
                                            if client.focus then
                                              client.focus:raise()
                                            end
                                          end),

  -- AwesomeWM management.
  awful.key({ modkey, "Control" }, "r", awesome.restart),
  awful.key({ modkey, "Shift"   }, "q", awesome.quit),

  -- Main Menu.
  awful.key({ modkey, "Control" }, "w", function () main_menu:show() end),

  -- Prompt.
  awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end),
  awful.key({ modkey }, "p", function () menubar.show() end),

  -- Run predefined programs.
  awful.key({ modkey, }, "`",      function ()
                                     quakeconsole[mouse.screen]:toggle()
                                   end),
  awful.key({ modkey, }, "Return", function ()
                                     awful.util.spawn(terminal_cmd)
                                   end),
  awful.key({ modkey, }, "t",      function ()
                                     awful.util.spawn(terminal_noscreen)
                                   end),
  awful.key({ modkey, }, "f",      function ()
                                     awful.util.spawn(browser)
                                   end),
  awful.key({ modkey, }, "e",      function ()
                                    os.execute(string.format(
                                      "rofimoji.py"
                                    ))
                                   end),
  awful.key({ modkey, }, "w",      function ()
                                    os.execute(string.format(
                                      "rofi -show window"
                                    ))
                                   end),
  awful.key({ modkey }, "F8",      function ()
                                    os.execute(string.format(
                                      "xbacklight -dec 5"
                                    ))
                                   end),
  awful.key({ modkey }, "F9",      function ()
                                    os.execute(string.format(
                                      "xbacklight -inc 5"
                                    ))
                                   end),
  awful.key({ }, "XF86Sleep",      function ()
                                     awful.util.spawn_with_shell("pm-suspend")
                                   end),
  -- Manage audio settings.
  awful.key({ }, "XF86AudioRaiseVolume",  function ()
                                    os.execute(string.format(
                                      "pactl set-sink-volume %s +5%%",
                                      audiocard
                                    ))
                                    volumewidget.update()
                                  end),
  awful.key({ }, "XF86AudioLowerVolume",   function ()
                                    os.execute(string.format(
                                      "pactl -- set-sink-volume %s -5%%",
                                      audiocard
                                    ))
                                    volumewidget.update()
                                  end),
  awful.key({ }, "XF86AudioMute", function ()
                                    os.execute(string.format(
                                      "pactl set-sink-mute %s toggle",
                                      audiocard
                                    ))
                                    volumewidget.update()
                                  end),

  -- Spotify

  awful.key({ }, "KP_Right", function ()
    awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")
                                  end),
  awful.key({ }, "KP_Left", function ()
    awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
                                  end),
  awful.key({ }, "XF86AudioPlay", function ()
    awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
                                  end),

  -- Cmus

  awful.key({ modkey, "Control" }, "s", function ()
    awful.util.spawn("cmus-remote -k +10")
                                  end),
  awful.key({ modkey, "Control" }, "p", function ()
    awful.util.spawn("cmus-remote -u")
                                  end),
  awful.key({ modkey, "Control" }, "b", function ()
    awful.util.spawn("cmus-remote -r")
                                  end),
  awful.key({ modkey, "Control" }, "f", function ()
    awful.util.spawn("cmus-remote -n")
                                  end),

  -- CopyQ
  awful.key({ modkey }, "q", function ()
                               os.execute('copyq show')
                             end),

  -- Run LUA code.
  awful.key({ modkey }, "x", function ()
                               awful.prompt.run(
                                 { prompt = "Run Lua code: " },
                                 mypromptbox[mouse.screen].widget,
                                 awful.util.eval,
                                 nil,
                                 awful.util.getdir("cache") .. "/history_eval"
                               )
                             end)
)

clientkeys = awful.util.table.join(
  -- Current window management.
  awful.key({ modkey, "Shift"   }, "f",      function (c) c.fullscreen = not c.fullscreen end),
  awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle),
  awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
  awful.key({ modkey,           }, "o",      awful.client.movetoscreen),
  awful.key({ modkey, "Shift"   }, "t",      function (c) c.ontop = not c.ontop end),
  awful.key({ modkey,           }, "n",      function (c) c.minimized = true end),
  awful.key({ modkey,           }, "m",      function (c)
    c.maximized_horizontal = not c.maximized_horizontal
    c.maximized_vertical   = not c.maximized_vertical
  end),

  -- Current window operations.
  awful.key({ modkey, "Shift"   }, "c", function (c) c:kill() end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = awful.util.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9, function ()
      local screen = mouse.screen
      local tag = awful.tag.gettags(screen)[i]
      if tag then awful.tag.viewonly(tag) end
    end),
    -- Toggle tag.
    awful.key({ modkey, "Control" }, "#" .. i + 9, function ()
      local screen = mouse.screen
      local tag = awful.tag.gettags(screen)[i]
      if tag then awful.tag.viewtoggle(tag) end
    end),
    -- Move client to tag.
      awful.key({ modkey, "Shift" }, "#" .. i + 9, function ()
      if client.focus then
        local tag = awful.tag.gettags(client.focus.screen)[i]
        if tag then awful.client.movetotag(tag) end
      end
    end),
    -- Toggle tag.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function ()
      if client.focus then
        local tag = awful.tag.gettags(client.focus.screen)[i]
        if tag then awful.client.toggletag(tag) end
      end
    end)
  )
end

clientbuttons = awful.util.table.join(
  awful.button({        }, 1, function (c) client.focus = c; c:raise() end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Set global keys.
root.keys(globalkeys)

-- Rules ───────────────────────────────────────────────────────────────────────

-- Rules to apply to new clients (through the `manage` signal).
awful.rules.rules = {
  -- All clients will match this rule.
  { rule = { },
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons
    }
  },

  { rule = { class = "Sxiv" },
    properties = { floating = true, above = true },
    callback = function (c)
      -- WARNING: I have patched awesomewm 3.5.6, bottom does not exist!
      awful.placement.bottom(c,nil)
    end
  },

  { rule = { class = "MPlayer" },
    properties = { floating = true } },


  { rule = { class = "gimp" },
    properties = { floating = true, tag = tags[1][9] } },


  -- Set Firefox to always map on tags number 2 of screen 1.
  { rule = { class = "Firefox" },
     properties = { tag = tags[1][2] } },


  { rule = { class = "Tor Browser" },
     properties = { tag = tags[1][2] } },


  { rule = { class = "Zathura" },
     properties = { tag = tags[1][3] } },





  { rule = { class = "Spotify" },
     properties = { tag = tags[1][5] } },


}

-- Signals ─────────────────────────────────────────────────────────────────────

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
  -- Enable sloppy focus.
  c:connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
       and awful.client.focus.filter(c) then
      client.focus = c
    end
  end)

  if not startup then
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Put windows in a smart way, only if they doesn't set an initial position.
    if not c.size_hints.user_position and not c.size_hints.program_position then
      awful.placement.no_overlap(c)
      awful.placement.no_offscreen(c)
    end
  end

  local titlebars_enabled = false
  if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
      awful.button({ }, 1, function()
        client.focus = c
        c:raise()
        awful.mouse.client.move(c)
      end),
      awful.button({ }, 3, function()
        client.focus = c
        c:raise()
        awful.mouse.client.resize(c)
      end)
    )

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(awful.titlebar.widget.iconwidget(c))
    left_layout:buttons(buttons)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(awful.titlebar.widget.floatingbutton(c))
    right_layout:add(awful.titlebar.widget.maximizedbutton(c))
    right_layout:add(awful.titlebar.widget.stickybutton(c))
    right_layout:add(awful.titlebar.widget.ontopbutton(c))
    right_layout:add(awful.titlebar.widget.closebutton(c))

    -- The title goes in the middle
    local middle_layout = wibox.layout.flex.horizontal()
    local title = awful.titlebar.widget.titlewidget(c)
    title:set_align("center")
    middle_layout:add(title)
    middle_layout:buttons(buttons)

    -- Now bring it all together
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)
    layout:set_middle(middle_layout)

    awful.titlebar(c):set_widget(layout)
  end
end)

-- No border for maximized or single clients
client.connect_signal("focus", function(c)
  if c.maximized_horizontal == true and c.maximized_vertical == true then
    c.border_width = 0
  elseif #awful.client.visible(mouse.screen) > 1 then
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_focus
  end
end)

client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
end)

-- Autostart applications ──────────────────────────────────────────────────────


run.once("copyq")


run.once("firefox")


run.once("megasync")


run.once("urxvt256cd")


run.once("start-pulseaudio-x11")


-- ─────────────────────────────────────────────────────────────────────────────
-- vim: set filetype=eruby.lua :

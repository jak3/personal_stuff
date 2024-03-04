-- Requires {{{

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
-- Widget and layout library
local wibox         = require("wibox")
-- Theme handling library
local beautiful     = require("beautiful")
-- Notification library
local naughty       = require("naughty")
local menubar       = require("menubar")
local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
                      require("awful.hotkeys_popup.keys")

-- }}}

-- {{{ Error handling

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify {
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors
  }
end

-- Handle runtime errors after startup
do
    local in_error = false

    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify {
          preset = naughty.config.presets.critical,
          title = "Oops, an error happened!",
          text = tostring(err)
        }

        in_error = false
    end)
end

-- }}}

-- {{{ Autostart windowless processes

-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

-- run_once({ "urxvtc", "firefox", "copyq", "megasync", "start-pulseaudio-x11" })

-- }}}

-- Variables {{{

local modkey = "Mod4"
local altkey = "Mod1"

local terminal_only = "urxvtc"
local terminal_sh_cmd = "urxvtc -e /bin/zsh -c 'tmux -2'"
awful.util.terminal = terminal_only

local browser = "firefox"

local editor = os.getenv("EDITOR") or "nvim" or "vim" or "vi"
local editor_cmd  = terminal_only .. " -e " .. editor

awful.util.tagnames = {
    "1:moin", "2:⚓", "3:☕", "4:π", "5:♪", "6:α", "7:ω", "8:☢", "9:ॐ"
}

awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.max,
  awful.layout.suit.corner.nw,
  awful.layout.suit.floating,
  awful.layout.suit.max,
  awful.layout.suit.fair,
  awful.layout.suit.corner.nw,
  awful.layout.suit.floating,
  awful.layout.suit.max.fullscreen
}

awful.util.taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then client.focus:move_to_tag(t) end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then client.focus:toggle_tag(t) end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = gears.table.join(
     awful.button({ }, 1, function(c)
         if c == client.focus then
             c.minimized = true
         else
             c:emit_signal("request::activate", "tasklist", { raise = true })
         end
     end),
     awful.button({ }, 3, function()
         awful.menu.client_list({ theme = { width = 250 } })
     end),
     awful.button({ }, 4, function() awful.client.focus.byidx(1) end),
     awful.button({ }, 5, function() awful.client.focus.byidx(-1) end)
)

-- thanks to https://github.com/lcpz/awesome-copycats
local chosen_theme = "powerarrow-dark"
beautiful.init(string.format("%s/.config/awesome4/themes/%s/mytheme.lua", os.getenv("HOME"), chosen_theme))

-- }}}

-- {{{ Menu

-- Yeah, ATM i do not need a menu, rofi and shell is enought
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", string.format("%s -e man awesome", terminal_only) },
   { "Manual", string.format("%s -e man awesome", terminal_only) },
   { "edit config", string.format("%s -e %s %s", terminal_only, editor, awesome.conffile) },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

awful.util.mymainmenu = freedesktop.menu.build {
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        -- other triads can be put here
    },
    after = {
        { "Open terminal", terminal },
        -- other triads can be put here
    }
}

-- }}}

-- {{{ Screen

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function (s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if only_one and not c.floating or c.maximized or c.fullscreen then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
    end
end)

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)

-- }}}

-- Mouse bindings {{{

root.buttons(gears.table.join(
  awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)
-- }}}

-- Key bindings {{{

-- Keyboard layout indicator
local klayout = { "us", "il" } -- useful for hebrew support
local klidx = 1

globalkeys = gears.table.join(
  awful.key({ modkey,        }, "s",      hotkeys_popup.show_help,
            {description="show help", group="awesome"}),
  -- Tag browsing
  awful.key({ modkey,        }, "Left",   awful.tag.viewprev,
            {description = "view previous", group = "tag"}),
  awful.key({ modkey,        }, "Right",  awful.tag.viewnext,
            {description = "view next", group = "tag"}),
  awful.key({ modkey,        }, "Escape", awful.tag.history.restore,
            {description = "go back", group = "tag"}),
  -- Non-empty tag browsing
  awful.key({ altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end,
            {description = "view  previous nonempty", group = "tag"}),
  awful.key({ altkey }, "Right", function () lain.util.tag_view_nonempty(1) end,
            {description = "view  previous nonempty", group = "tag"}),

  -- By-direction client focus TESTING
  awful.key({ modkey }, "j",
      function()
          awful.client.focus.global_bydirection("down")
          if client.focus then client.focus:raise() end
      end,
      {description = "focus down", group = "client"}),
  awful.key({ modkey }, "k",
      function()
          awful.client.focus.global_bydirection("up")
          if client.focus then client.focus:raise() end
      end,
      {description = "focus up", group = "client"}),
  awful.key({ modkey }, "h",
      function()
          awful.client.focus.global_bydirection("left")
          if client.focus then client.focus:raise() end
      end,
      {description = "focus left", group = "client"}),
  awful.key({ modkey }, "l",
      function()
          awful.client.focus.global_bydirection("right")
          if client.focus then client.focus:raise() end
      end,
      {description = "focus right", group = "client"}),
  -- Default client focus
  -- awful.key({ modkey,        }, "j",
  --       function ()
  --           awful.client.focus.byidx( 1)
  --       end,
  --           {description = "focus next by index", group = "client"}
  -- ),
  -- awful.key({ modkey,        }, "k",
  --       function ()
  --           awful.client.focus.byidx(-1)
  --       end,
  --           {description = "focus previous by index", group = "client"}
  --   ),

  -- Layout manipulation.
  awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
            {description = "swap with next client by index", group = "client"}),
  awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
            {description = "swap with previous client by index", group = "client"}),
  awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
            {description = "focus the next screen", group = "screen"}),
  awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
            {description = "focus the previous screen", group = "screen"}),
  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
            {description = "jump to urgent client", group = "client"}),
  awful.key({ modkey,           }, "Tab",
      function ()
          if cycle_prev then
              awful.client.focus.history.previous()
          else
              awful.client.focus.byidx(-1)
          end
          if client.focus then
              client.focus:raise()
          end
      end,
      {description = "cycle with previous/go back", group = "client"}),

  -- Show/hide wibox TESTING
  awful.key({ modkey }, "b", function ()
          for s in screen do
              s.mywibox.visible = not s.mywibox.visible
              if s.mybottomwibox then
                  s.mybottomwibox.visible = not s.mybottomwibox.visible
              end
          end
      end,
      {description = "toggle wibox", group = "awesome"}),
  -- Standard program
  awful.key({ modkey,           }, "Return", function () awful.spawn(terminal_sh_cmd) end,
            {description = "open a tmux terminal", group = "launcher"}),
  awful.key({ modkey,           }, "t", function () awful.spawn(terminal_only) end,
            {description = "open a clean terminal", group = "launcher"}),
  awful.key({ modkey, "Control" }, "r", awesome.restart,
            {description = "reload awesome", group = "awesome"}),
  awful.key({ modkey, "Shift"   }, "q", awesome.quit,
            {description = "quit awesome", group = "awesome"}),

  awful.key({ modkey, altkey    }, "l",     function () awful.tag.incmwfact( 0.05)          end,
            {description = "increase master width factor", group = "layout"}),
  awful.key({ modkey, altkey    }, "h",     function () awful.tag.incmwfact(-0.05)          end,
            {description = "decrease master width factor", group = "layout"}),

  awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
            {description = "increase the number of columns", group = "layout"}),
  awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
            {description = "decrease the number of columns", group = "layout"}),
  awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
            {description = "select next", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
            {description = "select previous", group = "layout"}),

  awful.key({ modkey, "Control" }, "n", function ()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
          c:emit_signal("request::activate", "key.unminimize", {raise = true})
      end
  end, {description = "restore minimized", group = "client"}),

  -- Dropdown application
  awful.key({ modkey, }, "`", function () awful.screen.focused().quake:toggle() end,
            {description = "dropdown application", group = "launcher"}),
  -- Widgets popups
  awful.key({ altkey, }, "c", function () if beautiful.cal then beautiful.cal.show(7) end end,
            {description = "show calendar", group = "widgets"}),

  -- Menu.
  awful.key({ modkey, }, "w",      function ()
                                    os.execute(string.format(
                                      "rofi -show window"
                                    ))
                                   end),
  awful.key({ modkey, "Control" }, "w", function () main_menu:show() end),

  -- Prompt.
  awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
            {description = "run prompt", group = "launcher"}),
  awful.key({ modkey }, "p", function() menubar.show() end,
            {description = "show the menubar", group = "launcher"}),

  -- Run predefined programs.
  awful.key({ modkey, "Shift"   }, "l",
            awful.spawn(terminal_only .. "-e $HOME/personal_stuff/scripts/keyboard_swap_enit.sh"),
            {description = "swap keyboard layout", group = "launcher"}),
  awful.key({ modkey, "Shift"   }, "0",     function()
                                              klidx = klidx % #(klayout) + 1
                                              os.execute(string.format(
                                                "setxkbmap " .. klayout[klidx]
                                              ))
                                              pic = "$HOME/.config/awesome/il-keyboard-layout.png"
                                              if klidx == 2 then
                                                awful.spawn(string.format(
                                                  "sxiv -g $(identify -format '%%wx%%h' %s) %s &", pic, pic))
                                              else
                                                os.execute(string.format("pkill -f il-keyboard-layout"))
                                              end
                                            end,
            {description = "keyboard layout hebrew with virtual keyboard", group = "launcher"}),
  awful.key({ modkey, }, "f", function () awful.spawn(browser) end,
            { description = "run browser", group = "launcher" }),
  awful.key({ modkey, }, "e", function () os.execute(string.format("rofimoji")) end,
            { description = "run rofimoji", group = "launcher" }),

  -- XF86
  awful.key({ }, "XF86MonBrightnessDown",      function ()
                                    os.execute(string.format(
                                      --"xbacklight -dec 5"
                                      "xrandr --output eDP-1 --gamma 1:.5:.5 --brightness .4"
                                    ))
                                   end,
            {description = "reduce brightness and color", group = "XF86" }),
  awful.key({ }, "XF86MonBrightnessUp",      function ()
                                    os.execute(string.format(
                                      --"xbacklight -inc 5"
                                      "xrandr --output eDP-1 --brightness 1"
                                    ))
                                   end,
            {description = "reduce brightness and color", group = "XF86" }),
  awful.key({ }, "XF86Sleep",      function ()
                                     awful.util.spawn_with_shell("loginctl suspend")
                                   end,
            {description = "Suspend pc using loginctl", group = "XF86" }),
  -- Manage audio settings. Da valutare se tenere tutte le sink sincronizzate
  awful.key({ }, "XF86AudioRaiseVolume",  function ()
                                    os.execute([[
                                      for SINK in $(pacmd list-sinks | grep 'index:' | cut -b12-)
                                      do
                                          pactl set-sink-volume $SINK +5%
                                      done]])
                                    beautiful.volume.update()
                                  end,
            {description = "Increase volume in all sinks", group = "XF86" }),
  awful.key({ }, "XF86AudioLowerVolume",   function ()
                                    os.execute([[
                                      for SINK in $(pacmd list-sinks | grep 'index:' | cut -b12-)
                                      do
                                          pactl set-sink-volume $SINK -5%
                                      done]])
                                    beautiful.volume.update()
                                  end,
            {description = "Decrease volume in all sinks", group = "XF86" }),
  awful.key({ }, "XF86AudioMute", function ()
                                    os.execute([[
                                      for SINK in $(pacmd list-sinks | grep 'index:' | cut -b12-)
                                      do
                                          pactl set-sink-mute $SINK toggle
                                      done]])
                                    beautiful.volume.update()
                                  end,
            {description = "Mute all sinks", group = "XF86" }),

  -- Spotify
  awful.key({ }, "KP_Right", function ()
    awful.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")
                                  end,
            {description = "Next Spotify Song", group = "Spotify" }),
  awful.key({ }, "KP_Left", function ()
    awful.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
                                  end,
            {description = "Previous Spotify Song", group = "Spotify" }),
  awful.key({ }, "XF86AudioPlay", function ()
    awful.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
                                  end,
            {description = "PlayPause Spotify", group = "Spotify" }),

  --[[ Cmus
  awful.key({ modkey, "Control" }, "s", function ()
    awful.spawn("cmus-remote -k +10")
                                  end),
  awful.key({ modkey, "Control" }, "p", function ()
    awful.spawn("cmus-remote -u")
                                  end),
  awful.key({ modkey, "Control" }, "b", function ()
    awful.spawn("cmus-remote -r")
                                  end),
  awful.key({ modkey, "Control" }, "f", function ()
    awful.spawn("cmus-remote -n")
                                  end),
  ]]

  -- CopyQ
  awful.key({ modkey }, "q", function () os.execute('copyq show') end),

  -- Run LUA code.
  awful.key({ modkey }, "x",
            function ()
                awful.prompt.run {
                  prompt       = "Run Lua code: ",
                  textbox      = awful.screen.focused().mypromptbox.widget,
                  exe_callback = awful.util.eval,
                  history_path = awful.util.get_cache_dir() .. "/history_eval"
                }
            end,
            {description = "lua execute prompt", group = "awesome"})
)

clientkeys = awful.util.table.join(
  -- Current window management.
  awful.key({ modkey, "Shift"   }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
  awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
            {description = "toggle floating", group = "client"}),
  awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
            {description = "move to master", group = "client"}),
  awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
            {description = "move to screen", group = "client"}),
  awful.key({ modkey,  "Shift"  }, "t",      function (c) c.ontop = not c.ontop            end,
            {description = "toggle keep on top", group = "client"}),
  awful.key({ modkey,           }, "n",
      function (c)
          -- The client currently has the input focus, so it cannot be
          -- minimized, since minimized clients can't have the focus.
          c.minimized = true
      end ,
      {description = "minimize", group = "client"}),
  awful.key({ modkey,           }, "m", function (c)
                                          c.maximized_horizontal = not c.maximized_horizontal
                                          c.maximized_vertical   = not c.maximized_vertical
                                        end,
            {description = "magnify client", group = "client"}),

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

-- Set global keys.
root.keys(globalkeys)

-- }}}

-- Rules {{{

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     callback = awful.client.setslave,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "MPlayer",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

  { rule = { class = "gimp" },
    properties = { floating = true, tag = "9" } },

  -- Set Firefox to always map on tags number 2 of screen 1.
  { rule = { class = "Firefox" },
     properties = { tag = "2" } },

  { rule = { class = "Tor Browser" },
     properties = { tag = "2" } },

  { rule = { class = "Zathura" },
     properties = { tag = "3" } },

  { rule = { class = "Spotify" },
     properties = { tag = "5" } },

}

-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = mytable.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, { size = 16 }) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = vi_focus})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- switch to parent after closing child window
local function backham()
    local s = awful.screen.focused()
    local c = awful.client.focus.history.get(s, 0)
    if c then
        client.focus = c
        c:raise()
    end
end

-- attach to minimized state
client.connect_signal("property::minimized", backham)
-- attach to closed state
client.connect_signal("unmanage", backham)
-- ensure there is always a selected client during tag switching or logins
tag.connect_signal("property::selected", backham)

-- }}}

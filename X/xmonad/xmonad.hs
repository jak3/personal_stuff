-- Imports {{{
import XMonad
-- Prompt
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise (runOrRaisePrompt)
import XMonad.Prompt.AppendFile (appendFilePrompt)
-- Hooks
import XMonad.Operations

import System.IO
import System.Exit

import XMonad.Util.Run
import Graphics.X11.ExtraTypes.XF86

import XMonad.Actions.CycleWS

import XMonad.Hooks.ManageDocks (manageDocks, avoidStruts)
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.EwmhDesktops

import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace (onWorkspace, onWorkspaces)
import XMonad.Layout.Reflect (reflectHoriz)
import XMonad.Layout.IM
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.LayoutHints
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Grid

import Data.Ratio ((%))

import qualified XMonad.StackSet as W
import qualified Data.Map as M

--}}}

-- Config {{{

-- Define Terminal, sleep solve rendering, screen is faster than zsh
myTerminal      = "urxvt -e /bin/zsh -c \"sleep 0.1;screen\""
-- Define modMask
mymodMask :: KeyMask
mymodMask = mod4Mask
-- Define workspaces
myWorkspaces    = ["1:main","2:⚓","3:☕", "4:v", "5:♪","6","7","8"]
--}}}
-- Main {{{
main = do
    xmproc <- spawnPipe "/usr/bin/xmobar $HOME/personal_stuff/X/xmonad/xmobarrc"
    xmonad $ defaultConfig
      { terminal            = myTerminal
      , workspaces          = myWorkspaces
      , keys                = mykeys
      , modMask             = mymodMask
      , layoutHook          = lessBorders OnlyFloat $ mylayoutHook
      , manageHook          = mymanageHook
      , logHook = myLogHook xmproc
      , normalBorderColor   = "#CCCCC6"
      , focusedBorderColor  = "#FD971F"
      , borderWidth         = 1
      , startupHook         = setWMName "LG3D"
      }
--}}}

-- ManageHook {{{
mymanageHook :: ManageHook
mymanageHook = (composeAll . concat $
    [ [resource     =? r            --> doIgnore            |   r   <- myIgnores]
    , [className    =? c            --> doShift  "1:main"   |   c   <- myDev    ]
    , [className    =? c            --> doShift  "2:⚓"      |   c   <- myWww    ]
    , [className    =? c            --> doShift  "3:☕"      |   c   <- myVim    ]
    , [className    =? c            --> doShift	 "4:v"      |   c   <- myMisc   ]
    , [className    =? c            --> doShift	 "5:♪"      |   c   <- myMus    ]
    , [className    =? c            --> doShift  "8"        |   c   <- myFloats ]
    , [name         =? n            --> doCenterFloat       |   n   <- myNames  ]
    , [isFullscreen --> doFullFloat ]
    ])

    where

        role      = stringProperty "WM_WINDOW_ROLE"
        name      = stringProperty "WM_NAME"

        -- classnames
        myFloats  = ["Smplayer","MPlayer","Xmessage","XFontSel","Downloads","Nm-connection-editor", "ADT", "Eclipse"]
        myWww     = ["Firefox","Google-chrome","Google-chrome-stable","Chromium", "Chromium-browser", "Iceweasel", "Vidalia"]
        myMisc    = ["VirtualBox"]
        myDev	  = [""]
        myVim	  = [""]
        myMus	  = [""]

        -- resources
        myIgnores = ["desktop","desktop_window","notify-osd","stalonetray","trayer"]

        -- names
        myNames   = ["bashrun","Google Chrome Options","Chromium Options"]

-- }}}

-- Layout
mylayoutHook  = onWorkspaces ["1:main","5:♪"] customLayout $
                onWorkspaces ["2:⚓","4:v"] customLayout2$
                onWorkspaces ["8"] customLayout3$
                customLayout

customLayout = avoidStruts $ tiled ||| Mirror tiled ||| Full ||| simpleFloat
  where
    tiled   = ResizableTall 1 (2/100) (1/2) []

customLayout2 = avoidStruts $ Full ||| tiled ||| Mirror tiled ||| simpleFloat
  where
    tiled   = ResizableTall 1 (2/100) (1/2) []

customLayout3 = avoidStruts $ simpleFloat ||| tiled ||| Mirror tiled ||| Full
  where
    tiled   = ResizableTall 1 (2/100) (1/2) []

--Bar
myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ defaultPP
    {   ppOutput = hPutStrLn h
        ,ppVisible = xmobarColor "white" "#1B1D1E" . shorten 50
        , ppCurrent           =   xmobarColor "#ee9a00" "#1B1D1E" . shorten 50
        , ppHidden            =   xmobarColor "white" "#1B1D1E" . shorten 50
        , ppHiddenNoWindows   =   xmobarColor "#7b7b7b" "#1B1D1E" . shorten 50
    }

-- }}}
-- Key mapping {{{
mykeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    -- launch terminal default (screen)
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    , ((modm .|. shiftMask, xK_t     ), spawn "urxvt -e /bin/zsh")
    , ((modm,               xK_f     ), spawn "firefox")
    , ((modm,               xK_g     ), spawn "/opt/chrome/usr/bin/google-chrome-stable &")
    , ((modm .|. shiftMask, xK_l     ), spawn "$HOME/personal_stuff/scripts/layout_switch.sh")
    , ((modm, xK_x     ), spawn "xscreensaver-command -lock")
    , ((modm, xK_s     ), spawn "slock")
    , ((modm, xK_y     ), spawn "/opt/redshift/bin/redshift -c $HOME/personal_stuff/X/redshift.conf")
    , ((modm .|. controlMask, xK_l), spawn "cmus-remote -k +10") -- seek 10s
    , ((modm .|. controlMask, xK_h), spawn "cmus-remote -u") -- pause
    , ((modm .|. controlMask, xK_k), spawn "cmus-remote -r") -- previous song
    , ((modm .|. controlMask, xK_j), spawn "cmus-remote -n") -- next song
    , ((modm .|. controlMask, xK_r), spawn "cmus-remote -R") -- repeat
    , ((0, xF86XK_AudioMute     ),          spawn "amixer set Master toggle")
    , ((0, xF86XK_AudioRaiseVolume     ),   spawn "amixer set Master 10+")
    , ((0, xF86XK_AudioLowerVolume     ),   spawn "amixer set Master 10-")
    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)
    -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)
    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)
    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )
    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )
    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)
    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)
    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)
    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)
    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile && xmonad --restart")
    ]
    ++
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
    | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    -- EOF vim: set ts=4 sw=4 tw=80 :

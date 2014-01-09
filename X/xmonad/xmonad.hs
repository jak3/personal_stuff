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

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.EwmhDesktops

import XMonad.Layout.NoBorders (smartBorders, noBorders)
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

-- Define Terminal
myTerminal      = "urxvt -e /bin/zsh -c screen"
-- Define modMask
mymodMask :: KeyMask
mymodMask = mod4Mask
-- Define workspaces
myWorkspaces    = ["1:main","2:www","3:code", "4:misc", "5:♪"]
-- Dzen/Conky
myXmonadBar = "dzen2 -x '1440' -y '0' -h '20' -w '500' -ta 'l' -fg '#FFFFFF' -bg '#1B1D1E'"
myStatusBar = "conky -c $HOME/.xmonad/.conky_dzen | dzen2 -x '2080' -w '1040' -h '20' -ta 'r' -bg '#1B1D1E' -fg '#FFFFFF' -y '0'"
myBitmapsDir = "$HOME/personal_stuff/X/xmoand/dzen2"
--}}}
-- Main {{{
main = do
    --dzen2 ones
    --dzenLeftBar  <- spawnPipe myXmonadBar
    --dzenRightBar <- spawnPipe myStatusBar
    --xmobar one
    xmproc <- spawnPipe "/usr/bin/xmobar $HOME/personal_stuff/X/xmonad/xmobarrc"   
    --dzen2 one
    --xmonad $ withUrgencyHookC dzenUrgencyHook { args = ["-bg", "red", "fg", "black", "-xs", "1", "-y", "25"] } urgencyConfig { remindWhen = Every 15 } $ defaultConfig
    --xmobar one
    xmonad $ defaultConfig   
      { terminal            = myTerminal
      , workspaces          = myWorkspaces
      , keys                = mykeys
      , modMask             = mymodMask
      , layoutHook          = mylayoutHook
      , manageHook          = mymanageHook
      --dzen2 one
      --, logHook             = myLogHook dzenLeftBar >> fadeInactiveLogHook 0.9
      --xmobar one
      , logHook = myLogHook xmproc
      , normalBorderColor   = colorNormalBorder
      , focusedBorderColor  = colorFocusedBorder
      , borderWidth         = 1
      , startupHook         = setWMName "LG3D"
}
--}}}

-- Hooks {{{
-- ManageHook {{{
mymanageHook :: ManageHook
mymanageHook = (composeAll . concat $
    [ [resource     =? r            --> doIgnore            |   r   <- myIgnores] -- ignore desktop
    , [className    =? c            --> doShift  "1:main"     |   c   <- myDev    ] -- move dev to main
    , [className    =? c            --> doShift  "2:www"      |   c   <- myWww    ] -- move webs to main
    , [className    =? c            --> doShift  "3:code"     |   c   <- myVim    ]
    , [className    =? c            --> doShift	 "4:misc"     |   c   <- myMisc   ]
    , [className    =? c            --> doShift	 "5:♪"        |   c   <- myMus    ]
    , [className    =? c            --> doCenterFloat       |   c   <- myFloats ] -- float my floats
    , [name         =? n            --> doCenterFloat       |   n   <- myNames  ] -- float my names
    , [isFullscreen                 --> myDoFullFloat                           ]
    ])

    where

        role      = stringProperty "WM_WINDOW_ROLE"
        name      = stringProperty "WM_NAME"

        -- classnames
        myFloats  = ["Smplayer","MPlayer","VirtualBox","Xmessage","XFontSel","Downloads","Nm-connection-editor"]
        myWww     = ["Firefox","Google-chrome","Chromium", "Chromium-browser", "Iceweasel", "Vidalia"]
        myMisc    = ["VirtualBox"]
        myDev	  = [""]
        myVim	  = [""]
        myMus	  = [""]

        -- resources
        myIgnores = ["desktop","desktop_window","notify-osd","stalonetray","trayer"]

        -- names
        myNames   = ["bashrun","Google Chrome Options","Chromium Options"]

-- a trick for fullscreen but stil allow focusing of other WSs
myDoFullFloat :: ManageHook
myDoFullFloat = doF W.focusDown <+> doFullFloat
-- }}}
mylayoutHook  = onWorkspaces ["1:main","5:♪"] customLayout $
                onWorkspaces ["2:www","4:misc"] customLayout2 $
                customLayout2

--Bar
myLogHook :: Handle -> X ()
--dzen2 one
--myLogHook h = dynamicLogWithPP $ defaultPP
--    {
--        ppCurrent           =   dzenColor "#ebac54" "#1B1D1E" . pad
--      , ppVisible           =   dzenColor "white" "#1B1D1E" . pad
--      , ppHidden            =   dzenColor "white" "#1B1D1E" . pad
--      , ppHiddenNoWindows   =   dzenColor "#7b7b7b" "#1B1D1E" . pad
--      , ppUrgent            =   dzenColor "black" "red" . pad
--      , ppWsSep             =   " "
--      , ppSep               =   "  |  "
--      , ppLayout            =   dzenColor "#ebac54" "#1B1D1E" .
--                                (\x -> case x of
--                                    "ResizableTall"             ->      "^i(" ++ myBitmapsDir ++ "/tall.xbm)"
--                                    "Mirror ResizableTall"      ->      "^i(" ++ myBitmapsDir ++ "/mtall.xbm)"
--                                    "Full"                      ->      "^i(" ++ myBitmapsDir ++ "/full.xbm)"
--                                    "Simple Float"              ->      "~"
--                                    _                           ->      x
--                                )
--      , ppTitle             =   (" " ++) . dzenColor "white" "#1B1D1E" . dzenEscape
--      , ppOutput            =   hPutStrLn h
--    }
--xmobar one
myLogHook h = dynamicLogWithPP $ defaultPP 
    {   ppOutput = hPutStrLn h
        ,ppVisible = xmobarColor "white" "#1B1D1E" . shorten 50
        , ppCurrent           =   xmobarColor "#ee9a00" "#1B1D1E" . shorten 50
        , ppHidden            =   xmobarColor "white" "#1B1D1E" . shorten 50
        , ppHiddenNoWindows   =   xmobarColor "#7b7b7b" "#1B1D1E" . shorten 50
    }                     
 
-- Layout
customLayout = avoidStruts $ tiled ||| Mirror tiled ||| Full ||| simpleFloat
  where
    tiled   = ResizableTall 1 (2/100) (1/2) []

customLayout2 = avoidStruts $ Full ||| tiled ||| Mirror tiled ||| simpleFloat
  where
    tiled   = ResizableTall 1 (2/100) (1/2) []

-- Theme {{{
-- Color names are easier to remember:
colorOrange         = "#FD971F"
colorDarkGray       = "#1B1D1E"
colorPink           = "#F92672"
colorGreen          = "#A6E22E"
colorBlue           = "#66D9EF"
colorYellow         = "#E6DB74"
colorWhite          = "#CCCCC6"

colorNormalBorder   = "#CCCCC6"
colorFocusedBorder  = "#fd971f"


barFont  = "terminus"
barXFont = "inconsolata:size=12"
xftFont = "xft: inconsolata-14"
--}}}

-- Prompt Config {{{
mXPConfig :: XPConfig
mXPConfig =
    defaultXPConfig { font                  = barFont
                    , bgColor               = colorDarkGray
                    , fgColor               = colorGreen
                    , bgHLight              = colorGreen
                    , fgHLight              = colorDarkGray
                    , promptBorderWidth     = 0
                    , height                = 14
                    , historyFilter         = deleteConsecutive
                    }

-- Run or Raise Menu
largeXPConfig :: XPConfig
largeXPConfig = mXPConfig
                { font = xftFont
                , height = 22
                }
-- }}}
-- Key mapping {{{
mykeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    -- launch terminal default (screen)
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    , ((modm .|. shiftMask, xK_t     ), spawn "urxvt -e /bin/zsh")
    , ((modm,               xK_f     ), spawn "firefox")
    , ((modm .|. shiftMask, xK_l     ), spawn "xscreensaver-command -lock")
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

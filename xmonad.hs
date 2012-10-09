import XMonad
import qualified XMonad.StackSet as W

import XMonad.Actions.CycleWS

import XMonad.Layout.Grid
import XMonad.Layout.Tabbed
import XMonad.Layout.NoBorders(smartBorders)

import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName

import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)

import XMonad.Prompt
import XMonad.Prompt.Shell(shellPrompt)
import XMonad.Prompt.Window
import XMonad.Hooks.ManageHelpers

import System.IO(hPutStrLn)

myManageHook = composeAll
	[ className =? "exe" 		--> doFullFloat ]

myLayoutHook = tiled ||| Mirror tiled ||| Grid ||| simpleTabbed
	where
		-- default tiling algorithm partitions the screen into two panes
		tiled   = Tall nmaster delta ratio

		-- The default number of windows in the master pane
		nmaster = 1

		-- Default proportion of screen occupied by master pane
		ratio   = 1/2

		-- Percent of screen to increment by when resizing panes
		delta   = 3/100

main = do
	xmproc <- spawnPipe "xmobar"
	xmonad $ defaultConfig
			{ manageHook = manageDocks <+> myManageHook
			, layoutHook = avoidStruts $ smartBorders $ myLayoutHook
			, startupHook = setWMName "LG3D"
			, logHook    = dynamicLogWithPP $ xmobarPP
				{ ppOutput = hPutStrLn xmproc
				, ppUrgent = xmobarColor "#CC0000" "" . wrap "**" "**"
				, ppTitle  = xmobarColor "#8AE234" ""
				}
			, borderWidth = 2
			, focusFollowsMouse = False
			, terminal = "xterm"
			}
			`additionalKeysP`
			[ ("M-p", shellPrompt defaultXPConfig { position = Top })
			, ("M-S-a", windowPromptGoto defaultXPConfig { position = Top })
			, ("M-a", windowPromptBring defaultXPConfig { position = Top })
			, ("M-x", sendMessage ToggleStruts)
			, ("M-<Left>", moveTo Prev HiddenNonEmptyWS)
			, ("M-S-<Left>", shiftToPrev)
			, ("M-S-<Right>", shiftToNext)
			, ("M-<Up>", windows W.focusUp)
			, ("M-S-<Up>", windows W.swapUp)
			, ("M-<Down>", windows W.focusDown)
			, ("M-S-<Down>", windows W.swapDown)
			, ("M-S-l", spawn "(pgrep xscreensaver || xscreensaver & sleep 1); xscreensaver-command -lock")
			, ("M-S-s", spawn "sudo pm-suspend-hybrid")
			, ("M-<Page_Up>", spawn "amixer sset Master 5%+")
			, ("M-<Page_Down>", spawn "amixer sset Master 5%-")
			, ("M-c", spawn "xdotool key 'ctrl+c'; xclip -o | xclip -i -selection clipboard")
			, ("M-v", spawn "xclip -selection clipboard -o | xclip -i && xdotool key 'shift+Insert'")
			, ("M-g", spawn "scrot -s")
			]

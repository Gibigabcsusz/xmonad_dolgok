   --
   -- An example, simple ~/.xmonad/xmonad.hs file.
   -- It overrides a few basic settings, reusing all the other defaults.
   --

import XMonad
import XMonad.Util.EZConfig (additionalKeys)
import qualified XMonad.StackSet as W
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run(spawnPipe)
import System.IO




myModMask = mod4Mask

myWorkspaces = ["1","2","3","4","5","6","7","8","9"] ++ (map snd myExtraWorkspaces) -- you can customize the names of the default workspaces by changing the list

myExtraWorkspaces = [(xK_0, "0")] -- list of (key, name)


myAdditionalKeys =
    [ -- ... your other hotkeys ...
    ] ++ [
        ((myModMask, key), (windows $ W.greedyView ws))
        | (key, ws) <- myExtraWorkspaces
    ] ++ [
        ((myModMask .|. shiftMask, key), (windows $ W.shift ws))
        | (key, ws) <- myExtraWorkspaces
    ]

myManageHook = composeAll [
    manageDocks,
    manageHook defaultConfig
  ]


main = do
    xmproc <- spawnPipe "xmobar"

    xmonad $ defaultConfig 
        { terminal           = "termite"
        , borderWidth        = 2
        , normalBorderColor  = "#2d3a3a"
        , manageHook = myManageHook
        , focusedBorderColor = "#2ba84a" 
        , modMask            = myModMask 
        , layoutHook         = avoidStruts  $  layoutHook defaultConfig
        , logHook            = dynamicLogWithPP xmobarPP
                                    { ppOutput = hPutStrLn xmproc
                                    , ppTitle = xmobarColor "green" "" . shorten 50
                                    }
        , workspaces         = myWorkspaces
        } `additionalKeys` myAdditionalKeys


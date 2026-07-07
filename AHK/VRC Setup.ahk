#Requires AutoHotkey v2

#include AudioDevices.ahk
SetOutput("BSB2")

SetTitleMatchMode("RegEx")
DetectHiddenWindows(True)

FindAndClose(aExeRegex) {
    for this_id in WinGetList("ahk_exe " aExeRegex) {
        if not WinExist("ahk_id " this_id) {
            continue
        }
        if (this_id = A_ScriptHwnd) {
            continue
        }
        if not InStr(WinGetTitle(this_id), "IME") {
            WinClose("ahk_id " this_id)
        }
    }
}

FindOrOpen(aFullPath) {
    lastSlash := InStr(aFullPath, "\", , , -1)
    exeName := SubStr(aFullPath, lastSlash+1)

    If WinExist("ahk_exe i)\\" exeName) {
        WinRestore()
        WinActivate()
    }
    else {
        Run(aFullPath)
    }
}

FindAndClose("i)\\AutoHotkey[^.]*\.exe")
FindAndClose("i)\\flux\.exe")
FindAndClose("i)\\Twinkle Tray\.exe")
FindAndClose("i)\\bridge-gui\.exe")
FindAndClose("i)\\PowerToys\.exe")
FindAndClose("i)\\Swiftpoint X1 Control Panel\.exe")
FindAndClose("i)\\Unity Hub\.exe")
FindAndClose("i)\\EpicGamesLauncher\.exe")
FindAndClose("i)\\GalaxyClient\.exe")
FindAndClose("i)\\GalaxyClient Helper\.exe")
FindAndClose("i)\\GOG Galaxy Notifications Renderer\.exe")
FindAndClose("i)\\GalaxyCommunication\.exe")
FindAndClose("i)\\VeraCrypt\.exe")
;FindAndClose("i)\\Telegram\.exe")

;FindOrOpen("C:\Program Files (x86)\SlimeVR Server\slimevr.exe")
FindOrOpen("C:\Program Files\VRCX\VRCX.exe")
;FindOrOpen("C:\Program Files (x86)\Steam\steamapps\common\Bigscreen Beyond Driver\bin\eyetracking\ETClient\BeyondET.exe")

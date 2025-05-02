;----- Common settings -----
#Requires AutoHotkey v2
#SingleInstance force

#include "%A_ScriptDir%"
#include xmouse-focus.ahk
#include WinEvent.ahk

Persistent()

global XWT_Lock := 0
global XWT_OldSetting := False

XWT_Disable() {
    global XWT_Lock

    if (++XWT_Lock == 1) {
        global XWT_OldSetting := SetWinHoverFocus(False)
    }

    A_TrayMenu.Rename("1&", "Clear " . XWT_Lock . " lock(s)")
    A_TrayMenu.Enable("1&")
}
XWT_Enable(aForce := False) {
    global XWT_Lock

    if (aForce) {
        XWT_Lock := 1
    }
    if (--XWT_Lock == 0) {
        global XWT_OldSetting
        SetWinHoverFocus(XWT_OldSetting)

        A_TrayMenu.Rename("1&", "Unlocked")
        A_TrayMenu.Disable("1&")
    }
}

XWT_WinShownCallback(hWnd, hook, dwmsEventTime) {
    XWT_Disable()
    WinActivate(Integer(hWnd))
    WinEvent.Close(XWT_WinClosedCallback, Integer(hWnd), 1)
}

XWT_WinClosedCallback(hWnd, hook, dwmsEventTime, properties) {
    XWT_Enable()
}

XWT_OnExit(exitReason, exitCode) {
    WinEvent.Stop()
    SetWinHoverFocus(False)
}
OnExit(XWT_OnExit)

XWT_HandleMessage(wParam, lParam, Msg, hWnd) {
    if (wParam = 0x7) { ; WTS_SESSION_LOCK
        XWT_Disable()
    }
    if (wParam = 0x8) { ; WTS_SESSION_UNLOCK
        XWT_Enable()
    }
}
OnMessage(0x281, XWT_HandleMessage) ; WM_WTSESSION_CHANGE

XWT_ResetMenu(ItemName, ItemPos, MyMenu) {
    xWT_Enable(True)
}

; Create our menu item
A_TrayMenu.Insert("1&", "Unlocked", XWT_ResetMenu)
A_TrayMenu.Disable("1&")

; Toggle hover-focus with Win+T
#T::SetWinHoverFocus("Toggle")

; and turn it on by default
SetWinHoverFocus(True)

; Temporarily disable hover-focus when specific windows happen
GroupAdd("NoHoverFocus", "ahk_exe OpenWith.exe")
GroupAdd("NoHoverFocus", "Task View ahk_class XamlExplorerHostIslandWindow ahk_exe explorer.exe")
GroupAdd("NoHoverFocus", "ahk_class Windows.UI.Core.CoreWindow ahk_exe ShellExperienceHost.exe")
GroupAdd("NoHoverFocus", "ahk_exe PowerToys.PowerLauncher.exe")
GroupAdd("NoHoverFocus", "ahk_class UnityContainerWndClass ahk_exe Unity.exe")
WinEvent.Show(XWT_WinShownCallback, "ahk_group NoHoverFocus")

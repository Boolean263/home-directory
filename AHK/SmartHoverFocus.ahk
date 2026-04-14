;----- Common settings -----
#Requires AutoHotkey v2
#SingleInstance force

#include "%A_ScriptDir%"
#include xmouse-focus.ahk
#include WinEvent.ahk

Persistent()

global XWT_Lock := 0
global XWT_OldSetting := False
global XWT_LockStr := "No locks"

XWT_Disable(aDesc := "unspecified") {
    global XWT_Lock

    if (++XWT_Lock == 1) {
        global XWT_OldSetting := SetWinHoverFocus(False)
        ;global XWT_LockStr := "Active locks:"
    }
    global XWT_LockStr .= "`n+" . aDesc
    A_IconTip := XWT_LockStr

    A_TrayMenu.Rename("1&", "Clear " . XWT_Lock . " lock(s)")
    A_TrayMenu.Enable("1&")
}
XWT_Enable(aDesc := "unspecified") {
    global XWT_Lock

    ; Type(bool) returns Integer, and I want an arg of True to force-enable
    if (Type(aDesc) = "Integer") {
        XWT_Lock := 1
    }
    if (--XWT_Lock == 0) {
        global XWT_OldSetting
        SetWinHoverFocus(XWT_OldSetting)

        global XWT_LockStr := A_ScriptName
        A_TrayMenu.Disable("1&")
    }
    else {
        global XWT_LockStr .= "`n-" . aDesc
    }
    global XWT_LockStr
    A_IconTip := XWT_LockStr
    A_TrayMenu.Rename("1&", "Unlocked")
}

XWT_WinShownCallback(hWnd, hook, dwmsEventTime) {
    XWT_Disable(WinGetTitle(hWnd) " ahk_class " WinGetClass(hWnd)) ; " ahk_exe " WinGetProcessName(hWnd))
    WinActivate(Integer(hWnd))
    WinEvent.Close(XWT_WinClosedCallback, Integer(hWnd), 1)
}

XWT_WinClosedCallback(hWnd, hook, dwmsEventTime, properties) {
    XWT_Enable(WinGetTitle(hWnd) " ahk_class " WinGetClass(hWnd)) ; " ahk_exe " WinGetProcessName(hWnd))
}

XWT_OnExit(exitReason, exitCode) {
    WinEvent.Stop()
    SetWinHoverFocus(False)
}
OnExit(XWT_OnExit)

; This part doesn't seem to work, it may need elevated privs
XWT_HandleMessage(wParam, lParam, Msg, hWnd) {
    if (wParam = 0x7) { ; WTS_SESSION_LOCK
        XWT_Disable("Lock workstation")
    }
    if (wParam = 0x8) { ; WTS_SESSION_UNLOCK
        XWT_Enable("Lock workstation")
    }
}
OnMessage(0x281, XWT_HandleMessage) ; WM_WTSESSION_CHANGE

XWT_ResetMenu(ItemName, ItemPos, MyMenu) {
    XWT_Enable(True)
}

; Create our menu item and tooltip
A_TrayMenu.Insert("1&", "Unlocked", XWT_ResetMenu)
A_TrayMenu.Disable("1&")
A_IconTip := A_ScriptName

; Toggle hover-focus with Win+T
#T::{
    OldState := SetWinHoverFocus("Toggle")
    if (OldState) {
        ; If we just turned off hover-focus,
        ; clear our locks
        global XWT_Lock := 0
        global XWT_OldSetting := False
        global XWT_LockStr := "No locks"
    }
}

; and turn it on by default
SetWinHoverFocus(True)

; Temporarily disable hover-focus when specific windows happen
GroupAdd("NoHoverFocus", "ahk_exe OpenWith.exe")
GroupAdd("NoHoverFocus", "Task View ahk_class XamlExplorerHostIslandWindow ahk_exe explorer.exe")
GroupAdd("NoHoverFocus", "ahk_class Windows.UI.Core.CoreWindow ahk_exe ShellExperienceHost.exe")
GroupAdd("NoHoverFocus", "ahk_exe PowerToys.PowerLauncher.exe")
GroupAdd("NoHoverFocus", "ahk_exe MediaMonkey.exe")
GroupAdd("NoHoverFocus", "ahk_class UnityContainerWndClass ahk_exe Unity.exe")
WinEvent.Show(XWT_WinShownCallback, "ahk_group NoHoverFocus")

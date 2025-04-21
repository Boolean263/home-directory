;----- Common settings -----
#Requires AutoHotkey v2
#SingleInstance force

#include "%A_ScriptDir%"
#include xmouse-focus.ahk
#include WinEvent.ahk

Persistent()

global XWT_Lock := 0
global XWT_OldSetting := False

XWT_WinShownCallback(hWnd, hook, dwmsEventTime) {
    global XWT_Lock

    if (++XWT_Lock == 1) {
        global XWT_OldSetting := SetWinHoverFocus(False)
    }
    WinActivate(Integer(hWnd))
    WinEvent.Close(XWT_WinClosedCallback, Integer(hWnd), 1)
}

XWT_WinClosedCallback(hWnd, hook, dwmsEventTime, properties) {
    global XWT_Lock

    if (--XWT_Lock == 0) {
        global XWT_OldSetting
        SetWinHoverFocus(XWT_OldSetting)
    }
}

XWT_OnExit(exitReason, exitCode) {
    WinEvent.Stop()
    SetWinHoverFocus(False)
}
OnExit(XWT_OnExit)

; Toggle hover-focus with Win+T
#T::SetWinHoverFocus("Toggle")

; and turn it on by default
SetWinHoverFocus(True)

; Temporarily disable hover-focus when specific windows happen
GroupAdd("NoHoverFocus", "ahk_exe OpenWith.exe")
WinEvent.Show(XWT_WinShownCallback, "ahk_group NoHoverFocus")

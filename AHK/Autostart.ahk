;----- Common settings -----
#Requires AutoHotkey v2
#SingleInstance force

; Make all future #Include's relative to this directory
#include "%A_ScriptDir%"

;----- Your autoexecute commands -----

; Toggle CapsLock by pressing both Shift keys
; (I typically remap CapsLock to Ctrl, either through the Registry
; or directly in my keyboard firmware)
<+RShift::
>+LShift::
{
    SetCapsLockState !GetKeyState('CapsLock', 'T')
}

; en-dash on Ctrl+NumpadSub, em-dash on Ctrl+Alt+NumpadSub
; (these are MS Word shortcuts that I'm making global)
^NumpadSub::Send "{U+2013}"
^!NumpadSub::Send "{U+2014}"

; Just the proper unicode symbols for the operator keys.
; Note that programs like Calculator don't recognize them.
NumpadMult::Send "{U+00D7}"
NumpadDiv::Send "{U+00F7}"

; Bring window to top
#a::
{
    MouseGetPos(,,&rwinid)
    WinMoveTop(Integer(rwinid))
    ;WinActivate(Integer(rwinid))
}

; Send window to bottom
#z::
{
    MouseGetPos(,,&rwinid)
    WinMoveBottom(Integer(rwinid))
}

; Toggle "focus" mode -- ie, borderless fullscreen
; Some programs have their own hotkey for this
#HotIf WinActive("ahk_class MozillaWindowClass") ; or WinActive(...)
    ; These programs use F11
    #f::
    {
        Send "{F11}"
    }
#HotIf WinActive("ahk_class mintty")
    ; These programs use Alt+Enter
    #f::
    {
        Send "!{Enter}"
    }
; For programs that don't, we can make it happen
#HotIf
#f::
{
    ; Toggle the border and titlebar of the current window
    WinSetStyle("^0xC40000", "A")

    ; Now see which we did
    MX := WinGetStyle("A")
    if (MX & 0xC40000) {
        ; Window now has both; we must be exiting focus mode
        WinRestore("A")
    }
    else {
        ; Window now has neither; we must be entering focus mode
        WinMaximize("A")
    }
}

; Close Windows Explorer so it restarts
!^Insert::ProcessClose("explorer.exe")

; Shut down Windows
;^!F4::Shutdown(9)
^!F4::Shutdown(1)

; Manage virtual desktops
; VD.ahk from https://github.com/FuPeiJiang/VD.ahk/tree/v2_port
#Include VD.ah2

; Windows already has:
; - Add desktop with Win+Ctrl+D
; - Remove current desktop with Win+Ctrl+F4

; Win+num to switch to that desktop
; Win+Ctrl+num to bring current window to that desktop
MyVD(ThisHotkey) {
    n := Integer(SubStr(ThisHotkey, -1))
    try {
        if InStr(ThisHotkey, "^") {
            VD.MoveWindowToDesktopNum("A", n)
        }
        VD.goToDesktopNum(n)
    }
    catch Error {
        ; Probably a desktop number that doesn't exist
    }
}

Loop 9 {
    Hotkey("#" A_Index, MyVD)
    Hotkey("#^" A_Index, MyVD)
}

; Allow toggling hover-focus
#include xmouse-focus.ahk
#T::SetWinHoverFocus("Toggle")

;----- Included scripts -----
#Include ChangeResolution.ahk
#include SimpleWindowDrag.ah2

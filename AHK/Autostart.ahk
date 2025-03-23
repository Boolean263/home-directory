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
^NumpadSub::
{
    Send "{U+2013}"
}

^!NumpadSub::
{
    Send "{U+2014}"
}

; Bring window to top
#a::
{
    MouseGetPos(,,&rwinid)
    WinActivate(Integer(rwinid))
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

; Restart Windows Explorer
!^Insert::
{
    ProcessClose("explorer.exe")
    ; it automatically restarts on its own
}

; Shut down Windows
^!F4::
{
    Shutdown(9)
}

; Test VD.ahk from https://github.com/FuPeiJiang/VD.ahk/tree/v2_port
#Include VD.ah2

; Win+num to switch to that desktop
; Win+Ctrl+num to bring current window to that desktop
#1::
{
    VD.goToDesktopNum(1)
}
#2::
{
    VD.goToDesktopNum(2)
}
#3::
{
    VD.goToDesktopNum(3)
}
#^1::
{
    VD.MoveWindowToDesktopNum("A", 1)
    VD.goToDesktopNum(1)
}
#^2::
{
    VD.MoveWindowToDesktopNum("A", 2)
    VD.goToDesktopNum(2)
}
#^3::
{
    VD.MoveWindowToDesktopNum("A", 3)
    VD.goToDesktopNum(3)
}

;----- Included scripts -----
#Include ChangeResolution.ahk
#include SimpleWindowDrag.ah2

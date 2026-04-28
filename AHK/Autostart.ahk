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

; Attach some fun stuff to the number pad.
; Note that programs like Calculator don't recognize them.
; The #HotIf documentation suggests this method for detecting
; multiple types of window in a performant way.
GroupAdd("UsesNumpad", "Calculator ahk_class ApplicationFrameWindow")
GroupAdd("UsesNumpad", "ahk_exe OpenMPT.exe")
#HotIf not WinActive("ahk_group UsesNumpad")
    ; en-dash on Ctrl+NumpadSub, em-dash on Ctrl+Alt+NumpadSub
    ; (these are MS Word shortcuts that I'm making global)
    ^NumpadSub::Send "{U+2013}"
    ^!NumpadSub::Send "{U+2014}"

    ; Just the proper unicode symbols for the operator keys.
    NumpadMult::Send "{U+00D7}"
    NumpadDiv::Send "{U+00F7}"
#HotIf

; Bring in some of my "AltGr" mappings from Linux.
; Note that Windows's ACTUAL AltGr is LCtrl+RAlt,
; but I'm only using RAlt since that's how I'm used to it.
; The syntax for that is: >!
>!3::Send "{U+2588}"    ; Solid block
>!8::Send "{U+2022}"    ; Bullet
>!+8::Send "{U+25E6}"   ; Hollow bullet
>!-::Send "{U+00AD}"    ; Soft hyphen
>!+-::Send "{U+2011}"   ; Non-breaking hyphen
>!+=::Send "{U+2295}"   ; Circled plus
>!.::Send "{U+00B7}"    ; Middle dot
>![::Send "{U+2018}"    ; Left single quote
>!]::Send "{U+2019}"    ; Right single quote
>!+[::Send "{U+201C}"   ; Left double quote
>!+]::Send "{U+201D}"   ; Right double quote
>!/::Send "{U+FFFD}"    ; Replacement symbol
>!Space::Send "{U+00A0}" ; Non-breaking space
>!+Space::Send "{U+200B}" ; Zero-width non-breaking space
>!d::Send "{U+00B0}"    ; Degree symbol
>!+d::Send "{U+0394}"   ; Delta symbol
>!l::Send "{U+2113}"    ; Small script L
>!+l::Send "{U+2112}"   ; Capital script L
>!m::Send "{U+03BC}"    ; Small mu
>!+m::Send "{U+039C}"   ; Capital mu
>!s::Send "{U+00A7}"    ; Section symbol

; Launch Windows Terminal with Win+Enter
#Enter::Run("wt", EnvGet("HOME"))

; Bring window to top
#a::
{
    MouseGetPos(,,&rwinid)
    WinMoveTop(Integer(rwinid))
}

; Send window to bottom
#z::
{
    MouseGetPos(,,&rwinid)
    WinMoveBottom(Integer(rwinid))
}

; Toggle "focus" mode -- ie, borderless fullscreen
; Some programs have their own hotkey for this...
GroupAdd("Focus_F11", "ahk_class MozillaWindowClass")
GroupAdd("Focus_AltEnter", "ahk_class mintty")

#HotIf WinActive("ahk_group Focus_F11")
    #f::
    {
        WinMoveTop("A")
        Send "{F11}"
    }
#HotIf WinActive("ahk_group Focus_AltEnter")
    #f::
    {
        WinMoveTop("A")
        Send "!{Enter}"
    }
; For programs that don't, we can make it happen
#HotIf
#f::
{
    WinMoveTop("A")

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
; Note: Either of these seems to do a 'full' shutdown,
; so on the next startup, my startup items don't start launching
; until I unlock the computer. Start > Shutdown doesn't have this problem.
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

; Win+P to toggle pinning window to all desktops
#p::VD.TogglePinWindow("A")

;----- Included scripts -----
;#Include ChangeResolution.ahk
#include SimpleWindowDrag.ah2

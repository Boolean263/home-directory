;----- Common settings -----
#Requires AutoHotkey v2.0

;----- Your autoexecute commands -----

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

;----- Included scripts -----
#Include ChangeResolution.ahk
; BELOW HERE HAS NOT YET BEEN EXAMINED FOR AHK 2
;#Include MoveInactiveWin.ahk
;#Include EasyWindowDrag.ahk
;; GoSub SKeySetup
;; GoSub PariSetup
;; GoSub ClockSetup
;; GoSub ClipPadSetup
;; 
;; SKeySetup:
;; #Include c:\t\AutoHotKey\SKey.ahk
;; 
;; PariSetup:
;; #Include c:\t\AutoHotKey\pari.ahk
;; 
;; ClockSetup:
;; #Include c:\t\AutoHotKey\Clock.ahk
;; 
;; ClipPadSetup:
;; #Include c:\t\AutoHotKey\ClipPad.ahk

;----- Shared subroutines, functions -----
;...

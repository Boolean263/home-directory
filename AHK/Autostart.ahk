;----- Common settings -----
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;----- Your autoexecute commands -----

; Bring window to top
#a::
MouseGetPos,,,rwinid
WinSet, Top,,ahk_id %rwinid%
Return

; Send window to bottom
#z::
MouseGetPos,,,rwinid
WinSet, Bottom,,ahk_id %rwinid%
Return

; Toggle "focus" mode -- ie, borderless fullscreen
#f::
WinGet MX, MinMax, A
If MX {
    WinSet, Style, +0xC40000, A
    WinRestore A
}
Else {
    WinSet, Style, -0xC40000, A
    WinMaximize A
}
Return

; Restart Windows Explorer
!^Insert::
Process, Close, explorer.exe
; it automatically restarts on its own
Return

;----- Included scripts -----
#Include ChangeResolution.ahk
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

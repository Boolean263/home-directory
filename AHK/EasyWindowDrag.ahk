; Easy Window Dragging -- KDE style (requires XP/2k/NT) -- by Jonny
; https://www.autohotkey.com
; This script makes it much easier to move or resize a window: 1) Hold down
; the ALT key and LEFT-click anywhere inside a window to drag it to a new
; location; 2) Hold down ALT and RIGHT-click-drag anywhere inside a window
; to easily resize it; 3) Press ALT twice, but before releasing it the second
; time, left-click to minimize the window under the mouse cursor, right-click
; to maximize it, or middle-click to close it.

; This script was inspired by and built on many like it
; in the forum. Thanks go out to ck, thinkstorm, Chris,
; and aurelian for a job well done.

; Change history:
; DAP 2022-03-24: Use Win instead of Alt
; November 07, 2006: Optimized resizing code in !RButton, courtesy of bluedawn.
; February 05, 2006: Fixed double-alt (the ~Alt hotkey) to work with latest versions of AHK.

; The Double-Alt modifier is activated by pressing
; Alt twice, much like a double-click. Hold the second
; press down until you click.
;
; The shortcuts:
;  Alt + Left Button  : Drag to move a window.
;  Alt + Right Button : Drag to resize a window.
;  Double-Alt + Left Button   : Minimize a window.
;  Double-Alt + Right Button  : Maximize/Restore a window.
;  Double-Alt + Middle Button : Close a window.
;
; You can optionally release Alt after the first
; click rather than holding it down the whole time.

If (A_AhkVersion < "1.0.39.00")
{
    MsgBox,20,,This script may not work properly with your version of AutoHotkey. Continue?
    IfMsgBox,No
    ExitApp
}

; Listen to the Windows power event "WM_POWERBROADCAST" (ID: 0x218):
OnMessage(0x218, "func_WM_POWERBROADCAST")
Return

/*
    This function is executed if the system sends a power event.
    Parameters wParam and lParam define the type of event:

    lParam: always 0
    wParam:
    PBT_APMQUERYSUSPEND             0x0000
    PBT_APMQUERYSTANDBY             0x0001

    PBT_APMQUERYSUSPENDFAILED       0x0002
    PBT_APMQUERYSTANDBYFAILED       0x0003

    PBT_APMSUSPEND                  0x0004
    PBT_APMSTANDBY                  0x0005

    PBT_APMRESUMECRITICAL           0x0006
    PBT_APMRESUMESUSPEND            0x0007
    PBT_APMRESUMESTANDBY            0x0008

    PBTF_APMRESUMEFROMFAILURE       0x00000001

    PBT_APMBATTERYLOW               0x0009
    PBT_APMPOWERSTATUSCHANGE        0x000A

    PBT_APMOEMEVENT                 0x000B
    PBT_APMRESUMEAUTOMATIC          0x0012

    Source: http://weblogs.asp.net/ralfw/archive/2003/09/09/26908.aspx
    */
func_WM_POWERBROADCAST(wParam, lParam)
{
    If (lParam = 0) {
        ; PBT_APMSUSPEND or PBT_APMSTANDBY? -> System will sleep
        If (wParam = 4 OR wParam = 5) {
            SendMessage,0x112,0xF170,2,,Program Manager
        }

        ; PBT_APMRESUMESUSPEND oder PBT_APMRESUMESTANDBY? -> System wakes up
        If (wParam = 7 OR wParam = 8) {
            SendMessage,0x112,0xF170,-1,,Program Manager
        }
    }
    Return
}

#MenuMaskKey vkFF

; This is the setting that runs smoothest on my
; system. Depending on your video card and cpu
; power, you may want to raise or lower this value.
SetWinDelay,2

CoordMode,Mouse
return

#LButton::
If DoubleAlt
{
    MouseGetPos,,,KDE_id
    ; This message is mostly equivalent to WinMinimize,
    ; but it avoids a bug with PSPad.
    PostMessage,0x112,0xf020,,,ahk_id %KDE_id%
    DoubleAlt := false
    return
}
; Get the initial mouse position and window id, and
; abort if the window is maximized.
MouseGetPos,KDE_X1,KDE_Y1,KDE_id
WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
If KDE_Win
    return
; Get the initial window position.
WinGetPos,KDE_WinX1,KDE_WinY1,,,ahk_id %KDE_id%
Loop
{
    GetKeyState,KDE_Button,LButton,P ; Break if button has been released.
    If KDE_Button = U
        break
    MouseGetPos,KDE_X2,KDE_Y2 ; Get the current mouse position.
    KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
    KDE_Y2 -= KDE_Y1
    KDE_WinX2 := (KDE_WinX1 + KDE_X2) ; Apply this offset to the window position.
    KDE_WinY2 := (KDE_WinY1 + KDE_Y2)
    WinMove,ahk_id %KDE_id%,,%KDE_WinX2%,%KDE_WinY2% ; Move the window to the new position.
}
return

#RButton::
If DoubleAlt
{
    MouseGetPos,,,KDE_id
    ; Toggle between maximized and restored state.
    WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
    If KDE_Win
        WinRestore,ahk_id %KDE_id%
    Else
        WinMaximize,ahk_id %KDE_id%
    DoubleAlt := false
    return
}
; Get the initial mouse position and window id, and
; abort if the window is maximized.
MouseGetPos,KDE_X1,KDE_Y1,KDE_id
WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
If KDE_Win
    return
; Get the initial window position and size.
WinGetPos,KDE_WinX1,KDE_WinY1,KDE_WinW,KDE_WinH,ahk_id %KDE_id%
; Define the window region the mouse is currently in.
; The four regions are Up and Left, Up and Right, Down and Left, Down and Right.
If (KDE_X1 < KDE_WinX1 + KDE_WinW / 2)
    KDE_WinLeft := 1
Else
    KDE_WinLeft := -1
If (KDE_Y1 < KDE_WinY1 + KDE_WinH / 2)
    KDE_WinUp := 1
Else
    KDE_WinUp := -1
Loop
{
    GetKeyState,KDE_Button,RButton,P ; Break if button has been released.
    If KDE_Button = U
        break
    MouseGetPos,KDE_X2,KDE_Y2 ; Get the current mouse position.
    ; Get the current window position and size.
    WinGetPos,KDE_WinX1,KDE_WinY1,KDE_WinW,KDE_WinH,ahk_id %KDE_id%
    KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
    KDE_Y2 -= KDE_Y1
    ; Then, act according to the defined region.
    WinMove,ahk_id %KDE_id%,, KDE_WinX1 + (KDE_WinLeft+1)/2*KDE_X2  ; X of resized window
                            , KDE_WinY1 +   (KDE_WinUp+1)/2*KDE_Y2  ; Y of resized window
                            , KDE_WinW  -     KDE_WinLeft  *KDE_X2  ; W of resized window
                            , KDE_WinH  -       KDE_WinUp  *KDE_Y2  ; H of resized window
    KDE_X1 := (KDE_X2 + KDE_X1) ; Reset the initial position for the next iteration.
    KDE_Y1 := (KDE_Y2 + KDE_Y1)
}
return

; "Alt + MButton" may be simpler, but I
; like an extra measure of security for
; an operation like this.
#MButton::
If DoubleAlt
{
    MouseGetPos,,,KDE_id
    WinClose,ahk_id %KDE_id%
    DoubleAlt := false
    return
}
return

; This detects "double-clicks" of the alt key.
~LWin::
DoubleAlt := A_PriorHotkey = "~LWin" AND A_TimeSincePriorHotkey < 400
Sleep 0
KeyWait LWin  ; This prevents the keyboard's auto-repeat feature from interfering.
return

; My additions
#a::
MouseGetPos,,,rwinid
WinSet, Top,,ahk_id %rwinid%
Return

#z::
MouseGetPos,,,rwinid
WinSet, Bottom,,ahk_id %rwinid%
Return

#f::
; Toggle "focus" mode -- ie, borderless fullscreen
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

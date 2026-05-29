#Requires AutoHotkey v2
; Adapted from https://superuser.com/a/1209478

#include system-params.ahk

; According to https://www.autohotkey.com/docs/v2/Concepts.htm#nothing
; the empty string is used to represent a non-value or default value.
SetWinHoverFocus(aOn, aRaise := "", aActTimeout := "") {

    ; This system call parameter enables or disables the setting
    ; "Activate a window by hovering over it with the mouse"
    ; found under Control Panel (*not* Settings),
    ; Ease of Access Center, Make the mouse easier to use.
    SPI_GETACTIVEWINDOWTRACKING := 0x1000
    SPI_SETACTIVEWINDOWTRACKING := 0x1001

    ; This one decides whether the window should be raised
    ; if it's made active by the above hover setting.
    SPI_GETACTIVEWNDTRKZORDER := 0x100C
    SPI_SETACTIVEWNDTRKZORDER := 0x100D

    ; And this one sets how long Windows should wait, in milliseconds,
    ; after the mouse hovers over a non-active window before
    ; it activates the window.
    ; Some programs misbehave if this is set too low; for example,
    ; custom pop-ups may immediately close if they don't have mouse focus
    ; when they're opened.
    ; That's why the aActTimeout default is 250 and not 0.
    SPI_GETACTIVEWNDTRKTIMEOUT := 0x2002
    SPI_SETACTIVEWNDTRKTIMEOUT := 0x2003

    current := ParamGet(SPI_GETACTIVEWINDOWTRACKING)
    if (aOn = "toggle") {
        aOn := !current
    }

    ParamSet(SPI_SETACTIVEWINDOWTRACKING, , aOn ? 1 : 0)

    if (aRaise != "")
        ParamSet(SPI_SETACTIVEWNDTRKZORDER, , aRaise ? 1 : 0)

    if (IsInteger(aActTimeout) and Number(aActTimeout) >= 0)
        ParamSet(SPI_SETACTIVEWNDTRKTIMEOUT, , Number(aActTimeout))

    return current
}

; If I'm running this file directly, toggle the setting and exit.
; If this file is included, don't do that.
if (!A_IsCompiled && A_LineFile == A_ScriptFullPath) {
    SetWinHoverFocus("Toggle")
}

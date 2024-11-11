; Change screen resolution with a hotkey.
; From https://www.tcg.com/blog/quickly-change-windows-10-resolution-with-autohotkey/

; Updated to AHK v2 using
; https://www.reddit.com/r/AutoHotkey/comments/11w816x/autohotkey_v2_code_to_change_screen_resolution/
#Requires AutoHotkey v2.0

#PgUp::
{
    ChangeResolution(32, 3440, 1440, 60)
}

#PgDn::
{
    ChangeResolution(32, 1920, 1080, 60)
}

; Colour depth, width, height, refresh rate
ChangeResolution( cD, sW, sH, rR ) {
    dM := Buffer(156, 0)
    NumPut("UShort", 156, dM, 36)
    DllCall("EnumDisplaySettingsA", "UInt", 0, "UInt", -1, "Ptr", dM)
    NumPut("UInt", 0x5c0000, dM, 40)
    NumPut("UInt", cD, dM, 104)
    NumPut("UInt", sW, dM, 108)
    NumPut("UInt", sH, dM, 112)
    NumPut("UInt", rR, dM, 120)
    Return DllCall("ChangeDisplaySettingsA", "Ptr", dM, "UInt", 0)
}

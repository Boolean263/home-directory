; Change screen resolution with a hotkey.
; From https://www.tcg.com/blog/quickly-change-windows-10-resolution-with-autohotkey/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#PgUp::
    ChangeResolution(32,3440,1440,60)
    return

#PgDn::
    ChangeResolution(32,1920,1080,60)
    return

; Colour depth, width, height, refresh rate
ChangeResolution( cD, sW, sH, rR ) {
    VarSetCapacity(dM,156,0)
    NumPut(156,2,&dM,36)
    DllCall( "EnumDisplaySettingsA", UInt,0, UInt,-1, UInt, &dM)
    NumPut(0x5c0000,dM,40)
    NumPut(cD,dM,104)
    NumPut(sW,dM,108)
    NumPut(sH,dM,112)
    NumPut(rR,dM,120)
    Return DllCall( "ChangeDisplaySettingsA", UInt,&dM, UInt,0 )
}

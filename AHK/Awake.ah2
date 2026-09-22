#Requires AutoHotkey v2

; https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-setthreadexecutionstate
class Awake {
    static On(*) {
        DllCall("SetThreadExecutionState", "UInt", 0x80000002)
    }
    static Off(*) {
        DllCall("SetThreadExecutionState", "UInt", 0x80000000)
    }
}

; Ensure any script which uses this library turns off Awake mode when it exits
OnExit(Awake.Off)

; If I'm running this file directly, stay awake while the MsgBox is open
if (!A_IsCompiled && A_LineFile == A_ScriptFullPath) {
    Awake.On()
    MsgBox("Keeping screen awake")
}

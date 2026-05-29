#Requires AutoHotkey v2

; Functions for managing calls to SystemParametersInfo as per
; https://learn.microsoft.com/en-ca/windows/win32/api/winuser/nf-winuser-systemparametersinfoa
;
; Although the documentation says the function signature is:
;    BOOL SystemParametersInfoA(
;      [in]      UINT  uiAction,
;      [in]      UINT  uiParam,
;      [in, out] PVOID pvParam,
;      [in]      UINT  fWinIni
;    );
;
; experiemntation shows that when I use it for SETTING a parameter, the pvParam
; needs to hold the actual value being set, not a pointer to it.
; Thus I have separate functions to handle these use cases.

ParamGet(uiAction, uiParam := 0, pvParam := 0) {
    fWinIni := 0
    DllCall("SystemParametersInfo", "UInt", uiAction, "UInt", uiParam, "UIntP", &retval := pvParam, "UInt", fWinIni)
    return retval
}

ParamSet(uiAction, uiParam := 0, pvParam := 0, fWinIni := 2) {
    ; the value of SPIF_SENDCHANGE (2) for fWinIni updates the user profile
    ; and sends a WM_SETTINGCHANGE message.
    DllCall("SystemParametersInfo", "UInt", uiAction, "UInt", uiParam, "UInt", pvParam, "UInt", fWinIni)
}

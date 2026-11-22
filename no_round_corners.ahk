#Requires AutoHotkey v2.0

DllCall("RegisterShellHookWindow", "Ptr", A_ScriptHwnd)
OnMessage(DllCall("RegisterWindowMessage", "Str", "SHELLHOOK"), OnShellMessage)

OnShellMessage(wParam, lParam, msg, hwnd) {
    ; HSHELL_WINDOWCREATED := 1
    if (wParam = 1) {
        SetSquareCorners(lParam)
    }
}

SetSquareCorners(hwnd) {
    try {
        ; DWMWA_WINDOW_CORNER_PREFERENCE = 33
        ; DWMWCP_DONOTROUND = 1 (Square corners)
        pref := 1
        DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", hwnd, "UInt", 33, "Int*", &pref, "UInt", 4)
    }
}

#Requires AutoHotkey v2.0

; fix DPI scaling issues (mouse/window pos/size)
DllCall("SetThreadDpiAwarenessContext", "ptr", -4, "ptr")

; deps
#Include "lib/Acc.ahk"
#Include "lib/groups.ahk"
#Include "lib/with.ahk"
#Include "lib/win.ahk"

; hotkeys
#Include "caps_lock.ahk"
#Include "copilot_key.ahk"
#Include "chrome_alt_n_tabs.ahk"
#Include "shortcuts.ahk"
#Include "mouse_drag.ahk"
#Include "no_round_corners.ahk"
#Include "ctrl_w.ahk"

; Win+Q - reload
#q:: {
	Reload

	; trigger tacky-borders reload as it keeps losing borders on some windows
	Run EnvGet("USERPROFILE") "\bin\tacky-borders.exe.lnk reload"
}

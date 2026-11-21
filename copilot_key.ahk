#Requires AutoHotkey v2.0

; Copilot key
LWinFirstDown := 0
LShiftFirstDown := 0
~*LWin:: {
	global LWinFirstDown
	if LWinFirstDown = 0 {
		LWinFirstDown := A_TickCount
	}

	; Win press/release - don't open Start Menu
	; FIXME: doesn't work well
	SetTimer () => Send("{Blind}{vkE8}"), -1
}
~*LShift:: {
	global LShiftFirstDown
	if LShiftFirstDown = 0
		LShiftFirstDown := A_TickCount
}
~*LWin Up:: {
	global LWinFirstDown := 0
}
~*LShift Up:: {
	global LShiftFirstDown := 0
}
<+<#F23:: {
	global LWinFirstDown
	global LShiftFirstDown
	tick := A_TickCount

	; Delay longer than "thr" between LWin/LShift and F23 is considered as separate keys.
	; Copilot key sends all 3 keys at once, so it's usually either 0 or 16
	thr := 30

	;MsgBox "Copilot: " . (tick - LWinFirstDown) . " " . (tick - LShiftFirstDown)
	if LWinFirstDown = 0 || LShiftFirstDown = 0
		throw Error("LWinFirstDown = 0 || LShiftFirstDown = 0")

	if (tick - LWinFirstDown <= thr && tick - LShiftFirstDown <= thr) ; Copilot only
		Send "#!{Space}" ; PowerToys Command Palette (default key shortcut)
	else if (tick - LWinFirstDown > thr && tick - LShiftFirstDown <= thr) ; Win+Copilot
		Run "wt.exe --profile Debian" ; Terminal - WSL
	else if (tick - LWinFirstDown <= thr && tick - LShiftFirstDown > thr) ; Shift+Copilot
		Send "{PrintScreen}" ; TODO: flameshot instead
	else if (tick - LWinFirstDown > thr && tick - LShiftFirstDown > thr) ; Win+Shift+Copilot
		Run "wt.exe --profile Debian" ; TODO: untiled window

	KeyWait "F23"
}

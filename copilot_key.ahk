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
	SetTimer () => WithoutKeyDelay(SendEvent, "{Blind}{vkE8}"), -10
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
LastCopilot := ""
<+<#F23:: {
	; Delay longer than "thr" between LWin/LShift and F23 is considered as separate keys.
	; Copilot key sends all 3 keys at once, so it's usually either 0 or 16
	thr := 30

	; Save the elapsed time between the first LWin/LShift key press and the whole combo.
	global LWinFirstDown
	global LShiftFirstDown
	if LWinFirstDown = 0 || LShiftFirstDown = 0
		throw Error("LWinFirstDown = 0 || LShiftFirstDown = 0")
	tick := A_TickCount
	lWin := (tick - LWinFirstDown) > thr
	lShift := (tick - LShiftFirstDown) > thr

	; Wait for all three keys to be released and their release to be processed.
	KeyWait "F23", "L"
	KeyWait "LShift", "L"
	KeyWait "LWin", "L"
	Sleep(0)

	; The global vars are 0 now.
	if LWinFirstDown != 0 || LShiftFirstDown != 0
		throw Error("LWinFirstDown != 0 || LShiftFirstDown != 0")

	if !lWin && !lShift
		Send "#!{Space}" ; PowerToys Command Palette (default key shortcut)
	else if lWin && !lShift
		Run "wt.exe --profile Debian" ; Terminal - WSL
	else if !lWin && lShift
		Send "{PrintScreen}" ; TODO: flameshot instead
	else if lWin && lShift
		Run "wt.exe --profile Debian" ; TODO: untiled window
}

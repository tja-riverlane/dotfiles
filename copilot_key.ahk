#Requires AutoHotkey v2.0

; Copilot key
LWinCountDown := 0
LShiftCountDown := 0
~*LWin Up:: global LWinCountDown := 0
~*LWin:: {
	global LWinCountDown += 1

	; Win press/release - don't open Start Menu
	SetTimer () => WithoutKeyDelay(SendEvent, "{Blind}{vkE8}"), -10
}
~*LShift Up:: global LShiftCountDown := 0
~*LShift:: global LShiftCountDown += 1
<+<#F23:: {
	; Copilot key sends all 3 keys at once, so if they've been pressed before, it's a combo.
	lWin := LWinCountDown > 1
	lShift := LShiftCountDown > 1

	; Wait for all three keys to be released and their release to be processed.
	KeyWait "F23", "L"
	KeyWait "LShift", "L"
	KeyWait "LWin", "L"
	Sleep(0)

	; The global vars are 0 now.
	if LWinCountDown != 0 || LShiftCountDown != 0
		throw Error("LWinCountDown != 0 || LShiftCountDown != 0")

	if !lWin && !lShift
		Send "#!{Space}" ; PowerToys Command Palette (default key shortcut)
	else if lWin && !lShift
		Run "wt.exe --profile Debian" ; Terminal - WSL
	else if !lWin && lShift
		Send "{PrintScreen}" ; TODO: flameshot instead
	else if lWin && lShift
		Run "wt.exe --profile Debian" ; TODO: untiled window
}

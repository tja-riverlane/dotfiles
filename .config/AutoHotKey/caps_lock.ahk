#Requires AutoHotkey v2.0

*CapsLock:: {
	; Record the exact millisecond Caps Lock was pressed
	startTime := A_TickCount

	; Immediately hold down Left Ctrl so key combinations (like Ctrl+C) work instantly
	Send "{Blind}{LCtrl down}"

	; Wait until Caps Lock is physically released
	KeyWait "CapsLock"

	; Release Left Ctrl
	Send "{Blind}{LCtrl up}"

	; If Caps Lock was held for less than 300ms, send Escape
	; A_PriorKey ensures Escape doesn't fire if you quickly pressed Ctrl+C within 300ms
	if (A_TickCount - startTime < 300 && A_PriorKey = "CapsLock") {
		Send "{Escape}"
	}
}

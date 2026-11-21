#Requires AutoHotkey v2.0

IsNormalWindow(WinTitle?) {
	winClass := WinGetClass(WinTitle?)

	; Exclude common system and desktop classes
	switch winClass {
		case "Progman", "WorkerW", "Shell_TrayWnd", "Shell_SecondaryTrayWnd":
			return false
		default:
			return true
	}
}

WithWinDelay(D, F, Args*) {
	saved := A_WinDelay, A_WinDelay := D
	ret := F(Args*)
	A_WinDelay := saved
	return ret
}

WithCoordMode(TargetType, RelativeTo, F, Args*) {
	saved := CoordMode(TargetType, RelativeTo?)
	ret := F(Args*)
	CoordMode(TargetType, saved)
	return ret
}

DragMoveResize(Button, Resize) {
	WithWinDelay(20, () => WithCoordMode("Mouse", "Screen", _DragMoveResize, Button, Resize))
}

_DragMoveResize(Button, Resize) {
	MouseGetPos(, , &win_id)
	if !WinExist("ahk_id " win_id)
		return

	if !IsNormalWindow()
		return

	; If the window is maximized, restore the initial position
	; and size of the window and center the mouse.
	If WinGetMinMax() {
		WinRestore()
		WinGetPos(&winX1, &winY1, &winW, &winH)
		MouseMove((winX1 + (winW / 2)), (winY1 + (winH / 2)), 0)
	}

	; Bring to the front.
	WinSetAlwaysOnTop(1)
	WinSetAlwaysOnTop(0)

	; Move/Resize the window.
	MouseGetPos(&mouseX1, &mouseY1)
	WinGetPos(&winX1, &winY1, &winW, &winH)
	Loop {
		if !GetKeyState(Button, "P") ; Break if button has been released.
			break

		MouseGetPos(&mouseX2, &mouseY2)
		if !Resize
			WinMove(winX1 + mouseX2 - mouseX1, winY1 + mouseY2 - mouseY1)
		else
			WinMove(, , winW + mouseX2 - mouseX1, winH + mouseY2 - mouseY1)
	}
}

LWin & LButton::DragMoveResize("LButton", false)
LWin & RButton::DragMoveResize("RButton", true)

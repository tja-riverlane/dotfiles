#Requires AutoHotkey v2.0

DragMoveResize(Button, Resize) {
	WithWinDelay(20, WithCoordMode, "Mouse", "Screen", _DragMoveResize, Button, Resize)
}

_DragMoveResize(Button, Resize) {
	MouseGetPos(, , &w)
	if !w
		return

	if !IsNormalWindow(w)
		return

	; If the window is maximized, restore the initial position
	; and size of the window and center the mouse.
	if WinGetMinMax() {
		WinRestore()
		WinGetPos(&winX1, &winY1, &winW, &winH)
		MouseMove((winX1 + (winW / 2)), (winY1 + (winH / 2)), 0)
	}

	; Bring to the front.
	WinRaise()

	; Move/Resize the window.
	MouseGetPos(&mouseX1, &mouseY1)
	WinGetPos(&winX1, &winY1, &winW, &winH)
	if Resize
		MouseMove(winX1 + winW, winY1 + winH)
	Loop {
		if !GetKeyState(Button, "P") ; Break if button has been released.
			break

		MouseGetPos(&mouseX2, &mouseY2)
		if !Resize
			WinMove(winX1 + mouseX2 - mouseX1, winY1 + mouseY2 - mouseY1)
		else
			WinMove(, , mouseX2 - winX1, mouseY2 - winY1)
	}
	if Resize
		MouseMove(mouseX1, mouseY1)
}

LWin & LButton::DragMoveResize("LButton", false)
LWin & RButton::DragMoveResize("RButton", true)

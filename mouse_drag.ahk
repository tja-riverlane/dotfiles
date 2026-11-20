#Requires AutoHotkey v2.0

IsNormalWindow(WinTitle := unset) {
	winClass := WinGetClass(WinTitle?)

	; Exclude common system and desktop classes
	switch winClass {
		case "Progman", "WorkerW", "Shell_TrayWnd", "Shell_SecondaryTrayWnd":
			return false
		default:
			return true
	}
}

LWin & LButton:: {
	SetWinDelay 20
	CoordMode "Mouse"

	; Get the window id
	MouseGetPos(, , &KDE_id)
	if !WinExist("ahk_id " KDE_id)
		return

	if !IsNormalWindow()
		return

	; If the window is maximized, restore the initial position
	; and size of the window and center the mouse.
	KDE_Win := WinGetMinMax()
	If KDE_Win {
		WinRestore()
		WinGetPos(&KDE_WinX1, &KDE_WinY1, &KDE_WinW, &KDE_WinH)
		MouseMove((KDE_WinX1 + (KDE_WinW / 2)), (KDE_WinY1 + (KDE_WinH / 2)), 0)
	}

	; Bring to the front.
	WinSetAlwaysOnTop(1)
	WinSetAlwaysOnTop(0)

	; Move the window.
	MouseGetPos(&KDE_X1, &KDE_Y1)
	WinGetPos(&KDE_WinX1, &KDE_WinY1)
	Loop {
		KDE_Button := GetKeyState("LButton", "P") ? "D" : "U" ; Break if button has been released.
		if (KDE_Button = "U")
			break
		MouseGetPos(&KDE_X2, &KDE_Y2)
		WinMove(KDE_WinX1 + KDE_X2 - KDE_X1, KDE_WinY1 + KDE_Y2 - KDE_Y1)
	}
}

LWin & RButton:: {
	SetWinDelay 20
	CoordMode "Mouse"

	; Get the window id
	MouseGetPos(, , &KDE_id)
	if !WinExist("ahk_id " KDE_id)
		return

	if !IsNormalWindow()
		return

	;; Abort if the window is maximized. (FIXME)
	;KDE_Win := WinGetMinMax("ahk_id " KDE_id)
	;If KDE_Win
	;	return

	; If the window is maximized, restore the initial position
	; and size of the window and center the mouse.
	KDE_Win := WinGetMinMax()
	If KDE_Win {
		WinRestore()
		WinGetPos(&KDE_WinX1, &KDE_WinY1, &KDE_WinW, &KDE_WinH)
		MouseMove((KDE_WinX1 + (KDE_WinW / 2)), (KDE_WinY1 + (KDE_WinH / 2)), 0)
	}

	; Get the initial window position and size.
	MouseGetPos(&KDE_X1, &KDE_Y1)
	WinGetPos(&KDE_WinX1, &KDE_WinY1, &KDE_WinW, &KDE_WinH)
	Loop {
		KDE_Button := GetKeyState("RButton", "P") ? "D" : "U" ; Break if button has been released.
		if (KDE_Button = "U")
			break

		MouseGetPos(&KDE_X2, &KDE_Y2)
		WinMove(, , KDE_WinW + KDE_X2 - KDE_X1, KDE_WinH + KDE_Y2 - KDE_Y1)
	}
}

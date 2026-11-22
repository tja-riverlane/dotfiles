#Requires AutoHotkey v2.0

IsNormalWindow(WinTitle?) {
	w := WinExist(WinTitle?)
	if !w
		return false

	; Skip windows with no title.
	if !WinGetTitle()
		return false

	; Exclude common system and desktop classes.
	switch WinGetClass() {
		case "Progman", "WorkerW", "Shell_TrayWnd", "Shell_SecondaryTrayWnd":
			return false
	}

	; Skip minimised windows.
	if WinGetMinMax() = -1
		return false

	; Skip ToolWindows unless they have an AppWindow style.
	exStyle := WinGetExStyle(w)
	if (exStyle & 0x80 && !(exStyle & 0x40000))
		return false

	; Skip any window that is owned by another (filters out context menus, dropdowns, tooltips, and dialogs).
	if (DllCall("GetWindow", "Ptr", w, "UInt", 4, "Ptr")) ; GW_OWNER = 4
		return false

	; Unnecessary as long as DetectHiddenWindows is off.
	;; Skip invisible windows.
	;if (!DllCall("IsWindowVisible", "Ptr", w))
	;	return false

	return true
}

WinGetListNormal(Monitor?) {
	if IsSet(Monitor)
		MonitorGetWorkArea(Monitor, &L, &T, &R, &B)

	res := []
	for w in WinGetList() {
		if !IsNormalWindow(w)
			continue

		if IsSet(Monitor) {
			WinGetPos(&wX, &wY, &wW, &wH, w)
			winCenterX := wX + (wW / 2)
			winCenterY := wY + (wH / 2)
			if !(winCenterX >= L && winCenterX < R && winCenterY >= T && winCenterY < B)
				continue
		}

		res.Push(w)
	}
	return res
}

;DbgWinGetListNormal() {
;	s := ""
;	for w in WinGetListNormal() {
;		t := WinGetTitle(w)
;		s .= w " (" t ")`n"
;	}
;
;	MsgBox "Windows:`n" s
;}

WinActivateMouse(WinTitle?) {
	if !WinExist(WinTitle?)
		return

	WithWinDelay(-1, WinActivate)

	WinGetPos(&X, &Y, &W, &H)
	WithCoordMode("Mouse", "Screen", MouseGetPos, &mX, &mY)
	if !(mX >= X && mX < (X + W) && mY >= Y && mY < (Y + H))
		WithCoordMode("Mouse", "Screen", MouseMove, X + W / 2, Y + H / 2)
}

GetMonitorByPos(X, Y, WorkArea?) {
	loop {
		try {
			if WorkArea ?? false
				MonitorGetWorkArea(A_Index, &L, &T, &R, &B)
			else
				MonitorGet(A_Index, &L, &T, &R, &B)
			if X >= L && X < R && Y >= T && Y < B
				return A_Index
		} catch {
			return
		}
	}
}

GetMonitorByMouse(WorkArea?) {
	WithCoordMode("Mouse", "Screen", MouseGetPos, &mouseX, &mouseY)
	return GetMonitorByPos(mouseX, mouseY, WorkArea?)
}

GetMonitorByActive(WorkArea?) {
	if !WinExist("A")
		return

	WinGetPos(&wX, &wY, &wW, &wH)
	winCenterX := wX + (wW / 2)
	winCenterY := wY + (wH / 2)

	return GetMonitorByPos(winCenterX, winCenterY, WorkArea?)
}

; Cycle focus to the next monitor.
; TODO: direction
CycleMonitors() {
	monitor := GetMonitorByActive(true)
	if !monitor
		return

	; Determine the next monitor.
	monitor += 1
	try {
		MonitorGet(monitor)
	} catch {
		monitor := 1
	}

	; Bring the current window to the front.
	; (Otherwise we wouldn't return back to it.)
	WinMoveTop("A")

	; Activate first window on the target monitor.
	for w in WinGetListNormal(monitor) {
		return WinActivateMouse(w)
	}

	; Fallback: center mouse on the target monitor.
	MonitorGetWorkArea(monitor, &L, &T, &R, &B)
	WithCoordMode("Mouse", "Screen", MouseMove, L + (R - L) / 2, T + (B - T) /2)
}

; Cycle focus to the next window
CycleWindows(Direction := 1) {
	_SwitchWindow(Direction)
}

FocusWindow(Index) {
	_SwitchWindow(, Index)
}

_SwitchWindow(Direction?, Index?) {
	monitor := GetMonitorByActive(true)
	if !monitor
		return

	wins := FilterOutObscuredWins(SortWinsColumnMajor(WinGetListNormal(monitor)))

	if IsSet(Direction) {
		; Find current window index.
		curW := WinExist("A")
		for i, w in wins {
			if w = curW {
				index := Mod(wins.Length + i - 1 + Direction, wins.Length) + 1
				break
			}
		}
	}

	if IsSet(Index) && Index > 0 && Index <= wins.Length
		WinActivateMouse(wins[Index])
}

SortWinsColumnMajor(wins, Pos?) {
	if !IsSet(Pos)
		Pos := GetPosMap(wins)

	; TODO: tolerance?
	InsertionSort(wins, (a, b) => Pos[a].x = Pos[b].x ? Pos[a].y < Pos[b].y : Pos[a].x < Pos[b].x)
	return wins
}

FilterOutObscuredWins(wins, Pos?) {
	if !IsSet(Pos)
		Pos := GetPosMap(wins)

	visible := []
	for win in wins {
		winRect := Pos[win]

		obscured := false
		for v in visible {
			vRect := Pos[v]
			if (vRect.x <= winRect.x && vRect.y <= winRect.y
			&& (vRect.x + vRect.w) >= (winRect.x + winRect.w)
			&& (vRect.y + vRect.h) >= (winRect.y + winRect.h)) {
				obscured := true
				break
			}
		}
		if !obscured
			visible.Push(win)
	}
	return visible
}

GetPosMap(wins) {
	pos := Map()
	for win in wins {
		WinGetPos(&X, &Y, &W, &H, win)
		pos[win] := {x: X, y: Y, w: W, h: H}
	}
	return pos
}

; TODO: move elsewhere
InsertionSort(A, LessThan := (a,b) => a < b) {
	i := 1
	while (i < A.Length) {
		x := A[i + 1]
		j := i
		while (j > 0 && LessThan(x, A[j])) {
			A[j + 1] := A[j]
			j -= 1
		}
		A[j + 1] := x
		i += 1
	}
	return A
}

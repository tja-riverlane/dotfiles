#Requires AutoHotkey v2.0

; Win+Space - PowerToys FancyZones editor (layout switcher)
#Space::Send "+#``"
; #Space::return ; disable keyboard layout switching

; Win+M - minimise active
; Shift+Win+M - minimise all
#m::WinMinimize "A"
+#m::#m
; TODO: bind minimise to something else - Win+M in xmonad is mirror layout

; Win+W - maximise toggle
#w:: {
	if WinExist("A") {
		if WinGetMinMax() = 1
			WithWinDelay(-1, WinRestore)
		else
			WithWinDelay(-1, WinMaximize)
		WinActivateMouse
	}
}
; TODO: Win+Shift+W - maximise; Win+W - toggle full layout in FancyZones?

; Win+Esc - close window
#Esc::WinClose "A"

; Win+Tab - cycle focus to next monitor
#Tab::CycleMonitors()
; TODO: Shift+Win+Tab - swap monitors (send shortcut to FancyZones? it's super slow though)

; Win+a/s/d - focus specific monitor
#a::FocusMonitor(1)
#s::FocusMonitor(2)
#d::FocusMonitor(3)

; Shift+Win+a/s/d - alternative shortcut for the original Windows shortcuts
+#a::Send "#a"
+#s::Send "#s"
+#d::Send "#d"

; Win+J/K - next/prev window on current screen
#j::CycleWindows(1)
#k::CycleWindows(-1)

; Shift+Win+J/K - swap with next/prev window on current screen (keep focus - move current)
+#j::SwapWindowUpDown(1)
+#k::SwapWindowUpDown(-1)

; Win+1/2/3/... - focus window on current screen
#1::FocusWindow(1)
#2::FocusWindow(2)
#3::FocusWindow(3)
#4::FocusWindow(4)
#5::FocusWindow(5)
#6::FocusWindow(6)
#7::FocusWindow(7)
#8::FocusWindow(8)
#9::FocusWindow(9)
#0::FocusWindow(10)

; Shift+Win+1/2/3/... - swap window with another on current screen (focus new - switch to target)
+#1::SwapWindowWith(1)
+#2::SwapWindowWith(2)
+#3::SwapWindowWith(3)
+#4::SwapWindowWith(4)
+#5::SwapWindowWith(5)
+#6::SwapWindowWith(6)
+#7::SwapWindowWith(7)
+#8::SwapWindowWith(8)
+#9::SwapWindowWith(9)
+#0::SwapWindowWith(10)

; TODO: Alt-F1 - workspace 1, ...

; Win+L - can't remap? :-(
; Win+; - lock screen
#;::DllCall("LockWorkStation")

; Shift+Win+Arrows - FancyZones moves
+#Left:: {
	if WinExist("A") {
		Send "#{Left}"
		WinActivateMouse
	}
}
+#Right:: {
	if WinExist("A") {
		Send "#{Right}"
		WinActivateMouse
	}
}
+#Up:: {
	if WinExist("A") {
		Send "#{Up}"
		WinActivateMouse
	}
}
+#Down:: {
	if WinExist("A") {
		Send "#{Down}"
		WinActivateMouse
	}
}

; Win+Arrows - media keys
#Left::Send "{Media_Prev}"
#Right::Send "{Media_Next}"
#Up::Send "{Media_Stop}"
#Down::Send "{Media_Play_Pause}"

; Shift+End - Shift-Insert to compensate for X13's reduced keyboard
#HotIf WinActive("ahk_group Terminals")
+End::Send "+{Insert}"
#HotIf

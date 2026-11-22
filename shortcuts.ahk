#Requires AutoHotkey v2.0

; Win+Space - PowerToys FancyZones editor (layout switcher)
#Space::+#`
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

; Win+J/K - next/prev window on current screen
#j::CycleWindows(1)
#k::CycleWindows(-1)

; Win+1/2/3/4/5/6/7/8/9/0 - focus window on current screen
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

; TODO: Alt-F1 - workspace 1, ...

; Win+L - can't remap? :-(
; Win+; - lock screen
#;::#l

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
#Left::Media_Prev
#Right::Media_Next
#Up::Media_Stop
#Down::Media_Play_Pause

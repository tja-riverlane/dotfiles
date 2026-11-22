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
			WinRestore
		else
			WinMaximize
		WinActivateMouse
	}
}
; TODO: Win+Shift+W - maximise; Win+W - toggle full layout in FancyZones?

; Win+Esc - close window
#Esc::WinClose "A"

; Win+Tab - cycle focus to next monitor
#Tab::CycleMonitors()
; TODO: Shift+Win+Tab - swap monitors (send shortcut to FancyZones? it's super slow though)

; TODO: Win+J - next window on current screen
; TODO: Win+K - prev window on current screen

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

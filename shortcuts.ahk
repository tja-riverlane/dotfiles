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

; Win+L - can't remap? :-(
; Win+; - lock screen
#;::#l

; Ctrl+W - erase word (or close tab if not typing)
GroupAdd "Terminals", "ahk_exe WindowsTerminal.exe"
GroupAdd "Browsers", "ahk_exe chrome.exe"
#HotIf !WinActive("ahk_group Terminals")
^w:: {
	caretExists := true
	if WinActive("ahk_group Browsers")
		try caretExists := Acc.ElementFromHandle("A", Acc.ObjId.Caret).Exists

	if caretExists
		Send "^{Backspace}"
	else
		Send "^w"
}
#HotIf

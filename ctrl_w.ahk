#Requires AutoHotkey v2.0

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

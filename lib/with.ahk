#Requires AutoHotkey v2.0

WithoutKeyDelay(F, Args*) {
	savedDelay := A_KeyDelay, A_KeyDelay := -1
	savedDuration := A_KeyDuration, A_KeyDuration := -1
	ret := F(Args*)
	A_KeyDelay := savedDelay
	A_KeyDuration := savedDuration
	return ret
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


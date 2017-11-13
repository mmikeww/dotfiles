; https://autohotkey.com/board/topic/91381-sticky-keys-just-for-shift-and-alphabetic-characters/
;----------------
; Shift-alpha sticky keys
shiftablekeys = abcdefghijklmnopqrstuvwxyz1234567890.,'/ ; keys that respond to sticky shift
modifierkeys  = {LControl}{RControl}{LAlt}{RAlt}{LWin}{RWin}
Shift::
if AlreadyShifting { ; for two-shift cancellation
	AlreadyShifting = 0
	return
}
; Change or remove 'T2' to affect timeout of the sticky shift
Input, key, B M L1 T2, {LControl}{RControl}{LAlt}{LShift}{RShift}{RAlt}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}{Tab}{Space}
myerror := ErrorLevel
if InStr(myerror, "Shift") { ; if a second shift is received, cancel the existing one
	AlreadyShifting = 1
	SendPlay {Shift}
}
If InStr(myerror, "EndKey") { ; a non-printing end key
	StringReplace, key, myerror, EndKey:
}
if (myerror = "Timeout") {
	; Timeout, not sending anything
} else if (myerror = "Max") && StrLen(key) == 1 && InStr(shiftablekeys, key) {
	; Shifting
	SendPlay {Shift Down}{%key%}{Shift Up}
} else if InStr(modifierkeys, key) {
	; Modifier key detected; sending on so it still works as expected
	SendPlay {%key% Down}
} else {
	; Non-shiftable key: sending unmodified
	SendPlay {%key%}
}
Return

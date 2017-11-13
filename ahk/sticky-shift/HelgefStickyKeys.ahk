; https://autohotkey.com/boards/viewtopic.php?p=135684#p135684
;
; Example usage:
stickyShift:= new StickyKey("LShift")
stickyShiftR:= new StickyKey("RShift")
;stickyCtrl:= new StickyKey("LControl")	; Needs to be LControl because A_PriorKey takes that name, so no LCtrl here. (Look in the keylist to find the correct keynames. set: static keyList:=StickyKey.makeKeyList(1) below)
;stickyAlt:= new StickyKey("LAlt")
;stickyWin:= new StickyKey("LWin")
;stickyNumpad:= new StickyKey("NumpadDiv")

; Note, StickyKey("Shift") doesn't work, instead do StickyKey("LShift") and StickyKey("RShift")
; For now, call regKeys() manually, after all sticky keys has been registred, this will be automatically done.
StickyKey.regKeys()

; Some test hotkeys
; ^!#+t::MsgBox, Test 1 ; Awkward combo for testing.
; Testing NumPadDiv as sticky key and how it behaves when not acting as modifier.
; ~NumpadDiv & 1::MsgBox, Test 2, Sticky NumPadDiv, A_ThisHotkey = %A_ThisHotkey% ; Sticky numpaddiv, this needs SendLevel, 1 in sendModified() for triggering. Should be optional.
; +NumpadDiv::MsgBox,Test 3 ; Strike: this is a bug. Seems to be fixed in regKeys(). Need to think about it.
; ^!NumpadDiv::MsgBox, Test 4


;StickyKey.regKeys("Off") ; turns off all keys.

class StickyKey {
	; To do (maybe),
	;		Handle deleteing of sticky keys. Need to clear self references and remove from static array. Turn off hotkeys.
	;		Methods for user defined lists and possibly exception list.
	;		Optional SendLevel for sendModified().
	;		Optional press duration, sendModified().
	;		Optional hotkey for "un-stick" all keys. (toggle off all)
	;		Optional context sensitive. (Eg, IfWinActive...)
	;		Method for enable/disable combine option. See "general settings" below.
	;		Evaluate the need/effect of this.isSending
	;		Evaluate the active stickies count and array.
	; Class variables
	static modifiers:=[]						; Holds references to all StickyKeys.
	static keyList:=StickyKey.makeKeyList(0)	; List of keys subject to being modified by sticky keys. Call this function with 1: show list of keys, for debug, or 0: no debug message.
	static nActive:=0							; Holds the number currently stuck stickies, if 0, hook() doesn't get called.
	static activated:=[]						; Holds the currently stuck stickies.
	; General settings
	static combine:=1							; Set to zero to avoid stacking sticky keys, i.e, set to zero to only modify by last toggled on sticky key.

	__new(modifier){
		this.toggle:=0										; Initially, the sticky keys is toggled off
		this.keyName:=modifier								; Store the key name
		toggleFn:=ObjBindMethod(this,"toggleSticky")		; The sticky key's up event is bound to toggleSticky(), see comments there.
		this.toggleFn:=toggleFn								; Store the func object for future turning off.
		Hotkey, % "~" this.keyName " up", % toggleFn
		this.prefix:="{" . this.keyName . " down}"			; Do this once, to avoid doing this every time sticky key is used. (It is for the modifiedSend())
		this.suffix:="{" . this.keyName . " up}"
		StickyKey.modifiers.Push(this)						; Store a reference to this sticky key in the class' list of instances. See comments at array declaration, at the top.
	}
	toggleSticky(){
		; Sticky keys up event are bound to this method.
		; If the previous key pressed was the sticky key's down event, it is toggled.
		this.toggle:= (A_PriorKey=this.keyName ? !this.toggle : 0)
		if (this.toggle && !StickyKey.combine)						; This handles turning off stacking modifiers, i.e., only modify by last toggled on sticky key.
			for k, modifier in StickyKey.modifiers
				modifier!=this ? (modifier.toggle:=0,modifier.n?(StickyKey.activated.Delete(modifier.n),modifier.n:="",--StickyKey.nActive):"") : ""			; Turn off all sticky key's except "this"
		; Update counter.
		this.toggle ? (this.n:=StickyKey.activated.Push(this),++StickyKey.nActive) : (this.n?(StickyKey.activated.Delete(this.n),this.n:="",--StickyKey.nActive):"")	
		StickyKey.nActive<0?StickyKey.nActive:=0:"" ; Ensure non-negative count. It happens if eg, shift is activated, and user presses shift+a -> A 
		return 
	}
	modifiedSend(){
		; A key (eg, a) has been suppressed due to at least one sticky key (eg, LShift) is toggled on.
		; The key (a) will be sent with all toggled on modifiers.
		for k, modifier in StickyKey.activated												; Loop all activated modifiers
			prefix.=modifier.prefix, suffix.=modifier.suffix, modifier.toggle:=0			; Set up send string and reset toggle.
		StickyKey.activated:=[], StickyKey.nActive:=0										; Reset activated array and counter
		SendLevel,1 ; this should be optional, Needs to be >0 to trigger ahk hook hotkeys (and hotstrings)
		SendInput, % prefix . "{" . A_ThisHotkey . " down}{" . A_ThisHotkey . " up}" . suffix
		return StickyKey.isSending:=0	; 
	}
	hook(){ 
		; Keys (eg, a) subject to being modified by a sticky key is bound to this context. (#if hook()).
		; If a sticky key (eg, LShift) is toggled on, the key (a) is in context, and its native function is suppressed,
		; it is passed to modifiedSend (eg, Send,{Lshift down}{a down}{a up}{Lshift up}.
		if StickyKey.isSending	; If InputLevel,1 in modifiedSend(), keys sent will call this function, return immediately.
			return 0
		ret:=0,allowBlock:=1
		for k, modifier in StickyKey.modifiers
			ret+=(A_PriorKey=modifier.keyName && modifier.toggle ? (modifier.keyName=A_ThisHotkey?allowBlock:=0:1) : modifier.toggle) 	; Need to have ( 1 : modifier.toggle)  instead of (1:0) in case a sticky is on but the prior key turned off another one.
		return StickyKey.isSending:=ret*allowBlock	; If true, modifiedSend() is called.
	}
	; Makes key list and registers hotkeys to context #if hook().
	; By default, "all" keys are bound.
	; Call makeKeyList(1) to see a list of all keys for regKeys(), which registers the hotkeys.
	; Note that regKeys() filters out modifiers that are in the same "group", eg, Lshift and Rshift.
	makeKeyList(db:=0){
		; Makes a keylist, with unique entries.
		keyList:=[]
		for n, FormatStr  in {256:"VK{:02x}",512:"SC{:03x}"} {	; Goes through both VK and SC key codes.
			Loop, % n {
				key:=GetKeyName(Format(FormatStr,A_Index-1))
				if (key!="" && !keyList.HasKey(key)) {
					keyList[key]:=""
					db?str.=key "|":""
					ctr++
				}
			}
		}
		if (db) {	; For debuggin purposes, shows a list of all keys in the key list. regKeys does some filtering to this.
			Gui, Add, text,, % "Keylist:"
			Sort, str, D|
			Gui, Add, ListBox,w200 r30 ,% str
			Gui, Add, text, , % "# Keys: " ctr
			Gui, show
		}
		return keyList ; this is kept as StickyKey.keyList
	}
	regKeys(onOff:="On"){
		; Registers hotkey according to the class keylist. Some filtering.
		Hotkey, If, StickyKey.nActive && StickyKey.hook()
		fn:=ObjBindMethod(StickyKey,"modifiedSend")
		for key in StickyKey.keyList {
			for k, modifier in StickyKey.modifiers
				if (StickyKey.IsInSameModifierGroup(key,modifier.keyName))	; (modifier.keyName=key || StickyKey.IsInSameModifierGroup(key,modifier.keyName))	; Filter out sticky keys from the key list, and keys in the same group, see comments in IsInSameModifierGroup().
					continue,2												; ^ Commenting out this seems to fix the "NumPadDiv" - bug. Needs to be pondered. (Note, this is not about the continue,2 line)
			Hotkey, % key, % fn, % onOff
		}
		Hotkey, If
	}
	IsInSameModifierGroup(keyA,keyB){
		; Returns 1 if keyA and keyB are "variants" of the same modifier, eg LCtrl and Control returns 1
		static modifiers :=  [	 {LCtrl	 	: 0, RCtrl		: 0, Ctrl	: 0, LControl: 0, RControl: 0, Control: 0}
								,{LAlt	 	: 0, Ralt		: 0, Alt	: 0}
								,{LWin	 	: 0, LWin		: 0}
								,{LShift	: 0, RShift		: 0, Shift	: 0}	]
		for k, group in modifiers
			if (group.HasKey(keyA) && group.HasKey(keyB))
				return 1
		return 0
	}
	; Context for the hotkey command.
	#if StickyKey.nActive && StickyKey.hook()
	#if	
}

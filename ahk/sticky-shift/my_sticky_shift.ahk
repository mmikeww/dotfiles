
; Sticky Shift
;
; ==================================
; OPTIONS
; ==================================

timeout := 1
                                     ; How long the Shift should stay active 
                                     ; this value is in seconds. use 0.5 for half second
                                     ; if you want a capital A, then press and release Shift, then press 'a' within two seconds
                                     ; after the timeout has elapsed, the shift is no longer in effect

; ----------------------------------

show_indicator := true
                                     ; Whether or not to show a grahpic while the Shift is in progress
                                     ; this value is either 'true' or 'false' with no quotes

; ----------------------------------

double_shift_for_caps := false
                                     ; Should tapping shift twice turn on Capslock?
                                     ; this value is either 'true' or 'false' with no quotes
                                     ; default is 'false', which means a double tap of Shift will cancel the shift

; ----------------------------------

skip_spacebar := false
                                     ; Allow the sequence "Shift,Space,Key" to still shift the Key
                                     ; this value is either 'true' or 'false' with no quotes
                                     ; this means that the Spacebar will not cancel the shift
                                     ; a user wanted to press Shift+Space to be able to shift the next char after Space

; ==================================
; END OF OPTIONS
; ==================================


#NoEnv
#SingleInstance, force
#KeyHistory, 0
ListLines, Off
SetBatchLines, -1
SendMode, Input
Hotkey, LShift,    Shift_Down, on
Hotkey, RShift,    Shift_Down, on
Hotkey, LShift Up, Shift_Up  , on
Hotkey, RShift Up, Shift_Up  , on
; Hotkey, LAlt,      Shift_Down, on
; Hotkey, RAlt,      Shift_Down, on
; Hotkey, LAlt Up,   Shift_Up  , on
; Hotkey, RAlt Up,   Shift_Up  , on
; we don't want Control as end key, because we need to be able to press Shift,Ctrl+Left
; we don't want Alt as end key, because Shift+Alt+F should still open up File menu bars
; we don't want Win as end key, because it Shift+Win+D should still send Shift+D
; don't want CapsLock as end key, because Shift down, Caps down/up, Shift still down + M, should invert CapsLock
end_keys := "{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}"
          . "{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{PrintScreen}{Pause}{AppsKey}{LShift}{RShift}"
; test := 0
if (show_indicator)
{
   HBITMAP := Create_shift_key_png()
   GUIH := Bitmap_GetHeight(HBITMAP)
   GUIW := Bitmap_GetWidth(HBITMAP)
   GUIY := A_ScreenHeight-150
   Gui, -DPIScale -Caption +AlwaysOnTop +ToolWindow
   Gui, Margin, 0, 0
   Gui, Add, Text, x0 y0 w%GUIW% h%GUIH% hwndHPic1
   Bitmap_SetImage(HPic1, HBITMAP)
   Gui, Show, Hide y%GUIY%, StickyShift indicator image
}
return




;F11::ListHotkeys
;Esc::ExitApp

; KeePass auto-type feature was triggering this script, so need a quick way to turn it off
F9::
   Suspend
   if (A_IsSuspended)
      ToolTip, StickyShift is now OFF
   else
      ToolTip, StickyShift is now ON
   SetTimer, ToolTipOff, -1000
return

ToolTipOff:
   ToolTip, 
return



Shift_Down:
   ; tooltip, % "[" A_ThisHotkey "]" ++test ;"`nA_PriorKey=" A_PriorKey    ; if you hold down shift, you'll see this loops after each timeout, so Shift is a repeat key just like any letter, it keeps getting spammed
   if (caps_on)
   {
      SetCapsLockState, Off
      caps_on := false
      return
   }

   if InStr(A_ThisHotkey, "Shift")
      trigger_shift_key := A_ThisHotkey        ; needs to be set because A_ThisHotkey gets overwritten by the Up hotkey
   else
      trigger_shift_key := "LShift"
   waiting_for_input := 1

   if (show_indicator)
      Gui, Show, NA

   Send, {%trigger_shift_key% down}
   Input, key, V M L1 T%timeout%, %end_keys%
   ; inputErrorLevel := ErrorLevel

   if (ErrorLevel == "EndKey:LShift") || (ErrorLevel == "EndKey:RShift")
   {
      KeyWait, % SubStr(ErrorLevel, 8)   ; careful, keywait sets its own errorlevel from this point forward
      if (double_shift_for_caps)
      {
         ; tooltip, a second shift press occurred.`ntrigger_shift_key: %trigger_shift_key%`ninputErrorLevel: %inputErrorLevel%
         ; sleep, 1000
         SetCapsLockState, On
         caps_on := true
      }
   }

   ; allow Shift,Space,Space,Space(etc),Letter to work:
   if (skip_spacebar)
      while (key = " ")
         Input key, V M L1 T%timeout%, %end_keys%

    ; tooltip, key=[%key%]`nA_ThisHotkey=[%A_ThisHotkey%]`ntrigger_shift_key=[%trigger_shift_key%]`ninputErrorlevel=%inputErrorLevel%`nhotkeys back on

   if (show_indicator)
      Gui, Hide

   if !(GetKeyState(A_ThisHotkey))
      Send, {%trigger_shift_key% Up}

   waiting_for_input := 0          ; the order of this line could possibly matter, this seems like the best order
   Hotkey, LShift, on
   Hotkey, RShift, on
   Hotkey, LShift Up, on
   Hotkey, RShift Up, on
return



Shift_Up:
   ; tooltip, [%A_ThisHotkey%]`nshift_key=%trigger_shift_key%

   ; if we pressed and released Shift, then the down hotkey is waiting for the next char input
   ; so we want to turn off these hotkeys, so that we can detect another LShift as the Input EndKey
   if (waiting_for_input)
   {
      ; tooltip, turning off hotkeys
      Hotkey, RShift,    off
      Hotkey, RShift Up, off
      Hotkey, LShift,    off
      Hotkey, LShift Up, off
   }

   ; else, the down hotkey is no longer waiting for input.
   ; this only fires if the Up hotkey was triggered AFTER the Input was complete
   ; which means shift was held down during the Input, resulting in a normal Shift+letter simultanous chord.
   ; this is needed because without it, then shift would get 'stuck' down.
   ; test: hold down Shift, and the down hotkey above fires. while still holding shift, we press a letter.
   ; the Input cmd captures the letter and then finally its supposed to Send Shift Up
   ; but we're still physically holding down Shift, so i don't think the virtual Send Shift Up ever goes through
   ; or if it does go through, it somehow blocks our real Shift up release
   else
   {
      Send, {%A_ThisHotkey%}
   }
return







; ##################################################################################
; # This was generated by Image2Include.ahk, you must not change it! #
; #
; # https://autohotkey.com/board/topic/93292-image2include-include-images-in-your-scripts/
; #
; ##################################################################################
Create_shift_key_png(NewHandle := False) {
Static hBitmap := 0
If (NewHandle)
   hBitmap := 0
If (hBitmap)
   Return hBitmap
VarSetCapacity(B64, 8944 << !!A_IsUnicode)
B64 := "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"
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
VarSetCapacity(Dec, DecLen, 0)
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", &Dec, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
; Bitmap creation adopted from "How to convert Image data (JPEG/PNG/GIF) to hBITMAP?" by SKAN
; -> http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257
hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Dec, "UPtr", DecLen)
DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
VarSetCapacity(SI, 16, 0), NumPut(1, SI, 0, "UChar")
DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &SI, "Ptr", 0)
DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", pBitmap)
DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", pBitmap, "PtrP", hBitmap, "UInt", 0)
DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
DllCall(NumGet(NumGet(pStream + 0, 0, "UPtr") + (A_PtrSize * 2), 0, "UPtr"), "Ptr", pStream)
Return hBitmap
}
; ----------------------------------------------------------------------------------------------------------------------
; Returns the width of a bitmap.
; ----------------------------------------------------------------------------------------------------------------------
Bitmap_GetWidth(hBitmap) {
   Static Size := (4 * 5) + A_PtrSize + (A_PtrSize - 4)
   VarSetCapacity(BITMAP, Size, 0)
   DllCall("Gdi32.dll\GetObject", "Ptr", hBitmap, "Int", Size, "Ptr", &BITMAP, "Int")
   Return NumGet(BITMAP, 4, "Int")
}
; ----------------------------------------------------------------------------------------------------------------------
; Returns the height of a bitmap.
; ----------------------------------------------------------------------------------------------------------------------
Bitmap_GetHeight(hBitmap) {
   Static Size := (4 * 5) + A_PtrSize + (A_PtrSize - 4)
   VarSetCapacity(BITMAP, Size, 0)
   DllCall("Gdi32.dll\GetObject", "Ptr", hBitmap, "Int", Size, "Ptr", &BITMAP, "Int")
   Return NumGet(BITMAP, 8, "Int")
}
; ----------------------------------------------------------------------------------------------------------------------
; Associates a new bitmap with a static control.
; Parameters:     hCtrl    -  Handle to the GUI control (Pic or Text).
;                 hBitmap  -  Handle to the bitmap to associate with the GUI control.
; Return value:   Handle to the image previously associated with the GUI control, if any; otherwise, NULL.
; ----------------------------------------------------------------------------------------------------------------------
Bitmap_SetImage(hCtrl, hBitmap) {
   ; STM_SETIMAGE = 0x172, IMAGE_BITMAP = 0x00, SS_BITMAP = 0x0E
   WinSet, Style, +0x0E, ahk_id %hCtrl%
   SendMessage, 0x172, 0x00, %hBitmap%, , ahk_id %hCtrl%
   Return ErrorLevel
}


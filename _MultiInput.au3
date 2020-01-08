; #FUNCTION# ===================================================================
; Name ..........: _MultiInput
; Description ...: InputBox with multiple inputs
; AutoIt Version : V3.3.0.0
; Syntax ........: _MultiInput(ByRef $aText[, $aDefaultText=""[, $sTitle = ""[, $vInputStyle = -1[, $iInputWidth = 200[, $sButtonL = "OK"[, $sButtonR = "Cancel"[, $iReturnMode = 0[, $parent]]]]]]])
; Parameter(s): .: $aText - Array with the text for the input-controls.
					; * Text-style:
					; | **Text** = bold
					; | ""Text"" = italic
					; | __Text__ = underline
					; | --Text-- = strike
; $aDefaultText - Optional: (Default = "") : Array with the default text for the input-controls. The controls will be prefilled.
; $sTitle - Optional: (Default = "") : Window-title
; $vInputStyle - Optional: (Default = -1) : Style for the input-controls.
					; | single var for a global style, or
					; | array for different styles
; * lool at the "GUI Control Styles"
; $iInputWidth - Optional: (Default = 200) : Width of the inputs
; $sButtonL - Optional: (Default = "OK") : Text of the left button
; $sButtonR - Optional: (Default = "Cancel") : Text of the right button
; $iReturnMode - Optional: (Default = 0) :
					; | 0 Returns a single string, values seperated with the GUIDataSeparatorChar
					; | 1 Returns an array with all values
; $parent - Optional: (Default = -1) : The window handle to use as the parent for this dialog.
; Return Value ..: Success - string or array, depending on $iReturnMode
; Failure - empty string
; @ERROR - 1 if cancel is pressed
					; | 2 UBound($aT) <> UBound($aInputFormat)
					; | 3 $aText not an array
					; | 4 $aDefaultText not an array
					; | 5 UBound($aText) <> UBound($aDefaultText)
; Author(s) .....: Thorsten Willert and M3d1c5
; Date ..........: Sun Jul 08 20:24:00 CET 2012
; Version .......: 4.0
; Example .......:
;
;Global $aTexts[5] = ["**Verzeichnis**", "Benutzer", "Passwort", "", "__Information__"]
;Global $aInputSt[5] = [-1, -1, 32] ; $ES_PASSWORD = 32


; Global $sValues = _MultiInput($aTexts, "", "Test", $aInputSt)
; If Not @error Then MsgBox(0, "", $sValues)
; ==============================================================================
Func _MultiInput(ByRef $atext, $adefaulttext = "", $stitle = "", $vinputstyle = -1, $iinputwidth = 200, $sbuttonl = "OK", $sbuttonr = "Cancel", $ireturnmode = 0, $parent = -1)
	Local $oldopt = Opt('GUIOnEventMode')


	; Default parameters
	If $iinputwidth < 100 Then $iinputwidth = 100
	If $iinputwidth = Default Then $iinputwidth = 200
	If $vinputstyle = Default Then $vinputstyle = -1
	If $sbuttonl = Default Then $sbuttonl = "OK"
	If $sbuttonr = Default Then $sbuttonr = "Cancel"


	; Parameter check (arrays only)
	If Not IsArray($atext) Then
		SetError(3)
		Return ""
	EndIf
	If Not IsArray($adefaulttext) And $adefaulttext <> "" Then
		SetError(4)
		Return ""
	EndIf
	If IsArray($vinputstyle) And UBound($vinputstyle) <> UBound($atext) Then
		SetError(2)
		Return ""
	EndIf
	If IsArray($adefaulttext) And UBound($atext) <> UBound($adefaulttext) Then
		SetError(5)
		Return ""
	EndIf


	Local $is = 6 ; char width
	Local $it = UBound($atext)
	Local $input[$it], $atextstyle[$it], $atextwidth[$it]
	Local $iofs = 0, $ilen = 0
	Local $ssc = Opt("GUIDataSeparatorChar")
	Local $sret = ""
	Local $inputstyle
	If Not IsArray($vinputstyle) Then $inputstyle = $vinputstyle


	; text width and styles
	For $i = 0 To $it - 1
		$ilen = StringLen($atext[$i])
		If $ilen > $iofs Then $iofs = $ilen ; max text width
		If $iofs < 10 Then $iofs = 10
		$atextwidth[$i] = 400
		$atextstyle[$i] = 0
		Select
			; bold
			Case StringRegExp($atext[$i], '^\*\*.*?\*\*$')
				$atextwidth[$i] = 600
				$atext[$i] = StringMid($atext[$i], 3, $ilen - 4)
				; italic
			Case StringRegExp($atext[$i], '^"".*?""$')
				$atextstyle[$i] = 2
				$atext[$i] = StringMid($atext[$i], 3, $ilen - 4)
				; underline
			Case StringRegExp($atext[$i], '^__.*?__$')
				$atextstyle[$i] = 4
				$atext[$i] = StringMid($atext[$i], 3, $ilen - 4)
				; strike
			Case StringRegExp($atext[$i], '^--.*?--$')
				$atextstyle[$i] = 8
				$atext[$i] = StringMid($atext[$i], 3, $ilen - 4)
		EndSelect
	Next


	; GUI
	If $parent <> -1 Then GUISetState(@SW_DISABLE, $parent)
	Local $hwin = GUICreate($stitle, $iofs * $is + $iinputwidth + 40, $it * 25 + 55, -1, -1, -1, -1, $parent)
	For $i = 0 To $it - 1
		If IsArray($vinputstyle) Then $inputstyle = $vinputstyle[$i]
		Select
			Case $atext[$i] <> ""
				GUICtrlCreateLabel($atext[$i] & ":", 16, $i * 25 + 15, $iofs * $is)
				GUICtrlSetFont(-1, 8.5, $atextwidth[$i], $atextstyle[$i])
				$input[$i] = GUICtrlCreateInput("", $iofs * $is + 20, $i * 25 + 10, $iinputwidth, -1, $inputstyle)
				If IsArray($adefaulttext) Then
					GUICtrlSetData($input[$i], $adefaulttext[$i])
				EndIf
			Case Else
				GUICtrlCreateLabel("", 16, 1)
		EndSelect
	Next
	Local $ok = GUICtrlCreateButton($sbuttonl, 16, $i * 25 + 20, 75)
	GUICtrlSetState(-1, 512) ; $GUI_DEFBUTTON = 512
	Local $cancel = GUICtrlCreateButton($sbuttonr, $iofs * $is + $iinputwidth - 55, $i * 25 + 20, 75)
	GUISetState(@SW_SHOW)
	; /GUI


	While True
		Switch GUIGetMsg()
			Case -3, $cancel ; $GUI_EVENT_CLOSE = -3
				If $parent <> -1 Then GUISetState(@SW_ENABLE, $parent)
				GUIDelete($hwin)
				Opt('GUIOnEventMode', $oldopt)
				SetError(1)
				Return ""
			Case $ok
				For $i = 0 To $it - 2
					$sret &= GUICtrlRead($input[$i]) & $ssc
				Next
				$sret &= GUICtrlRead($input[$i])
				If $parent <> -1 Then GUISetState(@SW_ENABLE, $parent)
				GUIDelete($hwin)
				Opt('GUIOnEventMode', $oldopt)
				If $ireturnmode = 0 Then
					Return $sret
				Else
					Return StringSplit($sret, $ssc, 2)
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>_MultiInput

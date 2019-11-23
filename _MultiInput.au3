; #FUNCTION# ===================================================================
; Name ..........: _MultiInput
; Description ...: InputBox with multiple inputs
; AutoIt Version : V3.3.0.0
; Syntax ........: _MultiInput(ByRef $aText[, $sTitle = ""[, $vInputStyle = -1[, $iInputWidth = 200[, $sButtonR = "OK"[, $sButtonL = "Cancel"[, $iReturnMode = 0]]]]]])
; Parameter(s): .: $aText - Array with the text for the input-controls.
					; * Text-style:
					; | **Text** = bold
					; | ""Text"" = italic
					; | __Text__ = underline
					; | --Text-- = strike
; $sTitle - Optional: (Default = "") : Window-title
; $vInputStyle - Optional: (Default = -1) : Style for the input-controls.
					; | single var for a global style, or
					; | array for different styles
; * look at the "GUI Control Styles"
; $iInputWidth - Optional: (Default = 200) : Width of the inputs
; $sButtonR - Optional: (Default = "OK") : Text of the right button
; $sButtonL - Optional: (Default = "Cancel") : Text of the left button
; $iReturnMode - Optional: (Default = 0) :
					; | 0 Returns a single string, values seperated with the GUIDataSeparatorChar
					; | 1 Returns an array with all values
; Return Value ..: Success - string or array, depending on $iReturnMode
; Failure - empty string
; @ERROR - 1 if cancel is pressed
					; | 2 UBound($aT) <> UBound($aInputFormat)
					; | 3 $aText not an array
; Author(s) .....: Thorsten Willert
; Date ..........: Sun Nov 08 12:25:22 CET 2009
; Version .......: 3.0
; Example .......:
;
;Global $aTexts[5] = ["**Verzeichnis**", "Benutzer", "Passwort", "", "__Information__"]
;Global $aInputSt[5] = [-1, -1, 32] ; $ES_PASSWORD = 32


; Global $sValues = _MultiInput($aTexts, "Test", $aInputSt)
; If Not @error Then MsgBox(0, "", $sValues)
; ==============================================================================
Func _MultiInput(ByRef $aText, $sTitle = "", $vInputStyle = -1, $iInputWidth = 200, $sButtonR = "OK", $sButtonL = "Cancel", $iReturnMode = 0)
    Local $oldOpt = Opt('GUIOnEventMode', 0)


    ; Default parameters
    If $iInputWidth < 100 Then $iInputWidth = 100
    If $iInputWidth = Default Then $iInputWidth = 200
    If $vInputStyle = Default Then $vInputStyle = -1
    If $sButtonR = Default Then $sButtonR = "OK"
    If $sButtonL = Default Then $sButtonL = "Cancel"


    ; Parameter check (arrays only)
    If Not IsArray($aText) Then
        SetError(3)
        Return ""
    EndIf
    If IsArray($vInputStyle) And UBound($vInputStyle) <> UBound($aText) Then
        SetError(2)
        Return ""
    EndIf


    Local $iS = 6 ; char width
    Local $iT = UBound($aText)
    Local $input[$iT], $aTextStyle[$iT], $aTextWidth[$iT]
    Local $iOfs = 0, $iLen = 0
    Local $sSC = Opt("GUIDataSeparatorChar")
    Local $sRet = ""
    Local $InputStyle
    If Not IsArray($vInputStyle) Then $InputStyle = $vInputStyle


    ; text width and styles
    For $i = 0 To $iT - 1
        $iLen = StringLen($aText[$i])
        If $iLen > $iOfs Then $iOfs = $iLen ; max text width
        If $iOfs < 10 Then $iOfs = 10
        $aTextWidth[$i] = 400
        $aTextStyle[$i] = 0
        Select
            ; bold
            Case StringRegExp($aText[$i], '^\*\*.*?\*\*$')
                $aTextWidth[$i] = 600
                $aText[$i] = StringMid($aText[$i], 3, $iLen - 4)
                ; italic
            Case StringRegExp($aText[$i], '^"".*?""$')
                $aTextStyle[$i] = 2
                $aText[$i] = StringMid($aText[$i], 3, $iLen - 4)
                ; underline
            Case StringRegExp($aText[$i], '^__.*?__$')
                $aTextStyle[$i] = 4
                $aText[$i] = StringMid($aText[$i], 3, $iLen - 4)
                ; strike
            Case StringRegExp($aText[$i], '^--.*?--$')
                $aTextStyle[$i] = 8
                $aText[$i] = StringMid($aText[$i], 3, $iLen - 4)
        EndSelect
    Next


    ; GUI
    Local $hWin = GUICreate($sTitle, $iOfs * $iS + $iInputWidth + 40, $iT * 25 + 55)
    For $i = 0 To $iT - 1
        If IsArray($vInputStyle) Then $InputStyle = $vInputStyle[$i]
        Select
            Case $aText[$i] <> ""
                GUICtrlCreateLabel($aText[$i] & ":", 16, $i * 25 + 15, $iOfs * $iS)
                GUICtrlSetFont(-1, 8.5, $aTextWidth[$i], $aTextStyle[$i])
                $input[$i] = GUICtrlCreateInput("", $iOfs * $iS + 20, $i * 25 + 10, $iInputWidth, -1, $InputStyle)
            Case Else
                GUICtrlCreateLabel("", 16, 1)
        EndSelect
    Next
    Local $ok = GUICtrlCreateButton($sButtonR, 16, $i * 25 + 20, 75)
    GUICtrlSetState(-1, 512) ; $GUI_DEFBUTTON = 512
    Local $cancel = GUICtrlCreateButton($sButtonL, $iOfs * $iS + $iInputWidth - 55, $i * 25 + 20, 75)
    GUISetState(@SW_SHOW)
    ; /GUI


    While True
        Switch GUIGetMsg()
            Case -3, $cancel ; $GUI_EVENT_CLOSE = -3
                GUIDelete($hWin)
                Opt('GUIOnEventMode', $oldOpt)
                SetError(1)
                Return ""
            Case $ok
                For $i = 0 To $iT - 2
                    $sRet &= GUICtrlRead($input[$i]) & $sSC
                Next
                $sRet &= GUICtrlRead($input[$i])
                GUIDelete($hWin)
                Opt('GUIOnEventMode', $oldOpt)
                If $iReturnMode = 0 Then
                    Return $sRet
                Else
                    Return StringSplit($sRet, $sSC, 2)
                EndIf
        EndSwitch
    WEnd
EndFunc   ;==>_MultiInput

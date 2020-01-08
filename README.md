# _MultiInput
AutoIt UDF: InputBox mit variabler Anzahl an Eingabefeldern.


## Funktionsaufruf

```autoit
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
;Global $aTexts[5] = ["**Verzeichnis**", "Benutzer", "Passwort", "", "__Information__"]
;Global $aInputSt[5] = [-1, -1, 32] ; $ES_PASSWORD = 32

; Global $sValues = _MultiInput($aTexts, "Test", $aInputSt)
; If Not @error Then MsgBox(0, "", $sValues)
; ==============================================================================
Func _MultiInput(ByRef $aText, $sTitle = "", $vInputStyle = -1, $iInputWidth = 200, $sButtonR = "OK", $sButtonL = "Cancel", $iReturnMode = 0)
```

## Beispiel
```autoit
Global $aTexts[5] = ["**Verzeichnis**", "Benutzer", "Passwort", "", "__Information__"]
Global $aInputSt[5] = [-1, -1, 32] ; $ES_PASSWORD = 32

Global $sValues = _MultiInput($aTexts, "Test", $aInputSt)
If Not @error Then MsgBox(0, "", $sValues)
```

![MultiInput](/images/_MultiInput.png)

## Voraussetzungen

AutoIt


## Installation

Als Funktion in das eigene Programm kopieren, oder als UDF in das Include Verzeichnis von AutoIt kopieren.


## Diskusion und Vorschläge

[autoit.de](https://autoit.de/thread/15449-multiinput-inputbox-mit-einer-variablen-anzahl-an-eingabe-feldern-v3-0/)

## ToDo

- [ ] Default Werte

## Authors
Thorsten Willert

M3d1c5 (support for default-text)

[Homepage](http://www.thorsten-willert.de/)

## Lizenz
Das Ganze steht unter der [Apache 2.0](https://github.com/THWillert/HomeMatic_CSS/blob/master/LICENSE) Lizenz
.

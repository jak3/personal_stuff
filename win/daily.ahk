; daily autohotkey file

#g::Run, "C:\Users\Giacomo"
#v::Run, "C:\Users\Giacomo\Documents\Visual Studio 2013\Projects"
#d::Run, "C:\Users\Giacomo\Downloads"

#SingleInstance
#WinActivateForce

Loop 10
{
n := A_Index-1
Hotkey, #%n%, Focus%n%
Hotkey, #Numpad%n%, Focus%n%
}
return

Focus1:
FocusButton(1)
return
Focus2:
FocusButton(2)
return
Focus3:
FocusButton(3)
return
Focus4:
FocusButton(4)
return
Focus5:
FocusButton(5)
return
Focus6:
FocusButton(6)
return
Focus7:
FocusButton(7)
return
Focus8:
FocusButton(8)
return
Focus9:
FocusButton(9)
return
Focus0:
FocusButton(10)
return

FocusButton(n)
{
global g_bundleCount

; these static variables can become inaccurate if windows are created or closed
; inbetween pressing of hotkeys, but in practice, we can safely ignore the
; inaccuracy
static prevBundleIndex := 0
static prevWindowIndex := 0

Build_hWndArray(n)

if (g_bundleCount >= n)
{
bundleSize := BundleSize(n)

if n = %prevBundleIndex%
windowIndex := Mod(prevWindowIndex, bundleSize) + 1
else
windowIndex := 1

hWnd := Get_hWndFromArray(n, windowIndex)

If bundleSize > 1 ; cycle through windows in the same bundle
WinActivate, ahk_id %hWnd%
Else ; single-window bundle; activate (restore) or minimize the window depending on whether it's active
IfWinActive, ahk_id %hWnd%
WinMinimize, ahk_id %hWnd%
Else
WinActivate, ahk_id %hWnd%

prevBundleIndex := n
prevWindowIndex := windowIndex
}
}

#-::
#NumpadSub::
ShowToolTips()
SetTimer, RemoveToolTips, -1000
Return

RemoveToolTips:
Loop, 10
ToolTip,,,,%A_Index%
Return

ShowToolTips()
{
global g_bundleCount
Build_hWndArray(10)

CoordMode, ToolTip, Screen
Loop, %g_bundleCount%
{
If A_Index < 5
continue

x := g_xs%A_Index%
y := g_ys%A_Index%
If A_Index = 10
text = 0
Else
text = %A_Index%

ToolTip, %text%, %x%, %y%, %A_Index%
}
}

Add_hWndToArray(gi, hWnd)
{
global
g_bundleSize%gi% := g_bundleSize%gi% + 1
local wi := g_bundleSize%gi%
g_hWnd%gi%_%wi% := hWnd
}

AddBundle(gi)
{
global
g_bundleSize%gi% := 0
}

BundleSize(gi)
{
global
return g_bundleSize%gi%
}

Get_hWndFromArray(gi, wi)
{
global
return g_hWnd%gi%_%wi%
}

RecButtonTopLeftLoc(gi, xTB, yTB, left, top)
{
global
g_xs%gi% := xTB + left
g_ys%gi% := yTB + top
}

Build_hWndArray(maxBundleCount)
{
global g_bundleCount

WinGet, pidTaskbar, PID, ahk_class Shell_TrayWnd
hProc := DllCall("OpenProcess", "Uint", 0x38, "int", 0, "Uint", pidTaskbar)
pProc := DllCall("VirtualAllocEx", "Uint", hProc, "Uint", 0, "Uint", 32, "Uint", 0x1000, "Uint", 0x4)
idxTB := GetTaskSwBar()
SendMessage, 0x418, 0, 0, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd ; TB_BUTTONCOUNT
buttonCount := ErrorLevel

ControlGet, hWndTB, hWnd,, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd
WinGetPos, xTB, yTB,,, ahk_id %hWndTB%

VarSetCapacity(btn, 32, 0)
VarSetCapacity(rect, 32, 0)

g_bundleCount := 0

Loop, %buttonCount%
{
SendMessage, 0x417, A_Index-1, pProc, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd ; TB_GETBUTTON

DllCall("ReadProcessMemory", "Uint", hProc, "Uint", pProc, "Uint", &btn, "Uint", 32, "Uint", 0)

idn := NumGet(btn, 4)
Statyle := NumGet(btn, 8, "Char")
dwData := NumGet(btn, 12)
If Not dwData
dwData := NumGet(btn, 16, "int64")

DllCall("ReadProcessMemory", "Uint", hProc, "Uint", dwData, "int64P", hWnd:=0, "Uint", NumGet(btn,12) ? 4:8, "Uint", 0)

If Not hWnd ; group button, indicates the start of a group of similar windows
{
If g_bundleCount >= %maxBundleCount%
Break

hidden := Statyle & 0x08 ; TBSTATE_HIDDEN
If Not hidden
{
grpCollapsed := true
g_bundleCount := g_bundleCount + 1
AddBundle(g_bundleCount)

SendMessage, 0x433, idn, pProc, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd ; TB_GETRECT
DllCall("ReadProcessMemory", "Uint", hProc, "Uint", pProc, "Uint", &rect, "Uint", 32, "Uint", 0)
RecButtonTopLeftLoc(g_bundleCount, xTB, yTB, NumGet(rect, 0), NumGet(rect, 4))
}
Else
grpCollapsed := false
}
else ; actual window button
{
If grpCollapsed
{
Add_hWndToArray(g_bundleCount, hWnd)
}
Else
{
If g_bundleCount >= %maxBundleCount%
Break

g_bundleCount := g_bundleCount + 1
AddBundle(g_bundleCount)
Add_hWndToArray(g_bundleCount, hWnd)

SendMessage, 0x433, idn, pProc, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd ; TB_GETRECT
DllCall("ReadProcessMemory", "Uint", hProc, "Uint", pProc, "Uint", &rect, "Uint", 32, "Uint", 0)
RecButtonTopLeftLoc(g_bundleCount, xTB, yTB, NumGet(rect, 0), NumGet(rect, 4))
}
}
}

DllCall("VirtualFreeEx", "Uint", hProc, "Uint", pProc, "Uint", 0, "Uint", 0x8000)
DllCall("CloseHandle", "Uint", hProc)
}

GetTaskSwBar()
{
ControlGet, hParent, hWnd,, MSTaskSwWClass1 , ahk_class Shell_TrayWnd
ControlGet, hChild , hWnd,, ToolbarWindow321, ahk_id %hParent%
Loop
{
ControlGet, hWnd, hWnd,, ToolbarWindow32%A_Index%, ahk_class Shell_TrayWnd
If Not hWnd
Break
Else If hWnd = %hChild%
{
idxTB := A_Index
Break
}
}
Return idxTB
}
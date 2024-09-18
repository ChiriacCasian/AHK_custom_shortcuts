#Persistent
SetTitleMatchMode, 2
SetTimer, HideCmdTitleBarAndScrollBar, 100

HideCmdTitleBarAndScrollBar:
IfWinActive ahk_class ConsoleWindowClass
{
    WinSet, Style, -0xC00000, A
}
return

^Up::WinMove, A,, , WinGetPos("Y")-50  ; Moves the window up by 50 pixels
^Down::WinMove, A,, , WinGetPos("Y")+50 ; Moves the window down by 50 pixels
^Left::WinMove, A,, WinGetPos("X")-50   ; Moves the window left by 50 pixels
^Right::WinMove, A,, WinGetPos("X")+50  ; Moves the window right by 50 pixels

WinGetPos(coord) {
    WinGetPos, X, Y, , , A
    return (coord = "X") ? X : Y
}

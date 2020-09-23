Attribute VB_Name = "modSubclass"

' TL Assembler
' Copyright © Tommy Lillehagen, 2004.
' All rights reserved.

Option Explicit

Private Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Private Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long
Private Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (lpvDest As Any, lpvSource As Any, ByVal cbCopy As Long)
Private Declare Function GetMenu Lib "user32" (ByVal hwnd As Long) As Long
Private Declare Function GetSubMenu Lib "user32" (ByVal hMenu As Long, ByVal nPos As Long) As Long
Public Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long
Public Const SW_SHOWNORMAL = 1

Private Const GWL_WNDPROC As Long = (-4)
Private Const WM_MENUSELECT = &H11F
Private Const WM_MOUSEWHEEL = &H20A
Private Const WM_GETMINMAXINFO = &H24
Private Const WHEEL_DELTA = 120

Private Type POINT
    x As Long
    y As Long
End Type

Private Type MINMAXINFO
    ptReserved As POINT
    ptMaxSize As POINT
    ptMaxPosition As POINT
    ptMinTrackSize As POINT
    ptMaxTrackSize As POINT
End Type

' This file handles subclassing of controls... Purpose: menu descriptions and to let you use mouse scroll in the controls

Private lPrevMainProc As Long, lPrevAsmEditProc As Long, lPrevBinEditProc As Long

Public Sub Install(hMain As Long, hAsmEdit As Long, hBinEdit As Long)
    lPrevMainProc = GetWindowLong(hMain&, GWL_WNDPROC)
    Call SetWindowLong(hMain&, GWL_WNDPROC, AddressOf MainProc)
    lPrevAsmEditProc = GetWindowLong(hAsmEdit&, GWL_WNDPROC)
    Call SetWindowLong(hAsmEdit&, GWL_WNDPROC, AddressOf AsmEditProc)
    lPrevBinEditProc = GetWindowLong(hBinEdit&, GWL_WNDPROC)
    Call SetWindowLong(hBinEdit&, GWL_WNDPROC, AddressOf BinEditProc)
End Sub

Public Sub Uninstall(hMain As Long, hAsmEdit As Long, hBinEdit As Long)
    Call SetWindowLong(hMain&, GWL_WNDPROC, lPrevMainProc)
    Call SetWindowLong(hAsmEdit&, GWL_WNDPROC, lPrevAsmEditProc)
    Call SetWindowLong(hBinEdit&, GWL_WNDPROC, lPrevBinEditProc)
End Sub

Public Function MainProc(ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
    On Error GoTo ErrHandle
    Dim mmi As MINMAXINFO
    Select Case Msg&
        Case WM_GETMINMAXINFO
            CopyMemory mmi, ByVal lParam, LenB(mmi)
            mmi.ptMinTrackSize.x = 480
            mmi.ptMinTrackSize.y = 320
            CopyMemory ByVal lParam, mmi, LenB(mmi)
        Case WM_MENUSELECT
            frmMain.sts.Panels(1).Text = ""
            If lParam = GetSubMenu(GetMenu(frmMain.hwnd), 0) Then
                Select Case LoWord(wParam)
                    Case 2: frmMain.sts.Panels(1).Text = "Create a new file..."
                    Case 4: frmMain.sts.Panels(1).Text = "Open existing file..."
                    Case 5: frmMain.sts.Panels(1).Text = "Reopen the compiled file..."
                    Case 6: frmMain.sts.Panels(1).Text = "Save file..."
                    Case 7: frmMain.sts.Panels(1).Text = "Save file as..."
                    Case 8: frmMain.sts.Panels(1).Text = "Export disassembly to file..."
                    Case 10: frmMain.sts.Panels(1).Text = "Assemble file..."
                    Case 12: frmMain.sts.Panels(1).Text = "Quit the application..."
                End Select
            ElseIf lParam = GetSubMenu(GetMenu(frmMain.hwnd), 1) Then
                Select Case LoWord(wParam)
                    Case 14: frmMain.sts.Panels(1).Text = "Cut selection to clipboard..."
                    Case 15: frmMain.sts.Panels(1).Text = "Copy selection to clipboard..."
                    Case 16: frmMain.sts.Panels(1).Text = "Paste from clipboard..."
                    Case 18: frmMain.sts.Panels(1).Text = "Duplicate line at caret..."
                    Case 19: frmMain.sts.Panels(1).Text = "Delete line at caret or selected lines if any..."
                    Case 21: frmMain.sts.Panels(1).Text = "Select all lines..."
                    Case 22: frmMain.sts.Panels(1).Text = "Unselect all lines..."
                End Select
            ElseIf lParam = GetSubMenu(GetMenu(frmMain.hwnd), 2) Then
                Select Case LoWord(wParam)
                    Case 24: frmMain.sts.Panels(1).Text = "Set commandline for run..."
                    Case 25: frmMain.sts.Panels(1).Text = "Get information about the instructions..."
                End Select
            ElseIf lParam = GetSubMenu(GetMenu(frmMain.hwnd), 3) Then
                Select Case LoWord(wParam)
                    Case 27: frmMain.sts.Panels(1).Text = "About TL Assembler..."
                    Case 29: frmMain.sts.Panels(1).Text = "Read the documentation of TLA..."
                End Select
            Else
                If LoWord(wParam) > 30 Then
                    frmMain.sts.Panels(1).Text = "Go to declaration of symbol..."
                End If
            End If
    End Select
CallPrevProc:
    If Msg& <> WM_GETMINMAXINFO Then
        MainProc& = CallWindowProc(lPrevMainProc, hwnd&, Msg&, wParam&, lParam&)
    End If
    Exit Function
ErrHandle:
    Err.Clear
End Function

Public Function AsmEditProc(ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
    On Error GoTo ErrHandle
    Select Case Msg&
        Case WM_MOUSEWHEEL:
            frmMain.ce.Scroll -3 * (wParam / 65536 / WHEEL_DELTA)
    End Select
CallPrevProc:
    AsmEditProc& = CallWindowProc(lPrevAsmEditProc, hwnd&, Msg&, wParam&, lParam&)
    Exit Function
ErrHandle:
    Err.Clear
End Function

Public Function BinEditProc(ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
    On Error GoTo ErrHandle
    Select Case Msg&
        Case WM_MOUSEWHEEL:
            frmMain.be.Scroll -3 * (wParam / 65536 / WHEEL_DELTA)
    End Select
CallPrevProc:
    BinEditProc& = CallWindowProc(lPrevAsmEditProc, hwnd&, Msg&, wParam&, lParam&)
    Exit Function
ErrHandle:
    Err.Clear
End Function

Private Function LoWord(lDWord As Long) As Integer
    If lDWord And &H8000& Then
        LoWord = lDWord Or &HFFFF0000
    Else
        LoWord = lDWord And &HFFFF&
    End If
End Function

VERSION 5.00
Begin VB.UserControl AsmEdit 
   AutoRedraw      =   -1  'True
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   2895
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4830
   BeginProperty Font 
      Name            =   "Courier New"
      Size            =   9
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ScaleHeight     =   193
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   322
   ToolboxBitmap   =   "AsmEdit.ctx":0000
   Begin VB.CommandButton cmd 
      Enabled         =   0   'False
      Height          =   270
      Index           =   3
      Left            =   810
      MaskColor       =   &H00FF00FF&
      Picture         =   "AsmEdit.ctx":0312
      Style           =   1  'Graphical
      TabIndex        =   6
      TabStop         =   0   'False
      ToolTipText     =   "Clear bookmarks"
      Top             =   2520
      UseMaskColor    =   -1  'True
      Width           =   270
   End
   Begin VB.CommandButton cmd 
      Enabled         =   0   'False
      Height          =   270
      Index           =   2
      Left            =   540
      MaskColor       =   &H00FF00FF&
      Picture         =   "AsmEdit.ctx":08E4
      Style           =   1  'Graphical
      TabIndex        =   5
      TabStop         =   0   'False
      ToolTipText     =   "Previous bookmark"
      Top             =   2520
      UseMaskColor    =   -1  'True
      Width           =   270
   End
   Begin VB.CommandButton cmd 
      Enabled         =   0   'False
      Height          =   270
      Index           =   1
      Left            =   270
      MaskColor       =   &H00FF00FF&
      Picture         =   "AsmEdit.ctx":0EB6
      Style           =   1  'Graphical
      TabIndex        =   4
      TabStop         =   0   'False
      ToolTipText     =   "Next bookmark"
      Top             =   2520
      UseMaskColor    =   -1  'True
      Width           =   270
   End
   Begin VB.CommandButton cmd 
      Height          =   270
      Index           =   0
      Left            =   0
      MaskColor       =   &H00FF00FF&
      Picture         =   "AsmEdit.ctx":1488
      Style           =   1  'Graphical
      TabIndex        =   3
      TabStop         =   0   'False
      ToolTipText     =   "Toggle bookmark"
      Top             =   2520
      UseMaskColor    =   -1  'True
      Width           =   270
   End
   Begin VB.HScrollBar hs 
      Height          =   270
      LargeChange     =   25
      Left            =   1080
      Max             =   255
      TabIndex        =   2
      TabStop         =   0   'False
      Top             =   2520
      Width           =   3315
   End
   Begin VB.VScrollBar vs 
      Height          =   2475
      LargeChange     =   5
      Left            =   4440
      Max             =   0
      TabIndex        =   1
      TabStop         =   0   'False
      Top             =   0
      Width           =   270
   End
   Begin VB.PictureBox p 
      AutoRedraw      =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      Height          =   2475
      Left            =   480
      MousePointer    =   3  'I-Beam
      OLEDropMode     =   1  'Manual
      ScaleHeight     =   165
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   265
      TabIndex        =   0
      Top             =   15
      Width           =   3975
   End
   Begin VB.Image iBM 
      Height          =   135
      Left            =   4500
      Picture         =   "AsmEdit.ctx":1A5A
      Top             =   2520
      Visible         =   0   'False
      Width           =   135
   End
End
Attribute VB_Name = "AsmEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' AsmEdit Control
' Copyright © Tommy Lillehagen, 2004.
' All rights reserved.

Option Explicit

Private Type Line
    Text As String
    Bookmark As Boolean
    Selected As Boolean
    BColor As Long
    FColor As Long
End Type

Private Type KBs
     b(0 To 255) As Byte
End Type

Private Const CLR_INVALID = -1
Private Const Symbols = ".,@[]():"

Private Declare Function CreateCaret Lib "user32" (ByVal hwnd As Long, ByVal hBitmap As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
Private Declare Function ShowCaret Lib "user32" (ByVal hwnd As Long) As Long
Private Declare Function SetCaretPos Lib "user32" (ByVal x As Long, ByVal y As Long) As Long
Private Declare Function HideCaret Lib "user32" (ByVal hwnd As Long) As Long
Private Declare Function DestroyCaret Lib "user32" () As Long
Private Declare Function TextOut Lib "gdi32" Alias "TextOutA" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal lpString As String, ByVal nCount As Long) As Long
Private Declare Function OleTranslateColor Lib "OLEPRO32.DLL" (ByVal OLE_COLOR As Long, ByVal HPALETTE As Long, pccolorref As Long) As Long
Private Declare Function GetKeyboardState Lib "user32" (kbArray As KBs) As Long
Private Declare Function ToAscii Lib "user32" (ByVal uVirtKey As Long, ByVal uScanCode As Long, lpbKeyState As KBs, lpwTransKey As Long, ByVal fuState As Long) As Long

Private Lines() As Line, LineCount As Integer
Private CaretX As Integer, CaretY As Integer, TabSize As Integer
Private bModified As Boolean, hasSel As Boolean, hasSLine As Boolean
Private FirstSel As Integer, SelMax As Integer, ShowSep As Boolean

Public Event PosChange(Line As Integer, Column As Integer)
Public Event PopupMenu()
Public Event DropFile(Filename As String)
Public Event SelChange()
Public Event Change()
Public Event GetColors(LineData As String, ColorData As String)
Public Event IsSeparated(LineText As String, XValue As Boolean)
Public Event IntToColor(Value As Integer, XColor As Long, XBold As Boolean, XItalic As Boolean)

Private Function TranslateColor(ByVal oClr As OLE_COLOR, Optional hPal As Long = 0) As Long
    If OleTranslateColor(oClr, hPal, TranslateColor) Then TranslateColor = CLR_INVALID
End Function

Private Property Get BlendColor(ByVal oColorFrom As OLE_COLOR, ByVal oColorTo As OLE_COLOR, Optional ByVal alpha As Long = 128) As Long
    Dim lCFrom As Long
    Dim lCTo As Long
    lCFrom = TranslateColor(oColorFrom)
    lCTo = TranslateColor(oColorTo)
    Dim lSrcR As Long
    Dim lSrcG As Long
    Dim lSrcB As Long
    Dim lDstR As Long
    Dim lDstG As Long
    Dim lDstB As Long
    lSrcR = lCFrom And &HFF
    lSrcG = (lCFrom And &HFF00&) \ &H100&
    lSrcB = (lCFrom And &HFF0000) \ &H10000
    lDstR = lCTo And &HFF
    lDstG = (lCTo And &HFF00&) \ &H100&
    lDstB = (lCTo And &HFF0000) \ &H10000
    BlendColor = RGB(((lSrcR * alpha) / 255) + ((lDstR * (255 - alpha)) / 255), ((lSrcG * alpha) / 255) + ((lDstG * (255 - alpha)) / 255), ((lSrcB * alpha) / 255) + ((lDstB * (255 - alpha)) / 255))
End Property

Private Sub AddLine(Text As String, Optional Bookmark As Boolean = False, Optional FColor As Long = vbWindowText, Optional BColor As Long = vbWindowBackground)
    LineCount = LineCount + 1
    ReDim Preserve Lines(LineCount) As Line
    Lines(LineCount).Text = TabToSpace(Text)
    Lines(LineCount).Bookmark = Bookmark
    Lines(LineCount).FColor = FColor
    Lines(LineCount).BColor = BColor
    Lines(LineCount).Selected = False
    bModified = True
    RaiseEvent Change
    UpdateScrollbars
End Sub

Private Sub RemoveLine(Index As Integer)
    Dim i As Integer
    For i = Index + 1 To LineCount
        Lines(i - 1) = Lines(i)
    Next i
    LineCount = LineCount - 1
    ReDim Preserve Lines(LineCount) As Line
    bModified = True
    RaiseEvent Change
    UpdateScrollbars
End Sub

Private Sub InsertLine(After As Integer, Text As String, Optional Bookmark As Boolean = False, Optional FColor As Long = vbWindowText, Optional BColor As Long = vbWindowBackground)
    Dim i As Integer
    i = LineCount
    If After >= LineCount Then
        AddLine TabToSpace(Text), Bookmark
        Exit Sub
    End If
    LineCount = LineCount + 1
    ReDim Preserve Lines(LineCount) As Line
    Do While i > After
        Lines(i + 1) = Lines(i)
        i = i - 1
    Loop
    Lines(After + 1).Text = TabToSpace(Text)
    Lines(After + 1).Bookmark = Bookmark
    Lines(After + 1).FColor = FColor
    Lines(After + 1).BColor = BColor
    Lines(After + 1).Selected = False
    bModified = True
    RaiseEvent Change
    UpdateScrollbars
End Sub

Private Function TabToSpace(Str As String, Optional startx As Integer = 0) As String
    Dim i As Integer, t As Integer, tmp As Integer
    For i = 1 To Len(Str)
        If Mid(Str, i, 1) = vbTab Then
            tmp = ((Int((startx + t) / TabSize) + 1) * TabSize) - t - startx
            TabToSpace = TabToSpace & StrRep(" ", tmp)
            t = t + tmp
        Else
            TabToSpace = TabToSpace & Mid(Str, i, 1)
            t = t + 1
        End If
    Next i
End Function

Private Sub AppendToLine(Index As Integer, Char As Integer, Str As String, Optional SelLen As Integer = 0)
    If Char < 0 Then Exit Sub
    If SelLen + Char > Len(Lines(Index).Text) Then
        Lines(Index).Text = Lines(Index).Text & StrRep(" ", Char - Len(Lines(Index).Text)) & TabToSpace(Str, Char)
    Else
        Lines(Index).Text = Left(Lines(Index).Text, Char) & TabToSpace(Str, Char) & Right(Lines(Index).Text, Len(Lines(Index).Text) - Char - SelLen)
    End If
    If Len(Lines(Index).Text) > 255 Then Lines(Index).Text = Left(Lines(Index).Text, 255)
    bModified = True
    RaiseEvent Change
    UpdateScrollbars
End Sub

Private Sub DeleteFromLine(Index As Integer, Char As Integer, iLen As Integer)
    AppendToLine Index, Char, "", iLen
    bModified = True
    RaiseEvent Change
    UpdateScrollbars
End Sub

Private Function LinesInWindow() As Integer
    LinesInWindow = p.ScaleHeight / TextHeight("A") + 1
End Function

Public Function NextToken(Str As String, Pos As Integer) As Integer
    Dim i As Integer
    NextToken = Len(Str)
    For i = Pos + 2 To Len(Str)
        If InStr(Symbols & " ", Mid(Str, i, 1)) Then
            NextToken = i - 1
            Exit Function
        End If
    Next i
End Function

Private Sub UpdateCaret()
    SetCaretPos (CaretX - hs.Value) * p.TextWidth("A"), (CaretY - vs.Value) * p.TextHeight("A")
    RaiseEvent PosChange(CaretY + 1, CaretX)
End Sub

Public Function StrRep(Char As String, Times As Integer) As String
    Dim i As Integer
    For i = 1 To Times
        StrRep = StrRep & Char
    Next i
End Function

Private Sub PrintLine(Str As String, x As Integer, y As Integer, FColor As Long, Sel As Boolean)
    Dim i As Integer, tmp As String, tmpy As Integer, tmpx As Integer, tmpcolor As Long, tmpbold As Boolean, tmpitalic As Boolean
    RaiseEvent GetColors(Str, tmp)
    p.FontBold = False
    p.FontItalic = False
    tmpy = (y - 1) * p.TextHeight("A")
    For i = x To Len(Str) - 1
        tmpx = (i - x) * p.TextWidth("A")
        RaiseEvent IntToColor(Int(Mid(tmp, i + 1, 1)), tmpcolor, tmpbold, tmpitalic)
        p.ForeColor = tmpcolor
        p.FontBold = tmpbold
        p.FontItalic = tmpitalic
        If FColor <> vbWindowText Then p.ForeColor = FColor
        If Sel Then p.ForeColor = vbHighlightText
        TextOut p.hdc, tmpx, tmpy, Mid(Str, i + 1, 1), 1
    Next i
    p.FontBold = False
    p.FontItalic = False
End Sub

Private Sub Paint_Textbox()
    Dim i As Integer, xtmp As Boolean
    UserControl.Cls
    UserControl.Line ((p.Left - 5) / 2, 0)-(p.Left - 5, p.Height), BlendColor(vbButtonFace, vbWindowBackground, 80), BF
    UserControl.Line (p.Left - 4, 0)-(p.Left - 4, p.Height), vbButtonShadow, BF
    UserControl.Line (p.Left - 3, 0)-(ScaleWidth, p.Height), vbWindowBackground, BF
    For i = vs.Value + 1 To IIf(vs.Value + LinesInWindow > LineCount, LineCount, vs.Value + LinesInWindow)
        If i <= LineCount Then
            If Lines(i).Bookmark Then
                UserControl.PaintPicture iBM.Picture, ((p.Left - 5) / 2) + 3, 1 + ((i - vs.Value - 1) * p.TextHeight("A")) + (p.TextHeight("A") / 2) - 4
            End If
        End If
    Next i
    p.Cls
    For i = vs.Value + 1 To IIf(vs.Value + LinesInWindow > LineCount, LineCount, vs.Value + LinesInWindow)
        If i <= LineCount Then
            If Lines(i).FColor <> vbWindowText Then
                p.Line (0, (i - vs.Value - 1) * p.TextHeight("A"))-(p.ScaleWidth, (i - vs.Value) * p.TextHeight("A")), Lines(i).BColor, BF
                UserControl.Line (p.Left - 3, 1 + (i - vs.Value - 1) * p.TextHeight("A"))-(p.Left, 1 + (i - vs.Value) * p.TextHeight("A")), Lines(i).BColor, BF
            End If
            If Lines(i).Selected Then
                p.Line (0, (i - vs.Value - 1) * p.TextHeight("A"))-(p.ScaleWidth, (i - vs.Value) * p.TextHeight("A")), vbHighlight, BF
                UserControl.Line (p.Left - 3, 1 + (i - vs.Value - 1) * p.TextHeight("A"))-(p.Left, 1 + (i - vs.Value) * p.TextHeight("A")), vbHighlight, BF
            End If
            PrintLine Lines(i).Text, hs.Value, i - vs.Value, Lines(i).FColor, Lines(i).Selected
            RaiseEvent IsSeparated(Lines(i).Text, xtmp)
            If xtmp And i > 1 And ShowSep Then
                p.Line (0, (i - vs.Value - 1) * p.TextHeight("A"))-(p.ScaleWidth - 3, (i - vs.Value - 1) * p.TextHeight("A")), vbButtonFace
            End If
        End If
    Next i
    UpdateCaret
End Sub

Public Function LabelOnLine(Str As String) As Boolean
    Dim iq As Integer, ic As Integer, il As Integer
    iq = InStr(Str, """"): If iq = 0 Then iq = Len(Str) + 1
    ic = InStr(Str, ";"): If ic = 0 Then ic = Len(Str) + 1
    il = InStr(Str, ":"): If il = 0 Then il = Len(Str) + 1
    LabelOnLine = (il < iq And il < ic)
End Function

Private Sub SetPos(y As Integer, Optional SetX As Boolean = False, Optional x As Integer = 0)
    If SetX Then
        CaretX = x
    Else
        CaretY = y
    End If
End Sub

Private Sub cmd_Click(Index As Integer)
    Dim i As Integer, bmFound As Boolean
    Select Case Index
        Case 0
            Lines(CaretY + 1).Bookmark = Not Lines(CaretY + 1).Bookmark
        Case 1
            For i = CaretY + 2 To LineCount
                If Lines(i).Bookmark Then
                    SetPos i - 1
                    Exit For
                End If
            Next i
        Case 2
            i = CaretY
            Do While i > 0
                If Lines(i).Bookmark Then
                    SetPos i - 1
                    Exit Do
                End If
                i = i - 1
            Loop
        Case 3
            For i = 1 To LineCount
                Lines(i).Bookmark = False
            Next i
    End Select
    bmFound = False
    For i = 1 To LineCount
        If Lines(i).Bookmark Then
            bmFound = True
            Exit For
        End If
    Next i
    cmd(1).Enabled = bmFound
    cmd(2).Enabled = bmFound
    cmd(3).Enabled = bmFound
    UpdatePos
    Paint_Textbox
    p.SetFocus
End Sub

Private Sub hs_Change()
    Paint_Textbox
End Sub

Private Sub hs_GotFocus()
    p.SetFocus
End Sub

Private Function GetNextSymbol(Line As String, Pos As Integer) As Integer
    Dim i As Integer
    GetNextSymbol = Len(Line)
    For i = Pos + 2 To Len(Line)
        If InStr(Symbols, Mid(Line, i, 1)) Then
            GetNextSymbol = i - 1
            Exit Function
        ElseIf InStr(Symbols, Mid(Line, i - 1, 1)) Then
            GetNextSymbol = i - 1
            Exit Function
        ElseIf Mid(Line, i, 1) = " " And Mid(Line, i - 1, 1) <> " " Then
            GetNextSymbol = i - 1
            Exit Function
        ElseIf Mid(Line, i, 1) = " " And Mid(Line, i + 1, 1) <> " " Then
            GetNextSymbol = i
            Exit Function
        End If
    Next i
End Function

Private Function GetPrevSymbol(Line As String, Pos As Integer) As Integer
    Dim i As Integer
    GetPrevSymbol = 0
    i = Pos - 1
    While i > 1
        If InStr(Symbols, Mid(Line, i, 1)) Then
            GetPrevSymbol = i - 1
            Exit Function
        ElseIf InStr(Symbols, Mid(Line, i + 1, 1)) Then
            GetPrevSymbol = i
            Exit Function
        ElseIf Mid(Line, i, 1) = " " And Mid(Line, i - 1, 1) <> " " Then
            GetPrevSymbol = i - 1
            Exit Function
        ElseIf Mid(Line, i, 1) = " " And Mid(Line, i + 1, 1) <> " " Then
            GetPrevSymbol = i
            Exit Function
        End If
        i = i - 1
    Wend
End Function

Private Sub p_KeyDown(KeyCode As Integer, Shift As Integer)
    Dim tmp As Integer, KeyAscii As Long, kstate As KBs
    If hasSel And Shift <> vbCtrlMask Then SelectAll False
    Select Case KeyCode
        Case vbKeyLeft
            If Shift = vbCtrlMask Then
                If CaretX > Len(Lines(CaretY + 1).Text) Then
                    CaretX = Len(Lines(CaretY + 1).Text)
                ElseIf CaretX > 0 Then
                    CaretX = GetPrevSymbol(Lines(CaretY + 1).Text, CaretX)
                End If
            Else
                If CaretX > 0 Then
                    CaretX = CaretX - 1
                ElseIf CaretY > 0 Then
                    CaretY = CaretY - 1
                    CaretX = Len(RTrim(Lines(CaretY + 1).Text))
                    If CaretX > p.ScaleWidth / TextWidth("A") Then
                        hs.Value = CaretX - (p.ScaleWidth / TextWidth("A")) + 1
                    End If
                End If
            End If
        Case vbKeyRight
            If Shift = vbCtrlMask Then
                If CaretX < Len(Lines(CaretY + 1).Text) Then
                    CaretX = GetNextSymbol(Lines(CaretY + 1).Text, CaretX)
                End If
            Else
                If CaretX < 255 Then
                    CaretX = CaretX + 1
                ElseIf CaretY < LineCount - 1 Then
                    CaretY = CaretY + 1
                    CaretX = 0
                End If
            End If
        Case vbKeyUp
            If CaretY > 0 Then CaretY = CaretY - 1
        Case vbKeyDown
            If CaretY < LineCount - 1 Then CaretY = CaretY + 1
        Case vbKeyHome
            CaretX = 0
            hs.Value = 0
        Case vbKeyEnd
            CaretX = Len(RTrim(Lines(CaretY + 1).Text))
            If CaretX > p.ScaleWidth / TextWidth("A") Then
                hs.Value = CaretX - (p.ScaleWidth / TextWidth("A")) + 1
            End If
        Case vbKeyPageUp
            If CaretY - (p.ScaleHeight / TextHeight("A")) < 0 Then
                CaretY = 0
                vs.Value = 0
            Else
                CaretY = CaretY - (p.ScaleHeight / TextHeight("A"))
                If vs.Value - (p.ScaleHeight / TextHeight("A")) > 0 Then
                    vs.Value = vs.Value - (p.ScaleHeight / TextHeight("A"))
                Else
                    vs.Value = 0
                End If
            End If
        Case vbKeyPageDown
            If CaretY + (p.ScaleHeight / TextHeight("A")) > LineCount Then
                CaretY = LineCount - 1
            Else
                CaretY = CaretY + (p.ScaleHeight / TextHeight("A"))
                If vs.Value + (p.ScaleHeight / TextHeight("A")) > vs.Max Then
                    vs.Value = vs.Max
                Else
                    vs.Value = vs.Value + (p.ScaleHeight / TextHeight("A"))
                End If
            End If
        Case vbKeyBack
            If CaretX > 0 Then
                If Shift = vbCtrlMask Then
                    tmp = GetPrevSymbol(Lines(CaretY + 1).Text, CaretX)
                    DeleteFromLine CaretY + 1, tmp, CaretX - tmp
                    CaretX = tmp
                Else
                    DeleteFromLine CaretY + 1, CaretX - 1, 1
                    CaretX = CaretX - 1
                End If
            ElseIf CaretY > 0 Then
                CaretX = Len(Lines(CaretY).Text)
                If Trim(Lines(CaretY + 1).Text) <> "" Then
                    AppendToLine CaretY, Len(Lines(CaretY).Text), Lines(CaretY + 1).Text
                End If
                RemoveLine CaretY + 1
                CaretY = CaretY - 1
            End If
            If hasSLine Then ClearSLine
        Case vbKeyDelete
            If CaretX < Len(Lines(CaretY + 1).Text) Then
                If Shift = vbCtrlMask Then
                    tmp = GetNextSymbol(Lines(CaretY + 1).Text, CaretX)
                    DeleteFromLine CaretY + 1, CaretX, tmp - CaretX
                Else
                    DeleteFromLine CaretY + 1, CaretX, 1
                End If
            ElseIf CaretY < LineCount - 1 Then
                If Trim(Lines(CaretY + 2).Text) <> "" Then
                    AppendToLine CaretY + 1, Len(Lines(CaretY + 1).Text), Lines(CaretY + 2).Text
                End If
                RemoveLine CaretY + 2
            End If
            If hasSLine Then ClearSLine
        Case vbKeyTab
            tmp = (Int(CaretX / TabSize) + 1) * TabSize
            AppendToLine CaretY + 1, CaretX, vbTab
            CaretX = tmp
            If hasSLine Then ClearSLine
        Case Else
            GetKeyboardState kstate
            tmp = ToAscii(KeyCode, Shift, kstate, KeyAscii, 0)
            If tmp = 1 Then
                If KeyAscii > 31 Then
                    AppendToLine CaretY + 1, CaretX, Chr(KeyAscii)
                    CaretX = CaretX + 1
                    Paint_Textbox
                ElseIf KeyAscii = 13 Then
                    InsertLine CaretY + 1, ""
                    If CaretX < Len(Lines(CaretY + 1).Text) Then
                        Lines(CaretY + 2).Text = StrRep(" ", PreCount(" ", Lines(CaretY + 1).Text)) & Right(LTrim(Lines(CaretY + 1).Text), Len(Lines(CaretY + 1).Text) - CaretX)
                        DeleteFromLine CaretY + 1, CaretX, Len(Lines(CaretY + 1).Text) - CaretX
                    End If
                    CaretX = PreCount(" ", Lines(CaretY + 1).Text)
                    CaretY = CaretY + 1
                End If
                If hasSLine Then ClearSLine
            End If
    End Select
    If CaretX > 255 Then CaretX = 255
    UpdatePos
    Paint_Textbox
    UpdateScrollbars
End Sub

Private Sub UpdatePos()
    If CaretX - hs.Value > p.ScaleWidth / p.TextWidth("A") Then
        hs.Value = CaretX - (p.ScaleWidth / p.TextWidth("A")) + 1
    ElseIf CaretX - hs.Value < 0 Then
        hs.Value = CaretX
    End If
    If CaretY - vs.Value + 1 > p.ScaleHeight / p.TextHeight("A") Then
        If vs.Value < vs.Max Then vs.Value = CaretY - (p.ScaleHeight / p.TextHeight("A")) + 1
    ElseIf CaretY - vs.Value < 0 Then
        vs.Value = CaretY
    End If
End Sub

Private Function PreCount(Char As String, Str As String)
    Dim i As Integer
    For i = 1 To Len(Str)
        If Mid(Str, i, 1) <> Char Then Exit Function
        PreCount = PreCount + 1
    Next i
End Function

Private Sub p_GotFocus()
    CreateCaret p.hwnd, 0, 0, TextHeight("A")
    ShowCaret p.hwnd
    UpdateCaret
End Sub

Private Sub p_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    p_GotFocus
    If Button = 1 Then
        CaretX = Int((x + (hs.Value * p.TextWidth("A"))) / p.TextWidth("A"))
        CaretY = Int((y + (vs.Value * p.TextHeight("A"))) / p.TextHeight("A"))
        If CaretY >= LineCount Then CaretY = LineCount - 1
        If CaretX < 0 Then CaretX = 0
        If CaretX > 255 Then CaretX = 255
        If hasSel Then SelectAll False
        Paint_Textbox
    End If
End Sub

Private Sub p_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    p_MouseDown Button, Shift, x, y
    If Button = 2 Then
        RaiseEvent PopupMenu
    End If
End Sub

Private Sub p_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, y As Single)
    If Data.Files.count = 1 Then
        RaiseEvent DropFile(Data.Files(1))
    End If
End Sub

Private Sub UserControl_Initialize()
    LineCount = 0: AddLine ""
    CaretY = 0: CaretX = 0
    TabSize = 8: bModified = False
    hasSel = False: hasSLine = False
    RaiseEvent SelChange
    Paint_Textbox
End Sub

Private Sub p_LostFocus()
    HideCaret p.hwnd
    DestroyCaret
End Sub

Private Sub UserControl_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    If x < p.Left Then
        SelectAll False
        FirstSel = vs.Value + CInt((y + 5) / p.TextHeight("A"))
        SelMax = 0
        UserControl_MouseMove Button, Shift, x, y
    End If
End Sub

Private Sub UserControl_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    Dim i As Integer, li As Integer
    If Button = 1 And x < p.Left Then
        li = vs.Value + CInt((y + 5) / p.TextHeight("A"))
        If li < 1 Then li = 1
        If li > LineCount Then li = LineCount
        If li > SelMax Then SelMax = li
        If li < FirstSel Then FirstSel = li
        If li <= LineCount Then
            CaretY = li - 1
        End If
        For i = FirstSel To SelMax
            Lines(i).Selected = (i <= li)
            hasSel = True
            RaiseEvent SelChange
        Next i
        Paint_Textbox
        UpdatePos
    End If
End Sub

Private Sub UserControl_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    Dim i As Integer, li As Integer
    If Button = 1 And x < p.Left Then
        li = vs.Value + CInt((y + 5) / p.TextHeight("A"))
        If li < 1 Then li = 1
        If li > LineCount Then li = LineCount
        For i = FirstSel To SelMax
            Lines(i).Selected = (i <= li)
            hasSel = True
            RaiseEvent SelChange
        Next i
        Paint_Textbox
    ElseIf Button = 2 Then
        RaiseEvent PopupMenu
    End If
End Sub

Private Sub UserControl_Paint()
    Paint_Textbox
End Sub

Private Sub UpdateScrollbars()
    vs.Max = IIf(LineCount >= LinesInWindow, LineCount - LinesInWindow + 2, 0)
    hs.Max = 256 - p.ScaleWidth / p.TextWidth("A")
End Sub

Private Sub UserControl_Resize()
    On Error Resume Next
    Dim i As Integer
    vs.Left = UserControl.ScaleWidth - vs.Width
    vs.Height = UserControl.ScaleHeight - hs.Height
    hs.Top = UserControl.ScaleHeight - hs.Height
    hs.Width = UserControl.ScaleWidth - vs.Width - hs.Left
    p.Width = UserControl.ScaleWidth - p.Left - vs.Width
    p.Height = UserControl.ScaleHeight - hs.Height - 1
    For i = 0 To 3
        cmd(i).Top = hs.Top
    Next i
    UpdateScrollbars
    Paint_Textbox
End Sub

Private Sub vs_Change()
    Paint_Textbox
End Sub

Private Sub vs_GotFocus()
    p.SetFocus
End Sub

Public Sub SetText(Str As String)
    Dim x() As String, i As Integer
    ReDim Lines(0) As Line
    LineCount = 0
    If Str <> "" Then
        x = Split(Str, vbCrLf)
        For i = 0 To UBound(x) - 1
            AddLine x(i)
        Next i
    Else
        AddLine ""
    End If
    CaretX = 0: CaretY = 0
    vs.Value = 0: hs.Value = 0
    UpdateScrollbars
    Paint_Textbox
    UpdateCaret
End Sub

Public Function GetLine(Index As Integer) As String
    If Index > LineCount Then
        GetLine = ""
    Else
        GetLine = RTrim(Lines(Index).Text)
    End If
End Function

Public Function ParseLine(Index As Integer) As String()
    If Index > LineCount Then
        ParseLine = Parse("")
    Else
        ParseLine = Parse(Lines(Index).Text)
    End If
End Function

Public Function GetText() As String
    Dim i As Integer, pre As String
    For i = 1 To LineCount
        GetText = GetText & pre & GetLine(i)
        pre = vbCrLf
    Next i
End Function

Public Function SLine(Index As Integer, Color1 As Long, Color2 As Long)
    Lines(Index).FColor = Color1
    Lines(Index).BColor = Color2
    hasSLine = True
    CaretY = Index - 1
    CaretX = Len(Lines(Index).Text)
    UpdatePos
    Paint_Textbox
End Function

Public Function ClearSLine()
    Dim i As Integer
    For i = 1 To LineCount
        Lines(i).FColor = vbWindowText
        Lines(i).BColor = vbWindowBackground
    Next i
    hasSLine = False
    Paint_Textbox
End Function

Private Sub vs_Scroll()
    Paint_Textbox
End Sub

Public Sub SelectAll(Optional Selected As Boolean = True)
    Dim i As Integer
    For i = 1 To LineCount
        Lines(i).Selected = Selected
    Next i
    hasSel = Selected
    RaiseEvent SelChange
    Paint_Textbox
End Sub

Public Sub DuplicateLine()
    InsertLine CaretY + 1, ""
    Lines(CaretY + 2).Text = Lines(CaretY + 1).Text
    Paint_Textbox
End Sub

Public Sub DeleteLine()
    If LineCount > 1 Then
        RemoveLine CaretY + 1
    Else
        Lines(1).Text = ""
    End If
    If CaretY + 1 > LineCount Then CaretY = LineCount - 1
    UpdatePos
    Paint_Textbox
End Sub

Public Sub CopySelLines()
    Dim i As Integer, tmp As String, pre As String
    For i = 1 To LineCount
        If Lines(i).Selected Then
            tmp = tmp & pre & Lines(i).Text
            pre = vbCrLf
        End If
    Next i
    Clipboard.SetText tmp
End Sub

Public Sub DeleteSelLines()
    Dim i As Integer
    While i <= LineCount
        If Lines(i).Selected Then
            RemoveLine i
            If i = CaretY - 1 Then CaretX = 0
            CaretY = CaretY - 1
        Else
            i = i + 1
        End If
    Wend
    If CaretY + 1 > LineCount Then CaretY = LineCount - 1
    UpdatePos
    Paint_Textbox
End Sub

Public Sub Paste()
    Dim i As Integer, tmp() As String
    tmp = Split(Clipboard.GetText(), vbCrLf)
    For i = 0 To UBound(tmp)
        If i = 0 And UBound(tmp) = 0 Then
            AppendToLine CaretY + 1, CaretX, tmp(0)
            CaretX = CaretX + Len(tmp(0))
        Else
            InsertLine CaretY + 1, tmp(i)
            CaretY = CaretY + 1
            CaretX = Len(tmp(i))
        End If
    Next i
    UpdatePos
    Paint_Textbox
End Sub

Public Sub Scroll(ByInt As Integer)
    If vs.Value + ByInt > vs.Max Then
        vs.Value = vs.Max
    ElseIf vs.Value + ByInt < 0 Then
        vs.Value = 0
    Else
        vs.Value = vs.Value + ByInt
    End If
End Sub

Public Sub GotoLine(linenum As Integer)
    CaretY = linenum - 1
    UpdateCaret
    UpdatePos
End Sub

Public Property Get Handle() As Long
    Handle = UserControl.hwnd
End Property

Public Property Get Modified() As Boolean
    Modified = bModified
End Property

Public Property Let Modified(ByVal bNewValue As Boolean)
    bModified = bNewValue
End Property

Public Property Get NumOfLines() As Integer
    NumOfLines = LineCount
End Property

Public Property Get HasSelection() As Boolean
    HasSelection = hasSel
End Property

Public Property Get CurrLine() As Integer
    CurrLine = CaretY + 1
End Property

Public Property Let CurrLine(Val As Integer)
    CaretY = Val - 1
    UpdateCaret
    UpdatePos
End Property

Public Function GetSymbols() As String()
    Dim tmp() As String, i As Integer, x() As String, cnt As Integer, currlab As String
    cnt = 0: ReDim Preserve x(cnt) As String
    For i = 1 To LineCount
        tmp = ParseLine(i)
        If tmp(0) <> "" Then
            ReDim Preserve x(cnt) As String
            If Left(tmp(0), 1) <> "." Then
                currlab = tmp(0)
                x(cnt) = tmp(0) & "|" & i
            Else
                x(cnt) = currlab & tmp(0) & "|" & i
            End If
            cnt = cnt + 1
        End If
    Next i
    GetSymbols = x
End Function

Public Function GetCurrentSymbol() As String
    Dim tmp() As String, i As Integer, hok As Boolean
    GetCurrentSymbol = "": i = CaretY + 1: hok = True
    While i > 0
        tmp = ParseLine(i)
        If tmp(0) <> "" Then
            If Not hok And Left(tmp(0), 1) <> "." Then
                GetCurrentSymbol = tmp(0) & GetCurrentSymbol
                Exit Function
            End If
            If hok Then GetCurrentSymbol = tmp(0)
            If Left(tmp(0), 1) = "." Then hok = False
            If hok Then Exit Function
        End If
        i = i - 1
    Wend
End Function

Public Property Get HasSymbols() As Boolean
    Dim tmp() As String, i As Integer
    HasSymbols = False
    For i = 1 To LineCount
        tmp = ParseLine(i)
        If tmp(0) <> "" Then HasSymbols = True: Exit For
    Next i
End Property

Private Function SplitEx(Str As String, Del As String) As String()
    Dim tmp() As String, count As Integer, i As Integer, ins As Boolean
    count = 0: ins = False
    ReDim Preserve tmp(count) As String
    For i = 1 To Len(Str)
        If Mid(Str, i, 1) = """" Then
            ins = Not ins
            tmp(count) = tmp(count) & Mid(Str, i, 1)
        ElseIf Mid(Str, i, 1) = Del And Not ins Then
            count = count + 1
            ReDim Preserve tmp(count) As String
        Else
            tmp(count) = tmp(count) & Mid(Str, i, 1)
        End If
    Next i
    SplitEx = tmp
End Function

Private Function InStrEx(Str As String, SubStr As String) As Integer
    Dim i As Integer, ins As Boolean
    InStrEx = 0: ins = False
    For i = 1 To Len(Str)
        If Mid(Str, i, 1) = """" Then
            ins = Not ins
        ElseIf Not ins And Mid(Str, i, Len(SubStr)) = SubStr Then
            InStrEx = i
            Exit For
        End If
    Next i
End Function

' Parse line into array...
'   Result is structured like this:
'       Result(0) = symbol name
'       Result(1) = instruction name
'       Result(2) = number of operands
'       Result(2+n) = operand n
Public Function Parse(Str As String) As String()
    Dim tmp() As String, c As Integer, count As Integer, ochar As Boolean, plab As Boolean
    Dim ops() As String, i As Integer, instring As Boolean
    c = 0: count = 2: ochar = False: plab = (InStrEx(Str, ":") = 0): instring = False
    If Not plab And InStrEx(Str, ";") > 0 Then
        plab = (InStrEx(Str, ":") > InStrEx(Str, ";"))
    End If
    If plab Then c = 1
    ReDim Preserve tmp(count) As String
    For i = 1 To Len(Str)
        If Mid(Str, i, 1) = ";" And Not instring Then
            i = Len(Str)
        ElseIf Mid(Str, i, 1) = ":" And Not instring Then
            c = 1
            plab = True
        ElseIf Mid(Str, i, 1) = """" Then
            instring = Not instring
            tmp(c) = tmp(c) & """"
        ElseIf ochar And Mid(Str, i, 1) = " " And c < 2 And Not instring Then
            c = 2
            ochar = False
        ElseIf Mid(Str, i, 1) = " " And instring Then
            tmp(c) = tmp(c) & " "
        ElseIf Mid(Str, i, 1) <> " " Then
            If plab Then ochar = True
            tmp(c) = tmp(c) & Mid(Str, i, 1)
        End If
    Next i
    If UBound(tmp) = 2 Then
        ops = SplitEx(tmp(2), ",")
        For i = 0 To UBound(ops)
            count = count + 1
            ReDim Preserve tmp(count) As String
            tmp(count) = ParseOperand(ops(i))
        Next i
        tmp(2) = UBound(ops) + 1
    End If
    Parse = tmp
End Function

Private Function ToHex(Str As Long) As String
    Dim i As Integer
    If Len(Hex(Str)) > 2 Then
        For i = 1 To 4 - Len(Hex(Str))
            ToHex = ToHex & "0"
        Next i
    Else
        If Len(Hex(Str)) = 1 Then ToHex = "0"
    End If
    ToHex = ToHex & Hex(Str)
End Function

Private Function ParseOperand(Str As String) As String
    On Error GoTo done
    If Len(Str) > 0 Then
        If Left(Str, 1) = "$" Then
            ParseOperand = Right(Str, Len(Str) - 1)
        ElseIf Left(Str, 1) = """" And Mid(Str, 3, 1) = """" And Len(Str) = 3 Then
            ParseOperand = ToHex(Asc(Mid(Str, 2, 1)))
        ElseIf InStr("0123456789", Left(Str, 1)) > 0 Then
            ParseOperand = ToHex(CLng(Str))
        Else
            ParseOperand = Str
        End If
    Else
        ParseOperand = ""
    End If
    Exit Function
done:
    ParseOperand = Str
End Function

Public Property Get HasLines() As Boolean
    HasLines = (LineCount > 0)
End Property

Public Property Get ShowSeparatorLines() As Boolean
    ShowSeparatorLines = ShowSep
End Property

Public Property Let ShowSeparatorLines(ByVal vNewValue As Boolean)
    ShowSep = vNewValue
    Paint_Textbox
End Property

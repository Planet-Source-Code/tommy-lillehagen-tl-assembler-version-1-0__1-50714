VERSION 5.00
Begin VB.UserControl BinEdit 
   AutoRedraw      =   -1  'True
   BackColor       =   &H80000005&
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   1035
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   1590
   BeginProperty Font 
      Name            =   "Courier New"
      Size            =   9
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ScaleHeight     =   1035
   ScaleWidth      =   1590
   ToolboxBitmap   =   "BinEdit.ctx":0000
   Begin VB.PictureBox p 
      AutoRedraw      =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      Height          =   855
      Left            =   0
      ScaleHeight     =   855
      ScaleWidth      =   1095
      TabIndex        =   1
      Top             =   0
      Width           =   1095
   End
   Begin VB.VScrollBar vs 
      Height          =   915
      LargeChange     =   5
      Left            =   1260
      Max             =   0
      TabIndex        =   0
      TabStop         =   0   'False
      Top             =   0
      Width           =   255
   End
End
Attribute VB_Name = "BinEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' BinEdit Control
' Copyright © Tommy Lillehagen, 2004.
' All rights reserved.

Option Explicit

Private Type DAI
    Offset As Integer
    Bytes() As Byte
    Size As Integer
    Text As String
    ExText As String
    Labeled As Boolean
    Data As Boolean
    DoesCall As Boolean
    CallOffset As Integer
    ExOffset As Integer
End Type

Private Declare Function OleTranslateColor Lib "OLEPRO32.DLL" (ByVal OLE_COLOR As Long, ByVal HPALETTE As Long, pccolorref As Long) As Long
Private Const CLR_INVALID = -1
Private Items() As DAI, ICount As Integer, MaxWidth As Integer, col1 As Integer, col2 As Integer
Private DataOff() As Integer, COC As Integer
Private DataOff2() As Integer, COC2 As Integer
Public Event DisAsmBegin()
Public Event Progress(done As Long, Total As Long)

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

Private Function HexToSByte(Str As String) As Integer
    If InStr("89ABCDEF", Left(Str, 1)) Then
        HexToSByte = -256 + CByte(Val("&H" & Str))
    Else
        HexToSByte = CByte(Val("&H" & Str))
    End If
End Function

Private Function HexToSInt(Str As String) As Long
    HexToSInt = CInt(Val("&H" & Str))
End Function

Private Sub FixItem(Index As Integer, Offset As Integer)
    Dim tmp As Integer
    With Items(Index)
        Select Case lInstruction
            Case "call"
                If lOp1i16 Then
                    tmp = HexToSInt(Right(lOperand1, Len(lOperand1) - 1))
                    tmp = tmp + Offset + 3
                    .Text = "call $" & ToWHex(tmp)
                    .ExText = "call @x" & ToWHex(tmp)
                    .CallOffset = tmp
                    .DoesCall = True
                    AddDataOff tmp
                End If
            Case "j"
                If lOp2i8 Then
                    tmp = HexToSByte(Right(lOperand2, Len(lOperand2) - 1))
                    tmp = tmp + Offset + 2
                    .Text = "j " & lOperand1 & ",$" & ToWHex(tmp)
                    .ExText = "j" & lOperand1 & " @x" & ToWHex(tmp)
                    .CallOffset = tmp
                    .DoesCall = True
                    AddDataOff tmp
                ElseIf lOp2i16 Then
                    tmp = HexToSInt(Right(lOperand2, Len(lOperand2) - 1))
                    tmp = tmp + Offset + 3
                    .Text = "j " & lOperand1 & ",$" & ToWHex(tmp)
                    .ExText = "j" & lOperand1 & " @x" & ToWHex(tmp)
                    .CallOffset = tmp
                    .DoesCall = True
                    AddDataOff tmp
                End If
            Case "jmp"
                If lOp1i8 Then
                    tmp = HexToSByte(Right(lOperand1, Len(lOperand1) - 1))
                    tmp = tmp + Offset + 2
                    .Text = "jmp $" & ToWHex(tmp)
                    .ExText = "jmp @x" & ToWHex(tmp)
                    .CallOffset = tmp
                    .DoesCall = True
                    AddDataOff tmp
                ElseIf lOp1i16 Then
                    tmp = HexToSInt(Right(lOperand1, Len(lOperand1) - 1))
                    tmp = tmp + Offset + 3
                    .Text = "jmp $" & ToWHex(tmp)
                    .ExText = "jmp @x" & ToWHex(tmp)
                    .CallOffset = tmp
                    .DoesCall = True
                    AddDataOff tmp
                End If
            Case "loop"
                If lOp1i8 Then
                    tmp = HexToSByte(Right(lOperand1, Len(lOperand1) - 1))
                    tmp = tmp + Offset + 2
                    .Text = "loop $" & ToWHex(tmp)
                    .ExText = "loop @x" & ToWHex(tmp)
                    .CallOffset = tmp
                    .DoesCall = True
                    AddDataOff tmp
                ElseIf lOp1i16 Then
                    tmp = HexToSInt(Right(lOperand1, Len(lOperand1) - 1))
                    tmp = tmp + Offset + 3
                    .Text = "loop $" & ToWHex(tmp)
                    .ExText = "loop @x" & ToWHex(tmp)
                    .CallOffset = tmp
                    .DoesCall = True
                    AddDataOff tmp
                End If
        End Select
    End With
End Sub

Private Sub AddDataOff(Word As Integer, Optional Additional As Integer = 0)
    ReDim Preserve DataOff(COC) As Integer
    DataOff(COC) = Word + Additional
    COC = COC + 1
End Sub


Private Sub AddDataOff2(Word As Integer)
    ReDim Preserve DataOff2(COC2) As Integer
    DataOff2(COC2) = Word
    COC2 = COC2 + 1
End Sub

Private Function IsCodeOffset(Offset As Integer) As Boolean
    Dim i As Integer
    IsCodeOffset = False
    For i = 0 To UBound(DataOff)
        If DataOff(i) = Offset Then
            IsCodeOffset = True
        End If
    Next i
End Function

Private Function IsCodeOffset2(Offset As Integer) As Boolean
    Dim i As Integer
    IsCodeOffset2 = False
    For i = 0 To UBound(DataOff2)
        If DataOff2(i) = Offset Then
            IsCodeOffset2 = True
        End If
    Next i
End Function

Public Sub ReadFile(Filename As String, org As Integer)
    Dim temp As String, r() As Byte, i As Integer, ii As Integer
    Dim cnt As Long, tmp() As Byte, ful As Long, bend As Boolean
    If Not FileExists(Filename) Then Exit Sub
    cnt = 0: ful = FileLen(Filename): ICount = 0: MaxWidth = 0: bend = False
    ReDim Preserve DataOff(0) As Integer: COC = 0
    ReDim Preserve DataOff2(0) As Integer: COC2 = 0
    RaiseEvent DisAsmBegin
    Open Filename For Binary As #1
        While Not EOF(1)
            cnt = cnt + 1
            ReDim Preserve r(cnt) As Byte
            Get 1, , r(cnt)
        Wend
    Close #1
    ReDim Preserve Items(ICount) As DAI
    With Items(ICount)
        .Size = 0
        .Offset = 0
        .Text = "org $" & ToWHex(org)
        .ExText = ""
        ReDim Preserve .Bytes(0) As Byte
    End With
    ICount = ICount + 1
    cnt = 1
    While cnt <= ful
        RaiseEvent Progress(cnt, ful)
        For i = cnt To UBound(r)
            ReDim Preserve tmp(i - cnt) As Byte
            tmp(i - cnt) = r(i)
        Next i
        ReDim Preserve Items(ICount) As DAI
        With Items(ICount)
            .Labeled = False
            .DoesCall = False
            .ExText = ""
            If IsCodeOffset(cnt - 1 + org) Then bend = False: .Labeled = True
            If bend Then
                .Text = "db $" & ToHex(tmp(0))
                .Size = 1
                ReDim Preserve .Bytes(0) As Byte
                .Bytes(0) = tmp(0)
                .Offset = cnt - 1 + org
                .Data = True
            Else
                .Data = False
                .Text = Disassemble(tmp)
                .Size = NumBytes
                .Offset = cnt - 1 + org
                If .Text = "int $20" Then bend = True
                If .Text = "ret" Then bend = True
                If Left(.Text, 4) = "jmp " Then bend = True
                FixItem ICount, cnt - 1 + org
                If lOp2i16 Then .ExOffset = HexToSInt(Right(lOperand2, Len(lOperand2) - 1)): AddDataOff2 .ExOffset
                If cnt + .Size > FileLen(Filename) Then .Size = FileLen(Filename) - cnt + 1
                For ii = 0 To .Size - 1
                    ReDim Preserve .Bytes(ii) As Byte
                    .Bytes(ii) = tmp(ii)
                Next ii
            End If
            If Left(.Text, 1) = "j" And Left(.Text, 3) <> "jmp" Then
                .Text = "j" & Mid(.Text, 3, InStr(.Text, ",") - 3) & " " & Mid(.Text, InStr(.Text, ",") + 1)
            ElseIf Left(.Text, 3) = "set" Then
                .Text = "set" & Mid(.Text, 5, InStr(.Text, ",") - 5) & " " & Mid(.Text, InStr(.Text, ",") + 1)
            End If
            If .Size > MaxWidth Then MaxWidth = .Size
            cnt = cnt + .Size
        End With
        ICount = ICount + 1
    Wend
    For i = 0 To ICount - 1
        If IsCodeOffset(Items(i).Offset) Then Items(i).Labeled = True
        If IsCodeOffset2(Items(i).Offset) Then Items(i).Labeled = True
        If (Items(i).ExOffset >= org) And (Items(i).ExOffset <= org + ful) Then
            Items(i).ExText = Left(Items(i).Text, InStr(Items(i).Text, ",")) & "@x" & ToWHex(Items(i).ExOffset)
        End If
    Next i
    col1 = 1090
    col2 = p.TextWidth("A") * (MaxWidth * 3) + (2 * 60)
    vs.Value = 0
    p_Paint
    RaiseEvent Progress(ful, ful)
End Sub

Private Function GenBytes(Bytes() As Byte, Size As Integer) As String
    Dim i As Integer, prev As String
    If Size - 1 > UBound(Bytes) Then Size = UBound(Bytes)
    For i = 0 To Size - 1
        GenBytes = GenBytes & prev & ToHex(Bytes(i))
        prev = " "
    Next i
End Function

Private Function ToHex(S As Byte) As String
    ToHex = IIf(Len(Hex(S)) = 1, "0" & Hex(S), Hex(S))
End Function

Private Function ToWHex(S As Integer) As String
    Dim i As Integer
    For i = 1 To 4 - Len(Hex(S))
        ToWHex = ToWHex & "0"
    Next i
    ToWHex = ToWHex & Hex(S)
End Function

Private Sub UserControl_Initialize()
    col1 = 1090: MaxWidth = 1
    col2 = p.TextWidth("A") * (MaxWidth * 3) + (2 * 60)
    p_Paint
End Sub

Private Sub p_Paint()
    Dim i As Integer, tmp As Integer, x() As String
    p.Cls
    p.Line (0, 0)-(col1 + col2 - 10, p.ScaleHeight), BlendColor(vbButtonFace, vbWindowBackground, 80), BF
    p.CurrentY = 0
    For i = vs.Value To IIf((p.ScaleHeight / p.TextHeight("A")) + vs.Value < ICount - 1, (p.ScaleHeight / p.TextHeight("A")) + vs.Value, ICount - 1)
        tmp = p.CurrentY
        If Items(i).Labeled Or i = 0 Then p.Line (0, p.CurrentY)-(col1 + col2 - 10, p.CurrentY + p.TextHeight("A") - 10), vbButtonShadow, BF
        If Items(i).DoesCall Then p.Line (col1 + col2, p.CurrentY)-(p.ScaleWidth, p.CurrentY + p.TextHeight("A") - 10), BlendColor(vbYellow, vbWindowBackground, 80), BF
        p.CurrentY = tmp
        p.CurrentX = 60
        p.ForeColor = IIf(Items(i).Labeled Or i = 0, BlendColor(vbButtonFace, vbWindowBackground, 80), vbButtonShadow)
        p.Print "0000:" & ToWHex(Items(i).Offset) & "  " & GenBytes(Items(i).Bytes, Items(i).Size)
    Next i
    p.Line (1080, 0)-(1080, p.ScaleHeight), vbButtonShadow
    p.Line (col1 + col2 - 10, 0)-(col1 + col2 - 10, p.ScaleHeight), vbButtonShadow
    p.CurrentY = 0
    For i = vs.Value To IIf((p.ScaleHeight / p.TextHeight("A")) + vs.Value < ICount - 1, (p.ScaleHeight / p.TextHeight("A")) + vs.Value, ICount - 1)
        tmp = p.CurrentY
        If Items(i).Data Then
            p.Line (col1 + col2, p.CurrentY)-(p.ScaleWidth, p.CurrentY + p.TextHeight("A") - 10), BlendColor(vbButtonFace, vbWindowBackground, 40), BF
        End If
        p.CurrentY = tmp
        p.CurrentX = col1 + col2 + 120
        p.ForeColor = IIf(Items(i).Data, BlendColor(vbButtonShadow, vbButtonFace), vbButtonText)
        x = Split(Items(i).Text)
        p.Print x(0)
        If UBound(x) = 1 Then
            p.CurrentY = tmp
            p.CurrentX = col1 + col2 + 120 + (p.TextWidth(" ") * 12)
            p.Print x(1)
        End If
    Next i
    tmp = ICount - (p.ScaleHeight / p.TextHeight("A")) + 1
    vs.Max = IIf(tmp > 0, tmp, 0)
End Sub

Private Sub UserControl_Resize()
    vs.Left = ScaleWidth - vs.Width
    vs.Height = ScaleHeight
    p.Move 0, 0, vs.Left, ScaleHeight
    p_Paint
End Sub

Private Sub vs_Change()
    On Error Resume Next
    p_Paint
    p.SetFocus
End Sub

Private Sub vs_Scroll()
    p_Paint
End Sub

Public Sub ClearAll()
    ICount = 0
    ReDim Preserve Items(0) As DAI
    p_Paint
End Sub

Public Sub ExportToFile(Filename As String)
    Dim i As Integer, tmp As String
    Open Filename For Output As #1
    For i = 0 To ICount - 1
        If Items(i).Labeled And i > 0 Then
            tmp = "x" & ToWHex(Items(i).Offset) & ":" & vbTab
        Else
            tmp = vbTab
        End If
        If Items(i).ExText = "" Then
            tmp = tmp & Replace(Items(i).Text, " ", vbTab)
        Else
            tmp = tmp & Replace(Items(i).ExText, " ", vbTab)
        End If
        Print #1, tmp
    Next i
    Close #1
End Sub

Public Property Get Handle() As Long
    Handle = UserControl.hwnd
End Property

Public Sub Scroll(ByInt As Integer)
    If vs.Value + ByInt > vs.Max Then
        vs.Value = vs.Max
    ElseIf vs.Value + ByInt < 0 Then
        vs.Value = 0
    Else
        vs.Value = vs.Value + ByInt
    End If
    p_Paint
End Sub

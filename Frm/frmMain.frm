VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form frmMain 
   Caption         =   "Untitled - TL Assembler"
   ClientHeight    =   4035
   ClientLeft      =   60
   ClientTop       =   630
   ClientWidth     =   7155
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   4035
   ScaleWidth      =   7155
   StartUpPosition =   2  'CenterScreen
   Begin MSComctlLib.Toolbar tb 
      Align           =   1  'Align Top
      Height          =   360
      Left            =   0
      TabIndex        =   3
      Top             =   0
      Width           =   7155
      _ExtentX        =   12621
      _ExtentY        =   635
      ButtonWidth     =   609
      ButtonHeight    =   582
      AllowCustomize  =   0   'False
      Wrappable       =   0   'False
      Appearance      =   1
      Style           =   1
      ImageList       =   "iml"
      _Version        =   393216
      BeginProperty Buttons {66833FE8-8583-11D1-B16A-00C0F0283628} 
         NumButtons      =   12
         BeginProperty Button1 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "new"
            Object.ToolTipText     =   "New"
            ImageIndex      =   1
         EndProperty
         BeginProperty Button2 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "open"
            Object.ToolTipText     =   "Open"
            ImageIndex      =   2
         EndProperty
         BeginProperty Button3 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Enabled         =   0   'False
            Key             =   "save"
            Object.ToolTipText     =   "Save"
            ImageIndex      =   3
         EndProperty
         BeginProperty Button4 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button5 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "cut"
            Object.ToolTipText     =   "Cut"
            ImageIndex      =   4
         EndProperty
         BeginProperty Button6 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "copy"
            Object.ToolTipText     =   "Copy"
            ImageIndex      =   5
         EndProperty
         BeginProperty Button7 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "paste"
            Object.ToolTipText     =   "Paste"
            ImageIndex      =   6
         EndProperty
         BeginProperty Button8 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "delete"
            Object.ToolTipText     =   "Delete"
            ImageIndex      =   7
         EndProperty
         BeginProperty Button9 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button10 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "make"
            Object.ToolTipText     =   "Make"
            ImageIndex      =   8
         EndProperty
         BeginProperty Button11 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button12 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "about"
            Object.ToolTipText     =   "About"
            ImageIndex      =   9
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ImageList iml 
      Left            =   6540
      Top             =   1800
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   9
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":08CA
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":0EBC
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":14AE
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":1AA0
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":2092
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":2684
            Key             =   ""
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":2C76
            Key             =   ""
         EndProperty
         BeginProperty ListImage8 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":3268
            Key             =   ""
         EndProperty
         BeginProperty ListImage9 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":385A
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComDlg.CommonDialog cdlMake 
      Left            =   6660
      Top             =   840
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      DefaultExt      =   "com"
      DialogTitle     =   "Make"
      Filter          =   "Executable Files|*.com;*.exe|All Files|*.*"
      FilterIndex     =   1
      Flags           =   4
   End
   Begin MSComDlg.CommonDialog cdl 
      Left            =   6660
      Top             =   360
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      DefaultExt      =   "tla"
      Filter          =   "Source Files (*.tla)|*.tla|Executable Files|*.com;*.exe|All Files|*.*"
      FilterIndex     =   1
      Flags           =   4
   End
   Begin TLA.AsmEdit ce 
      Height          =   2595
      Left            =   0
      TabIndex        =   1
      Top             =   360
      Width           =   5595
      _ExtentX        =   9869
      _ExtentY        =   4577
   End
   Begin MSComctlLib.StatusBar sts 
      Align           =   2  'Align Bottom
      Height          =   285
      Left            =   0
      TabIndex        =   0
      Top             =   3750
      Width           =   7155
      _ExtentX        =   12621
      _ExtentY        =   503
      ShowTips        =   0   'False
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   3
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            AutoSize        =   1
            Object.Width           =   6985
            MinWidth        =   5292
         EndProperty
         BeginProperty Panel2 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Alignment       =   1
            Text            =   "Ln 1 Col 1"
            TextSave        =   "Ln 1 Col 1"
         EndProperty
         BeginProperty Panel3 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Key             =   "proc"
         EndProperty
      EndProperty
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin MSComDlg.CommonDialog cdlX 
      Left            =   6660
      Top             =   1320
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      DefaultExt      =   "com"
      DialogTitle     =   "Export"
      Filter          =   "All Files|*.*"
      FilterIndex     =   1
      Flags           =   4
   End
   Begin TLA.BinEdit be 
      Height          =   1695
      Left            =   0
      TabIndex        =   2
      Top             =   0
      Visible         =   0   'False
      Width           =   3495
      _ExtentX        =   6165
      _ExtentY        =   2990
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&File"
      Begin VB.Menu mnuNew 
         Caption         =   "&New"
         Shortcut        =   ^N
      End
      Begin VB.Menu mnuFl1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuOpen 
         Caption         =   "&Open..."
         Shortcut        =   ^O
      End
      Begin VB.Menu mnuOpenMain 
         Caption         =   "Open &compiled file"
         Enabled         =   0   'False
         Shortcut        =   ^B
         Visible         =   0   'False
      End
      Begin VB.Menu mnuSave 
         Caption         =   "&Save"
         Shortcut        =   ^S
      End
      Begin VB.Menu mnuSaveAs 
         Caption         =   "Save &as..."
      End
      Begin VB.Menu mnuExport 
         Caption         =   "&Export..."
         Visible         =   0   'False
      End
      Begin VB.Menu mnuFl2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuMake 
         Caption         =   "&Make..."
         Shortcut        =   {F9}
      End
      Begin VB.Menu mnuFl3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mnuEdit 
      Caption         =   "&Edit"
      Begin VB.Menu mnuCut 
         Caption         =   "Cu&t"
         Shortcut        =   ^X
      End
      Begin VB.Menu mnuCopy 
         Caption         =   "&Copy"
         Shortcut        =   ^C
      End
      Begin VB.Menu mnuPaste 
         Caption         =   "&Paste"
         Shortcut        =   ^V
      End
      Begin VB.Menu mnuEl2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuDuplicate 
         Caption         =   "&Duplicate line"
         Shortcut        =   {F6}
      End
      Begin VB.Menu mnuDelete 
         Caption         =   "Delete &line"
         Shortcut        =   ^Y
      End
      Begin VB.Menu mnuEl3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSelectAll 
         Caption         =   "&Select all"
         Shortcut        =   ^A
      End
      Begin VB.Menu mnuUnselectAll 
         Caption         =   "&Unselect all"
      End
   End
   Begin VB.Menu mnuTools 
      Caption         =   "&Tools"
      Begin VB.Menu mnuCmdLine 
         Caption         =   "&Commandline"
      End
      Begin VB.Menu mnuInstructionInfo 
         Caption         =   "&Instruction look-up"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "&Help"
      Begin VB.Menu mnuAbout 
         Caption         =   "&About..."
         Shortcut        =   {F1}
      End
      Begin VB.Menu mnuHl1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuDocumentation 
         Caption         =   "&Documentation..."
      End
   End
   Begin VB.Menu mnuProc 
      Caption         =   ""
      Visible         =   0   'False
      Begin VB.Menu mnuP 
         Caption         =   ""
         Index           =   0
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

' TL Assembler
' Copyright © Tommy Lillehagen, 2004.
' All rights reserved.

Option Explicit

Public PrevFile As String, ProcCount As Integer, CmdLine As String, org As Integer

Private Sub be_DisAsmBegin()
    frmWait.Show , Me
End Sub

Private Sub be_Progress(done As Long, Total As Long)
    frmWait.Disassemble done, Total
End Sub

Private Sub ce_Change()
    tb.Buttons("save").Enabled = ce.Modified
End Sub

Private Sub ce_DropFile(Filename As String)
    cdl.Filename = Filename
    LoadIt
End Sub

Private Sub ce_GetColors(LineData As String, ColorData As String)
    Dim i As Integer, ii As Integer, tmp As String, c As Integer, prevok As Boolean, lsc As Boolean
    prevok = True
    For i = 1 To Len(LineData)
        If Mid(LineData, i, 1) = """" Then
            c = InStr(i + 1, LineData, """")
            If c = 0 Then c = Len(LineData)
            ColorData = ColorData & ce.StrRep("2", c - i + 1)
            i = c
            prevok = False
        ElseIf Mid(LineData, i, 1) = ";" Then
            ColorData = ColorData & ce.StrRep("3", Len(LineData) - i + 1)
            i = Len(LineData)
            prevok = False
        ElseIf Mid(LineData, i, 1) = "[" Then
            lsc = False
            c = InStr(i + 1, LineData, "]")
            If c = 0 Then c = Len(LineData): lsc = True
            ColorData = ColorData & "1" & ce.StrRep("5", c - i - IIf(lsc, 0, 1)) & IIf(lsc, "", "1")
            i = c
            prevok = True
        ElseIf InStr(".,@[]():", Mid(LineData, i, 1)) > 0 Then
            ColorData = ColorData & "1"
            prevok = True
        ElseIf prevok And InStr("0123456789", Mid(LineData, i, 1)) > 0 Then
            ColorData = ColorData & "4"
            prevok = True
        ElseIf Mid(LineData, i, 1) = "$" Then
            c = ce.NextToken(LineData, i + 1)
            If c = 0 Then c = Len(LineData)
            ColorData = ColorData & ce.StrRep("4", c - i + 1)
            i = c
            prevok = True
        ElseIf Mid(LCase(LineData), i, 6) = "print " Then
            ColorData = ColorData & ce.StrRep("6", 5)
            i = i + 4
        ElseIf Mid(LCase(LineData), i, 6) = "input " Then
            ColorData = ColorData & ce.StrRep("6", 5)
            i = i + 4
        ElseIf Mid(LCase(LineData), i, 3) = "cls" Then
            ColorData = ColorData & ce.StrRep("6", 3)
            i = i + 2
        Else
            ColorData = ColorData & "0"
            prevok = (Mid(LineData, i, 1) = " ")
        End If
    Next i
End Sub

Private Sub ce_IntToColor(Value As Integer, XColor As Long, XBold As Boolean, XItalic As Boolean)
    XBold = False
    XItalic = False
    Select Case Value
        Case 0: XColor = vbWindowText
        Case 1: XColor = &HFF0000
        Case 2: XColor = &H80
        Case 3: XColor = &HA0A0A0: XItalic = True
        Case 4: XColor = &H8000&
        Case 5: XColor = &H800080
        Case 6: XColor = &H800000: XBold = True
    End Select
End Sub

Private Sub ce_IsSeparated(LineText As String, XValue As Boolean)
    XValue = ce.LabelOnLine(LineText)
End Sub

Private Sub ce_PopupMenu()
    PopupMenu mnuEdit
End Sub

Private Sub ce_PosChange(Line As Integer, Column As Integer)
    sts.Panels(2).Text = "Ln " & Line & " Col " & Column
    If ce.HasSymbols Then
        sts.Panels(3).Text = ce.GetCurrentSymbol
    Else
        sts.Panels(3).Text = ""
    End If
    tb.Buttons("delete").Enabled = (ce.HasSelection Or ce.GetLine(ce.CurrLine) <> "")
End Sub

Private Sub ce_SelChange()
    tb.Buttons("cut").Enabled = ce.HasSelection
    tb.Buttons("copy").Enabled = ce.HasSelection
    tb.Buttons("paste").Enabled = (Clipboard.GetText() <> "")
    tb.Buttons("delete").Enabled = (ce.HasSelection Or ce.GetLine(ce.CurrLine) <> "")
End Sub

Private Sub Form_Load()
    Width = 480 * Screen.TwipsPerPixelX
    Height = 320 * Screen.TwipsPerPixelY
    Install hwnd, ce.Handle, be.Handle
    frmSplash.Show vbModal, Me
    InitAsm
    ce.ShowSeparatorLines = True
    If Command <> "" Then
        If Left(Command, 4) = "bin:" Then
            cdl.Filename = GetFilename(Mid(Command, 5))
            LoadHex
        Else
            cdl.Filename = GetFilename(Command)
            LoadIt
        End If
    End If
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    Cancel = Not AskSave
End Sub

Private Sub Form_Resize()
    If WindowState <> 1 Then
        ce.Move 0, ce.Top, ScaleWidth, ScaleHeight - sts.Height - ce.Top
        be.Move 0, 0, ScaleWidth, ScaleHeight - sts.Height
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Uninstall frmMain.hwnd, ce.Handle, be.Handle
End Sub

Private Sub mnuAbout_Click()
    frmAbout.Show vbModal, Me
End Sub

Private Sub mnuCmdLine_Click()
    CmdLine = InputBox("Commandline")
End Sub

Private Sub mnuCopy_Click()
    If Not ce.HasLines Then Exit Sub
    ce.CopySelLines
End Sub

Private Sub mnuCut_Click()
    If Not ce.HasLines Then Exit Sub
    ce.CopySelLines
    ce.DeleteSelLines
End Sub

Private Sub mnuDelete_Click()
    If Not ce.HasLines Then Exit Sub
    If ce.HasSelection Then
        ce.DeleteSelLines
    Else
        ce.DeleteLine
    End If
End Sub

Private Sub mnuDocumentation_Click()
    frmDoc.Show , Me
End Sub

Private Sub mnuDuplicate_Click()
    If Not ce.HasLines Then Exit Sub
    ce.DuplicateLine
End Sub

Private Sub mnuEdit_Click()
    If Not ce.HasLines Then Exit Sub
    mnuCut.Enabled = ce.HasSelection
    mnuCopy.Enabled = ce.HasSelection
    mnuPaste.Enabled = (Clipboard.GetText() <> "")
    mnuDuplicate.Enabled = (ce.GetLine(ce.CurrLine) <> "")
    mnuUnselectAll.Enabled = ce.HasSelection
    mnuDelete.Enabled = (ce.HasSelection Or ce.GetLine(ce.CurrLine) <> "")
End Sub

Private Sub mnuExit_Click()
    Unload Me
End Sub

Private Sub mnuExport_Click()
    cdlX.ShowSave
    If cdlX.Filename <> "" Then be.ExportToFile cdlX.Filename
End Sub

Private Sub mnuInstructionInfo_Click()
    frmInfo.Show vbModal, Me
End Sub

Private Sub mnuMake_Click()
    mnuSave_Click
    cdlMake.ShowSave
    If cdlMake.Filename <> "" Then
        AssembleEx
    End If
End Sub

Private Sub mnuNew_Click()
    If AskSave Then
        ShowHex False
        cdl.Filename = ""
        ce.SetText ""
        CleanUp True
    End If
End Sub

Private Sub mnuOpen_Click()
    If AskSave Then
        cdl.ShowOpen
        If cdl.Filename <> "" Then
            If cdl.FilterIndex = 2 Then
                LoadHex
            Else
                LoadIt
            End If
        End If
    End If
End Sub

Private Sub mnuOpenMain_Click()
    cdl.Filename = PrevFile
    LoadIt
    mnuOpenMain.Enabled = False
    mnuOpenMain.Visible = False
End Sub

Private Sub mnuP_Click(Index As Integer)
    If Not ce.HasLines Then Exit Sub
    ce.GotoLine mnuP(Index).Tag
End Sub

Private Sub mnuPaste_Click()
    If Not ce.HasLines Then Exit Sub
    ce.DeleteSelLines
    ce.Paste
End Sub

Private Sub mnuSave_Click()
    If cdl.Filename <> "" Then
        SaveIt
    Else
        mnuSaveAs_Click
    End If
End Sub

Private Sub mnuSaveAs_Click()
    cdl.ShowSave
    If cdl.Filename <> "" Then
        SaveIt
    End If
End Sub

Public Sub LoadIt()
    Dim tmp As String, all As String
    ShowHex False
    Open cdl.Filename For Input As #1
        While Not EOF(1)
            Line Input #1, tmp
            all = all & tmp & vbCrLf
        Wend
    Close #1
    ce.SetText all
    CleanUp True
End Sub

Public Sub LoadHex()
    ShowHex True
    UpdateTitle
    org = 256
    frmOrigin.Show vbModal, Me
    be.ReadFile cdl.Filename, org
End Sub

Private Sub SaveIt()
    If Not ce.HasLines Then Exit Sub
    Open cdl.Filename For Output As #1
    Print #1, ce.GetText
    Close #1
    CleanUp False
End Sub

Private Sub mnuSelectAll_Click()
    If Not ce.HasLines Then Exit Sub
    ce.SelectAll
End Sub

Private Sub mnuUnselectAll_Click()
    If Not ce.HasLines Then Exit Sub
    ce.SelectAll False
End Sub

Private Function AskSave() As Boolean
    AskSave = True
    If Not ce.Modified Then Exit Function
    Select Case MsgBox("The contents of the file has changed." & vbCrLf & "Do you want to save the changes?", vbYesNoCancel, "Save?")
        Case vbYes
            mnuSave_Click
        Case vbCancel
            AskSave = False
    End Select
End Function

Private Sub CleanUp(Full As Boolean)
    If Full Then cdlMake.Filename = "": CmdLine = ""
    ce.Modified = False
    tb.Buttons("save").Enabled = ce.Modified
    UpdateTitle
End Sub

Private Sub UpdateTitle()
    If cdl.Filename <> "" Then
        Caption = Right(cdl.Filename, Len(cdl.Filename) - InStrRev(cdl.Filename, "\")) & " - TL Assembler"
    Else
        Caption = "Untitled - TL Assembler"
    End If
End Sub

Private Sub ShowHex(Visible As Boolean)
    If Visible Then be.ClearAll
    be.Visible = Visible
    ce.Visible = Not Visible
    tb.Visible = Not Visible
    sts.Panels(2).Text = IIf(Visible, "", "Ln 1 Col 0")
    sts.Panels(3).Text = ""
    mnuSave.Enabled = Not Visible
    mnuSaveAs.Enabled = Not Visible
    mnuMake.Enabled = Not Visible
    mnuEdit.Visible = Not Visible
    mnuCmdLine.Enabled = Not Visible
    mnuExport.Visible = Visible
End Sub

Private Sub sts_PanelClick(ByVal Panel As MSComctlLib.Panel)
    Dim tmp() As String, i As Integer
    If Not ce.HasLines Then Exit Sub
    If Panel.Key = "proc" And ce.Visible Then
        For i = 1 To ProcCount - 1
            Unload mnuP(i)
        Next i
        ProcCount = 0
        mnuP(ProcCount).Caption = ""
        mnuP(ProcCount).Tag = 1
        If ce.HasSymbols Then
            tmp = ce.GetSymbols
            For i = 0 To UBound(tmp)
                If Left(tmp(i), InStr(tmp(i), "|") - 1) <> ce.GetCurrentSymbol Then
                    If ProcCount > 0 Then Load mnuP(ProcCount)
                    mnuP(ProcCount).Caption = Left(tmp(i), InStr(tmp(i), "|") - 1)
                    mnuP(ProcCount).Tag = Right(tmp(i), Len(tmp(i)) - InStrRev(tmp(i), "|"))
                    ProcCount = ProcCount + 1
                End If
            Next i
            If ProcCount > 0 Then PopupMenu mnuProc
        End If
    End If
End Sub

Private Sub tb_ButtonClick(ByVal Button As MSComctlLib.Button)
    Select Case Button.Key
        Case "new"
            mnuNew_Click
        Case "open"
            mnuOpen_Click
        Case "save"
            mnuSave_Click
        Case "cut"
            mnuCut_Click
        Case "copy"
            mnuCopy_Click
        Case "paste"
            mnuPaste_Click
        Case "delete"
            mnuDelete_Click
        Case "make"
            mnuSave_Click
            If cdlMake.Filename <> "" Then
                AssembleEx
            Else
                mnuMake_Click
            End If
        Case "about"
            mnuAbout_Click
    End Select
End Sub

VERSION 5.00
Begin VB.Form frmResult 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Result"
   ClientHeight    =   1035
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4455
   ControlBox      =   0   'False
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmResult.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1035
   ScaleWidth      =   4455
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdRun 
      Caption         =   "&Run"
      Height          =   315
      Left            =   2160
      TabIndex        =   1
      Top             =   660
      Width           =   1095
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "&Close"
      Height          =   315
      Left            =   3300
      TabIndex        =   0
      Top             =   660
      Width           =   1095
   End
   Begin VB.Image imgIcon 
      Height          =   480
      Left            =   0
      Picture         =   "frmResult.frx":000C
      ToolTipText     =   "Click me to hide the output"
      Top             =   90
      Width           =   480
   End
   Begin VB.Label labInfo 
      BackStyle       =   0  'Transparent
      ForeColor       =   &H80000017&
      Height          =   435
      Left            =   540
      TabIndex        =   2
      Top             =   120
      Width           =   3855
   End
End
Attribute VB_Name = "frmResult"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

' TL Assembler
' Copyright © Tommy Lillehagen, 2004.
' All rights reserved.

Option Explicit

Private Sub cmdClose_Click()
    Unload Me
End Sub

Public Sub ShowInfo(Bytes As Integer, Line As Integer, File As String, ErrMsg As AsmError)
    If ErrMsg = aeNone Then
        labInfo.Caption = "Successfully compiled." & vbCrLf & Bytes & " byte(s) written."
        cmdRun.Enabled = True
    Else
        If FileExists(frmMain.cdlMake.Filename) Then Kill frmMain.cdlMake.Filename
        labInfo.Caption = "Could not complete the compilation process." & vbCrLf & "Error[" & Line & "]: "
        Select Case ErrMsg
            Case aeInstruction: labInfo.Caption = labInfo.Caption & "unknown instruction"
            Case aeOperands: labInfo.Caption = labInfo.Caption & "illegal combination of operands"
            Case aeSymbol: labInfo.Caption = labInfo.Caption & "symbol not found"
            Case aeMemorySyntax: labInfo.Caption = labInfo.Caption & "illegal syntax of memory operand"
            Case aeOperandSyntax: labInfo.Caption = labInfo.Caption & "illegal syntax of operand"
            Case aeString: labInfo.Caption = labInfo.Caption & "missing end quote"
            Case aeValue: labInfo.Caption = labInfo.Caption & "value out of range"
            Case aeInclude: labInfo.Caption = labInfo.Caption & "can't include from an included file"
            Case aeIncludeFile: labInfo.Caption = labInfo.Caption & "file not found"
            Case aeRedeclaration: labInfo.Caption = labInfo.Caption & "symbol already exists"
        End Select
        labInfo.Caption = labInfo.Caption & "."
        If File <> "" Then
            frmMain.PrevFile = frmMain.cdl.Filename
            frmMain.mnuOpenMain.Visible = True
            frmMain.mnuOpenMain.Enabled = True
            frmMain.cdl.Filename = GetFilename(File)
            frmMain.LoadIt
        End If
        frmMain.ce.SLine Line, &HFFFFFF, &H80
        cmdRun.Enabled = False
    End If
End Sub

Private Sub cmdRun_Click()
    If FileExists(frmMain.cdlMake.Filename) Then
        ShellExecute Me.hwnd, vbNullString, frmMain.cdlMake.Filename & " " & frmMain.CmdLine, vbNullString, Left$(frmMain.cdlMake.Filename, 3), SW_SHOWNORMAL
    End If
End Sub

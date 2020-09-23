VERSION 5.00
Begin VB.Form frmWait 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Processing..."
   ClientHeight    =   615
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3735
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
   Icon            =   "frmWait.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   615
   ScaleWidth      =   3735
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin TLA.Progress pg 
      Height          =   255
      Left            =   60
      TabIndex        =   0
      Top             =   60
      Width           =   3615
      _ExtentX        =   6376
      _ExtentY        =   450
   End
   Begin VB.Label labStatus 
      Height          =   240
      Left            =   120
      TabIndex        =   1
      Top             =   360
      Width           =   3495
   End
End
Attribute VB_Name = "frmWait"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

' TL Assembler
' Copyright © Tommy Lillehagen, 2004.
' All rights reserved.

Option Explicit

Public Sub Update(Pass As Integer)
    Select Case Pass
        Case 1
            pg.SetPos 1, 4
            labStatus.Caption = "Generating source code..."
        Case 2
            pg.SetPos 2, 4
            labStatus.Caption = "Generating virtual offsets..."
        Case 3
            pg.SetPos 3, 4
            labStatus.Caption = "Replacing symbols with correspondig offsets..."
        Case 4
            pg.SetPos 4, 4
            labStatus.Caption = "Assembling and writing code to file..."
        Case 5
            labStatus.Caption = ""
            Unload Me
    End Select
    DoEvents
End Sub

Public Sub Disassemble(done As Long, Total As Long)
    If done < Total Then
        pg.SetPos done, Total
        labStatus.Caption = "Disassembling..."
    Else
        labStatus.Caption = ""
        Unload Me
    End If
    DoEvents
End Sub

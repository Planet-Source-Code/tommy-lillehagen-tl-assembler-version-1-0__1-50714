VERSION 5.00
Begin VB.Form frmDoc 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Documentation"
   ClientHeight    =   3210
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6480
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmDoc.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3210
   ScaleWidth      =   6480
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.PictureBox pFrame 
      BackColor       =   &H80000005&
      Height          =   3195
      Left            =   0
      ScaleHeight     =   3135
      ScaleWidth      =   6405
      TabIndex        =   1
      TabStop         =   0   'False
      Top             =   0
      Width           =   6465
      Begin VB.TextBox txt 
         BorderStyle     =   0  'None
         BeginProperty Font 
            Name            =   "Courier New"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   3075
         Left            =   60
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertical
         TabIndex        =   0
         TabStop         =   0   'False
         Text            =   "frmDoc.frx":05E2
         Top             =   0
         Width           =   6315
      End
   End
End
Attribute VB_Name = "frmDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

' TL Assembler
' Copyright © Tommy Lillehagen, 2004.
' All rights reserved.

Option Explicit

Private Sub Form_Resize()
    pFrame.Move 0, 0, ScaleWidth, ScaleHeight
    txt.Move 60, 0, pFrame.ScaleWidth - 60, pFrame.ScaleHeight
End Sub

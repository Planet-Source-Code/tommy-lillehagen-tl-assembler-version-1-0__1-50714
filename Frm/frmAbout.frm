VERSION 5.00
Begin VB.Form frmAbout 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "About"
   ClientHeight    =   2415
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4830
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmAbout.frx":0000
   LinkTopic       =   "frmAbout"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2415
   ScaleWidth      =   4830
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdClose 
      Caption         =   "&Close"
      Height          =   315
      Left            =   3600
      TabIndex        =   5
      Top             =   2040
      Width           =   1155
   End
   Begin VB.PictureBox picElse 
      Height          =   1335
      Left            =   1260
      ScaleHeight     =   1275
      ScaleWidth      =   3435
      TabIndex        =   2
      Top             =   660
      Width           =   3495
      Begin VB.Label Label2 
         Caption         =   "       Alvaro Tejada (aka Blag)"
         Height          =   195
         Left            =   60
         TabIndex        =   8
         Top             =   990
         Width           =   3315
      End
      Begin VB.Label Label1 
         Caption         =   "       Aaron Wilkes (aka Wilksey)"
         Height          =   195
         Left            =   60
         TabIndex        =   7
         Top             =   810
         Width           =   3315
      End
      Begin VB.Label labThanks 
         Caption         =   "Special thanks to (for supporting me):"
         Height          =   195
         Left            =   60
         TabIndex        =   6
         Top             =   600
         Width           =   3315
      End
      Begin VB.Label labCopy1 
         Caption         =   "Copyright © Tommy Lillehagen, 2004."
         Height          =   195
         Left            =   60
         TabIndex        =   4
         Top             =   60
         Width           =   3315
      End
      Begin VB.Label labCopy2 
         Caption         =   "All rights reserved."
         Height          =   195
         Left            =   60
         TabIndex        =   3
         Top             =   270
         Width           =   3315
      End
   End
   Begin VB.Line lh 
      BorderColor     =   &H80000014&
      X1              =   1200
      X2              =   4750
      Y1              =   540
      Y2              =   540
   End
   Begin VB.Line ls 
      BorderColor     =   &H80000010&
      BorderWidth     =   2
      X1              =   1200
      X2              =   4740
      Y1              =   540
      Y2              =   540
   End
   Begin VB.Label labDesc 
      Caption         =   "x86 (16-bit) Assembler and Disassembler"
      Height          =   195
      Left            =   1260
      TabIndex        =   1
      Top             =   270
      Width           =   3495
   End
   Begin VB.Label labName 
      Caption         =   "TL Assembler Version "
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   195
      Left            =   1260
      TabIndex        =   0
      Top             =   60
      Width           =   3495
   End
   Begin VB.Image imgAbout 
      Height          =   2415
      Left            =   0
      Picture         =   "frmAbout.frx":000C
      Top             =   0
      Width           =   1125
   End
End
Attribute VB_Name = "frmAbout"
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

Private Sub Form_Load()
    labName.Caption = labName.Caption & App.Major & "." & App.Minor & _
        " (Build " & App.Revision & ")"
End Sub

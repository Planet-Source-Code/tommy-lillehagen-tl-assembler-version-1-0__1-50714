VERSION 5.00
Begin VB.Form frmOrigin 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Origin"
   ClientHeight    =   1515
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4470
   ControlBox      =   0   'False
   BeginProperty Font 
      Name            =   "Verdana"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1515
   ScaleWidth      =   4470
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdContinue 
      Caption         =   "Disassemble"
      Height          =   375
      Left            =   2880
      TabIndex        =   2
      Top             =   1080
      Width           =   1515
   End
   Begin VB.TextBox txtOrg 
      Height          =   315
      Left            =   60
      TabIndex        =   1
      Text            =   "0"
      Top             =   720
      Width           =   4335
   End
   Begin VB.Label labDescription 
      Caption         =   "Input the origin of the code (in decimal value). In other words the offset in memory where the code is supposed to be run from:"
      Height          =   615
      Left            =   60
      TabIndex        =   0
      Top             =   60
      Width           =   4335
   End
End
Attribute VB_Name = "frmOrigin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

' TL Assembler
' Copyright © Tommy Lillehagen, 2004.
' All rights reserved.

Private Sub cmdContinue_Click()
    frmMain.org = CInt(txtOrg.Text)
    Unload Me
End Sub

Private Sub Form_Load()
    txtOrg.Text = frmMain.org
End Sub

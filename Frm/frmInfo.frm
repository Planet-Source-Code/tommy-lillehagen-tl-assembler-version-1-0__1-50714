VERSION 5.00
Begin VB.Form frmInfo 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Information about instructions"
   ClientHeight    =   3015
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4650
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmInfo.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3015
   ScaleWidth      =   4650
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.ListBox lst 
      Height          =   1620
      Left            =   60
      TabIndex        =   3
      Top             =   480
      Width           =   4515
   End
   Begin VB.TextBox txtSearch 
      Height          =   285
      Left            =   1020
      TabIndex        =   0
      Top             =   60
      Width           =   3555
   End
   Begin VB.Label labB 
      Height          =   195
      Left            =   1080
      TabIndex        =   6
      Top             =   2130
      Width           =   3495
   End
   Begin VB.Label labBitPatt 
      Caption         =   "Bit pattern:"
      Height          =   195
      Left            =   120
      TabIndex        =   5
      Top             =   2130
      Width           =   855
   End
   Begin VB.Label labN 
      BackColor       =   &H80000018&
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000017&
      Height          =   195
      Left            =   180
      TabIndex        =   4
      Top             =   2490
      Width           =   4275
   End
   Begin VB.Label labD 
      BackColor       =   &H80000018&
      ForeColor       =   &H80000017&
      Height          =   255
      Left            =   180
      TabIndex        =   2
      Top             =   2700
      Width           =   4275
   End
   Begin VB.Line lH 
      BorderColor     =   &H80000014&
      X1              =   60
      X2              =   4570
      Y1              =   420
      Y2              =   420
   End
   Begin VB.Line lS 
      BorderColor     =   &H80000010&
      BorderWidth     =   2
      X1              =   60
      X2              =   4560
      Y1              =   420
      Y2              =   420
   End
   Begin VB.Label labLookUp 
      Caption         =   "Search for:"
      Height          =   195
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   855
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H80000018&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H80000017&
      Height          =   675
      Left            =   -60
      Top             =   2400
      Width           =   4815
   End
End
Attribute VB_Name = "frmInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

' TL Assembler
' Copyright © Tommy Lillehagen, 2004.
' All rights reserved.

Option Explicit

Dim xpatt() As Integer, xpattc As Integer

Private Sub Form_Load()
    Dim i As Integer, ii As Integer
    lst.Clear: xpattc = 0
    For i = 0 To UBound(AI)
        With AI(i)
            For ii = 0 To UBound(.Format) - 1
                ReDim Preserve xpatt(xpattc) As Integer
                lst.AddItem .Name & " " & .Format(ii)
                lst.ItemData(lst.ListCount - 1) = i
                xpatt(xpattc) = ii
                xpattc = xpattc + 1
            Next ii
        End With
    Next i
End Sub

Private Sub lst_Click()
    With AI(lst.ItemData(lst.ListIndex))
        If .Name = "j" Or .Name = "set" Then
            labN.Caption = UCase(.Name) & "cc"
        Else
            labN.Caption = UCase(.Name)
        End If
        labD.Caption = .Description
        labB.Caption = .Pattern(xpatt(lst.ListIndex))
    End With
End Sub

Private Sub lst_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode >= vbKeyA And KeyCode <= vbKeyZ Then
        txtSearch.Text = LCase(Chr(KeyCode))
        txtSearch.SetFocus
    End If
End Sub

Private Sub txtSearch_Change()
    Dim i As Integer
    For i = 0 To lst.ListCount - 1
        If Left(lst.List(i), Len(txtSearch.Text)) = txtSearch.Text Then
            lst.ListIndex = i
            Exit For
        End If
    Next i
End Sub

Private Sub txtSearch_GotFocus()
    txtSearch.SelStart = Len(txtSearch.Text)
End Sub

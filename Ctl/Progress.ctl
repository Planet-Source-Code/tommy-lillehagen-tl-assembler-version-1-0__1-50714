VERSION 5.00
Begin VB.UserControl Progress 
   AutoRedraw      =   -1  'True
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   480
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   3705
   FillColor       =   &H8000000D&
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ForeColor       =   &H8000000D&
   ScaleHeight     =   480
   ScaleWidth      =   3705
   ToolboxBitmap   =   "Progress.ctx":0000
End
Attribute VB_Name = "Progress"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' Progressbar
' Copyright © Tommy Lillehagen, 2004.
' All rights reserved.

Option Explicit

Private iValue As Long, iMax As Long

Public Function SetPos(Value As Long, Max As Long)
    iValue = Value
    iMax = Max
    UserControl_Paint
End Function

Private Sub UserControl_Paint()
    Cls
    UserControl.Line (0, 0)-(iValue / iMax * ScaleWidth, ScaleHeight), , BF
End Sub

Attribute VB_Name = "modExAsm"

' Extended Assembler
' Copyright © Tommy Lillehagen, 2004.
' All rights reserved.

Option Explicit

Private Type Line
    Label As String
    SubLabel As Boolean
    Instruction As String
    Operand() As String
    OperandCount As Integer
    Offset As Integer
    Size As Integer
    File As String
    LineNumber As Integer
    Optimizeable As Boolean
End Type

Public Enum AsmError
    aeNone = 0
    aeInstruction = 1
    aeOperands = 2
    aeSymbol = 3
    aeMemorySyntax = 4
    aeOperandSyntax = 5
    aeString = 6
    aeValue = 7
    aeInclude = 8
    aeIncludeFile = 9
    aeRedeclaration = 10
End Enum

Private Const Symbols = "[+]"

Private Lines() As Line, LineCount As Integer, CurrOffset As Integer
Private SymbolExist As Boolean, StringOk As Boolean, ErrLine As Integer, ErrFile As String
Private CurrLabel As String, ValueInRange As Boolean, SymX2 As Boolean
Private IncInSubinc As Boolean, IncFileExist As Boolean
Public BytesWritten As Integer

Private Function ByteToHex(Value As Byte) As String
    ByteToHex = IIf(Len(Hex(Value)) = 1, "0" & Hex(Value), Hex(Value))
End Function

Private Function XByteToHex(Value As Integer) As String
    Dim Str As String
    Str = Hex(Value)
    If Len(Str) = 1 Then
        XByteToHex = "0" & Str
    Else
        XByteToHex = Right(Str, 2)
    End If
End Function

Private Function WordToHex(Value As Integer) As String
    Dim i As Integer
    For i = 1 To 4 - Len(Hex(Value))
        WordToHex = WordToHex & "0"
    Next i
    WordToHex = WordToHex & Hex(Value)
End Function

Private Function HexToWord(Value As String) As Integer
    HexToWord = CInt("&H" & Right(Value, Len(Value) - 1))
End Function

Public Function FileExists(FullPathAndFile As String) As Integer
    Dim result As Integer
    On Error Resume Next
    result = FileLen(FullPathAndFile)
    If Err = 0 Then FileExists = True
End Function

' Extended assemble procedure which let's you assemble a file and adds the support of symbols and
' an extended syntax
Public Sub AssembleEx()
    If frmMain.cdl.Filename <> "" Then ChDir Left(frmMain.cdl.Filename, InStrRev(frmMain.cdl.Filename, "\") - 1)
    InstructionOk = True: OperandsOk = True
    frmWait.Show , frmMain
    BytesWritten = 0: StringOk = True: ValueInRange = True: SymX2 = False
    frmWait.Update 1
    PassOne
    If Not StringOk Then GoTo done
    If Not OperandsOk Then GoTo done
    If IncInSubinc Then GoTo done
    If Not IncFileExist Then GoTo done
    If SymX2 Then GoTo done
    frmWait.Update 2
    PassTwo
    If Not OperandsOk Then GoTo done
    frmWait.Update 3
    PassThree
    If Not SymbolExist Then GoTo done
    frmWait.Update 4
    PassFour
done:
    ' See if errors occured, if so set error message
    If Not InstructionOk Then
        frmResult.ShowInfo BytesWritten, ErrLine, ErrFile, aeInstruction
    ElseIf Not ValueInRange Then
        frmResult.ShowInfo BytesWritten, ErrLine, ErrFile, aeValue
    ElseIf Not IncFileExist Then
        frmResult.ShowInfo BytesWritten, ErrLine, ErrFile, aeIncludeFile
    ElseIf IncInSubinc Then
        frmResult.ShowInfo BytesWritten, ErrLine, ErrFile, aeInclude
    ElseIf SymX2 Then
        frmResult.ShowInfo BytesWritten, ErrLine, ErrFile, aeRedeclaration
    ElseIf Not OperandsOk Then
        frmResult.ShowInfo BytesWritten, ErrLine, ErrFile, aeOperands
    ElseIf Not MemoryOk Then
        frmResult.ShowInfo BytesWritten, ErrLine, ErrFile, aeMemorySyntax
    ElseIf Not SyntaxOk Then
        frmResult.ShowInfo BytesWritten, ErrLine, ErrFile, aeOperandSyntax
    ElseIf Not SymbolExist Then
        frmResult.ShowInfo BytesWritten, ErrLine, ErrFile, aeSymbol
    ElseIf Not StringOk Then
        frmResult.ShowInfo BytesWritten, ErrLine, ErrFile, aeString
    Else
        frmResult.ShowInfo BytesWritten, ErrLine, ErrFile, aeNone
    End If
    frmWait.Update 5
    frmResult.Show vbModal, frmMain
End Sub

' Add item with a parsed structure given by 'tmp' (parsed in AsmEdit) to the array of LineItems
'   tmp() as String is structured like this:
'       tmp(0) = symbol name
'       tmp(1) = instruction name
'       tmp(2) = number of operands
'       tmp(2+n) = operand n
Private Sub AddLine(tmp() As String, linenum As Integer, Optional filenm As String = "")
    Dim i As Integer, ii As Integer
    If tmp(1) = "db" Then
        For i = 1 To tmp(2)
            If Left(tmp(2 + i), 1) = """" Then
                If Mid(tmp(2 + i), Len(tmp(2 + i)), 1) <> """" Then
                    StringOk = False
                    Exit Sub
                End If
                For ii = 2 To Len(tmp(2 + i)) - 1
                    AddOneOpLine IIf(i = 1 And ii = 2, tmp(0), ""), tmp(1), ByteToHex(Asc(Mid(tmp(2 + i), ii, 1))), linenum, filenm
                Next ii
            Else
                AddOneOpLine IIf(i = 1, tmp(0), ""), tmp(1), tmp(2 + i), linenum, filenm
            End If
        Next i
    ElseIf (Left(tmp(1), 1) = "j" Or Left(tmp(1), 3) = "set") And Not Left(tmp(1), 3) = "jmp" Then
        ReDim Preserve Lines(LineCount) As Line
        With Lines(LineCount)
            .LineNumber = linenum
            .File = filenm
            If DoesSymbolExist(tmp(0)) Then SymX2 = True: Exit Sub
            If Left(tmp(0), 1) = "." Then
                .Label = CurrLabel & tmp(0)
                .SubLabel = True
            Else
                .Label = tmp(0)
                .SubLabel = False
                If tmp(0) <> "" Then CurrLabel = tmp(0)
            End If
            .Optimizeable = True
            .Instruction = IIf(Left(tmp(1), 3) = "set", "set", "j")
            .OperandCount = 0
            If UBound(tmp) <> 3 Then Exit Sub
            .OperandCount = 2
            ReDim Preserve .Operand(1) As String
            .Operand(0) = Right(tmp(1), Len(tmp(1)) - 1)
            .Operand(1) = tmp(3)
        End With
        LineCount = LineCount + 1
    Else
        ReDim Preserve Lines(LineCount) As Line
        With Lines(LineCount)
            .LineNumber = linenum
            .File = filenm
            If DoesSymbolExist(tmp(0)) Then SymX2 = True: Exit Sub
            If Left(tmp(0), 1) = "." Then
                .Label = CurrLabel & tmp(0)
                .SubLabel = True
            Else
                .Label = tmp(0)
                .SubLabel = False
                If tmp(0) <> "" Then CurrLabel = tmp(0)
            End If
            .Optimizeable = True
            .Instruction = tmp(1)
            .OperandCount = tmp(2)
            If .OperandCount > 0 Then
                For i = 3 To 2 + tmp(2)
                    ReDim Preserve .Operand(i - 3) As String
                    If Len(tmp(i)) = 3 Then
                        If Left(tmp(i), 1) = """" And Right(tmp(i), 1) = """" Then
                            .Operand(i - 3) = ByteToHex(CByte(Val(Mid(tmp(i), 2, 1))))
                        Else
                            .Operand(i - 3) = tmp(i)
                        End If
                    Else
                        .Operand(i - 3) = tmp(i)
                    End If
                Next i
            End If
        End With
        LineCount = LineCount + 1
    End If
End Sub

' Add item as previous procedure, but this is call from AddLine if the assembly statement only has one operand
' This makes it easier to handle instructions as "db" etc. which can have many operands at same line, but which
' are interpreted as a set of assembly statments with one operand (e.g. "db 13,10" = "db 13" and "db 10")
Private Sub AddOneOpLine(lab As String, ins As String, op As String, ln As Integer, Optional filenm As String = "")
    ReDim Preserve Lines(LineCount) As Line
    With Lines(LineCount)
        .LineNumber = ln
        .File = filenm
        If DoesSymbolExist(lab) Then SymX2 = True: Exit Sub
        If Left(lab, 1) = "." Then
            .Label = CurrLabel & lab
            .SubLabel = True
        Else
            .Label = lab
            .SubLabel = False
            If lab <> "" Then CurrLabel = lab
        End If
        .Optimizeable = True
        .Instruction = ins
        .OperandCount = 1
        ReDim Preserve .Operand(0) As String
        .Operand(0) = op
    End With
    LineCount = LineCount + 1
End Sub

' Check whether a symbol exists
Private Function DoesSymbolExist(Str As String) As Boolean
    Dim tmp As String, i As Integer
    DoesSymbolExist = False
    If Str = "" Then Exit Function
    If Left(Str, 1) = "." Then
        tmp = CurrLabel & Str
    Else
        tmp = Str
    End If
    For i = 0 To LineCount - 1
        If Lines(i).Label = tmp Then
            DoesSymbolExist = True
            Exit For
        End If
    Next i
End Function

' Get size (in bytes) of the result of assembly statement given by Code
Public Function TmpAsm(Code As String) As Integer
    Dim r() As Byte
    r = Assemble(Code)
    TmpAsm = UBound(r)
End Function

' Generate the final code (of a line to be assembled and be outputted to output file) with replacements
' for the symbols (they are replaced with the offset of the symbol)... This will check the opportunity
' to optimize the code etc.
Private Function GenCode(Index As Integer) As String
    Dim i As Integer, prev As String
    With Lines(Index)
        GenCode = .Instruction
        prev = " "
        For i = 1 To .OperandCount
            GenCode = GenCode & prev & FixOperand(.Operand(i - 1))
            prev = ","
        Next i
        If Not AsmOk(GenCode) Then
            GenCode = .Instruction
            .Optimizeable = False
            prev = " "
            For i = 1 To .OperandCount
                GenCode = GenCode & prev & FixOperand(.Operand(i - 1), , False)
                prev = ","
            Next i
        End If
    End With
End Function

' This is used to get a temporary assembly statment
Private Function CombCode(Index As Integer) As String
    Dim i As Integer, prev As String
    With Lines(Index)
        CombCode = .Instruction
        prev = " "
        For i = 1 To .OperandCount
            CombCode = CombCode & prev & .Operand(i - 1)
            prev = ","
        Next i
        If Not AsmOk(CombCode) Then
            If .Instruction = "loop" Then ValueInRange = False
        End If
    End With
End Function

' Split a string by characters in the variable Symbols (with some improvements)
Private Function Token(Str As String) As String()
    Dim tmp() As String, c As Integer, i As Integer
    c = 0: ReDim Preserve tmp(c) As String
    For i = 1 To Len(Str)
        If InStr(Symbols, Mid(Str, i, 1)) > 0 Then
            c = c + 1
            ReDim Preserve tmp(c) As String
            tmp(c) = Mid(Str, i, 1)
            c = c + 1
            ReDim Preserve tmp(c) As String
        Else
            tmp(c) = tmp(c) & Mid(Str, i, 1)
        End If
    Next i
    Token = tmp
End Function

' Fix the operand given by Str. Value is inputted if a symbol is found on the line and if the offset
' of the symbol is set. The symbol will be replaced with Value in hexadecimal value, and then we have
' an operand which either is ready to be temporarily assembled (to get the offsets of symbols) or to be
' finaly assembled with correct symbol offsets etc.
Private Function FixOperand(Str As String, Optional Value As Integer = 0, Optional Optimize As Boolean = True) As String
    Dim tmp() As String, i As Integer
    tmp = Token(Str)
    For i = 0 To UBound(tmp)
        If i > 0 Then
            If IsLabel(tmp(i)) And tmp(i - 1) = "[" Then
                FixOperand = FixOperand & WordToHex(Value)
                GoTo go_next
            End If
        End If
        If IsLabel(tmp(i)) Then
            If Optimize Then
                If Value >= -128 And Value <= 127 Then
                    FixOperand = FixOperand & XByteToHex(Value)
                Else
                    FixOperand = FixOperand & WordToHex(Value)
                End If
            Else
                FixOperand = FixOperand & WordToHex(Value)
            End If
        Else
            FixOperand = FixOperand & tmp(i)
        End If
go_next:
    Next i
End Function

' Get reference of a symbol (if any) in an operand
Private Function GetSymbol(Str As String) As String
    Dim tmp() As String, i As Integer
    tmp = Token(Str)
    For i = 0 To UBound(tmp)
        If IsLabel(tmp(i)) Then
            If Mid(Str, 2, 1) = "." Then
                GetSymbol = CurrLabel & Right(tmp(i), Len(tmp(i)) - 1)
            Else
                GetSymbol = Right(tmp(i), Len(tmp(i)) - 1)
            End If
        End If
    Next i
End Function

' Check wheter a string is a symbol or not
Private Function IsLabel(Str As String) As Boolean
    If Left(Str, 1) = "@" Then
        IsLabel = True
    Else
        IsLabel = False
    End If
End Function

' Check if a line has an instruction with operand which need to be handled as
' a relative operand
Private Function RelInstruction(Index As Integer) As Boolean
    RelInstruction = False
    With Lines(Index)
        Select Case .Instruction
            Case "j": RelInstruction = True
            Case "jmp"
                If IsLabel(.Operand(0)) Then RelInstruction = True
            Case "loop": RelInstruction = True
            Case "j": RelInstruction = True
            Case "call"
                If IsLabel(.Operand(0)) Then RelInstruction = True
        End Select
    End With
End Function

' As the name says... Include a file
Private Sub IncludeFile(Index As Integer, Filename As String)
    Dim Data As String, tmp() As String, ln As Integer: ln = 0
    Open Filename For Input As #1
        While Not EOF(1)
            Line Input #1, Data
            ln = ln + 1
            ErrLine = ln
            tmp = frmMain.ce.Parse(Data)
            If tmp(1) = "include" Then IncInSubinc = True: GoTo done
            AddLine tmp, ln, Right(Filename, Len(Filename) - InStrRev(Filename, "\"))
            If Not StringOk Then GoTo done
        Wend
done:
    Close #1
End Sub

' Get full filename
Public Function GetFilename(Str As String) As String
    If Left(Str, 1) = """" Then
        GetFilename = Mid(Str, 2, Len(Str) - 2)
    Else
        GetFilename = Str
    End If
    If Mid(Str, 2, 1) <> ":" Then
        GetFilename = CurDir() & "\" & GetFilename
    End If
End Function

' Pass one: read input file into an array of lines
Private Sub PassOne()
    Dim i As Integer, tmp() As String, x As String
    LineCount = 0: IncInSubinc = False: IncFileExist = True
    ReDim Preserve Lines(LineCount) As Line
    For i = 1 To frmMain.ce.NumOfLines
        ErrLine = i
        ErrFile = ""
        tmp = frmMain.ce.ParseLine(i)
        If tmp(1) = "include" Then
            If tmp(2) <> "1" Then OperandsOk = False: Exit Sub
            x = GetFilename(tmp(3))
            If Not FileExists(x) Then IncFileExist = False: Exit Sub
            ErrFile = tmp(3)
            IncludeFile i, x
            If IncInSubinc Then Exit Sub
            If Not StringOk Then Exit Sub
        Else
            AddLine tmp, i
            If SymX2 Then Exit Sub
        End If
    Next i
End Sub

' Pass two: get offsets of symbols
Private Sub PassTwo()
    Dim i As Integer, sz As Integer, ii As Integer
    CurrOffset = 0
    For i = 0 To LineCount - 1
        With Lines(i)
            ErrLine = .LineNumber
            ErrFile = .File
            .Offset = CurrOffset
            If .Instruction = "org" Then
                If .OperandCount <> 1 Then OperandsOk = False: Exit Sub
                If Not CheckHex(.Operand(0)) Then OperandsOk = False: Exit Sub
                CurrOffset = HexToWord(.Operand(0))
            ElseIf .Instruction = "rb" Then
                If .OperandCount <> 1 Then OperandsOk = False: Exit Sub
                If Not CheckHex(.Operand(0)) Then OperandsOk = False: Exit Sub
                CurrOffset = CurrOffset + HexToWord(.Operand(0))
                .Size = HexToWord(.Operand(0))
            ElseIf .Instruction <> "" And .Instruction <> "include" Then
                sz = TmpAsm(GenCode(i))
                If Not OperandsOk Then
                    For ii = 0 To .OperandCount - 1
                        If CheckHex(.Operand(ii)) And Len(.Operand(ii)) = 2 Then
                            .Operand(ii) = "00" & .Operand(ii)
                        End If
                    Next ii
                End If
                sz = TmpAsm(GenCode(i))
                CurrOffset = CurrOffset + sz
                .Size = sz
            End If
        End With
    Next i
End Sub

' Pass three: fix the operands (replace symbol references with the offset of the symbol)
Private Sub PassThree()
    Dim i As Integer, ii As Integer, iii As Integer, toff As Integer
    SymbolExist = True
    For i = 0 To LineCount - 1
        With Lines(i)
            ErrLine = .LineNumber
            ErrFile = .File
            If .Instruction <> "include" Then
                If .Label <> "" And .SubLabel = False Then CurrLabel = .Label
                For iii = 1 To .OperandCount
                    If GetSymbol(.Operand(iii - 1)) <> "" Then
                        SymbolExist = False
                        For ii = 0 To LineCount - 1
                            If Lines(ii).Label = GetSymbol(.Operand(iii - 1)) Then
                                toff = Lines(ii).Offset
                                If RelInstruction(i) Then toff = toff - .Offset - .Size
                                .Operand(iii - 1) = FixOperand(.Operand(iii - 1), toff, .Optimizeable)
                                SymbolExist = True
                                Exit For
                            End If
                        Next ii
                        If Not SymbolExist Then Exit Sub
                    End If
                Next iii
            End If
        End With
    Next i
End Sub

' Check if an instruction is one which doesn't output code or not ('rb' does in some cases, but this is handled other places)
Private Function EmptyInstruction(Index As Integer, CheckRest As Boolean) As Boolean
    Dim i As Integer
    EmptyInstruction = True
    For i = Index To IIf(CheckRest, LineCount - 1, Index)
        If Lines(i).Instruction <> "rb" And _
           Lines(i).Instruction <> "org" And _
           Lines(i).Instruction <> "include" And _
           Lines(i).Instruction <> "" Then
            EmptyInstruction = False
            Exit For
        End If
    Next i
End Function

' Pass four: the final pass which assembles the fnal code and outputs the result of each line to the output file
Private Sub PassFour()
    Dim i As Integer, ii As Integer, r() As Byte
    If FileExists(frmMain.cdlMake.Filename) Then Kill frmMain.cdlMake.Filename
    ValueInRange = True
    Open frmMain.cdlMake.Filename For Binary As #1
    For i = 0 To LineCount - 1
        With Lines(i)
            ErrLine = .LineNumber
            ErrFile = .File
            If Not EmptyInstruction(i, False) Then
                r = Assemble(CombCode(i))
                If Not InstructionOk Or Not OperandsOk Or Not MemoryOk Or Not SyntaxOk Then
                    Exit For
                End If
                For ii = 1 To UBound(r)
                    Put #1, , r(ii)
                Next ii
                BytesWritten = BytesWritten + UBound(r)
            ElseIf .Instruction = "rb" Then
                If i < LineCount - 1 Then
                    If Not EmptyInstruction(i + 1, True) Then
                        ReDim Preserve r(0) As Byte: r(0) = 0
                        For ii = 1 To .Size
                           Put #1, , r(0)
                           BytesWritten = BytesWritten + 1
                        Next ii
                    End If
                End If
            End If
        End With
    Next i
    Close #1
End Sub

' Return the index of the line where the offset equals 'Offset'
Public Function GetOffset(Offset As Integer) As Integer
    Dim i As Integer
    For i = 0 To LineCount - 1
        If Lines(i).Offset = Offset Then
            GetOffset = i
            Exit Function
        End If
    Next i
End Function


Attribute VB_Name = "modAsm"

' x86 Assembly Module
' Copyright © Tommy Lillehagen, 2004.
' All rights reserved.

Option Explicit

Private Type AsmItem
    Name As String
    Format() As String
    Pattern() As String
    Description As String
End Type

Public AI() As AsmItem, AICount As Integer
Private BitsToDel As Integer, BitsPos As Integer, result() As Byte, sResult As String
Public InstructionOk As Boolean, OperandsOk As Boolean, MemoryOk As Boolean, SyntaxOk As Boolean
Public lInstruction As String, lOperand1 As String, lOperand2 As String, NumBytes As Integer
Public lOp1i8 As Boolean, lOp2i8 As Boolean, lOp1i16 As Boolean, lOp2i16 As Boolean

' Add instruction and its bit patterns
Public Sub AddAI(Pattern As String, Desc As String)
    Dim i As Integer, l() As String, p() As String, tc As Integer, c() As String
    p = Split(Pattern, " ")
    l = Split(p(1), "|")
    ReDim Preserve AI(AICount) As AsmItem
    With AI(AICount)
        .Name = p(0)
        .Description = Desc
        tc = 0
        For i = 0 To UBound(l)
            tc = tc + 1
            ReDim Preserve .Format(tc) As String
            ReDim Preserve .Pattern(tc) As String
            If InStr(l(i), ":") Then
                c = Split(l(i), ":")
                .Format(i) = c(0)
                .Pattern(i) = c(1)
            Else
                .Format(i) = ""
                .Pattern(i) = l(i)
            End If
        Next i
    End With
    AICount = AICount + 1
End Sub

' Assemble code (with simple syntax) and return opcode
Public Function Assemble(Code As String) As Byte()
    ReDim Preserve result(0) As Byte
    Dim i As Integer, ii As Integer, tmp As String, ci As Integer
    Code = LCase(Code) & " "
    InstructionOk = False: OperandsOk = False: MemoryOk = True: SyntaxOk = True
    For i = 0 To UBound(AI)
        If AI(i).Name = Left(Code, InStr(Code, " ") - 1) Then
            InstructionOk = True
            For ii = 0 To UBound(AI(i).Format) - 1
                For ci = 0 To 7
                    ' some instructions require static operands (then the type of the operand
                    ' should not be used in the search for bit pattern), therefore first go through
                    ' and check if any of the patterns accept only static operands, one static and the
                    ' rest not ... and so on...
                    tmp = CodeToFormat(Trim(Code), FTypeToBit(ci))
                    If tmp = AI(i).Name & " " & AI(i).Format(ii) Then
                        Asm AI(i).Pattern(ii), AI(i).Format(ii), Trim(Code)
                        If UBound(result) > 0 Then OperandsOk = True
                        GoTo done
                    End If
                Next ci
            Next ii
        End If
    Next i
done:
    Assemble = result
End Function

' Check whether an assembly instruction (with operands) exists
Public Function AsmOk(Code As String) As Boolean
    Dim i As Integer, ii As Integer, tmp As String, ci As Integer
    AsmOk = False
    Code = LCase(Code) & " "
    For i = 0 To UBound(AI)
        If AI(i).Name = Left(Code, InStr(Code, " ") - 1) Then
            For ii = 0 To UBound(AI(i).Format) - 1
                For ci = 0 To 7
                    tmp = CodeToFormat(Trim(Code), FTypeToBit(ci))
                    If tmp = AI(i).Name & " " & AI(i).Format(ii) Then
                        AsmOk = True
                        Exit Function
                    End If
                Next ci
            Next ii
        End If
    Next i
End Function

' Disassemble inputted code and return an assembly statement
Public Function Disassemble(Code() As Byte) As String
    Dim i As Integer, ii As Integer
    For i = 0 To UBound(AI)
        For ii = 0 To UBound(AI(i).Format) - 1
            If DisAsm(i, ii, Code) Then GoTo done
        Next ii
    Next i
    sResult = "db " & ByteToHex(Code(0))
    lOp1i8 = True
    lOperand1 = ByteToHex(Code(0))
    NumBytes = 1
done:
    Disassemble = sResult
End Function

' Used in checking the use of static operands
Private Function FTypeToBit(Value As Integer) As String
    Select Case Value
        Case 0: FTypeToBit = "000"
        Case 1: FTypeToBit = "001"
        Case 2: FTypeToBit = "010"
        Case 3: FTypeToBit = "011"
        Case 4: FTypeToBit = "100"
        Case 5: FTypeToBit = "101"
        Case 6: FTypeToBit = "110"
        Case 7: FTypeToBit = "111"
    End Select
End Function

' Convert a string of bits to its byte value
Private Function BitToByte(b As String) As Byte
    Dim i As Integer, x As Byte
    BitToByte = 0: x = 128
    For i = 1 To 8
        If Mid(b, i, 1) = "1" Then
            BitToByte = BitToByte + x
        End If
        x = x / 2
    Next i
End Function

' Convert a byte to a string of bits
Private Function ByteToBit(b As Byte) As String
    ByteToBit = "00000000"
    If b And 1 Then Mid$(ByteToBit, 8, 1) = "1"
    If b And 2 Then Mid$(ByteToBit, 7, 1) = "1"
    If b And 4 Then Mid$(ByteToBit, 6, 1) = "1"
    If b And 8 Then Mid$(ByteToBit, 5, 1) = "1"
    If b And 16 Then Mid$(ByteToBit, 4, 1) = "1"
    If b And 32 Then Mid$(ByteToBit, 3, 1) = "1"
    If b And 64 Then Mid$(ByteToBit, 2, 1) = "1"
    If b And 128 Then Mid$(ByteToBit, 1, 1) = "1"
End Function

' Check if a string contains a hexadecimal value
Public Function CheckHex(Str As String) As Boolean
    Dim i As Integer
    CheckHex = True
    If Len(Str) <> 2 And Len(Str) <> 4 Then CheckHex = False: Exit Function
    For i = 1 To Len(Str)
        If InStr("0123456789abcdef", LCase(Mid(Str, i, 1))) = 0 Then
            CheckHex = False
        End If
    Next i
End Function

' Add byte to result of assembly process
Private Function AddByte(Bits As String) As String
    ReDim Preserve result(UBound(result) + 1) As Byte
    result(UBound(result)) = BitToByte(Bits)
End Function

' Convert code to format (e.g. "mov ah,09" => "mov r8,i8" and "in al,15" => "in al,i8" [this is because
' 'al' is found first in the patterns => static operand instead of type]
Private Function CodeToFormat(Code As String, SetX As String) As String
    Dim tmp() As String, i As Integer, p As String
    If InStr(Code, " ") Then
        tmp = Split(Code, " ")
        CodeToFormat = tmp(0) & " "
        If InStr(tmp(1), ",") Then
            tmp = Split(tmp(1), ",")
            p = ""
            For i = 0 To UBound(tmp)
                CodeToFormat = CodeToFormat & p & IIf(Mid(SetX, i + 1, 1) = "1", GetFormat(tmp(i)), tmp(i))
                p = ","
            Next i
        Else
            CodeToFormat = CodeToFormat & IIf(Left(SetX, 1) = "1", GetFormat(tmp(1)), tmp(1))
        End If
    Else
        CodeToFormat = Code & " "
    End If
End Function

' Get format of a single operand (e.g. "b[si]" => "m8")
Private Function GetFormat(Str As String) As String
    If R8ToBit(Str) <> "" Then
        GetFormat = "r8"
    ElseIf R16ToBit(Str) <> "" Then
        GetFormat = "r16"
    ElseIf CCToBit(Str) <> "" Then
        GetFormat = "cc"
    ElseIf SRegToBit(Str) <> "" Then
        GetFormat = "sr"
    ElseIf Left(Str, 2) = "b[" Then
        GetFormat = "m8"
    ElseIf Left(Str, 2) = "w[" Then
        GetFormat = "m16"
    ElseIf Len(Str) = 2 And CheckHex(Str) Then
        GetFormat = "i8"
    ElseIf Len(Str) = 4 And CheckHex(Str) Then
        GetFormat = "i16"
    Else
        SyntaxOk = False
    End If
End Function

' Convert a 8-bit register to a string of bits
Private Function R8ToBit(Str As String) As String
    Select Case Str
        Case "al": R8ToBit = "000"
        Case "cl": R8ToBit = "001"
        Case "dl": R8ToBit = "010"
        Case "bl": R8ToBit = "011"
        Case "ah": R8ToBit = "100"
        Case "ch": R8ToBit = "101"
        Case "dh": R8ToBit = "110"
        Case "bh": R8ToBit = "111"
    End Select
End Function

' Convert a 16-bit register to a string of bits
Private Function R16ToBit(Str As String) As String
    Select Case Str
        Case "ax": R16ToBit = "000"
        Case "cx": R16ToBit = "001"
        Case "dx": R16ToBit = "010"
        Case "bx": R16ToBit = "011"
        Case "sp": R16ToBit = "100"
        Case "bp": R16ToBit = "101"
        Case "si": R16ToBit = "110"
        Case "di": R16ToBit = "111"
    End Select
End Function

' Convert a segment register to a string of bits
Private Function SRegToBit(Str As String) As String
    Select Case Str
        Case "es": SRegToBit = "000"
        Case "cs": SRegToBit = "001"
        Case "ss": SRegToBit = "010"
        Case "ds": SRegToBit = "011"
        Case "fs": SRegToBit = "100"
        Case "gs": SRegToBit = "101"
    End Select
End Function

' Convert a condition (used in coditional jumps etc.) to a string of bits
Private Function CCToBit(Str As String) As String
    If Str = "o" Then
        CCToBit = "0000"
    ElseIf Str = "no" Then
        CCToBit = "0001"
    ElseIf Str = "b" Or Str = "nae" Then
        CCToBit = "0010"
    ElseIf Str = "nb" Or Str = "ae" Then
        CCToBit = "0011"
    ElseIf Str = "z" Or Str = "e" Then
        CCToBit = "0100"
    ElseIf Str = "nz" Or Str = "ne" Then
        CCToBit = "0101"
    ElseIf Str = "na" Or Str = "be" Then
        CCToBit = "0110"
    ElseIf Str = "a" Or Str = "nbe" Then
        CCToBit = "0111"
    ElseIf Str = "s" Then
        CCToBit = "1000"
    ElseIf Str = "ns" Then
        CCToBit = "1001"
    ElseIf Str = "p" Or Str = "pe" Then
        CCToBit = "1010"
    ElseIf Str = "np" Or Str = "po" Then
        CCToBit = "1011"
    ElseIf Str = "l" Or Str = "nge" Then
        CCToBit = "1100"
    ElseIf Str = "nl" Or Str = "ge" Then
        CCToBit = "1101"
    ElseIf Str = "ng" Or Str = "le" Then
        CCToBit = "1110"
    ElseIf Str = "g" Or Str = "nle" Then
        CCToBit = "1111"
    End If
End Function

' Convert a memory operand to a string of bits
Private Function MemToBit(Str As String) As String
    Dim reg As String, mode As String, disp As String
    Dim tmp() As String, Pos As Integer, rm As String
    tmp = Split(Mid(Str, 3, Len(Str) - 3), "+")
    rm = tmp(0): Pos = 1: disp = ""
    If UBound(tmp) > 0 Then
        If (tmp(0) = "bx" Or tmp(0) = "bp") And (tmp(1) = "si" Or tmp(1) = "di") Then
            rm = rm & "+" & tmp(1)
            Pos = 2
        End If
        If UBound(tmp) = Pos Then
            disp = tmp(Pos)
        End If
    End If
    If disp = "" Then
        mode = "00"
    ElseIf Len(disp) = 2 Then
        mode = "01"
    ElseIf Len(disp) = 4 Then
        mode = "10"
    Else
        MemoryOk = False
    End If
    Select Case rm
        Case "bx+si": reg = "000"
        Case "bx+di": reg = "001"
        Case "bp+si": reg = "010"
        Case "bp+di": reg = "011"
        Case "si": reg = "100"
        Case "di": reg = "101"
        Case "bp"
            reg = "110"
            If disp = "" Then mode = "01": disp = "00"
        Case "bx": reg = "111"
        Case Else
            If Len(rm) = 4 Then
                reg = "110": mode = "00"
                disp = rm
            Else
                MemoryOk = False
            End If
    End Select
    If Len(disp) = 4 Then
        disp = ByteToBit(Val("&H" & Right(disp, 2))) & ByteToBit(Val("&H" & Left(disp, 2)))
    ElseIf Len(disp) = 2 Then
        disp = ByteToBit(Val("&H" & disp))
    Else
        disp = ""
    End If
    MemToBit = mode & reg & disp
End Function

' Convert a string of bits to a 8-bit register
Private Function BitToR8(Str As String) As String
    Select Case Str
        Case "000": BitToR8 = "al"
        Case "001": BitToR8 = "cl"
        Case "010": BitToR8 = "dl"
        Case "011": BitToR8 = "bl"
        Case "100": BitToR8 = "ah"
        Case "101": BitToR8 = "ch"
        Case "110": BitToR8 = "dh"
        Case "111": BitToR8 = "bh"
    End Select
End Function

' Convert a string of bits to a 16-bit register
Private Function BitToR16(Str As String) As String
    Select Case Str
        Case "000": BitToR16 = "ax"
        Case "001": BitToR16 = "cx"
        Case "010": BitToR16 = "dx"
        Case "011": BitToR16 = "bx"
        Case "100": BitToR16 = "sp"
        Case "101": BitToR16 = "bp"
        Case "110": BitToR16 = "si"
        Case "111": BitToR16 = "di"
    End Select
End Function

' Convert a string of bits to a segment register
Private Function BitToSReg(Str As String) As String
    Select Case Str
        Case "000": BitToSReg = "es"
        Case "001": BitToSReg = "cs"
        Case "010": BitToSReg = "ss"
        Case "011": BitToSReg = "ds"
        Case "100": BitToSReg = "fs"
        Case "101": BitToSReg = "gs"
    End Select
End Function

' Convert a string of bits to a condition
Private Function BitToCC(Str As String) As String
    Select Case Str
        Case "0000": BitToCC = "o"
        Case "0001": BitToCC = "no"
        Case "0010": BitToCC = "b"
        Case "0011": BitToCC = "nb"
        Case "0100": BitToCC = "z"
        Case "0101": BitToCC = "nz"
        Case "0110": BitToCC = "na"
        Case "0111": BitToCC = "a"
        Case "1000": BitToCC = "s"
        Case "1001": BitToCC = "ns"
        Case "1010": BitToCC = "p"
        Case "1011": BitToCC = "np"
        Case "1100": BitToCC = "l"
        Case "1101": BitToCC = "nl"
        Case "1110": BitToCC = "ng"
        Case "1111": BitToCC = "g"
    End Select
End Function

' Convert a string of bits to a memory operand
Private Function BitToMem(Str As String, pre As String) As String
    Dim mode As String, reg As String, disp As String
    mode = Left(Str, 2)
    reg = Mid(Str, 3, 3)
    If Len(Str) > 5 Then disp = Mid(Str, 6)
    Select Case reg
        Case "000": BitToMem = "bx+si"
        Case "001": BitToMem = "bx+di"
        Case "010": BitToMem = "bp+si"
        Case "011": BitToMem = "bp+di"
        Case "100": BitToMem = "si"
        Case "101": BitToMem = "di"
        Case "110": BitToMem = "bp"
        Case "111": BitToMem = "bx"
    End Select
    BitToMem = pre & "[" & BitToMem
    If Mid(BitToMem, 2) = "[bp" And mode = "00" Then
        BitToMem = pre & "[" & BitToHex(disp) & "]"
        BitsToDel = 16
        Exit Function
    ElseIf mode = "00" Then
        BitToMem = BitToMem & "]"
        BitsToDel = 0
    Else
        If mode = "01" Then
            disp = Left(disp, 8): BitsToDel = 8
        Else
            BitsToDel = 16
        End If
        BitToMem = BitToMem & "+" & BitToHex(disp) & "]"
    End If
End Function

' Convert a hexadecimal value (string) to string of bits
Private Function HexToBit(Value As String) As String
    If Len(Value) = 2 Then
        HexToBit = ByteToBit(Val("&H" & Value))
    ElseIf Len(Value) = 4 Then
        HexToBit = ByteToBit(Val("&H" & Right(Value, 2))) & ByteToBit(Val("&H" & Left(Value, 2)))
    End If
End Function

' Convert a byte to a hexadecimal value (string)
Private Function ByteToHex(Value As Byte) As String
    ByteToHex = IIf(Len(Hex(Value)) = 1, "0" & Hex(Value), Hex(Value))
End Function

' Convert a string of bits to a hexadecimal value (string)
Private Function BitToHex(Value As String) As String
    If Len(Value) = 8 Then
        BitToHex = ByteToHex(BitToByte(Value))
    ElseIf Len(Value) = 16 Then
        BitToHex = ByteToHex(BitToByte(Right(Value, 8))) & ByteToHex(BitToByte(Left(Value, 8)))
    End If
End Function

' Convert an operand to string of bits (input: the code e.g. "ah" and the format "r8")
Private Function CodeToBit(Code As String, Format As String) As String
    Select Case Format
        Case "r8": CodeToBit = R8ToBit(Code)
        Case "r16": CodeToBit = R16ToBit(Code)
        Case "i8": CodeToBit = HexToBit(Code)
        Case "i16": CodeToBit = HexToBit(Code)
        Case "m8": CodeToBit = MemToBit(Code)
        Case "m16": CodeToBit = MemToBit(Code)
        Case "sr": CodeToBit = SRegToBit(Code)
        Case "cc": CodeToBit = CCToBit(Code)
        Case Else
            If R8ToBit(Code) <> "" Then
                CodeToBit = R8ToBit(Code)
            ElseIf R16ToBit(Code) <> "" Then
                CodeToBit = R16ToBit(Code)
            ElseIf SRegToBit(Code) <> "" Then
                CodeToBit = SRegToBit(Code)
            ElseIf CCToBit(Code) <> "" Then
                CodeToBit = CCToBit(Code)
            End If
    End Select
End Function

' Convert a string of bits to an operand
Private Function CodeFromBit(Code As String, Format As String) As String
    Select Case Format
        Case "r8": CodeFromBit = BitToR8(Code)
        Case "r16": CodeFromBit = BitToR16(Code)
        Case "i8": CodeFromBit = "$" & BitToHex(Code)
        Case "i16": CodeFromBit = "$" & BitToHex(Code)
        Case "m8": CodeFromBit = BitToMem(Code, "b")
        Case "m16": CodeFromBit = BitToMem(Code, "w")
        Case "sr": CodeFromBit = BitToSReg(Code)
        Case "cc": CodeFromBit = BitToCC(Code)
        Case Else
            If BitToR8(Code) <> "" Then
                CodeFromBit = BitToR8(Code)
            ElseIf BitToR16(Code) <> "" Then
                CodeFromBit = BitToR16(Code)
            ElseIf BitToSReg(Code) <> "" Then
                CodeFromBit = BitToSReg(Code)
            ElseIf BitToCC(Code) <> "" Then
                CodeFromBit = BitToCC(Code)
            End If
    End Select
End Function

' Get part of a string of bits ('Extra' is for use when code contains a displacement)
' (e.g. Code: "00111001", Pattern: "00aaabbb", Char: "a" => Result: "111")
Private Function BitFromCode(Code As String, Pattern As String, Char As String, Optional Extra As Integer = 0) As String
    Dim i As Integer, lmem As Integer
    If Len(Code) < Len(Pattern) + Extra Then Code = Code & "0000000000000000"
    If InStr(Pattern, Char) Then
        For i = 1 To Len(Code)
            If Mid(Pattern, i, 1) = Char Then
                BitFromCode = BitFromCode & Mid(Code, i, 1)
                lmem = i + 1
            End If
        Next i
        BitFromCode = BitFromCode & Mid(Code, lmem, Extra)
        BitsPos = lmem
    Else
        BitFromCode = ""
    End If
End Function

' Replace characters in pattern with the character at the same position in value and return the result
Private Function BitToPattern(Pattern As String, Value As String, Char As String) As String
    Dim i As Integer, ii As Integer, lmem As Integer
    ii = 1
    If InStr(Pattern, Char) Then
        For i = 1 To Len(Pattern)
            If Mid(Pattern, i, 1) = Char Then
                BitToPattern = BitToPattern & Mid(Value, ii, 1)
                ii = ii + 1
                lmem = i
            Else
                BitToPattern = BitToPattern & Mid(Pattern, i, 1)
            End If
        Next i
        If ii < Len(Value) Then BitToPattern = Left(BitToPattern, lmem) & Mid(Value, ii) & Right(BitToPattern, Len(BitToPattern) - lmem)
    Else
        BitToPattern = Pattern
    End If
End Function

' Called from Assemble. This assembles a code when pattern and format is given (these are set from Assemble)
Private Sub Asm(Pattern As String, Format As String, Code As String)
    Dim tfrm() As String, tcod() As String, i As Integer, res As String
    res = Pattern
    If Format <> "" Then
        If InStr(Format, ",") Then
            tfrm = Split(Format, ",")
            tcod = Split(Right(Code, Len(Code) - InStr(Code, " ")), ",")
            tcod(0) = CodeToBit(tcod(0), tfrm(0))
            tcod(1) = CodeToBit(tcod(1), tfrm(1))
            If UBound(tcod) = 2 Then tcod(2) = CodeToBit(tcod(2), tfrm(2))
        Else
            ReDim Preserve tfrm(0) As String
            ReDim Preserve tcod(0) As String
            tfrm(0) = Format
            tcod(0) = CodeToBit(Right(Code, Len(Code) - InStr(Code, " ")), Format)
        End If
        For i = 0 To UBound(tcod)
            res = BitToPattern(res, tcod(i), Chr(Asc("a") + i))
        Next i
    End If
    For i = 1 To Len(res) - 1 Step 8
        AddByte Mid(res, i, 8)
    Next i
End Sub

' Works in the same way as Asm, but this disassembles of course :)
Private Function DisAsm(x As Integer, xx As Integer, c() As Byte) As Boolean
    Dim tmp As String, i As Integer, f() As String, ops As String
    Dim pchar As String
    tmp = "": pchar = "": DisAsm = False: BitsToDel = 0
    For i = 0 To UBound(c)
        tmp = tmp & ByteToBit(c(i))
    Next i
    If Len(tmp) < Len(AI(x).Pattern(xx)) Then Exit Function
    For i = 1 To Len(AI(x).Pattern(xx))
        If Mid(AI(x).Pattern(xx), i, 1) = "0" Or Mid(AI(x).Pattern(xx), i, 1) = "1" Then
            If Mid(AI(x).Pattern(xx), i, 1) <> Mid(tmp, i, 1) Then Exit Function
        End If
    Next i
    DisAsm = True
    lInstruction = AI(x).Name
    If AI(x).Format(xx) <> "" Then
        f = Split(AI(x).Format(xx), ",")
        lOp1i8 = False: lOp1i16 = False: lOp2i8 = False: lOp2i16 = False
        For i = 0 To UBound(f)
            If i = 0 Then
                lOp1i8 = (f(i) = "i8")
                lOp1i16 = (f(i) = "i16")
            End If
            If i = 1 Then
                lOp2i8 = (f(i) = "i8")
                lOp2i16 = (f(i) = "i16")
            End If
            If f(i) = "m8" Or f(i) = "m16" Then
                f(i) = CodeFromBit(BitFromCode(tmp, AI(x).Pattern(xx), Chr(Asc("a") + i), 16), f(i))
                tmp = Left(tmp, BitsPos - 1) & Mid(tmp, BitsPos + BitsToDel)
            ElseIf Left(f(i), 1) = "r" Or Left(f(i), 1) = "i" Or f(i) = "sr" Or f(i) = "cc" Then
                f(i) = CodeFromBit(BitFromCode(tmp, AI(x).Pattern(xx), Chr(Asc("a") + i)), f(i))
            End If
            ops = ops & pchar & f(i)
            pchar = ","
            If i = 0 Then lOperand1 = f(i)
            If i = 1 Then lOperand2 = f(i)
        Next i
    End If
    sResult = Trim(AI(x).Name & " " & ops)
    NumBytes = (Len(AI(x).Pattern(xx)) + BitsToDel) / 8
End Function


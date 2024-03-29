Attribute VB_Name = "modX86"

' x86 (16 bit) Instruction Set
' Copyright © Tommy Lillehagen, 2004.
' All rights reserved.

Option Explicit

' Add all the instrcutions, their bit patterns and their descriptions
Public Sub InitAsm()
    AddAI "aaa 00110111", "ASCII Adjust after Addition"
    AddAI "aad 1101010100001010", "ASCII Adjust AX before Division"
    AddAI "aam 1101010000001010", "ASCII Adjust AX after Multiply"
    AddAI "aas 00111111", "ASCII Adjust AL after Subtraction"
    AddAI "adc r8,r8:0001000011bbbaaa|r16,r16:0001000111bbbaaa|r8,r8:0001001011aaabbb|r16,r16:0001001111aaabbb|al,i8:00010100bbbbbbbb|ax,i16:00010101bbbbbbbbbbbbbbbb|r8,i8:1000000011010aaabbbbbbbb|r16,i16:1000000111010aaabbbbbbbbbbbbbbbb|m8,i8:10000000aa010aaabbbbbbbb|m16,i16:10000001aa010aaabbbbbbbbbbbbbbbb|m8,r8:00010000aabbbaaa|m16,r16:00010001aabbbaaa|r8,m8:00010010bbaaabbb|r16,m16:00010011bbaaabbb", "Add with Carry"
    AddAI "add r8,r8:0000000011bbbaaa|r16,r16:0000000111bbbaaa|r8,r8:0000001011aaabbb|r16,r16:0000001111aaabbb|al,i8:00000100bbbbbbbb|ax,i16:00000101bbbbbbbbbbbbbbbb|r8,i8:1000000011000aaabbbbbbbb|r16,i16:1000000111000aaabbbbbbbbbbbbbbbb|m8,i8:10000000aa000aaabbbbbbbb|m16,i16:10000001aa000aaabbbbbbbbbbbbbbbb|m8,r8:00000000aabbbaaa|m16,r16:00000001aabbbaaa|r8,m8:00000010bbaaabbb|r16,m16:00000011bbaaabbb", "Add"
    AddAI "and r8,r8:0010000011bbbaaa|r16,r16:0010000111bbbaaa|r8,r8:0010001011aaabbb|r16,r16:0010001111aaabbb|al,i8:00100100bbbbbbbb|ax,i16:00100101bbbbbbbbbbbbbbbb|r8,i8:1000000011100aaabbbbbbbb|r16,i16:1000000111100aaabbbbbbbbbbbbbbbb|m8,i8:10000000aa100aaabbbbbbbb|m16,i16:10000001aa100aaabbbbbbbbbbbbbbbb|m8,r8:00100000aabbbaaa|m16,r16:00100001aabbbaaa|r8,m8:00100010bbaaabbb|r16,m16:00100011bbaaabbb", "Logical And"
    AddAI "arpl r16,r16:0110001111bbbaaa|m16,r16:01100011aabbbaaa", "Adjust RPL Field of Selector"
    AddAI "bound r16,m16:01100010bbaaabbb", "Check Array Againt Bounds"
    AddAI "bsf r16,r16:000011111011110011aaabbb|m16,r16:0000111110111100aabbbaaa", "Bit Scan Forward"
    AddAI "bsr r16,r16:000011111011110111aaabbb|m16,r16:0000111110111101aabbbaaa", "Bit Scan Reverse"
    AddAI "bt r16,r16:000011111010001111bbbaaa|m8,i8:0000111110111010aa100aaabbbbbbbb|r16,i8:000011111011101011100aaabbbbbbbb|m16,r16:0000111110100011aabbbaaa", "Bit Test"
    AddAI "btc r16,r16:000011111011101111bbbaaa|m8,i8:0000111110111010aa111aaabbbbbbbb|r16,i8:000011111011101011111aaabbbbbbbb|m16,r16:0000111110111011aabbbaaa", "Bit Test and Complement"
    AddAI "btr r16,r16:000011111011001111bbbaaa|m8,i8:0000111110111010aa110aaabbbbbbbb|r16,i8:000011111011101011110aaabbbbbbbb|m16,r16:0000111110110011aabbbaaa", "Bit Test and Reset"
    AddAI "bts r16,r16:000011111010101111bbbaaa|m8,i8:0000111110111010aa101aaabbbbbbbb|r16,i8:000011111011101011101aaabbbbbbbb|m16,r16:0000111110101011aabbbaaa", "Bit Test and Set"
    AddAI "call i16:11101000aaaaaaaaaaaaaaaa|r16:1111111111010aaa|m16:11111111aa010aaa", "Call procedure (in same segment)"
    AddAI "callf i16,i16:10011010aaaaaaaaaaaaaaaabbbbbbbbbbbbbbbb|m16:11111111aa011aaa", "Call procedure (in other segment)"
    AddAI "cbw 10011000", "Convert Byte to Word"
    AddAI "clc 11111000", "Clear Carry Flag"
    AddAI "cld 11111100", "Clear Direction Flag"
    AddAI "cli 11111010", "Clear Interrupt Flag"
    AddAI "clts 0000111100000110", "Clear Task-Switched Flag in CR0"
    AddAI "cmc 11110101", "Complement Carry Flag"
    AddAI "cmp r8,r8:0011100011bbbaaa|r16,r16:0011100111bbbaaa|r8,r8:0011101011aaabbb|r16,r16:0011101111aaabbb|al,i8:00111100bbbbbbbb|ax,i16:00111101bbbbbbbbbbbbbbbb|r8,i8:1000000011111aaabbbbbbbb|r16,i16:1000000111111aaabbbbbbbbbbbbbbbb|m8,i8:10000000aa111aaabbbbbbbb|m16,i16:10000001aa111aaabbbbbbbbbbbbbbbb|m8,r8:00111000aabbbaaa|m16,r16:00111001aabbbaaa|r8,m8:00111010bbaaabbb|r16,m16:00111011bbaaabbb", "Compare Two Operands"
    AddAI "cmpsb 10100110", "Compare String Operands"
    AddAI "cmpsw 10100111", "Compare String Operands"
    AddAI "cpuid 0000111110100010", "CPU Identification"
    AddAI "cwd 10011001", "Convert Word to Doubleword"
    AddAI "cwde 10011000", "Convert Word to Doubleword"
    AddAI "daa 00100111", "Decimal Adjust AL after Addition"
    AddAI "das 00101111", "Decimal Adjust AL after Subtraction"
    AddAI "dec r8:1111111011001aaa|r16:01001aaa|m8:11111110aa001aaa|m16:11111111aa001aaa", "Decrement by 1"
    AddAI "div r8:1111011011110aaa|r16:1111011111110aaa|m8:11110110aa110aaa|m16:11110111aa110aaa", "Unsigned Divide"
    AddAI "enter imm16,imm8:11001000aaaaaaaaaaaaaaaabbbbbbbb", "Make Stack Frame for HL Procedure"
    AddAI "hlt 11110100", "Halt"
    AddAI "idiv r8:1111011011111aaa|r16:1111011111111aaa|m8:11110110aa111aaa|m16:11110111aa111aaa", "Signed Divide"
    AddAI "imul r8:1111011011101bbb|r16:1111011111101bbb|m8:11110110bb101bbb|m16:11110111bb101bbb|r16,r16:000011111010111111bbbaaa|m16,r16:0000111110101111aabbbaaa", "Signed Multiply"
    AddAI "in al,i8:11100100bbbbbbbb|ax,i8:11100101bbbbbbbb|al,dx:11101100|ax,dx:11101101", "Input From Port"
    AddAI "inc r8:1111111011000aaa|r16:01000aaa|m8:11111110aa000aaa|m16:11111111aa000aaa", "Increment by 1"
    AddAI "insb 01101100", "Input from DX Port"
    AddAI "insw 01101101", "Input from DX Port"
    AddAI "int i8:11001101aaaaaaaa", "Interrupt Type n"
    AddAI "into 11001110", "Interrupt 4 on Overflow"
    AddAI "iret 11001111", "Interrupt Return"
    AddAI "j cc,i8:0111aaaabbbbbbbb|cc,i16:000011111000aaaabbbbbbbbbbbbbbbb", "Jump if Codition is met"
    AddAI "jcxz i8:11100011aaaaaaaa", "Jump on CX Zero"
    AddAI "jmp i8:11101011aaaaaaaa|i16:11101001aaaaaaaaaaaaaaaa|r16:1111111111100aaa|m16:11111111aa100aaa", "Jump (in same segment)"
    AddAI "jmpf i16,i16:11101010aaaaaaaaaaaaaaaabbbbbbbbbbbbbbbb|mem16:11111111aa101aaa", "Jump (in other segment)"
    AddAI "lahf 10011111", "Load Flags into AH Register"
    AddAI "lar r16,r16:000011110000001011aaabbb|r16,m16:0000111100000010bbaaabbb", "Load Access Rights Byte"
    AddAI "lea r16,m16:10001101bbaaabbb", "Load Effective Address"
    AddAI "leave 11001001", "HL Procedure Exit"
    AddAI "lgdt m16:0000111100000001aa010aaa", "Load Global Descriptor Table Register"
    AddAI "lidt m16:0000111100000001aa110aaa", "Load Interrupt Descriptor Table Register"
    AddAI "lldt r16:000011110000000011010aaa|m16:0000111100000000aa010aaa", "Load Loval Descriptor Table Register"
    AddAI "lds r16,m16:11000101bbaaabbb", "Load Pointer to DS"
    AddAI "les r16,m16:11000100bbaaabbb", "Load Pointer to ES"
    AddAI "lfs r16,m16:0000111110110100bbaaabbb", "Load Pointer to FS"
    AddAI "lgs r16,m16:0000111110110101bbaaabbb", "Load Pointer to GS"
    AddAI "lss r16,m16:0000111110110010bbaaabbb", "Load Pointer to SS"
    AddAI "lmsw r16:000011110000000111110aaa|m16:0000111100000001aa110aaa", "Load Machine Status Word"
    AddAI "lock 11110000", "Assert LOCK# Signal Prefix"
    AddAI "lodsb 10101100", "Load String Operand"
    AddAI "lodsw 10101101", "Load String Operand"
    AddAI "loop i8:11100010aaaaaaaa", "Loop Count"
    AddAI "loopz i8:11100001aaaaaaaa", "Loop Count while Zero"
    AddAI "loope i8:11100001aaaaaaaa", "Loop Count while Equal"
    AddAI "loopnz i8:11100000aaaaaaaa", "Loop Count while not Zero"
    AddAI "loopne i8:11100000aaaaaaaa", "Loop Count while not Equal"
    AddAI "lsl r16,r16:000011110000001111aaabbb|r16,m16:0000111100000011bbaaabbb", "Load Segment Limit"
    AddAI "ltr r16:000011110000000011011aaa|m16:0000111100000000aa011aaa", "Load Task Register"
    AddAI "mov r8,r8:1000100011bbbaaa|r8,r8:1000101011aaabbb|r16,r16:1000100111bbbaaa|r16,r16:1000101111aaabbb|r8,i8:10110aaabbbbbbbb|r16,i16:10111aaabbbbbbbbbbbbbbbb|r8,i8:1100011011000aaabbbbbbbb|r16,i16:1100011111000aaabbbbbbbbbbbbbbbb|r8,m8:10001010bbaaabbb|r16,m16:10001011bbaaabbb|m8,r8:10001000bbaaabbb|m16,r16:10001001bbaaabbb|m8,i8:11000110aa000aaabbbbbbbb|m16,i16:11000111aa000aaabbbbbbbbbbbbbbbb|sr,r16:1000111011aaabbb|sr,m16:10001110bbaaabbb|r16,sr:1000110011bbbaaa|r16,m16:10001100bbaaabbb", "Move Data"
    AddAI "movm al,i16:10100000bbbbbbbbbbbbbbbb|ax,i16:10100001bbbbbbbbbbbbbbbb|i16,al:10100010aaaaaaaaaaaaaaaa|i16,ax:10100011aaaaaaaaaaaaaaaa", "Move Memory(disp16 only) <-> Accumulator"
    AddAI "movsb 10100100", "Move Data from String to String"
    AddAI "movsw 10100101", "Move Data from String to String"
    AddAI "movsx r8,r8:000011111011111011aaabbb|r16,r16:000011111011111111aaabbb|r8,m8:0000111110111110bbaaabbb|r16,m16:0000111110111111bbaaabbb", "Move with Sign-Extend"
    AddAI "movzx r8,r8:000011111011011011aaabbb|r16,r16:000011111011011111aaabbb|r8,m8:0000111110110110bbaaabbb|r16,m16:0000111110110111bbaaabbb", "Move with Zero-Extend"
    AddAI "mul r8:1111011011100aaa|r16:1111011111100aaa|m8:11110110aa100aaa|m16:11110111aa100aaa", "Unsigned Multiply"
    AddAI "neg r8:1111011011011aaa|r16:1111011111011aaa|m8:11110110aa011aaa|m16:11110111aa011aaa", "Two's Complement Negation"
    AddAI "nop 10010000", "No Operation"
    AddAI "not r8:1111011011010aaa|r16:1111011111010aaa|m8:11110110aa010aaa|m16:11110111aa010aaa", "One's Complement Negation"
    AddAI "or r8,r8:0000100011bbbaaa|r16,r16:0000100111bbbaaa|r8,r8:0000101011aaabbb|r16,r16:0000101111aaabbb|m8,i8:10000000aa001aaabbbbbbbb|m16,i16:10000001aa001aaabbbbbbbbbbbbbbbb|r8,m8:00001010bbaaabbb|r16,m16:00001011bbaaabbb|m8,r8:00001000aabbbaaa|m16,r16:00001001aabbbaaa|al,i8:00001100bbbbbbbb|ax,i16:00001101bbbbbbbbbbbbbbbb|r8,i8:1000000011001aaabbbbbbbb|r16,i16:1000000111001aaabbbbbbbbbbbbbbbb", "Logical Inclusive OR"
    AddAI "out dx,al:11101110|dx,ax:11101111|i8,al:11100110aaaaaaaa|i8,ax:11100111aaaaaaaa", "Output to Port"
    AddAI "outsb 01101110", "Output to DX Port"
    AddAI "outsw 01101111", "Output to DX Port"
    AddAI "pop r16:01011aaa|r16:1000111111000aaa|m16:10001111aa000aaa|cs:00000000|ds:00011111|es:00000111|ss:00010111|sr:0000111110aaa001", "Pop a Word/Segment Register from the Stack"
    AddAI "popa 01100001", "Pop All General Registers"
    AddAI "popf 10011101", "Pop Stack into FLAGS Register"
    AddAI "push r16:01010aaa|r16:1111111111110aaa|m16:11111111aa110aaa|i16:01101000aaaaaaaaaaaaaaaa|cs:00001110|ds:00011110|es:00000110|ss:00010110|sr:0000111110aaa000", "Push Operand/Segment Register onto the Stack"
    AddAI "pusha 01100000", "Push All General Registers"
    AddAI "pushf 10011100", "Push FLAGS Register onto the Stack"
    AddAI "rcl r8:1101000011010aaa|r16:1101000111010aaa|r8,cl:1101001011010aaa|r16,cl:1101001111010aaa|r8,i8:1100000011010aaabbbbbbbb|r16,i8:1100000111010aaabbbbbbbb|m8,i8:11000000aa010aaabbbbbbbb|m16,i8:11000001aa010aaabbbbbbbb|m8,cl:11010010aa010aaa|m16,cl:11010011aa010aaa|m8:11010000aa010aaa|m16:11010001aa010aaa", "Rotate thru Carry Left"
    AddAI "rcr r8:1101000011011aaa|r16:1101000111011aaa|r8,cl:1101001011011aaa|r16,cl:1101001111011aaa|r8,i8:1100000011011aaabbbbbbbb|r16,i8:1100000111011aaabbbbbbbb|m8,i8:11000000aa011aaabbbbbbbb|m16,i8:11000001aa010aaabbbbbbbb|m8,cl:11010010aa011aaa|m16,cl:11010011aa011aaa|m8:11010000aa011aaa|m16:11010001aa011aaa", "Rotate thru Carry Right"
    AddAI "rep_insb 1111001101101100", "Input String"
    AddAI "rep_insw 1111001101101101", "Input String"
    AddAI "rep_lodsb 1111001110101100", "Load String"
    AddAI "rep_lodsw 1111001110101101", "Load String"
    AddAI "rep_movsb 1111001110100100", "Move String"
    AddAI "rep_movsw 1111001110100101", "Move String"
    AddAI "rep_outsb 1111001101101110", "Output String"
    AddAI "rep_outsw 1111001101101111", "Output String"
    AddAI "rep_stosb 1111001110101010", "Store String"
    AddAI "rep_stosw 1111001110101011", "Store String"
    AddAI "repe_cmpsb 1111001110100110", "Compare String"
    AddAI "repe_cmpsw 1111001110100111", "Compare String"
    AddAI "repe_scasb 1111001110101110", "Scan String"
    AddAI "repe_scasw 1111001110101111", "Scan String"
    AddAI "repne_cmpsb 1111001010100110", "Compare String"
    AddAI "repne_cmpsw 1111001010100111", "Compare String"
    AddAI "repne_scasb 1111001010101110", "Scan String"
    AddAI "repne_scasw 1111001010101111", "Scan String"
    AddAI "ret 11000011|i16:11000010aaaaaaaaaaaaaaaa", "Return from Procedure (in same segment)"
    AddAI "retf 11001011|i16:11001010aaaaaaaaaaaaaaaa", "Return from Procedure (in other segment)"
    AddAI "rol r8:1101000011000aaa|r16:1101000111000aaa|r8,cl:1101001011000aaa|r16,cl:1101001111000aaa|r8,i8:1100000011000aaabbbbbbbb|r16,i8:1100000111000aaabbbbbbbb|m8,i8:11000000aa000aaabbbbbbbb|m16,i8:11000001aa000aaabbbbbbbb|m8,cl:11010010aa000aaa|m16,cl:11010011aa000aaa|m8:11010000aa000aaa|m16:11010001aa000aaa", "Rotate Left"
    AddAI "ror r8:1101000011001aaa|r16:1101000111001aaa|r8,cl:1101001011001aaa|r16,cl:1101001111001aaa|r8,i8:1100000011001aaabbbbbbbb|r16,i8:1100000111001aaabbbbbbbb|m8,i8:11000000aa001aaabbbbbbbb|m16,i8:11000001aa001aaabbbbbbbb|m8,cl:11010010aa001aaa|m16,cl:11010011aa001aaa|m8:11010000aa001aaa|m16:11010001aa001aaa", "Rotate Right"
    AddAI "sahf 10011110", "Store AH into FLAGS"
    AddAI "sbb r8,r8:0001100011bbbaaa|r8,r8:0001101011aaabbb|r16,r16:0001100111bbbaaa|r16,r16:0001101111aaabbb|m8,i8:10000000aa011aaabbbbbbbb|m16,i16:10000001aa011aaabbbbbbbbbbbbbbbb|al,i8:00011100aaaaaaaa|ax,i16:00011101aaaaaaaaaaaaaaaa|r8,i8:1000000011011aaabbbbbbbb|r16,i16:1000000111011aaabbbbbbbbbbbbbbbb|r8,m8:00011010bbaaabbb|r16,m16:00011011bbaaabbb|m8,r8:00011000aabbbaaa|m16,r16:00011001aabbbaaa", "Integer Subtraction with Borrow"
    AddAI "scasb 10101110", "Scan String"
    AddAI "scasw 10101111", "Scan String"
    AddAI "set cc,r8:000011111001aaaa11000bbb|cc,m8:000011111001aaaabb000bbb", "Byte Set on Condition"
    AddAI "sgdt m16:0000111100000001aa000aaa", "Store Global Descriptor Table Register"
    AddAI "shl r8:1101000011100aaa|r16:1101000111100aaa|r8,cl:1101001011100aaa|r16,cl:1101001111100aaa|r8,i8:1100000011100aaabbbbbbbb|r16,i8:1100000111100aaabbbbbbbb|m8,i8:11000000aa100aaabbbbbbbb|m16,i8:11000001aa100aaabbbbbbbb|m8,cl:11010010aa100aaa|m16,cl:11010011aa100aaa|m8:11010000aa100aaa|m16:11010001aa100aaa", "Shift Left"
    AddAI "sal r8:1101000011100aaa|r16:1101000111100aaa|r8,cl:1101001011100aaa|r16,cl:1101001111100aaa|r8,i8:1100000011100aaabbbbbbbb|r16,i8:1100000111100aaabbbbbbbb|m8,i8:11000000aa100aaabbbbbbbb|m16,i8:11000001aa100aaabbbbbbbb|m8,cl:11010010aa100aaa|m16,cl:11010011aa100aaa|m8:11010000aa100aaa|m16:11010001aa100aaa", "Shift Arithmetic Left"
    AddAI "shld r16,r16,i8:000011111010010011bbbaaacccccccc|m16,r16,i8:0000111110100100aabbbaaacccccccc|r16,r16,cl:000011111010010111bbbaaa|m16,r16,cl:0000111110100101aabbbaaa", "Double Precision Shift Left"
    AddAI "shr r8:1101000011101aaa|r16:1101000111101aaa|r8,cl:1101001011101aaa|r16,cl:1101001111101aaa|r8,i8:1100000011101aaabbbbbbbb|r16,i8:1100000111101aaabbbbbbbb|m8,i8:11000000aa101aaabbbbbbbb|m16,i8:11000001aa101aaabbbbbbbb|m8,cl:11010010aa101aaa|m16,cl:11010011aa101aaa|m8:11010000aa101aaa|m16:11010001aa101aaa", "Shift Right"
    AddAI "sar r8:1101000011111aaa|r16:1101000111111aaa|r8,cl:1101001011111aaa|r16,cl:1101001111111aaa|r8,i8:1100000011111aaabbbbbbbb|r16,i8:1100000111111aaabbbbbbbb|m8,i8:11000000aa111aaabbbbbbbb|m16,i8:11000001aa111aaabbbbbbbb|m8,cl:11010010aa111aaa|m16,cl:11010011aa111aaa|m8:11010000aa111aaa|m16:11010001aa111aaa", "Shift Arithmetic Right"
    AddAI "shrd r16,r16,i8:000011111010110011bbbaaacccccccc|m16,r16,i8:0000111110101100aabbbaaacccccccc|r16,r16,cl:000011111010110111bbbaaa|m16,r16,cl:0000111110101101aabbbaaa", "Double Precision Shift Right"
    AddAI "sidt m16:0000111100000001aa001aaa", "Store Interrupt Descriptor Table Register"
    AddAI "sldt r16:000011110000000011000aaa|m16:0000111100000000aa000aaa", "Store Local Descriptor Table Register"
    AddAI "smsw r16:000011110000000111100aaa|m16:0000111100000001aa100aaa", "Store Machine Status Word"
    AddAI "stc 11111001", "Set Carry Flag"
    AddAI "std 11111101", "Set Direction Flag"
    AddAI "sti 11111011", "Set Interrupt Flag"
    AddAI "stosb 10101010", "Store String Data"
    AddAI "stosw 10101011", "Store String Data"
    AddAI "str r16:000011110000000011001aaa|m16:0000111100000000aa001aaa", "Store Task Register"
    AddAI "sub r8,r8:0010100011bbbaaa|r16,r16:0010100111bbbaaa|r8,r8:0010101011aaabbb|r16,r16:0010101111aaabbb|al,i8:00101100bbbbbbbb|ax,i16:00101101bbbbbbbbbbbbbbbb|r8,i8:1000000011101aaabbbbbbbb|r16,i16:1000000111101aaabbbbbbbbbbbbbbbb|m8,i8:10000000aa101aaabbbbbbbb|m16,i16:10000001aa101aaabbbbbbbbbbbbbbbb|m8,r8:00101000aabbbaaa|m16,r16:00101001aabbbaaa|r8,m8:00101010bbaaabbb|r16,m16:00101011bbaaabbb", "Integer Subtraction"
    AddAI "test r8,r8:1000010011aaabbb|r16,r16:1000010111aaabbb|al,i8:10101000bbbbbbbb|ax,i16:10101001bbbbbbbbbbbbbbbb|r8,i8:1111011011000aaabbbbbbbb|r16,i16:1111011111000aaabbbbbbbbbbbbbbbb|m8,i8:11110110aa000aaabbbbbbbb|m16,i16:11110111aa000aaabbbbbbbbbbbbbbbb|m8,r8:10000100aabbbaaa|m16,r16:10000101aabbbaaa", "Logical Compare"
    AddAI "verr r16:000011110000000011100aaa|m16:0000111100000000aa100aaa", "Verify a Segment for Reading"
    AddAI "verw r16:000011110000000011101aaa|m16:0000111100000000aa101aaa", "Verify a Segment for Writing"
    AddAI "wait 10011011", "Wait"
    AddAI "xadd r8,r8:000011111100000011bbbaaa|r16,r16:000011111100000111bbbaaa|m8,r8:0000111111000000aabbbaaa|m16,r16:0000111111000001aabbbaaa", "Exchange and Add"
    AddAI "xchg ax,r16:10010bbb|r16,ax:10010aaa|r8,r8:1000011011aaabbb|r16,r16:1000011011bbbaaa|m8,r8:10000100aabbbaaa|m16,r16:10000101aabbbaaa|r8,m8:10000110bbaaabbb|r16,m16:10000111bbaaabbb", "Exchange Memory/Register with Register"
    AddAI "xlatb 11010111", "Table Look-up Translation"
    AddAI "xor r8,r8:0011000011bbbaaa|r16,r16:0011000111bbbaaa|r8,r8:0011001011aaabbb|r16,r16:0011001111aaabbb|al,i8:00110100bbbbbbbb|ax,i16:00110101bbbbbbbbbbbbbbbb|r8,i8:1000000011110aaabbbbbbbb|r16,i16:1000000111110aaabbbbbbbbbbbbbbbb|m8,i8:10000000aa110aaabbbbbbbb|m16,i16:10000001aa110aaabbbbbbbbbbbbbbbb|m8,r8:00110000aabbbaaa|m16,r16:00110001aabbbaaa|r8,m8:00110010bbaaabbb|r16,m16:00110011bbaaabbb", "Logical Exclusive OR"
    AddAI "db i8:aaaaaaaa", "Define Byte"
    AddAI "dw i16:aaaaaaaaaaaaaaaa", "Define Word"
End Sub

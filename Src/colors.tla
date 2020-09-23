
; Example program: Colors

        org     $0100           ; origin

start:  mov     dh,12           ; row
        mov     dl,25           ; column
        mov     bl,$5D          ; style
        mov     si,@text1       ; text
        call    @print

        mov     dh,13           ; row
        mov     dl,27           ; column
        mov     bl,$A2          ; style
        mov     si,@text2       ; text
        call    @print

        xor     ax,ax
        int     $16             ; wait for key

        int     $20             ; terminate application

text1:  db      " Hello world! ",0

text2:  db      " From TLA! ",0

print:  mov     ah,2
        mov     bh,0
        inc     dl
        int     $10             ; set cursor position
        lodsb                   ; load one byte from text
        cmp     al,0
        je      @.end           ; if the byte is 0 then we're done
        mov     ah,9
        mov     bh,0
        mov     cx,1
        int     $10             ; else print the character
        jmp     @print          ; go loop (this won't quit until 0 is found)
.end:   ret


; Example program: Questions

        org     $0100

start:  mov     ah,9
        mov     dx,@name
        int     $21           ; write question

getkey: mov     cx,31         ; max number of characters to input
        mov     di,@data      ; pointer to the buffer where the characters will be stored
.loop:  mov     ah,1
        int     $21           ; read one character with echo
        cmp     al,13         ; if character = new line...
        je      @.end         ; then we're done
        stosb                 ; else we add the character to the buffer given by di
        dec     cx            ; cx = cx - 1
        cmp     cx,0
        jg      @.loop        ; if cx > 0 then goto .loop
.end:   mov     al,$24        ; else add the DOS terminate character
        stosb                 ; to the buffer

show:   mov     ah,9
        mov     dx,@hi
        int     $21           ; goto a new line and write "Hi " to screen
        mov     dx,@data
        int     $21           ; write one and one character from the buffer till the byte $24 is met
        mov     dx,@hi.end
        int     $21           ; write "!" to screen and goto a new line

        xor     ax,ax
        int     $16           ; wait for keyboard input

        int     $20           ; terminate application

name:   db "What's your name? ",$24

hi:     db 13,10,"Hi ",$24
.end:   db "!",13,10,$24

data:   rb 32


; Example program: Write integer to screen

        org     $0100

start:  mov     ah,9
        mov     dx,@intro
        int     $21           ; write a little into to screen

        mov     ax,843
        call    @putint       ; write "843" to screen

        mov     ah,9
        mov     dx,@sadd
        int     $21           ; write " + " to screen

        movm    ax,@number    ; moves the value of the word at the offset @number to ax
                              ; (Note! in other assemblers you write mov ax,w[@number],
                              ; but because of some optimizing, I've changed the syntax
                              ; a little bit)
        call    @putint       ; write number in ax to screen

        mov     ah,9
        mov     dx,@sequal
        int     $21           ; write " = " to screen

        movm    ax,@number    ; ax = 149
        add     ax,843        ; ax = ax + 843
        call    @putint       ; output the result

        mov     ah,2
        mov     dl,13
        int     $21           ; print Cr to screen
        mov     dl,10
        int     $21           ; print Lf to screen
                              ; and we're on a new line

        xor     ax,ax
        int     $16           ; wait for keyboard input

        int     $20           ; terminate application

number: dw      149

intro:  db      "Let's do some simple mathematics!",13,10,$24

sadd:   db      " + ",$24

sequal: db      " = ",$24

putint: push    ax
        push    bx
        push    cx
        push    dx         ; push registers to stack
        mov     bx,10      ; bx = 10 (base = 10)
        xor     cx,cx      ; cx = 0
.new:   xor     dx,dx      ; dx = 0
        div     bx         ; ax = ax / bx => remainder is stored in dx
        push    dx         ; push dx to stack
        inc     cx         ; cx = cx + 1
        test    ax,ax
        jnz     @.new      ; if ax <> 0 then goto .nex
.loop:  pop     dx         ; pop value from stack into dx
        add     dl,"0"     ; convert digit to character (0 and "0" is not the same)
        mov     ah,2
        int     $21        ; print character stored in dl to screen
        loop    @.loop     ; if cx > 0 then goto .loop
        pop     dx
        pop     cx
        pop     bx
        pop     ax         ; pop registers from stack
        ret                ; return to the offset where the procedure
                           ; was called from...

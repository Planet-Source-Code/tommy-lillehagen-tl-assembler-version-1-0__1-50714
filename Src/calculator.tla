
; Example program: Calculator

        org     $0100

start:  mov     ah,9
        mov     dx,@str1
        int     $21

        call    @getnum
        movm    @num1,ax

        mov     ah,9
        mov     dx,@str2
        int     $21

        call    @getnum
        movm    @num2,ax

        mov     ah,9
        mov     dx,@str3
        int     $21

        movm    ax,@num1
        add     ax,w[@num2]
        call    @putnum

        mov     ah,2
        mov     dl,13
        int     $21
        mov     dl,10
        int     $21

        xor     ax,ax
        int     $16

        int     $20

str1:   db    "First number:  ",$24
str2:   db 10,"Second number: ",$24
str3:   db 10,"The sum is:    ",$24

num1:   rb 2 ; two bytes = one word
num2:   rb 2

getnum: push    dx
        xor     dx,dx
.loop:  mov     ah,1
        int     $21
        cmp     al,13
        je      @.end
        sub     al,"0"
        cmp     al,9
        jg      @.end
        push    ax
        mov     ax,dx
        mov     dx,10
        mul     dx
        mov     dx,ax
        pop     ax
        xor     ah,ah
        add     dx,ax
        jmp     @.loop
.end:   mov     ax,dx
        pop     dx
        ret

putnum: push    ax
        push    bx
        push    cx
        push    dx
        mov     bx,10
        xor     cx,cx
.new:   xor     dx,dx
        div     bx
        push    dx
        inc     cx
        test    ax,ax
        jnz     @.new
.loop:  pop     dx
        add     dl,"0"
        mov     ah,2
        int     $21
        loop    @.loop
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret

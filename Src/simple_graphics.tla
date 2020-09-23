
; Example program: Simple drawing on screen

        org     $0100

start:  mov     ah,0
        mov     al,$13
        int     $10

        mov     cx,100
loop1:  mov     ah,$0C
        mov     al,4
        mov     bh,0
        inc     cx
        mov     dx,20
        int     $10
        cmp     cx,160
        jle     @loop1

loop2:  mov     ah,$0C
        mov     al,9
        mov     bh,0
        inc     dx
        int     $10
        cmp     dx,80
        jle     @loop2

loop3:  mov     ah,$0C
        mov     al,6
        mov     bh,0
        dec     dx
        dec     cx
        int     $10
        cmp     dx,20
        jg      @loop3

        mov     si,@_func
        xor     cx,cx
loop4:  lodsb
        test    al,al
        je      @done
        inc     cx
        jmp     @loop4
done:   shr     cx,1
        mov     bp,@_func
        mov     ah,$13
        mov     al,3
        xor     bh,bh
        mov     bl,5
        mov     dh,15
        mov     dl,5
        int     $10

        xor     ax,ax
        int     $16

        int     $20

_func:  db "C",6,"ý",6," ",15,"=",15," ",15,"A",4,"ý",4
        db " ",15,"+",15," ",15,"B",9,"ý",9,0

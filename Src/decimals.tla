
; Example program: dealing with decimals

        org     $0100

        mov     ah,9
        mov     dx,@m1
        int     $21

        call    @get_single
        mov     cx,ax

        mov     ah,9
        mov     dx,@m2
        int     $21

        call    @get_single
        add     cx,ax

        mov     ah,9
        mov     dx,@m3
        int     $21

        mov     ax,cx
        call    @put_single

        mov     ah,9
        mov     dx,@m4
        int     $21

        mov     ax,cx
        shr     ax,1            ; divide ax by 2
        call    @put_single

        xor     ax,ax
        int     $16

        int     $20

m1:     db      "Number one: $"
m2:     db      13,10,"Number two: $"
m3:     db      13,10,"Sum:        $"
m4:     db      13,10,"Sum / 2:    $"

put_single:
        push    ax
        push    bx
        push    cx
        push    dx
        xor     cx,cx
        mov     bx,10
.l1:    xor     dx,dx
        div     bx
        push    dx
        inc     cx
        cmp     ax,0
        jnz     @.l1
.l2:    cmp     cx,1
        jne     @.l3
        mov     dl,"."
        mov     ah,2
        int     $21
.l3:    pop     dx
        add     dl,"0"
        mov     ah,2
        int     $21
        loop    @.l2
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret

get_single:
        push    dx
        push    bx
        xor     dx,dx
        xor     bx,bx
.loop:  mov     ah,1
        int     $21
        cmp     al,13
        je      @.end
        cmp     al,"."
        jne     @.ok
        not     bx
        jmp     @.loop
.ok:    sub     al,"0"
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
        test    bx,bx
        jz      @.loop
.end:   mov     ax,dx
        test    bx,bx
        jnz     @.done
        mov     dx,10
        mul     dx
.done:  pop     bx
        pop     dx
        ret

; ax = number to print
; bx = base of number

putint: push    ax
        push    bx
        push    cx
        push    dx
        xor     cx,cx
.new:   xor     dx,dx
        div     bx
        push    dx
        inc     cx
        test    ax,ax
        jnz     @.new
.loop:  pop     dx
        add     dl,"0"
        cmp     dl,"9"
        jng     @.ok
        add     dl,7
.ok:    mov     ah,2
        int     $21
        loop    @.loop
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret

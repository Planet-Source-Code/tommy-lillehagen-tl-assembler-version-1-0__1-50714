
; Example program: Writing directly to the video segment

        org     $0100

        mov     ax,$13
        int     $10

        mov     ax,$A000
        mov     es,ax
        mov     al,194
        mov     cx,$FFFF
        rep_stosb

        mov     cx,50
        mov     di,32110
loop:   push    cx
        mov     al,45
        mov     cx,100
        rep_stosb
        pop     cx
        add     di,220
        loop    @loop

        xor     ax,ax
        int     $16

        int     $20

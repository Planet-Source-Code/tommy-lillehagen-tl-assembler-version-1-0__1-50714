
; Example program: Hello world!

        org     $0100               ; origin = 100h

start:  mov     ah,9                ; function = 9 (write to screen)
        mov     dx,@msg             ; data to write to screen (terminated by $24)
        int     $21                 ; call DOS interrupt

wait:   xor     ax,ax               ; function = 0 (wait for key)
        int     $16                 ; call keyboard interrupt

exit:   int     $20                 ; call DOS interrupt
                                    ; (terminate program)

msg:    db "Hello world!",13,10,$24 ; define bytes

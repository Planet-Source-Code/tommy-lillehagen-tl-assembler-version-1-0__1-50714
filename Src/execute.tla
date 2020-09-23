
; Example program: Execute a program

        org     $0100

start:  mov     ah,$4A
        mov     bx,4097
        int     $21                     ; resize memory

        mov     w[@params.2],@_cmd
        mov     ax,ds
        movm    @params.3,ax            ; set parameters

        mov     ax,$4B00
        mov     dx,@_prog
        mov     bx,@params
        int     $21                     ; load and execute program

        mov     ah,9
        mov     dx,@_done
        int     $21                     ; show message

        xor     ax,ax
        int     $16                     ; wait for key

        int     $20                     ; terminate program

_done:  db 13,10,"Back in execute.com...",13,10,$24

_prog:  db "hello.com",0
_cmd:   db 0,13

params:
  .1:   dw 0
  .2:   dw 0
  .3:   dw 0
  .4:   rb 4
  .5:   rb 4

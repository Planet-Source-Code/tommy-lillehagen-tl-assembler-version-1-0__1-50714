
; Example program: Include files

        org     $0100

start:  mov     ax,1692       ; number to write
        mov     bx,16         ; base = 16 (hexadecimal)
        call    @putint       ; call procedure to output the number

        xor     ax,ax
        int     $16           ; wait for keyboard input

        int     $20           ; terminate application

include "included_file.tla"   ; include a file (note! files can not
                              ; be included within a file which is
                              ; included by another

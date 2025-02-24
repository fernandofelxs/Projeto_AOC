vscr_seg: dw 0

InitBuffer:
        ; COM files get (most/all) available memory, grab some of it
        mov     bx, word [0x0002] ; Get last paragraph from PSP
        sub     bx, 64000/16 ; Make room for back buffer
        mov     [vscr_seg], bx

        mov     ax, ds
        add     ax, 0x1000 ; Program start paragraph + 64K (max of COM file)
 
        ; Clear back buffer
        mov     es, [vscr_seg]
        xor     di, di
        xor     ax, ax
        mov     cx, 32000
        cld
        rep     stosw

CopyToScreen:
        ; Copy from back buffer to the screen
        push    ds ; Remember to save DS!
        mov     ds, [vscr_seg]
        mov     ax, 0xa000
        mov     es, ax
        xor     di, di
        xor     si, si
        mov     cx, 32000
        cld     
        rep     movsw
        pop     ds ; ... And restore it again

        ret

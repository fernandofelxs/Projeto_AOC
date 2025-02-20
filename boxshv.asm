		; tell NASM we want 16-bit assembly language
		BITS	16
		ORG	0x100				; DOS loads us here
Start:		
        CALL	InstallKB
		CALL	InitVideo

        mov     ax, 156
        mov     cx, 180
        mov     [XPosition], ax
        mov     [YPosition], cx

.gameLoop:	
        CALL	WaitFrame

        xor     si, si
        CALL    DrawBackground

        mov     ax, [XPosition]
        mov     cx, [YPosition]
        mov     bx, PlayerSprite
        CALL    DrawBox

		cmp	    byte [Quit], 1
		jne	    .gameLoop			; loop if counter > 0

		CALL	RestoreVideo
		CALL	RestoreKB

		mov	    ax, 0x4C00
		INT	    0x21
        ; exit

Quit:		DB	0

%include "kb.asm"
%include "video.asm"
%include "sprites.asm"

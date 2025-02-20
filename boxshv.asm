		; tell NASM we want 16-bit assembly language
		BITS	16
		ORG	0x100				; DOS loads us here
Start:		
        CALL	InstallKB
		CALL	InitVideo

        mov     ax, 0
        mov     cx, 190
        mov     [PlayerXPosition], ax
        mov     [PlayerYPosition], cx
        CALL    InitiateEnemies

.gameLoop:	
        CALL	WaitFrame
        CALL    DrawBackground

        mov     ax, [PlayerXPosition]
        mov     cx, [PlayerYPosition]
        mov     bx, PlayerSprite
        CALL    DrawBox
        
        CALL    DrawEnemies

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
%include "charpos.asm"

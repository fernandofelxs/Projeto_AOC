		; tell NASM we want 16-bit assembly language
		BITS	16
		ORG	0x100				; DOS loads us here

Start:		
        CALL    InitBuffer
        CALL	InstallKB
		CALL	InitVideo

        CALL    InitializePlayer
        CALL    InitializeEnemies

.gameLoop:	
        CALL    RestoreBackBuffer 
        CALL	WaitFrame

        CALL    UpdateCycles

        mov     al, 02ah ; orange color
        CALL    FillBackground

        CALL    DrawScore
        CALL    DrawPlayer
        CALL    VerifyBullet
        CALL    MoveEnemies
        CALL    DrawEnemies
        CALL    MoveArrows
        CALL    DrawArrows
        CALL    CopyToScreen

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
%include "memory.asm"
%include "score.asm"
%include "gameover.asm"
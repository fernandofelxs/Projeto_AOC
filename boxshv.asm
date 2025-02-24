; tell NASM we want 16-bit assembly language
BITS	16
ORG	0x100				; DOS loads us here

Start:		
    CALL  InitBuffer
    CALL	InstallKB
		CALL	InitVideo

    mov     ax, 160
    mov     cx, 190
    mov     [PlayerXPosition], ax
    mov     [PlayerYPosition], cx
    CALL    InitializeEnemies
    mov     dx, [Cycles]

.gameLoop:	
    CALL  RestoreBackBuffer 
    CALL	WaitFrame

    mov     al, 02ah ; orange color
    CALL    FillBackground

    CALL    DrawScore
    CALL    DrawPlayer
    call    VerifyBullet
    CALL    MoveEnemies
    CALL    DrawEnemies
    CALL    MoveArrows
    CALL    DrawArrows
    CALL    IncreaseScore
    CALL    CopyToScreen
    call    CheckGameOver
		cmp	    byte [Quit], 1
		jne	    .gameLoop			; loop if counter > 0

    mov     ah, 05h
    int     10h

		CALL	RestoreVideo
		CALL	RestoreKB

		mov	    ax, 0x4C00
		INT	    0x21
; exit

Quit:		DB	0
GameOverFlag:		DB	0

CheckGameOver:
        push bx
        mov si, 0

.LoopOverEnemies:
        add     si, 2
        cmp     si, 48
        jge     .done
        mov     bx, [EnemyY+si]
        mov     ax, [PlayerYPosition]
        sub     ax, bx
        cmp     ax, 10
        jge     .LoopOverEnemies
	      ;mov	    byte [Quit], 1
	      mov	    byte [GameOverFlag], 1
        call GameOverLoop
        pop     bx

.done:
    pop     bx
    ret

%include "gameover.asm"
%include "kb.asm"
%include "video.asm"
%include "sprites.asm"
%include "charpos.asm"
%include "memory.asm"
%include "score.asm"

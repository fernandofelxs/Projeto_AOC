GameOverFlag:		DB	0

CheckGameOver:
        push    ax
        push    bx
        push    si
        mov     si, 0
.LoopOverEnemies:
        add     si, 2
        cmp     si, 48
        jge     .done
        mov     bx, [EnemyY+si]
        mov     ax, [PlayerYPosition]
        sub     ax, bx
        cmp     ax, 10
        jge     .LoopOverEnemies
	mov	byte [GameOverFlag], 1
        CALL    GameOverLoop
.done:
        pop     si
        pop     bx
        pop     ax
        ret

GameOverLoop:
        CALL    RestoreBackBuffer
        mov     al, 02ah
        CALL    FillBackground
        CALL    DrawBackground ; orange color

        mov     ax, 120
        mov     cx, 100
        mov     bx, GSprite
        CALL    DrawBox

        mov     ax, 128
        mov     cx, 100
        mov     bx, ASprite
        CALL    DrawBox

        mov     ax, 137
        mov     cx, 100
        mov     bx, MSprite
        CALL    DrawBox

        mov     ax, 146
        mov     cx, 100
        mov     bx, ESprite
        CALL    DrawBox

        mov     ax, 160
        mov     cx, 100
        mov     bx, OSprite
        CALL    DrawBox

        mov     ax, 168
        mov     cx, 100
        mov     bx, VSprite
        CALL    DrawBox

        mov     ax, 176
        mov     cx, 100
        mov     bx, ESprite
        CALL    DrawBox

        mov     ax, 184
        mov     cx, 100
        mov     bx, RSprite
        CALL    DrawBox

        CALL    DrawScore
        CALL    CopyToScreen
        cmp	byte [Quit], 1
	jne	GameOverLoop

        jmp     EndGame
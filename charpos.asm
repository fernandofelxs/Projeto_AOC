PlayerXPosition: dw 0
PlayerYPosition: dw 0
EnemyX: dw 25 dup(0)
EnemyY: dw 25 dup(0)
ArrowX: dw 20 dup(0)
ArrowY: dw 20 dup(0)
ArrowNum: dw 1

InitializeEnemies:
        mov     si, 0
        mov     ax, 64
        mov     bx, 8
.LoopOverEnemies:
        add     si, 2
        mov     [EnemyX+si], ax
        add     ax, bx
        mov     dx, bx
        mov     [EnemyY+si], dx
        cmp     si, 48 ; max number of enemies
        jl      .LoopOverEnemies
        ret

; clobbers si
DrawEnemies:
        push    ax
        push    bx
        push    cx
        mov     si, 0
        mov     bx, EnemySprite
.DrawLoop:
        add     si, 2
        mov     ax, [EnemyX+si]
        mov     cx, [EnemyY+si]
        CALL    DrawBox
        cmp     si, 48
        jl      .DrawLoop
        pop     cx
        pop     bx
        pop     ax
        ret

; clobbers si
DrawArrows:
        push    ax
        push    bx
        push    cx
        mov     si, 0
        mov     bx, ArrowSprite
.DrawLoop2:
        add     si, 2
        mov     ax, [ArrowX+si]
        mov     cx, [ArrowY+si]
        CALL    DrawBox
        cmp     si, 38
        jl      .DrawLoop2
        pop     cx
        pop     bx
        pop     ax
        ret

; clobbers si
MoveArrows:
        push    ax
        push    bx
        push    cx
        mov     si, 0
.LoopThroughArrows:
        add     si, 2
        mov     bx, [ArrowY+si]
        cmp     bx, 0
        je      .Continue
        dec     bx
        mov     [ArrowY+si], bx 
.Continue:
        cmp     si, 38
        jl      .LoopThroughArrows
        pop     cx
        pop     bx
        pop     ax
        ret
PlayerXPosition: dw 0
PlayerYPosition: dw 0
EnemyX: dw 26 dup(0)
EnemyY: dw 26 dup(10)
ArrowX: dw 26 dup(0)
ArrowY: dw 26 dup(320)
EnemyAct: dw 26 dup(0)
ArrowNum: dw 1
Cycles: dw 0

InitializePlayer:
        push    ax
        push    cx
        mov     ax, 160
        mov     cx, 190
        mov     [PlayerXPosition], ax
        mov     [PlayerYPosition], cx
        pop     cx
        pop     ax
        ret

UpdateCycles:
        push    dx
        mov     dx, word [Cycles]
        cmp     dx, 20
        jge     .ResetCycles
        inc     dx
        jmp     .Done
.ResetCycles:
        xor     dx, dx
.Done:
        mov     word [Cycles], dx
        pop     dx
        ret

; clobbers si
InitializeEnemies:
        push    ax
        push    bx
        push    dx
        mov     si, 0
        mov     ax, 64
        mov     bx, 8
.LoopOverEnemies:
        add     si, 2
        mov     word [EnemyX+si], ax
        add     ax, bx
        mov     dx, bx
        mov     word [EnemyY+si], dx
        cmp     si, 48 ; max number of enemies
        jl      .LoopOverEnemies
        pop     dx
        pop     bx
        pop     ax
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
        mov     ax, word [EnemyX+si]
        mov     cx, word [EnemyY+si]
        cmp     cx, 0
        je .DrawLoop 
        CALL    DrawBox
        cmp     si, 48
        jl      .DrawLoop
        pop     cx
        pop     bx
        pop     ax

; clobbers si
DrawArrows:
        push    ax
        push    bx
        push    cx
        mov     si, 0
        mov     bx, ArrowSprite
.DrawLoop2:
        add     si, 2
        mov     ax, word [ArrowX+si]
        mov     cx, word [ArrowY+si]
        cmp     cx, 4
        jle     .Continue
        cmp     cx, 320
        jge     .Continue
        CALL    DrawBox
.Continue:
        cmp     si, 48
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

.nextArrow:
        add     si, 2

.LoopThroughArrows:
        mov     bx, word [ArrowY+si]

        cmp     bx, 320
        je      .nextArrow

        sub     bx, 5
        mov     word [ArrowY+si], bx 
        cmp     si, 48
        jl      .nextArrow

.Continue:
        pop     cx
        pop     bx
        pop     ax
        ret

MoveEnemies:
        push    ax
        push    bx
        push    cx
        mov     si, 0
.LoopThroughEnemies:
        add     si, 2
        mov     bx, word [EnemyY+si]
        cmp     bx, 190
        jg      .Continue
        cmp     bx, 0
        jle     .Continue
        mov     cx, word [EnemyX+si]       
        cmp     cx, 0
        jle     .Continue
        inc     bx
        mov     word [EnemyY+si], bx 
.Continue:
        cmp     si, 48
        jl      .LoopThroughEnemies
        pop     cx
        pop     bx
        pop     ax
        ret

.LoopThroughArrows:
        cmp     si, 48
        jge     .Continue
        
        add     si, 2
        mov     ax, word [ArrowX+si]
        mov     bx, [ArrowY+si]
        cmp     bx, 0
        je      .Continue
        dec     bx
        mov     word [ArrowY+si], bx

        mov     di, 0

VerifyBullet:
        push    si
        push    di
        push    ax
        push    bx
        push    cx
        push    dx

        mov     si, 2
        mov     di, 2

.resetValues:
        mov     di, 2
        cmp     si, 48
        jge     .Continue
        mov     bx, word [ArrowY+si]
        sub     bx, 10

.LoopOverEnemies:
        mov     ax, word [ArrowX+si]

        cmp     di, 48 ; max number of enemies
        jge     .nextArrow

        mov     cx, word [EnemyX+di]
        mov     dx, word [EnemyY+di]

        cmp     ax, cx
        jne     .nextEnemy

        cmp     bx, dx
        jg      .nextEnemy

        ; enemy hit
        mov     cx, 320
        mov     dx, 0
        mov     word [EnemyX+di], dx
        mov     word [EnemyY+di], dx
        mov     word [ArrowX+si], cx
        mov     word [ArrowY+si], cx
        CALL    IncreaseScore

        jmp     .nextArrow

.nextArrow:
        add     si, 2
        jmp     .resetValues

.nextEnemy:
        add     di, 2
        jmp     .LoopOverEnemies

.Continue:
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        pop     si
        pop     di
        ret
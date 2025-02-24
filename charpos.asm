PlayerXPosition: dw 0
PlayerYPosition: dw 0
EnemyX: dw 26 dup(0)
EnemyY: dw 26 dup(0)
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
        cmp     dx, 8
        jg      .ResetCycles
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
        xor     si, si
        mov     ax, 64
        mov     bx, 0 ; swap to 8 to spawn at game start

.LoopOverEnemies:
        add     si, 2
        mov     word [EnemyX+si], ax
        add     ax, bx
        mov     dx, bx
        mov     word [EnemyY+si], dx
        cmp     si, 50 ; max number of enemies
        jl      .LoopOverEnemies
        pop     dx
        pop     bx
        pop     ax

        ; bugged enemy, ignore
        mov     word [EnemyX+50], 310
        mov     word [EnemyY+50], 190 

        ret

SpawnEnemies:
        push    si
        push    ax
        push    bx
        push    cx
        push    dx
        cmp     word [Cycles], 8
        jl      .Done
        xor     si, si
.LoopOverEnemies1:
        add     si, 2
        mov     ax, word [EnemyY+si]
        cmp     ax, 0
        je      .Spawn        
.LoopOverEnemies2:
        cmp     si, 50 ; max number of enemies
        jl      .LoopOverEnemies1
        jmp     .Done
.Spawn: 
        push    ax
        push    si
        shl     si, 1
        add     si, 128

        ; get random value
        mov ah, 00h; get system time        
        int 1ah
        mov     ax, dx
        xor     dx, dx
        mov     cx, si
        div     cx

        pop     si
        pop     ax

        cmp     dx, 8  ; if the remainder is less or equal to 8, spawn an enemy
        jg      .LoopOverEnemies2

        mov     word [EnemyY+si], 8

        push    ax
        push    bx
        push    dx
        mov     ax, si
        mov     bx, 4
        mul     bx
        add     ax, 56
        xor     dx, dx
        mov     word [EnemyX+si], ax ; 64+(4*si)
        pop     dx
        pop     bx
        pop     ax

        jmp     .LoopOverEnemies2
.Done:
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        pop     si
        ret

; clobbers si
DrawEnemies:
        push    ax
        push    bx
        push    cx
        xor     si, si
        mov     bx, EnemySprite
.DrawLoop:
        add     si, 2
        mov     ax, word [EnemyX+si]
        mov     cx, word [EnemyY+si]
        cmp     cx, 0
        je      .DrawLoop 
        CALL    DrawBox
        cmp     si, 50
        jl      .DrawLoop
        pop     cx
        pop     bx
        pop     ax

; clobbers si
DrawArrows:
        push    ax
        push    bx
        push    cx
        xor     si, si
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
        cmp     si, 50
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
        cmp     si, 50
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
        cmp     si, 50
        jl      .LoopThroughEnemies
        pop     cx
        pop     bx
        pop     ax
        ret

.LoopThroughArrows:
        cmp     si, 50
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
        cmp     si, 50
        jge     .Continue
        mov     bx, word [ArrowY+si]
        sub     bx, 10

.LoopOverEnemies:
        mov     ax, word [ArrowX+si]

        cmp     di, 50 ; max number of enemies
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
        pop     di
        pop     si
        ret
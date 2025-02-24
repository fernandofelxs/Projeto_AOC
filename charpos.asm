PlayerXPosition: dw 0
PlayerYPosition: dw 0
EnemyX: dw 25 dup(0)
EnemyY: dw 25 dup(10)
ArrowX: dw 25 dup(0)
ArrowY: dw 25 dup(320)
EnemyAct: dw 25 dup(0)
ArrowNum: dw 1
Cycles: dw 0
CycleCounter: dw 0

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
        mov     cx, [CycleCounter]
        inc     cx
        mov     [CycleCounter], cx

        cmp     cx, 5
        je      .noSpawn
        jne     .spawn

.noSpawn:
        xor cx, cx
        mov [EnemyX+si], cx
        add     ax, bx
        mov     dx, bx
        mov     [EnemyY+si], cx
        mov     [CycleCounter], cx
        jmp .updateInitialPos

.spawn:
        mov     [EnemyX+si], ax
        add     ax, bx
        mov     dx, bx
        mov     [EnemyY+si], dx

.updateInitialPos:
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
        mov     ax, [EnemyX+si]
        mov     cx, [EnemyY+si]
        cmp cx, 0
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
        mov     ax, [ArrowX+si]
        mov     cx, [ArrowY+si]
        cmp     cx, 4
        jle     .Continue
        cmp     cx, 320
        jge     .Continue
        CALL    DrawBox
.Continue:
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

.nextArrow:
        add     si, 2

.LoopThroughArrows:
        mov     bx, [ArrowY+si]

        cmp bx, 320
        je .nextArrow

        sub     bx, 5
        mov  [ArrowY+si], bx 
        cmp  si, 48
        jl  .nextArrow

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
        mov     bx, [EnemyY+si]
        cmp     bx, 190
        jg      .Continue
        cmp     bx, 0
        jle     .Continue
        mov     cx, [EnemyX+si]       
        cmp     cx, 0
        jle     .Continue
        inc     bx
        mov     [EnemyY+si], bx 
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
        mov     ax, [ArrowX+si]
        mov     bx, [ArrowY+si]
        cmp     bx, 0
        je      .Continue
        dec     bx
        mov     [ArrowY+si], bx

        mov di, 0

VerifyBullet:
        push si
        push di
        push ax
        push bx
        push cx
        push dx

        mov si, 0
        mov di, 0

.resetValues:
        mov di, 0
        cmp si, 48
        jg .Continue
        mov bx, [ArrowY+si]

.LoopOverEnemies:
        mov ax, [ArrowX+si]

        cmp di, 48 ; max number of enemies
        jg .nextArrow

        mov cx, [EnemyX+di]
        mov dx, [EnemyY+di]

        cmp ax, cx
        jne .nextEnemy

        add dx, 10
        cmp bx, dx
        jg .nextEnemy

        mov cx, 320
        mov dx, 0
        mov [EnemyX+di], dx
        mov [EnemyY+di], dx
        mov [ArrowX+si], cx
        mov [ArrowY+si], cx

        jmp .nextArrow

.nextArrow:
        add si, 2
        jmp .resetValues

.nextEnemy:
        add di, 2
        jmp .LoopOverEnemies

.Continue:
        pop     cx
        pop     dx
        pop     bx
        pop     ax
        pop si
        pop di
        ret

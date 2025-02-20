PlayerXPosition: dw 0
PlayerYPosition: dw 0
EnemyX: dw 25 dup(0)
EnemyY: dw 25 dup(0)

InitiateEnemies:
        mov si, 0
        mov ax, 64
        mov bx, 8
.LoopOverEnemies:
        add si, 2
        mov [EnemyX+si], ax
        add ax, bx
        mov dx, bx
        mov [EnemyY+si], dx
        cmp si, 48 ; max number of enemies
        jl .LoopOverEnemies
        ret

DrawEnemies:
        push ax
        push bx
        push cx
        mov si, 0
        xor ax, ax
        xor cx, cx
        mov bx, EnemySprite
.DrawLoop:
        add si, 2
        mov ax, [EnemyX+si]
        mov cx, [EnemyY+si]
        CALL DrawBox
        cmp si, 48
        jl .DrawLoop
        pop cx
        pop bx
        pop ax
        ret







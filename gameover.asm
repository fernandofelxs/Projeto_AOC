GameOverLoop:
    mov     al, 0h
    CALL    FillBackground
    mov     bx, GSprite
    CALL    DrawBox
    jmp GameOverLoop

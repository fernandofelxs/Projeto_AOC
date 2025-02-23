ScoreNumbers: db 7 dup(0)


DrawScore:
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        xor     si, si
        mov     ax, 311
        mov     cx, 8


.DrawLoop:
        cmp     si, 6
        je      .EndDrawing
        mov     dl, byte [ScoreNumbers+si]
        sub     ax, 8
        cmp     dl, 0
        je      .DrawZero
        cmp     dl, 1
        je      .DrawOne
        cmp     dl, 2
        je      .DrawTwo
        cmp     dl, 3
        je      .DrawThree
        cmp     dl, 4
        je      .DrawFour
        cmp     dl, 5
        je      .DrawFive
        cmp     dl, 6
        je      .DrawSix
        cmp     dl, 7
        je      .DrawSeven
        cmp     dl, 8
        je      .DrawEight
        cmp     dl, 9
        je      .DrawNine

        jmp     .EndDrawing     ; should never happen
.DrawZero:
        inc     si
        mov     bx, ZeroSprite
        CALL    DrawBox
        jmp     .DrawLoop
.DrawOne:
        inc     si
        mov     bx, OneSprite
        CALL    DrawBox
        jmp     .DrawLoop
.DrawTwo:
        inc     si
        mov     bx, TwoSprite
        CALL    DrawBox
        jmp     .DrawLoop
.DrawThree:
        inc     si
        mov     bx, ThreeSprite
        CALL    DrawBox
        jmp     .DrawLoop
.DrawFour:
        inc     si
        mov     bx, FourSprite
        CALL    DrawBox
        jmp     .DrawLoop
.DrawFive:
        inc     si
        mov     bx, FiveSprite
        CALL    DrawBox
        jmp     .DrawLoop
.DrawSix:
        inc     si
        mov     bx, SixSprite
        CALL    DrawBox
        jmp     .DrawLoop
.DrawSeven:
        inc     si
        mov     bx, SevenSprite
        CALL    DrawBox
        jmp     .DrawLoop
.DrawEight:
        inc     si
        mov     bx, EightSprite
        CALL    DrawBox
        jmp     .DrawLoop
.DrawNine:
        inc     si
        mov     bx, NineSprite
        CALL    DrawBox
        jmp     .DrawLoop        
.EndDrawing:
        pop     si
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret

IncreaseScore:
        push    ax
        push    si
        push    di
        xor     si, si
        xor     di, di
.ScoreLoop1:
        cmp     byte [ScoreNumbers+si], 9
        jne      .ScoreLoop2
        inc     si
        cmp     si, 6
        jge     .ScoreLoop2
        jmp     .ScoreLoop1
.ScoreLoop2:
        cmp     di, si
        jge      .IncrementNumber
        mov     byte [ScoreNumbers+di], 0
        inc     di
        jmp     .ScoreLoop2
.IncrementNumber:
        cmp     si, 6
        je      .MaxScore
        mov     al, byte [ScoreNumbers+si]
        inc     al
        mov     byte [ScoreNumbers+si], al
        jmp     .EndScoreLoop
.MaxScore:
        mov     byte [ScoreNumbers+6], 0 
.EndScoreLoop:        
        pop     di
        pop     si
        pop     ax
        ret
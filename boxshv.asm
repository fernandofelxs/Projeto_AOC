		; tell NASM we want 16-bit assembly language
		BITS	16
		ORG	0x100				; DOS loads us here
Start:		
        CALL	InstallKB
		CALL	InitVideo

        mov ax, 20
        mov cx, 20
        mov [XPosition], ax
        mov [YPosition], cx

.gameLoop:	
        CALL	WaitFrame

        xor si, si
        CALL    drawbackground

        mov ax, [XPosition]
        mov cx, [YPosition]
        mov bx, playersprite
        CALL    drawbox

		CMP	BYTE [Quit], 1
		JNE	.gameLoop			; loop if counter > 0

		CALL	RestoreVideo
		CALL	RestoreKB

		MOV	AX, 0x4C00
		INT	0x21
        ; exit

Quit:		DB	0

%include "kb.asm"
%include "video.asm"
%include "sprites.asm"

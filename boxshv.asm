		; tell NASM we want 16-bit assembly language
		BITS	16
		ORG	0x100				; DOS loads us here
Start:		
        CALL	InstallKB
		CALL	InitVideo

        xor si, si
        CALL drawbackground

        mov ax, 20
        mov cx, 20
        mov bx, playersprite
        CALL    drawbox

.gameLoop:	
        CALL	WaitFrame
		CMP	BYTE [Quit], 1
		JNE	.gameLoop			; loop if counter > 0

		CALL	RestoreVideo
		CALL	RestoreKB

		MOV	AX, 0x4C00
		INT	0x21
        ; exit
        
playersprite: 		db      0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh 
                    db      02h, 02h, 02h, 02h, 0Ah, 06h, 0ffh, 0ffh 
                    db      0ffh, 02h, 02h, 02h, 02h, 0Ah, 06h, 0ffh 
                    db      0fh, 1bh, 56h, 00h, 56h, 00h, 0ffh, 06h 
                    db      0ffh, 0c7h, 0c7h, 0c7h, 0c7h, 0c7h, 0ffh, 0fh 
                    db      06h, 0c7h, 0c7h, 0c7h, 02h, 0Ah, 02h, 0fh 
                    db      0ffh, 0c7h, 0c7h, 02h, 02h, 0Ah, 0ffh, 06h
                    db      0ffh, 06h, 0ffh, 0ffh, 0ffh, 06h, 06h, 0ffh 

Quit:		DB	0

%include "kb.asm"
%include "video.asm"

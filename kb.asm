OldKBHandler:	DW	0
OldKBSeg:	DW	0
XPosition: DW 0
YPosition: DW 0

InstallKB:	
        PUSH	ES
		PUSH	BX
		PUSH	DX
		; backup old KB interrupt
		MOV	AX, 0x3509			; get interrupt 9
		INT	0x21
		MOV	[OldKBHandler], BX
		MOV	[OldKBSeg], ES
		; install new KB interrupt
		MOV	AH, 0x25
		MOV	DX, KBHandler
		INT	0x21
		POP	DX
		POP	BX
		POP	ES
		RET

RestoreKB:	
        PUSH	DX
		PUSH	DS
		MOV	AX, 0x2509
		MOV	DX, [OldKBHandler]
		MOV	DS, [OldKBSeg]
		INT	0x21
		POP	DS
		POP	DX
		RET

KBHandler:	
		PUSH 	BX
        PUSH	AX
		IN	AL, 0x60			; get key event
		CMP	AL, 0x01			; ESC pressed?
		JNE	.done
		MOV	[Quit], AL

.done:	
		CMP AL, 0x20			; D key pressed?
		JNE t1
		MOV BX, [XPosition]
		CMP BX, 312
		JE EndHandling			; Reached end of screen
		INC BX
		MOV [XPosition], BX		
	t1:	
		CMP AL, 0x1E			; A key pressed?
		JNE t2
		MOV BX, [XPosition]
		CMP BX, 1
		JE EndHandling		
		DEC BX
		MOV [XPosition], BX
	t2:
		CMP AL, 0x11			; W key pressed?
		JNE t3
		MOV BX, [YPosition]
		CMP BX, 1
		JE EndHandling		
		DEC BX
		MOV [YPosition], BX
	t3:
		CMP AL, 0x1F			; S key pressed?
		JNE EndHandling
		MOV BX, [YPosition]
		CMP BX, 192
		JE EndHandling
		INC BX
		MOV [YPosition], BX
	EndHandling:
        MOV	AL, 0x20			; ACK
		OUT	0x20, AL			; send ACK
		POP	AX
		POP BX
		IRET
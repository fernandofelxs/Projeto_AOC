OldKBHandler:	DW	0
OldKBSeg:	DW	0
XPosition: DW 0
YPosition: DW 0

InstallKB:	
        push	es
		push 	bx
		push 	dx
		; backup old KB interrupt
		mov 	ax, 0x3509			; get interrupt 9
		INT		0x21
		mov		[OldKBHandler], bx
		mov		[OldKBSeg], es
		; install new KB interrupt
		mov 	ah, 0x25
		mov 	dx, KBHandler
		INT		0x21
		pop 	dx
		pop 	bx
		pop 	es
		RET

RestoreKB:	
        push 	dx
		push 	ds
		mov 	ax, 0x2509
		mov 	dx, [OldKBHandler]
		mov 	ds, [OldKBSeg]
		INT		0x21
		pop 	ds
		pop 	dx
		RET

KBHandler:	
		push 	bx
        push 	ax
		IN		al, 0x60			; get key event
		cmp 	al, 0x01			; check if ESC was pressed
		jne		D_Key
		mov		[Quit], AL

	D_Key:
		cmp 	al, 0x20			; check if D was pressed
		jne 	A_Key
		mov 	bx, [XPosition]
		cmp 	bx, 312
		je 		EndHandling			; Reached end of screen
		inc 	bx
		mov 	[XPosition], bx
	A_Key:
		cmp 	al, 0x1E			; check if A was pressed
		jne 	Spacebar
		mov 	bx, [XPosition]
		cmp 	bx, 1
		je 		EndHandling		
		dec 	bx
		mov 	[XPosition], bx
	Spacebar:
		cmp 	al, 0x32			; check if spacebar was pressed
		jne 	EndHandling
		; TODO: implement shooting with spacebar
	EndHandling:
        mov 	al, 0x20			; ACK
		OUT		0x20, al			; send ACK
		pop 	ax
		pop 	bx
		IRET
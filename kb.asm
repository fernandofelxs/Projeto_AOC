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
		cmp 	al, 0x01			; ESC pressed?
		jne		.done
		mov		[Quit], AL

.done:	
		cmp 	al, 0x20			; D key pressed?
		jne 	t1
		mov 	bx, [XPosition]
		cmp 	bx, 312
		je 		EndHandling			; Reached end of screen
		inc 	bx
		mov 	[XPosition], bx
	t1:	
		cmp 	al, 0x1E			; A key pressed?
		jne 	t2
		mov 	bx, [XPosition]
		cmp 	bx, 1
		je 		EndHandling		
		dec 	bx
		mov 	[XPosition], bx
	t2:
		cmp 	al, 0x11			; W key pressed?
		jne 	t3
		mov 	bx, [YPosition]
		cmp 	bx, 1
		je 		EndHandling		
		dec 	bx
		mov 	[YPosition], bx
	t3:
		cmp 	al, 0x1F			; S key pressed?
		jne 	EndHandling
		mov 	bx, [YPosition]
		cmp 	bx, 192
		je 		EndHandling
		inc		bx
		mov 	[YPosition], bx
	EndHandling:
        mov 	al, 0x20			; ACK
		OUT		0x20, al			; send ACK
		pop 	ax
		pop 	bx
		IRET
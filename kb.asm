OldKBHandler:	DW	0
OldKBSeg:	DW	0

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
		push 	cx
		push 	bx
        push 	ax
		push 	si
		IN		al, 0x60			; get key event
		cmp 	al, 0x01			; check if ESC was pressed
		jne		D_Key
		mov		[Quit], AL
	D_Key:
		cmp 	al, 0x20			; check if D was pressed
		jne 	A_Key
		mov 	bx, [PlayerXPosition]
		cmp 	bx, 304
		je 		EndHandling			; reached rightmost end of screen
		add 	bx, 8
		mov 	[PlayerXPosition], bx
		jmp 	EndHandling
	A_Key:
		cmp 	al, 0x1E			; check if A was pressed
		jne 	Spacebar
		mov 	bx, [PlayerXPosition]
		cmp 	bx, 8
		je 		EndHandling			; reached leftmost end of screen
		sub 	bx, 8
		mov 	[PlayerXPosition], bx
		jmp 	EndHandling
	Spacebar:
		cmp 	al, 0x39			; check if spacebar was pressed
		jne 	EndHandling
		mov 	si, [ArrowNum]
		shl 	si, 1
		cmp 	si, 38
		jl 		.Continue
		mov 	si, 0
	.Continue:
		mov 	bx, [PlayerXPosition]
		mov 	cx, [PlayerYPosition]
		sub 	cx, 8
		mov 	[ArrowX+si], bx
		mov 	[ArrowY+si], cx
		mov 	ax, [ArrowNum]
		cmp 	ax, 19 				; arrow max
		jl 		.IncrementArrow
		xor 	ax, ax
		mov 	[ArrowNum], ax
		jmp 	EndHandling
	.IncrementArrow:
		mov 	ax, [ArrowNum]
		inc 	ax
		mov 	[ArrowNum], ax
	EndHandling:
        mov 	al, 0x20			; ACK
		OUT		0x20, al			; send ACK
		pop 	si
		pop 	ax
		pop 	bx
		pop 	cx
		IRET
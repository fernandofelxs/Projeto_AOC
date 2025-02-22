; the VGA hardware is always in one of two states:
; * refresh, where the screen gets redrawn.
;            This is the state the VGA is in most of the time.
; * retrace, a relatively short period when the electron gun is returning to
;            the top left of the screen, from where it will begin drawing the
;            next frame to the monitor. Ideally, we write the next frame to
;            the video memory entirely during retrace, so each refresh is
;            only drawing one full frame
; The following procedure waits until the *next* retrace period begins.
; First it waits until the end of the current retrace, if we're in one
; (if we're in refresh this part of the procedure does nothing)
; Then it waits for the end of refresh.

WaitFrame:	
        push 	dx
		; port 0x03DA contains VGA status
		mov 	dx, 0x03DA
.waitRetrace:	
        IN 		al, dx				; read from status port
		; bit 3 will be on if we're in retrace
		test 	al, 0x08			; are we in retrace?
		jnz		.waitRetrace

.endRefresh:	
        IN		al, dx
		test 	al, 0x08			; are we in refresh?
		jz 		.endRefresh
		pop 	dx
		RET

; NOTE: makes ES point to video memory!
InitVideo:	; set video mode 0x13
		mov 	ax, 0x13
		INT		0x10
        ; make ES point to the VGA memory
        mov 	ax, 0xA000
		mov 	es, ax
		RET

RestoreVideo:	; return to text mode 0x03
		mov		ax, 0x03
		INT		0x10
		RET

;Example of how to draw a pixel to a position in the framebuffer
;DrawPixel:	
;        MOV	 BYTE [ES:0x1234], 0x06 ; color brown
;		 RET

;Parameters:
;- AX -> X position
;- CX -> Y position
;- BX -> base memory address of the bitmap
DrawBox:
		push 	ax
		push 	bx
		push 	cx
		push 	si
		push    ax              ;Save the X value for later
		mov		ax, cx          ;Prepare for multiplications
		mov     dx, 320         ;The box is 8x8, the screen width is 320
		mul     dx
		mov     cx, ax          ;Retrieve the line into CX
        pop     ax              ;Retrieve the X value into AX register
		add     cx, ax          ;Now we've put in AX the pointer value 
		mov     si, cx          ;Set SI to the correct address we'll draw
		mov     cx, 00
		mov     ax, 00
		mov     dx, 00
DrawLoop:
		mov     al, byte [ds:bx]		;Current address in BX
		cmp     al, 0ffh				;This is transparent pixel, don't draw
		je      DontDraw
		mov     byte [es:si], al        ;Put the pixel into RAM
DontDraw:
		inc     bx
		inc     cx
		inc     dx
		cmp     dx, 8           ;Sort of modulo
		je      JumpLineDraw    ;Time to increment SI in a more complex way
		inc     si
ContinueComp:
		cmp     cx, 64        ;Compare CX the max the field will be
		jne     DrawLoop        ;Continue
		pop 	si
		pop 	cx
		pop 	bx
		pop 	ax
		ret                     ;Return
JumpLineDraw:
		mov     dx, 00h
		add     si, 313			;Jump a whole line
		jmp     ContinueComp    ;Continue the routine

DrawBackground:
		xor 	si, si
.DrawBackgroundLoop:
        mov     byte[es:si], 0x0ff ; orange color
        inc     si
        cmp     si, 0fa00h ; 0fa00h = 64000
        jne     .DrawBackgroundLoop
        ret

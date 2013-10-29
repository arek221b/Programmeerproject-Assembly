.MODEL large	; multiple data segments and multiple code segments
.STACK 2048  	; stack

; --- INCLUDES -----------------------------------------------------------------

include VIDEO.INC
include KEYB.INC

; --- MACROS AND CONSTANTS -----------------------------------------------------

; Other constants	
SCREENW		equ 320
SCREENH		equ 200
SPEED_BAR	equ 8
BarWidthorg	equ 30
BarHeight	equ 3
beginpixel  equ 56000
balheight   equ 2
balwidth    equ 2



; --- DATA SEGMENT -------------------------------------------------------------
.DATA        ; data segment, variables
oldVideoMode	db ?
posBAR dw 100
barWIDTH dw ?
posXorg db 160
posYorg db 50 
posbal dw 2700

; --- SCREEN BUFFER ------------------------------------------------------------
.FARDATA?	; segment that contains the screenBuffer for mode 13h drawing
palette			db 768 dup(0)
screenBuffer	db 64000 dup(?)	; the 64000 bytes for the screen

; --- CODE SEGMENT -------------------------------------------------------------
.CODE        ; code segment
main PROC NEAR
	mov	ax, @data	; get data segment address
	mov	ds, ax		; set DS to data segment
	
	; Install our own keyboard handler
	call	installKeyboardHandler

	; fade to black
	call	fadeToBlack
	
	; clear videoset buffer
	call	clearScreenBuffer

	; draw the screen buffer
	call 	updateScreen
	
	; set mode 13h
	mov	ax, 13h
	push	ax
	call	setVideoMode
	mov		[oldVideoMode], al
	
	mov [barWIDTH], BarWidthorg
	
@main_loop:
	call	clearScreenBuffer
	
	;draw bal
	
	call drawbal
	; draw a  rectangle
	mov ax, [barWIDTH]
	push	ax
	mov ax, BarHeight
	push	ax
	call 	drawBar

	; draw the screen buffer
	call 	updateScreen
	
	; handle user input
	call	handleInput
	cmp		al, 0
	jz		@main_loop
	
	; Restore original keyboard handler
	call	uninstallKeyboardHandler

	; Restore original video mode
	mov		al, [oldVideoMode]
	xor		ah, ah
	push	ax
	call	setVideoMode
	
	; Exit to DOS
	mov		ax, 4c00h	; exit to DOS function, return code 00h
	int		21h			; call DOS
main ENDP

; Fades the active colors to black
fadeToBlack PROC NEAR
	push	ax

	mov	ax, seg palette
	push	ax
	mov	ax, offset palette
	push	ax
	call	paletteInitFade
@@:	waitVBlank
	call	paletteNextFade
	test	ax, ax
	jnz	@B

	pop	ax
	ret 0
fadeToBlack ENDP

; Clears the screen buffer to color 0
clearScreenBuffer PROC NEAR
	push	ax
	push	cx
	push	di
	push	es
	
	cld
	mov		ax, seg screenBuffer
	mov		es, ax
	mov		di, offset screenBuffer
	mov		cx, 64000/2
	xor		ax, ax
	rep		stosw
	
	pop	es
	pop	di
	pop	cx
	pop	ax
	ret	0
clearScreenBuffer ENDP

; Updates the screen (copies contents from screenBuffer to screen)
updateScreen PROC NEAR
	push	ax
	push	cx
	push	dx
	push	si
	push	di
	push	ds
	push	es
	
	; setup source and dest segments
	mov		ax, seg screenBuffer
	mov		ds, ax
	mov		si, offset screenBuffer
	mov		ax, 0a000h	; video memory
	mov		es, ax
	xor		di, di
	
	cld
	mov		cx, 64000 / 2
	waitVBlank	; wait for a VB (modifies AX and DX)
	rep		movsw	; blit to screen	
	
	pop		es
	pop		ds
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		ax
	ret		0
updateScreen ENDP

; Reads keyboard buffer and acts (returns non-zero if loop should end, 0 otherwise)
handleInput PROC NEAR
	push	es
	push 	dx
	push	bx
	
	mov	ax, seg __keysActive
	mov	es, ax

	xor	ah, ah
	mov	al, es:[__keysActive]
	cmp	al, 0
	jz	@done		; no key pressed
	
	mov	al, es:[__keyboardState][SCANCODE_LEFT]	; test LEFT key
	cmp	al, 0
	jz @F	; jump next
	; call some function to handle this key
	mov dx, [posBAR]
	cmp dx, 0
	jz @F
	mov	cx, SPEED_BAR
	cmp 	dx, cx
	jge 	movebarLeft
	mov 	cx, dx ; put bar to the edge
movebarLeft:	
	neg cx
	add [posBAR], cx
	
@@:
	mov	al, es:[__keyboardState][SCANCODE_RIGHT]	; test RIGHT key
	cmp	al, 0
	jz @F	; jump next
	; call some function to handle this key
	mov	dx, [posBAR]
	neg dx
	add dx, SCREENW
	mov ax, [barWIDTH]
	neg ax
	add dx, ax
	
	cmp dx, 0
	jz @F
	mov	cx, SPEED_BAR
	cmp 	dx, cx
	jge 	movebarRight
	mov 	cx, dx ; put bar to the edge
movebarRight:	
		add [posBAR], cx

@@:
	mov	al, es:[__keyboardState][SCANCODE_UP]	; test RIGHT key
	cmp	al, 0
	jz @F	; jump next
	mov ax, [barWIDTH]
	add ax, 10
	mov [barWIDTH], ax

@@:
	; finally, let's put the ESC key status as return value in AX
	mov	al, es:[__keyboardState][SCANCODE_ESC]	; test ESC

@done:
	pop 	bx
	pop	dx
	pop	es
	ret 0
handleInput ENDP

; Draw a rectangle at the center of the screen buffer.
; W, H passed on stack.
drawBar PROC NEAR
	push	bp
	mov	bp, sp
	
	push	ax
	push	bx
	push	cx
	push	dx
	push	di
	push	es
	
	; set segment
	mov	ax, seg screenBuffer
	mov	es, ax
	
	mov 	ax, [posBAR]            
	add ax, beginpixel
	add	ax, offset screenBuffer
	
	mov	cx, [bp + 4][0]	; rect Height
	mov	di, ax
	
drawloop:
	push cx	
	mov	cx, [bp + 4][2]	; rect Width
	mov	al, 15	; color
	cld
	rep	stosb	; draw	
	sub	di, [bp + 4][2]
	add	di, SCREENW	; jump to next pixel (on next line)
	pop 	cx
	loop	drawloop

	; We are done
	pop	es
	pop	di
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	; return
	pop	bp
	ret	4
drawBar ENDP
  

drawbal Proc NEAR

	push	bp
	mov	bp, sp
	
	push	ax
	push	bx
	push	cx
	push	dx
	push	di
	push	es
	
	; set segment
	mov	ax, seg screenBuffer
	mov	es, ax
	
	mov 	ax, [posbal]            
	add	ax, offset screenBuffer
	
	mov	cx, balheight
	mov	di, ax
	
drawloop:
	push cx	
	mov	cx, balwidth
	mov	al, 15	; color
	cld
	rep	stosb	; draw	
	sub	di, balwidth
	add	di, SCREENW	; jump to next pixel (on next line)
	pop 	cx
	loop	drawloop

	; We are done
	pop	es
	pop	di
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	; return
	pop	bp
	ret	4
drawbal ENDP

     
; _------------------------------- END OF CODE ---------------------------------
END main

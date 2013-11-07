.MODEL large	; multiple data segments and multiple code segments
.STACK 2048  	; stack

; --- INCLUDES -----------------------------------------------------------------

include VIDEO.INC
include KEYB.INC

; --- CONSTANTS ---------------------------------------------------------------

; Other constants	
SCREENW		equ 320
SCREENH		equ 200
BarWidthorg	equ 30
BarHeight	equ 3


; --- DATA SEGMENT -------------------------------------------------------------
.DATA        ; data segment, variables
oldVideoMode	db ?

;BAR
posBAR 	dw 100, 175
widthBAR dw ?
speedBAR	equ 8

;BALL
BALL	word 6,6	;x/y
		byte 0,0,1,1,0,0 
		byte 0,1,1,1,1,0
		byte 1,1,1,1,1,1
		byte 1,1,1,1,1,1
		byte 0,1,1,1,1,0
		byte 0,0,1,1,0,0
		
SIZEOFball	equ $-BALL
BALLcolour	db SIZEOFball dup(15)
posBALL 		dw 2 dup(?) ;pos x en y
speedBALL 	dw 5, -5

;BRICKS
;BRICKS db x1,y1,	x2,y2, ...
;BRICKScolour db colours

;SPECIAL
effectTimer EQU 100
longBARtime dw 0 ;timer for long bar

; --- SCREEN BUFFER ------------------------------------------------------------
.FARDATA?	; segment that contains the screenBuffer for mode 13h drawing
palette			db 768 dup(0)
screenBuffer	db 64000 dup(?)	; the 64000 bytes for the screen

; --- CODE SEGMENT -------------------------------------------------------------
.CODE        ; code segment

; --- SET PROGRAM ------------------------------------
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
	
	mov 	[widthBAR], BarWidthorg
	mov 	ax, [posBAR][0]
	mov	[posBALL][0], ax
	mov	ax, [posBAR][2]
	mov	[posBALL][2], ax
	mov 	ax, [BALL][2]
	sub 	[posBALL][2], ax
	
; --- DRAWLOOP ---------------------------------------
@main_loop:
	call	clearScreenBuffer
	
	;	draw ball
;	mov 	ax, BALLcolour
;	push 	ax
;	mov 	ax, BALL
;	push 	ax
;	mov 	ax, SIZEOFball
;	push 	ax
;	mov 	ax, posBALL
;	push 	ax
	call 	drawObject
	
	; draw bar
	mov 	ax, [widthBAR]
	push	ax
	mov 	ax, BarHeight
	push	ax
	call 	drawBar
	
	; draw the screen buffer
	call 	updateScreen
	
	call paddleDetection
	
	call wallDetection
	
	; update position ball
	call	updateBall
	
	;decrement the timer
	dec 	[longBARtime]
	mov 	ax, [longBARtime]
	cmp 	ax, 0
	jg @F   
	mov [widthBAR], BarWidthorg ; set the orginal length of bar
	
	; handle user input
@@:	call	handleInput
	cmp		al, 0
	jz		@main_loop
	
	call endProgram
main ENDP

; --- FUNCTIONS -----------------------------------
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
	mov		cx, 64000 / 2 ;set counter
	waitVBlank	; wait for a VB (modifies AX and DX)
	rep		movsw	; blit to screen	/ Move word at address DS:SI to address ES:DI
	
	pop		es
	pop		ds
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		ax
	ret		0
updateScreen ENDP

updateBall PROC NEAR
	mov 	ax, [posBALL][0]
	add 	ax, [speedBALL][0]
	mov 	[posBALL][0], ax
	mov 	ax, [posBALL][2]
	add 	ax, [speedBALL][2]
	mov 	[posBALL][2], ax
updateBall ENDP

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
	mov	cx, speedBAR
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
	mov ax, [widthBAR]
	neg ax
	add dx, ax
	
	cmp dx, 0
	jz @F
	mov	cx, speedBAR
	cmp 	dx, cx
	jge 	movebarRight
	mov 	cx, dx 	; put bar to the edge
	movebarRight:	
		add [posBAR], cx
	
@@:
	mov 	ax, [longBARtime]
	cmp 	ax, 0
	jg @F 
	mov	al, es:[__keyboardState][SCANCODE_UP]	; test RIGHT key
	mov [longBARtime], effectTimer
	cmp	al, 0
	jz @F	; jump next
	mov ax, 20
	add [widthBAR], ax
	mov ax, 10
	sub [posBAR], ax

@@:
	; finally, let's put the ESC key status as return value in AX
	mov	al, es:[__keyboardState][SCANCODE_ESC]	; test ESC

@done:
	pop 	bx
	pop	dx
	pop	es
	ret 0
handleInput ENDP

; --- HANDLE DETECTION ----------------------------
newBallprop PROC NEAR
;	- verzekerd nieuwe pos: dus vector -  afstand tot het object = offset van object
;	- neg vector(x of y) afh van boven/onder of rechts/links
; return: 0
newBallprop ENDP


; miscchien gezamelijke functie
wallDetection PROC NEAR
; detecteert of er aanraking is met de wall op stap + 1
; return: afstand tot de wall
	push	bp
	mov	bp, sp

	push	ax
	push	bx
	push	cx
	push	dx
	push	di
	push	es

	mov ax, [posBALL][0]
	add ax, [speedBALL][0]
	
	cmp ax, 0
	jg @F
	neg [speedBALL][0]
@@: 
	add ax, [BALL][0]
	cmp ax, SCREENW
	jl @F 
	neg [speedBALL][0]
	
@@:	mov ax, [posBALL][2]
	add ax, [speedBALL][2]
	cmp ax, 0
	jg @F
	neg [speedBALL][2]
@@: 
	add ax, [BALL][2]
	cmp ax, SCREENH
	jl @F 
	call endProgram

@@:
	; We are done
	pop	es
	pop	di
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	; return
	pop	bp
	ret	0

wallDetection ENDP

paddleDetection PROC NEAR
; detecteert of er aanraking is met de paddle op stap + 1
; return afstand tot de paddle en boven/onder (of rechts/links)

	push	bp
	mov	bp, sp
	
	push	ax
	push	bx
	push	cx
	push	dx
	push	di
	push	es
	
	mov ax, [posBALL][2]
	add ax, [speedBALL][2]
	add ax, [BALL][2]
	cmp ax, [posBAR][2]
	jl paddleDetection_done
	
	mov ax, [posBALL][0]
	add ax, [speedBALL][0]
	mov bx, ax
	
	; eerste vergelijking
	mov ax, [posBAR][0]
	dec ax
	add ax, [widthBAR]
	cmp bx, ax
	jg paddleDetection_done
	
	mov ax, [posBAR][0]
	inc ax
	sub ax, [BALL][0]
	cmp bx, ax
	jl paddleDetection_done
	
	mov ax, [speedBALL][2]
	neg ax
	mov [speedBALL][2], ax

	paddleDetection_done:
	; We are done
	pop	es
	pop	di
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	; return
	pop	bp
	ret	0
paddleDetection ENDP

brickDetection PROC NEAR
; detecteert of er aanraking is met de object op stap + 1
; return afstand tot de paddle en boven/onder of rechts/links
brickDetection ENDP

; --- DRAWING -------------------------------------
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
	
	mov	ax, SCREENW
	mov 	dx, [posBAR][2]
	mul	dx    
	add   ax, [posBAR][0]
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
  
drawObject Proc NEAR

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
	
	mov	ax, SCREENW
	mov 	dx, [posBALL][2]
	mul	dx    
	add   ax, [posBALL][0]
	add	ax, offset screenBuffer
	mov	di, ax
	
	mov cx, 0 ;rij
	mov bx, 0 ;kolom
	mov si, 4
	
	draw_newline:
		mov ax, [BALL][si]
		cmp al,0
		je	nextpos
		draw:
		mov 	al, [BALLcolour][si]
		mov	es:[di], al	; set pixel
		nextpos:
		inc 	si
		inc 	bx
		inc	di
		cmp	bx, [BALL][0]
		je nextline
		jmp draw_newline
		nextline:
		inc	cx
		add 	di, SCREENW
		cmp 	cx, [BALL][2]
		je draw_done
		mov	ax, [BALL][0]
		neg 	ax
		add	di, ax
		add	bx, ax
		jmp draw_newline

	draw_done:	
	; We are done
	pop	es
	pop	di
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	; return
	pop	bp
	ret	0
drawObject ENDP

endProgram PROC NEAR

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

endProgram ENDP

; _------------------------------- END OF CODE ---------------------------------
END main

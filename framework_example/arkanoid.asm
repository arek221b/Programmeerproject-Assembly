.MODEL large	; multiple data segments and multiple code segments
.STACK 2048  	; stack

; ==============================================================================
; INCLUDES
; ==============================================================================

include VIDEO.INC
include KEYB.INC
include data.asm

; ==============================================================================
; CODE SEGMENT
; ==============================================================================
.CODE        ; code segment

; ------------------------------------------------------------
; START PROGRAM
; ------------------------------------------------------------
main PROC NEAR
	mov	ax, @data	; get data segment address
	mov	ds, ax		; set DS to data segment
	
	; INSTALLATION
	; -------------------------------------
	; Install keyboard handler
	call	installKeyboardHandler

	; fade to black
	call	fadeToBlack
	
	; set mode 13h
	mov	ax, 13h
	push	ax
	call	setVideoMode
	mov		[oldVideoMode], al
	
	; MENU
	; -------------------------------------
	call printArkanoid
	
	call updateScreen
	
	call SetHighscore
	
	mov	ah, 12	; xcursor
	mov	al, 15	; ycursor
	push 	ax
	lea	ax, msgMenu1	; adress message
	push 	ax
	call printString
	
	mov	ah, 11	; xcursor
	mov	al, 17	; ycursor
	push 	ax
	lea	ax, msgExit	; adress message
	push 	ax
	call printString
	
  	mov	ax, seg __keysActive
  	mov	es, ax
	@@:
		mov	al, es:[__keyboardState][SCANCODE_ESC]
		cmp	al, 0
		jz	checkP
		call endProgram
		checkP:
		mov	al, es:[__keyboardState][SCANCODE_P]
		cmp	al, 0
		je		@B
	
	call 	newGame
	
	ret 0

main ENDP

; ------------------------------------------------------------
; START GAME
; ------------------------------------------------------------
	
newGame PROC NEAR
	
	mov	[LIFE], 3		; give maxlife
	mov	[SCORE], 0		; set score zero
	mov	[LEVEL], 1		; begin with level 1
	mov	[MAXLIFE], 3
	
	call 	loadLevels
	call 	drawBackground
	call	newLevel			; start new level
	
	ret 0
	
newGame ENDP

; ------------------------------------------------------------
; START LEVEL
; ------------------------------------------------------------

newLevel PROC NEAR	
	
	push 	bp
	mov	bp, sp 
	push	cx
	push	dx
	push	si
	push	di
	push	ds
	push	es
	
	; INITIATE LEVEL
	; -------------------------------------
	; select level
	mov	ax, [LEVEL]
	
	; check maximum level reached
	cmp	ax, [nbrLEVELS]
	jle @F
	call endGame
	
	; select levelarrays
	@@:
	; calculate index  array (1 word elements)
	sal 	ax, 1
	sub	ax, 2 ; array starts at 0
	mov	si, ax
	mov 	ax, [colourBRICKs][si]
	mov	[currentcolourBRICK], ax
	mov 	ax, [nbrBRICKS][si]
	mov	[currentnbrBRICKS], ax
	mov 	ax, [posBRICKS][si]
	mov	[currentposBRICK], ax
	mov 	ax, [stateBRICKS][si]
	mov	[currentstateBRICKS], ax
	
	
	; print level
	mov	ah, 02h			; select function 09h (set cursor)
	mov	dh, 1				; y position of cursor
	mov	dl, 7				; x position of cursor
	xor 	bh, bh 			; viode page 0
	int 	10h				; set cursor
	mov 	ax, [LEVEL]
	push 	ax
	call 	printInt
	
	call printScore
	
	; set all bricks visible
	mov	cx, [currentnbrBRICKS]
	mov	si, 0										; array index number
	@@:
		mov	al, 1
		mov	[currentvisBRICKS][si], al		; set visible (1: visible/ 0: invisible)
		dec 	cx
		inc 	si
		cmp 	cx, 0
		jnz	@B	
	
	mov 	[posBAR], iposBARx 		; set initial bar position

	; BEGIN LEVEL
	; -------------------------------------
	
	start_over:
		call setInit						; set initial ball conditions		
   	call updateScreenBuffer			; draw bricks/bar/ball/harts
	
	; print string (press P to begin)
 	mov	ah, 9	; xcursor
	mov	al, 15	; ycursor
	push 	ax
	lea	ax, msgMenu3	; adress message
	push 	ax
	call printString
	
   mov	ax, seg __keysActive
   mov	es, ax
	
	; wait 1/8 sec (for smooth transition between levels)
	@@:
	mov	ax, 00h
	int	1ah	; read System-Timer Time Counter 
	mov	ax, dx
	add	ax, 1	; (12h = 18: 1 sec)
	mov	[tik], ax
	DELAY:
		mov ax, 00h
		int	1ah
		cmp	[tik], dx
		jge DELAY
	
	mov	al, es:[__keyboardState][SCANCODE_Q]
	cmp	al, 0
	jz	checkspace
	call endGame
	checkspace:
	mov	al, es:[__keyboardState][SCANCODE_SPACEBAR]
	cmp	al, 0
	jnz DRAWloop
	
	; select level
	cmp [SCORE], 0	; only switch between levels when new game
	jne @B
	checkpreviuoslevel:
		mov	al, es:[__keyboardState][SCANCODE_LEFT]
		cmp	al, 0
		je checknextlevel
		cmp 	[LEVEL], 1 ; if level 1 is selected then no previous
		je checknextlevel
		dec [LEVEL]
		call newLevel
	checknextlevel:
		mov	al, es:[__keyboardState][SCANCODE_RIGHT]
		cmp	al, 0
		je	@B
		mov	ax, [LEVEL]
		cmp	ax, [nbrLEVELS]
		je @B
		inc [LEVEL]
		call newLevel	

start_over_decrement: 
  dec [MAXLIFE]
  jmp start_over
	
; BEGIN LEVEL
; -------------------------------------
DRAWloop:

	mov ax, [LIFE]
	cmp ax, [MAXLIFE]
	jne start_over_decrement
	
	call updateScreenBuffer	; draw bricks/bar/ball/harts
	
	call printScore
	
	call bricksDetection		; detect collision between ball and bricks
	
	call paddleDetection		; detect collision between ball and paddle
	
	call wallDetection		; detect collision between ball and wall
	
	call moveBricks				; make the bricks move
	
	call handleInput			; handle userinput

	call updateBall			; update ball (if not yet done by detection)

	mov [detected], 0			; prepare for new ball change
	
	; check if not death
	cmp [LIFE], 0	
	jnz DRAWloop
	
	; end game when LIFE = 0
	call endGame
	
	pop	es
	pop	ds
	pop	di
	pop	si
	pop	dx
	pop	cx
	pop	bp
	ret	0
	
newLevel ENDP

loadLevels PROC NEAR
	
	push	ax
	push	cx
	push	dx
	push	si
	push	di
	push	ds
	push	es
	
	mov	ax, @data	; get data segment address
	mov	ds, ax		; set DS to data segment
	mov	es, ax		; set ES to data segment
	
	mov cx, 0
	levelloop:
		push 	cx
		mov	si, cx
		sal	si, 1
		mov	ax, [nbrBRICKS][si]
		sal	ax, 1
		mov	cx, ax	 ;set counter
		mov 	ax, [posBRICKS][si]
		mov	di, ax
		mov	ax, [inposBRICKS][si] 
		mov	si, ax
		cld	; clear direction flag (inc di/si when movsw)
		rep	movsw	; blit to screen	/ Move word at address DS:SI to address ES:DI
		pop	cx
		inc 	cx
		cmp 	cx, [nbrLEVELS]
		jne	levelloop
	
	pop		es
	pop		ds
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		ax
	ret		0

loadLevels ENDP

updateScreenBuffer PROC NEAR
	
	call	clearGameBuffer
	; draw ball
	mov 	ax, offset BALLcolour
	push 	ax
	mov 	ax, offset BALL
	push 	ax
	mov 	ax, offset posBALL
	push 	ax
	call 	drawObject

	; draw bricks
	mov	di, 0
	mov	si, 0
	mov 	dx, 0 ; teller om te tellen ofdat er nog wel bricks op het speelveld zijn
	drawBricksloop:
		mov	al, [currentvisBRICKS][di]
		cmp	al, 0
		jz @F ; nextbrick
		inc	dx
		mov	ah, 0
		mov	bx, [currentcolourBRICK]
		mov	al, [bx][di]
		push 	ax
		lea	ax, [BRICK]
		push 	ax
		mov 	bx, [currentposBRICK]
		lea	ax, [bx][si]
		push 	ax
		call 	drawRECT
		@@:
		inc 	di
		add	si, 4
		cmp 	di, [currentnbrBRICKS] 
		jnz	drawBricksloop
	
	;check if all bricks are gone	
	cmp dx, 0
	jnz @F
	mov 	ax, [LEVEL]
	inc 	ax
	mov [LEVEL], ax
	call newLevel
	@@:
	; draw bar
	mov 	ax, offset BARcolour
	push 	ax
	mov 	ax, offset BAR
	push 	ax
	mov 	ax, offset posBAR
	push 	ax
	call 	drawObject
	
	; draw hart
	mov 	cx, [LIFE]
	mov	bx, 0
	@@:
		mov 	ax, offset HARTcolour
		push 	ax
		mov 	ax, offset HART
		push 	ax
		lea 	ax, [posHART][bx]
		push 	ax
		call 	drawObject
		dec 	cx
		add	bx, 4
		cmp 	cx, 0
		jnz	@B

	; draw the screen buffer
	call 	updateGameScreen
	
	ret 0
	
updateScreenBuffer ENDP

setInit PROC NEAR
	;initialisten van de vector
	
	mov ax, [speedBALLinit][0]
	mov [speedBALL][0], ax
	mov ax, [speedBALLinit][2]
	mov [speedBALL][2], ax

	;initialiseren van start positie van de bal

	mov 	ax, [posBAR][0]
	mov	[posBALL][0], ax
	
	mov	ax, [posBAR][2]
	sub 	ax, [BALL][2]
	mov 	[posBALL][2], ax
	
	ret 0

setInit ENDP

drawBackground PROC NEAR

	push 	bp
	mov	bp, sp 
	push	cx
	push	dx
	push	si
	push	di
	push	ds
	push	es
	
	call clearScreenBuffer
	
	; draw TUBE1	
	mov 	cx, [nbrTUBES1]
	mov	bx, 0
	@@:
		mov 	ax, offset TUBE1colour
		push 	ax
		mov 	ax, offset TUBE1
		push 	ax
		lea 	ax, [posTUBE1][bx]
		push 	ax
		call 	drawObject
		dec 	cx
		add	bx, 4
		cmp 	cx, 0
		jnz	@B
		
	; draw TUBE2	
	mov 	cx, [nbrTUBES2]
	mov	bx, 0
	@@:
		mov 	ax, offset TUBE2colour
		push 	ax
		mov 	ax, offset TUBE2
		push 	ax
		lea 	ax, [posTUBE2][bx]
		push 	ax
		call 	drawObject
		dec 	cx
		add	bx, 4
		cmp 	cx, 0
		jnz	@B
		
	; draw PIPE1	
	mov 	cx, [nbrPIPES1]
	mov	bx, 0
	@@:
		mov 	ax, offset PIPE1colour
		push 	ax
		mov 	ax, offset PIPE1
		push 	ax
		lea 	ax, [posPIPE1][bx]
		push 	ax
		call 	drawObject
		dec 	cx
		add	bx, 4
		cmp 	cx, 0
		jnz	@B
		
	; draw PIPE2	
	mov 	cx, [nbrPIPES2]
	mov	bx, 0
	@@:
		mov 	ax, offset PIPE2colour
		push 	ax
		mov 	ax, offset PIPE2
		push 	ax
		lea 	ax, [posPIPE2][bx]
		push 	ax
		call 	drawObject
		dec 	cx
		add	bx, 4
		cmp 	cx, 0
		jnz	@B
		
	call 	updateScreen
	
	; Draw strings
	mov	ah, 10	; xcursor
	mov	al, 1	; ycursor
	push 	ax
	lea	ax, msgScore	; adress message
	push 	ax
	call printString
	
	mov	ah, 22	; xcursor
	mov	al, 1	; ycursor
	push 	ax
	lea	ax, msgHighScore	; adress message
	push 	ax
	call printString
	
	mov ah, 02h            			; select function 09h (set cursor)
	mov  dh, 1        				; y position of cursor
	mov  dl, 33      					; x position of cursor
	xor   bh, bh       				; viode page 0
	int 10h          					; set cursor
	mov  ax, [highscore]
	push  ax
	call printInt
	
	mov	ah, 1	; xcursor
	mov	al, 1	; ycursor
	push 	ax
	lea	ax, msgLevels	; adress message
	push 	ax
	call printString
		
	pop	es
	pop	ds
	pop	di
	pop	si
	pop	dx
	pop	cx
	pop	bp
	ret	0
	
drawBackground ENDP

; --- FUNCTIONS -----------------------------------
; Fades the active colors to black

calcSquareroot PROC NEAR
; calculate the square root of ax 
; Nexton formule f(x) = x^2 - S = 0 --> xn+1 = xn - f(xn)/f'(xn) = 1/2(xn + S/xn)
; convergence if startvalue is close to root, take here ax
	push 	bp
	mov	bp, sp 
	push	cx
	push	dx
	push	si
	push	di
	push	ds
	push	es
	
	mov	si, [bp + 4]	; save S
	calcSquarerootloop:
		mov	bx, ax	; set next value
		mov	ax, si
		mov	cx , bx	
		cwd		; sign extend to DX:AX (32-bit)
		idiv	cx	; divide DX:AX by cx
					; result in AX, remainder in DX
		add	ax, bx
		sar	ax, 1 ; divide ax by 2
		cmp	bx, ax ; check convergence
		jne	calcSquarerootloop
	
	pop	es
	pop	ds
	pop	di
	pop	si
	pop	dx
	pop	cx
	pop	bp
	ret	2
	
calcSquareroot ENDP

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
	mov		ax, seg screenBuffer ; Move the segment where screenBuffer is located
	mov		es, ax
	mov		di, offset screenBuffer
	mov		cx, 64000/2 ; /2 want men springt volgens 2 byte en buffer is 64000 lang
	mov 		al, backgrColour
	mov		ah, backgrColour
	rep		stosw ; mov	es:[di], ax	; set pixel for cx times
	
	pop	es
	pop	di
	pop	cx
	pop	ax
	ret	0
clearScreenBuffer ENDP

clearGameBuffer PROC NEAR
	push	bp	
	mov	bp, sp
	
	push	ax
	push 	bx
	push	cx
	push 	dx
	push	di
	push	es
	
	cld
	mov	ax, seg screenBuffer ; Move the segment where screenBuffer is located
	mov	es, ax
	mov	di, offset screenBuffer
	add	di, llimit
	mov	ax, ulimit
	mov	bx, SCREENW
	mul	bx
	add	di, ax
	
	HORZL	equ rlimit-llimit
	mov	ax, blimit
	sub	ax, ulimit
	mov	bx, ax
	loopke:
		mov	cx, HORZL/2
		mov 	al, backgrColour 
		mov	ah, backgrColour 
		rep	stosw ; mov	es:[di], ax	; set pixel for cx times
		add	di, SCREENW
		sub	di, HORZL
		dec bx
		cmp bx, 0
		jnz	loopke
	
	pop	es
	pop	di
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	
	pop	bp
	ret	0
clearGameBuffer ENDP

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
	waitVBlank	; wait for a VB (modifies AX and DX)
	mov		cx, 64000 / 2 ;set counter
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

updateGameScreen PROC NEAR
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
	add		si, llimit
	add		di, llimit
	mov		ax, ulimit
	mov		bx, SCREENW
	mul		bx
	add		si, ax
	add		di, ax
	
	cld
	waitVBlank	; wait for a VB (modifies AX and DX)
	HORZL	equ rlimit-llimit
	mov	ax, blimit
	sub	ax, ulimit
	mov	bx, ax
	loopke:
		mov	cx, HORZL/2
		rep	movsw ; Move word at address DS:SI to address ES:DI
		add	si, SCREENW
		add	di, SCREENW
		sub	si, HORZL
		sub	di, HORZL
		dec 	bx
		cmp 	bx, 0
		jnz loopke
	
	pop		es
	pop		ds
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		ax
	ret		0
updateGameScreen ENDP

updateBall PROC NEAR

	push ax
	push bx
	push cx
	push dx
	
	
	cmp [detected], 1
	je @done
	
	mov 	ax, [posBALL][0]
	add 	ax, [speedBALL][0]
	mov 	[posBALL][0], ax
	mov 	ax, [posBALL][2]
	add 	ax, [speedBALL][2]
	mov 	[posBALL][2], ax
	
	@done:
	pop dx
	pop cx
	pop bx
	pop ax
	
	ret 0
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
	mov 	ax, 1
	push 	ax
	call 	movePaddle
	
	@@:
	mov	al, es:[__keyboardState][SCANCODE_RIGHT]	; test RIGHT key
	cmp	al, 0
	jz @F	; jump next
	mov	ax, 0
	push	ax
	call 	movePaddle

	@@:
	; finally, let's put the ESC key status as return value in AX
	mov	al, es:[__keyboardState][SCANCODE_Q]	; test ESC
	cmp	al, 0
	jz @done	; jump next
	call endGame
			
	@done:
	pop 	bx
	pop	dx
	pop	es
	ret 0
handleInput ENDP

movePaddle PROC NEAR
; verzet de paddle naargelang de afstand tot de limieten
; input: 1 --> linkerkant / 0 --> rechterkant
	push	bp	
	mov	bp, sp

	push	ax
	push	bx
	push	cx
	push	dx
	push	di
	push	es
	
	mov 	cx, [bp + 4] 
	
	; berekening van de afstand tot de limiet
	mov 	ax, [posBAR][0]
	cmp	cx, 0
	jz	@F
	sub 	ax, llimit
	jmp movePaddle_compare
	@@:
	add	ax, [BAR][0]
	sub	ax, rlimit
	neg 	ax
	
	movePaddle_compare:
	cmp ax, 0
	jz movePaddle_done
	mov	bx, speedBAR
	cmp 	ax, bx
	jge movePaddle_move
	mov	bx, ax ; put bar to the edge
	
	movePaddle_move:
	cmp	cx, 0
	jz	@F
	neg 	bx
	@@:
	add	[posBAR][0], bx

	movePaddle_done:	
	
	pop	es
	pop	di
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	; return
	pop	bp

	ret 2

movePaddle ENDP

; ==============================================================================
; HANDLE DETECTION
; ==============================================================================

; --- WALL DETECTION -----------------------------------------------------------
wallDetection PROC NEAR
; detect collision at step n + 1

	push	bp
	mov	bp, sp

	push	ax
	push	bx
	push	cx
	push	dx
	push	di
	push	es
	
	; -----------------------
	; |  check left wall		|
	; -----------------------
	mov 	ax, [posBALL][0]
	add 	ax, [speedBALL][0]
	sub	ax, llimit
	cmp ax, 0                 
	jge @F							; jump to next check 
	
	; calculate new x position   
	neg ax
	add	ax, llimit
	mov [posBall][0], ax
	; calculate new y position
	mov ax, [posBall][2]
	add ax, [speedBall][2]
	mov [posBall][2], ax
	mov [detected], 1			; ball position is changed
	
	; change speedvector
	neg [speedBALL][0]       	; invert x speed
	jmp wallDetection_done		; walldetection is done
	
	; -----------------------
	; |  check right wall	|
	; -----------------------
@@:
	mov ax, [posBALL][0]
	add ax, [speedBALL][0]
	add ax, [BALL][0]   
	sub ax, rlimit 
	cmp ax, 0
	jle @F							; jump to next check 
	
	; calculate new x position 
	mov bx, rlimit
	sub bx, ax
	sub bx, [BALL][0] 
	mov [posBall][0], bx
	; calculate new y position
	mov ax, [posBall][2]
	add ax, [speedBall][2]
	mov [detected], 1			; ball position is changed
	
	; change speedvector
	neg [speedBALL][0]			; invert x speed
	jmp wallDetection_done		; walldetection is done
		
	; -----------------------
	; |  check upper wall	|
	; -----------------------
@@:
	mov ax, [posBALL][2]
	add ax, [speedBALL][2]
	sub ax, ulimit
	cmp ax, 0
	jge @F							; jump to next check
	
	; calculate new y position  
	neg ax	
	add ax, ulimit
	mov [posBall][2], ax
	; calculate new x position
	mov ax, [posBall][0]
	add ax, [speedBall][0]
	mov [posBall][0], ax
	mov [detected], 1			; ball position is changed
	
	; change speedvector
	neg [speedBALL][2]        	; invert x speed
	jmp wallDetection_done		; walldetection is done

	; -----------------------
	; |  check buttom wall	|
	; -----------------------
@@:
	mov ax, [posBALL][2]
	add ax, [speedBALL][2]
	add ax, [BALL][2]
	sub ax, blimit
	cmp ax, 0
	jle wallDetection_done 		; walldetection is done
	
	; game over
	dec [LIFE]						; LIFE = LIFE - 1
	call setInit					; set initial conditions

  	; -----------------------
  	; |   detection done		|
  	; -----------------------
wallDetection_done:
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

; --- PADDLE DETECTION ---------------------------------------------------------
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
	
	; bereken volgende geval van de y-positie van de bal
	mov ax, [posBALL][2]  
	cmp ax, [posBar][2] ; als de bal reeds onder de paddle zich bevindt dan er geen colission zijn
	jg  paddleDetection_done
	add ax, [speedBALL][2]     
	
	; berekening van de offset (y) van de bal tot de bovenkant van de paddle
	add ax, [BALL][2]         	; optellen van hoogte van de bal
	sub ax, [posBAR][2]			
	mov cx, ax						; opslaan
	cmp ax, 0      				; 
	jl paddleDetection_done   	;jump to last
	
	; bereken volgende geval van de x-positie van de bal
	mov 	ax, [speedBall][0]
	sar	ax, 1		; slechts de helft omdat daar de plaats ong zal zijn waar het op het blakje terecht komt
	add ax, [posBall][0] 
	mov bx, ax                 ; opslaan  
	
	; rechterlimiet van de botsingszone
	mov ax, [posBAR][0]       	
	add ax, [BAR][0]
	cmp bx, ax
	jg paddleDetection_done   	; als het groter is dan de rechter dan buiten botsingszone
	
	;linkerlimiet van de bostingszone
	
	mov ax, [posBAR][0] 			; limiet van de botsingszone
	sub ax, [BALL][0]
	;sub ax, [BALL][0]       	; trek de breedte van de bal eraf 
	cmp bx, ax              	
	jl paddleDetection_done 	; als het kleiner is dan de linkerlimiet dan buiten botsingszone
	
	call beep
	; update y position of ball
	mov ax, [posBar][2]
	sub ax, [Ball][2]
	sub ax, cx
	mov [posBall][2], ax
	
	; update x position of ball   
	mov [posBall][0], bx
	mov [detected], 1
	
	; update speedvector (bereken offset tov linkerlimiet)
	mov 	ax, bx 
	sub	ax, [posBAR][0] ; berekening midden van de balk + ball (limiet grootte)
	add	ax, [BALL][0]
	mov	bx, ax
	mov	al, [newspeedBALL][bx]
	cbw
	mov	[speedBALL][0], ax
	; totale snelheid moet behouden blijven
	cmp 	ax, 0	
	jge positive
	neg ax
	positive:
	mul	ax
	neg 	ax
	add	ax, [abs2speedBALL] ; constante snelheid van 50 = 5^2 + 5^2
	push 	ax
	call 	calcSquareroot ; calculate square root of ax
	neg	ax
	mov	[speedBALL][2], ax

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

bricksDetection PROC NEAR
; detecteert of er aanraking is met de object op stap + 1
; return afstand tot de paddle en boven/onder of rechts/links

	push	bp
	mov	bp, sp
	
	push	ax
	push	bx
	push	cx
	push	dx
	
	mov	di, 0	; arrayindex pointer
	mov	si, 0	; brick counter
	brickloop:
	
		; check brick visible 
		mov 	al, [currentvisBRICKS][di]
		cmp	al, 0
		jz @F ; nextbrick
		mov 	ax, 1
		push 	ax			; make room for return value
		mov 	bx, [currentposBRICK]
		mov	ax, [bx + 2][si]
		push ax					; arg2 (y position)
		mov	ax, [bx][si]
		push ax					; integer (x position)
		call  brickDetection
		pop	ax
		mov	[currentvisBRICKS][di], al 
		@@:
		inc 	di
		add	si, 4
		cmp 	di, [currentnbrBRICKS]
		jnz	brickloop
		
	; We are done
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	; return
	pop	bp
	ret	0

bricksDetection ENDP

brickDetection PROC NEAR
; detecteert of er aanraking is met de object op stap + 1
; return afstand tot de paddle en boven/onder of rechts/links

	push	bp
	mov	bp, sp
	
	push	ax
	push	bx
	push	cx
	push	dx
	
	xposBRICK equ [bp + 4]
	yposBRICK equ [bp + 6]
	
	;------------------
	;BOVENKANT checken
	;------------------

    ;|Vergelijken of de bal erboven zit |
    ;------------------------------------
      
	mov ax, [posBALL][2]      ;nieuwe positie y coordinaten berekenen
	add ax, [speedBALL][2]     
	
	add ax, [BALL][2]         ; y breedte van de bal
	mov dx, yposBRICK
	
	cmp ax, dx                ; je vergelijk de hoogte van de bovenkant van bal met de onderkant van de brick
	jl  brickDetection_done  ;jump to last want je weet dat de bal boven de blok zit
	
	
    ;|Vergelijken of de bal binnen de breedte zit onder de hoogte|
    ;-------------------------------------------------------------
	mov ax, [posBALL][0]      ; x positie updaten
	add ax, [speedBALL][0]
	mov bx, ax                 ; ax opslagen  in bx , in bx zit dus de x positie  

	
	; eerste vergelijking ivm de positie van de brick en de bal : rechterlimiet
	
	
	mov ax, xposBRICK          
	dec ax                  ; limiet van de botsingszone
	add ax, [BRICK][0]
	cmp bx, ax
	jg brickDetection_done   ;als de je buiten de zone van de rechterlimiet  bent mag je verder spelen
	
	
	;tweede vergelijking ivm  de positie van de brick en de bal : linkerlimiet
	
	
	mov ax, xposBRICK
	inc ax                  ; limiet van de botsingszone
	sub ax, [BALL][0]       ; trek de breedte van de bal eraf 
	cmp bx, ax              ; positie van de bal  moet kleiner zijn  dan de linkerlimiet
	jl brickDetection_done ;als het kleiner is dan de linkerlimiet dan zit je goed
	 
    ;-----------------
	;ONDERKANT checken
	;-----------------
	
	
	;|Vergelijken of de bal eronderzit |
    ;------------------------------------
    
    
    
	mov ax, [posBALL][2]      ;nieuwe positie y coordinaten berekenen
	add ax, [speedBALL][2]     
	
	;add ax, [BALL][2]         ; y breedte van de bal
	mov dx, yposBRICK
	add dx, [BRICK][2]
	cmp ax, dx                ; je vergelijk de hoogte van de bovenkant van bal met de onderkant van de brick
	jg brickDetection_done    ;jump to last want je weet dat de bal onder de blok zit
	
	
	;|Vergelijken of de bal binnen de breedte zit onder de basis |
    ;-------------------------------------------------------------
	
	
	; eerste vergelijking ivm de positie van de brick en de bal : rechterlimiet
	
	
	mov ax, xposBRICK           
	dec ax                  ; limiet van de botsingszone
	add ax, [BRICK][0]       
	cmp bx, ax
	jg brickDetection_done   ;als de je buiten de zone van de rechterlimiet  bent mag je verder spelen
	
	
	;tweede vergelijking ivm  de positie van de brick en de bal : linkerlimiet
	
	
	mov ax, xposBRICK
	inc ax                  ; limiet van de botsingszone
	sub ax, [BALL][0]       ; trek de breedte van de bal eraf 
	cmp bx, ax              ; positie van de bal  moet kleiner zijn  dan de linkerlimiet
	jl brickDetection_done ;als het kleiner is dan de linkerlimiet dan zit je goed
	
	
	;nu weten we dat de bal zowiezo een collision heeft, nu is de vraag welke collision
	;dit doen we door te kijken van waar dat de bal komt
	
	
	mov ax, [posBall][0]    ;voorafgaande positie ball
	mov bx, ax
	;in bx zit voorgaande positie ball
	mov ax, xposBRICK
	cmp ax, bx 
	jg bricksidecollision
	
	add ax, [BRICK][0]
	cmp ax, bx
	jl bricksidecollision
	
brickbasiscollision:
	neg [speedBALL][2]   ; aanpassen van de speedvector
	jmp deletebrick
	
bricksidecollision:
	neg [speedBALL][0]   ; aanpassen van de speedvector
	
deletebrick:
	xor ax, ax
	mov	[bp + 8] , ax
	add 	[SCORE], 10

brickDetection_done:
	; We are done
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	; return
	pop	bp
	ret	4

brickDetection ENDP

moveBricks PROC NEAR

        push        ax
        push        bx
        push        cx
        push        dx
        
        mov        cx, [currentnbrBRICKS]
        mov         bx, [currentstateBRICKS]
        mov        si, 0                                                                                ; array index number
        xor ah, ah ;ah leegmaken
        
        moveloop:
                mov        al, [bx][si]
                cmp al, 0
                je nextBrick
                
                cmp al, 3
                jge movevert
                
                ;move horizontal
                push ax
                push si 
                call moveBrickHorz
                jmp nextBrick
                
                movevert:
                push ax
                push si 
                call moveBrickVert
                
                nextBrick:
                dec         cx
                inc         si
                cmp         cx, 0
                jnz        moveloop        
                
        pop        dx
        pop        cx
        pop        bx
        pop        ax
        ret        0

moveBricks ENDP

moveBrickHorz PROC NEAR
                        
        push        bp
        mov        bp, sp
        
        push        ax
        push        bx
        push        cx
        push        dx
        push si
        
        mov si, [bp + 4]
        mov ax, [bp + 6]
        
        
        ;si maal 4
        sal si, 1
        sal si, 1
        
                        cmp al , 1
                        jne @F 
                ; move left
                        mov         bx, [currentposBRICK]
                        mov        ax, [bx][si]
                        mov        dx, ax
                        add        dx, [BRICK][0]
                        cmp        dx, llimit
                        jge add1
                        mov         ax, rlimit                ; if crossed set to the other edge
                        jmp saveNewpos
                        add1:
                        push si
                        mov si, [LEVEL]
                        dec si
                        sal si ,1
                        mov        dx, [moveBrickspeed][si]
                        sub ax, dx
                        pop si
                        jmp saveNewpos
                
                @@:        
                ; move right
                        mov         bx, [currentposBRICK]
                        mov        ax, [bx][si]
                        cmp         ax, rlimit        ; check if brick crossed edge
                        jle add2
                        mov ax, llimit                ; if crossed set to the other edge
                        sub        ax, [BRICK][0]
                        jmp saveNewpos
                        add2:
                                                push si
                        mov si, [LEVEL]
                        dec si
                        sal si, 1
                        mov        dx, [moveBrickspeed][si]
                        add ax, dx
                        pop si
                
                saveNewpos:
                mov        [bx][si], ax
                
        ; We are done
        pop si
        pop        dx
        pop        cx
        pop        bx
        pop        ax
        
        ; return
        pop        bp
        ret        4
        
moveBrickHorz ENDP


moveBrickVert PROC NEAR
                        
        push        bp
        mov        bp, sp
        

        push        ax
        push        bx
        push        cx
        push        dx
        push    si
        
        mov si, [bp + 4]
        mov ax, [bp + 6]
        
        
        ;si maal 4
        sal si, 1
        sal si, 1
        
        cmp al , 3
        jne @F 
        ; move up
        mov         bx, [currentposBRICK]
        mov        ax, [bx + 2][si]
        mov        dx, ax
        add        dx, [BRICK][2]
        cmp        dx, ulimit
        jge add1
        mov         ax, blimit-120                ; if crossed set to the other edge
        jmp saveNewpos
        add1:
                        push si
                        mov si, [LEVEL]
                        dec si
                        sal si, 1
                        mov        dx, [moveBrickspeed][si]
                        sub ax, dx
                        pop si
        jmp saveNewpos
        
        @@:
        ; move down
        mov         bx, [currentposBRICK]
        mov        ax, [bx + 2][si]
        cmp         ax, blimit-70        ; check if brick crossed edge
        jle add2
        mov ax, ulimit                ; if crossed set to the other edge
        sub        ax, [BRICK][2]
        jmp saveNewpos
        add2:
                        push si
                        mov si, [LEVEL]
                        dec si
                        sal si, 1
                        mov        dx, [moveBrickspeed][si]
                        add ax, dx
                        pop si
                
        saveNewpos:
                mov        [bx + 2][si], ax
                
        ; We are done
        pop si
        pop        dx
        pop        cx
        pop        bx
        pop        ax

        ; return
        pop        bp
        ret        4
        
moveBrickVert ENDP

; --- DRAWING -------------------------------------
; Draw a rectangle at the center of the screen buffer.
; W, H passed on stack.
drawRECT PROC NEAR
	push	bp
	mov	bp, sp
	
	push	ax
	push	bx
	push	cx
	push	dx
	push	di
	push	es
	
	addrpos		equ [bp + 4]
	addrdim  	equ [bp + 6]
	rectColour	equ [bp + 8]
	
	; set segment
	mov	ax, seg screenBuffer
	mov	es, ax
	
	mov 	bx, addrpos
	
	mov	ax, SCREENW
	mov 	dx, [bx][2]
	mul	dx    
	add   ax, [bx][0]
	add	ax, offset screenBuffer
	mov	di, ax
	
	mov 	bx, addrdim
	mov	cx, [bx][2]
	 drawloop:
	 	push cx  
	 	mov	cx, [bx][0]  ; rect Width
	 	mov 	al, rectColour  ; color
		xor	ah, ah
	 	cld
	 	rep  stosb  ; draw  
	 	sub  di, [bx][0]
	 	add  di, SCREENW  ; jump to next pixel (on next line)
	 	pop   cx
	 	loop  drawloop

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
	ret	6
drawRECT  ENDP
 
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
	
	mov 	si, [bp + 4] ; adress of position
	
	mov	ax, SCREENW
	mov 	dx, [si][2]
	mul	dx    
	add   ax, [si][0]
	add	ax, offset screenBuffer
	mov	di, ax
	
	mov cx, 0 ; rij
	mov dx, 0 ; kolom
	mov si, 4
	
	adressObject equ [bp + 6]
	adressColour equ [bp + 8]
	
	draw_newline: 
		mov 	bx, adressObject
		mov 	ax, [bx][si]
		cmp 	al,0
		je	nextpos
		draw:
		mov 	bx, adressColour
		mov 	al, [bx][si]
		mov	es:[di], al	; set pixel
		nextpos:
		inc 	si
		inc 	dx
		inc	di
		mov 	bx, adressObject
		cmp	dx, [bx][0]
		je nextline
		jmp draw_newline
		nextline:
		inc	cx
		add 	di, SCREENW
		mov 	bx, adressObject
		cmp 	cx, [bx][2]
		je draw_done
		mov 	bx, adressObject
		mov	ax, [bx][0]
		neg 	ax
		add	di, ax
		add	dx, ax
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
	ret	6
drawObject ENDP

endGame PROC NEAR
	
	push	bp
	mov	bp, sp
	
	push	ax
	push	bx
	push	cx
	push	dx
	
 	call clearScreenBuffer
 	call updateScreen
	
	; Save score if highscore
	call SaveHighscore
	
	; MENU
 	mov	ah, 15	; xcursor
	mov	al, 5	; ycursor
	push 	ax
	lea	ax, msgYScore	; adress message
	push 	ax
	call printString
	
	mov ah, 02h							; select function 09h (set cursor)
	mov	dh, 7							; y position of cursor
	mov	dl, 19 						; x position of cursor
	xor 	bh, bh 						; viode page 0
	int 10h	
	mov	ax, [SCORE]
	push  ax
	call printInt
	
 	mov	ah, 7	; xcursor
	mov	al, 16	; ycursor
	push 	ax
	lea	ax, msgNewgame	; adress message
	push 	ax
	call printString
	
 	mov	ah, 11	; xcursor
	mov	al, 19	; ycursor
	push 	ax
	lea	ax, msgExit	; adress message
	push 	ax
	call printString
	
	
	; wait for p to begin
  	mov	ax, seg __keysActive
  	mov	es, ax
	@@:
		mov	al, es:[__keyboardState][SCANCODE_ESC]
		cmp	al, 0
		jz	checkP
		call endProgram
		checkP:
		mov	al, es:[__keyboardState][SCANCODE_P]
		cmp	al, 0
		je		@B
	
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	
	pop	bp
	
	call 	newGame
	
	ret 0
	
endGame ENDP

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
	
	ret 0
	
endProgram ENDP

printInt PROC NEAR

	push	bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push	ax
	push	bx
	push	cx
	push	dx
	push	si	
	
	integer equ [bp + 4]

	mov	bx, integer
	
	cmp bx, 0
	jne @F
	mov ah, 02h
	mov dx, 0
	add dl, 48 ; converteert het tot ASCII
	int 21h
	jmp printInt_done
@@:	
	test	bx, 0FFFFh ; test if bx is negative
	jnz	@F
	mov	ah, 2
	mov	dl, '-'
	int	21h
	; invert sign of bx
	neg	bx
@@:
	; prepare powers-of-ten on stack
	mov	ax, 1
	push	ax
	mov	ax, 10
	push	ax
	mov	ax, 100
	push	ax
	mov	ax, 1000
	push	ax
	mov	ax, 10000
	push	ax

@@:
	pop	cx
	cmp	bx, cx
	jb	@B
@@:
	mov	ax, bx
	cwd		; sign extend to DX:AX (32-bit)
	idiv	cx	; divide DX:AX by current power of ten
				; result in AX, remainder in DX
	mov	bx, dx
	mov	ah, 02h	; print one character
	mov	dl, al	; al contains the digit, move into dl
	add	dl, 48	; add 48 to convert it to ASCII digit
	int	21h

	cmp	cx, 1
	je	printInt_done
	pop	cx	; next power of ten
	jmp	@B ; repeat for next digit
printInt_done:
	; restore context (reverse pop the registers)
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	; restore sp and bp
	mov	sp, bp
	pop	bp

	ret	2
printInt ENDP

printString PROC NEAR
	
	push  bp  ; save dynamic link
	mov  bp, sp  ; update bp
	; save context on stack
	push  ax
	push  bx
	push  cx
	push  dx
	push  si 
	
	xcursor equ [bp + 7]
	ycursor equ [bp + 6]
	message equ [bp + 4]
	
	mov 	ah, 02h			; select function 09h (set cursor)
	mov	dl, xcursor 	; x position of cursor
	mov	dh, ycursor		; y position of cursor
	xor 	bh, bh 			; viode page 0
	int 	10h				; set cursor
	mov	ah, 09h			; select function 09h (print string)
	mov	dx, message		; load offset address of msgMenu1 (press Q to exit)
	int	21h
	
 	pop  si
 	pop  dx
 	pop  cx
 	pop  bx
 	pop  ax
 	; restore sp and bp
 	mov  sp, bp
 	pop  bp

	ret 4

printString ENDP

printScore PROC NEAR
	
	push ax
	push bx
	push cx
	push dx
	
	mov ah, 02h				; select function 09h (set cursor)
	mov	dh, 1				; y position of cursor
	mov	dl, 17			; x position of cursor
	xor 	bh, bh 			; viode page 0
	int 10h					; set cursor
	mov	ax, [SCORE]
	push  ax
	call printInt
	
	pop dx
	pop cx
	pop bx
	pop ax
	
	ret 0
printScore ENDP

printArkanoid PROC NEAR

	push 	ax
	push 	cx
	
	mov 	ax, offset characterAcolour
	push 	ax
	mov 	ax, offset characterA
	push 	ax
	mov 	ax, offset poscharacterA
	push 	ax
	call 	drawObject
	
	mov 	ax, offset characterRcolour
	push 	ax
	mov 	ax, offset characterR
	push 	ax
	mov 	ax, offset poscharacterR
	push 	ax
	call 	drawObject
	
	mov 	ax, offset characterKcolour
	push 	ax
	mov 	ax, offset characterK
	push 	ax
	mov 	ax, offset poscharacterK
	push 	ax
	call 	drawObject
	
	mov 	ax, offset characterAscolour
	push 	ax
	mov 	ax, offset characterAs
	push 	ax
	mov 	ax, offset poscharacterAs
	push 	ax
	call 	drawObject
	
	mov 	ax, offset characterNcolour
	push 	ax
	mov 	ax, offset characterN
	push 	ax
	mov 	ax, offset poscharacterN
	push 	ax
	call 	drawObject
	
	mov 	ax, offset characterOcolour
	push 	ax
	mov 	ax, offset characterO
	push 	ax
	mov 	ax, offset poscharacterO
	push 	ax
	call 	drawObject
	
	mov 	ax, offset characterIcolour
	push 	ax
	mov 	ax, offset characterI
	push 	ax
	mov 	ax, offset poscharacterI
	push 	ax
	call 	drawObject
	
	mov 	ax, offset characterDcolour
	push 	ax
	mov 	ax, offset characterD
	push 	ax
	mov 	ax, offset poscharacterD
	push 	ax
	call 	drawObject
	
	mov	cx, 2
	MENUbarloop:
		xor	ah, ah
		mov	al, 15
		push 	ax
		lea 	ax, [MENUbar]
		push 	ax
		lea 	ax, [posMENUbar]
		push 	ax
		call 	drawRECT
		
		mov 	ax, [posMENUbar][2]
		add	ax, 66
		mov	[posMENUbar][2], ax
		dec cx
		cmp cx, 0
		jne MENUbarloop
	
	pop	cx
	pop 	ax
	ret 0

printArkanoid ENDP

beep PROC NEAR

	mov	al, 182 			; send command to PIT( Programmable Interval Timer)
	out 43h, al				; to prepare speaker for the note
	
	; Set frequency
	mov ax, 1521 			; f = 1193182 / x here x = 1521 and f = 783.00 (note = G)
	out 42h, al 			; send LSB (by accessing channel 2 (controls PC speaker) of PIT)
	mov al, ah				
	out 42h, al				; send MSB
	
	; Turn on speaker
	in al, 61h  			; get value of port 61h
	or al, 00000011b 		; change last bits to 1
	out 61h, al				; send value to port 61h
	
	; Pause
	mov	cx, 1000000000
	delay_loop:
		loop	delay_loop
	
	; Turn off speaker
	in al, 61h				; get value of port 61h
	and al, 11111100b 	; change last bits to 0
	out 61h, al				; send value to port 61h
	
	ret 0
beep ENDP

SaveHighscore PROC NEAR
	
	push  bp  ; save dynamic link
 	mov  bp, sp  ; update bp
 	; save context on stack
 	push  ax
 	push  bx
 	push  cx
 	push  dx
 	push  si  
	
	; open file
 	mov  ax,3d00h
 	lea  dx,[filename]
 	int  21h
 	jnc @F     ;als de carry niet gezet is dan kan men voort gaan met het lezen van de file
  
 	;anders moet men de highscore gewoon op nul initializeren 
 	mov ax , [SCORE]
 	mov [highscore], ax
 	jmp @@save
 
 @@:
 	mov bx, ax ; put handle in BX
	
 	; read from file
 	mov  ah, 3fh
 	mov  cx, 2
 	lea  dx, [highscore]
 	int  21h
 	jnc  @F 	
	;min highscore gewoon megeven zodanig score zowiezo wordt weggeschreven 
 	mov highscore, 0
 	
	@@:
 	;compare scores
 	mov ax, [SCORE]  ;we halen de behaalde score van de stack 
 	cmp ax, [highscore]
 	jle done
	
	; print (new Highscore)
	mov ah, 02h							; select function 09h (set cursor)
	mov	dh, 10						; y position of cursor
	mov	dl, 14 						; x position of cursor
	xor 	bh, bh 						; viode page 0
	int 10h								; set cursor
	mov	ah, 09h						; select function 09h (print string)
	mov	dx, offset msgNewhigh	; load offset address of msgYScore (NEW HIGHSCORE)
	int	21h
	
	mov ax, [SCORE]
	mov [highscore], ax
 	@@save:
 	;file open for writing
 	mov  ax,3d01h
 	lea  dx,[filename]
 	int  21h
 	jnc @F
  
  ; try to create the file
 	mov ah, 3ch
 	mov cl, 0
 	lea dx, [filename]
 	int 21h
 	jc done ; error occured
	
	@@:
 	mov  bx, ax ; put handle in BX
 
 	; write score to file
 	mov  ah,40h
 	mov  cx,2
 	lea  dx,[highscore]
 	int  21h
 
 	; close file
 	mov  ah,3eh
 	int  21h
 
 	done:
 	; restore context (reverse pop the registers)
 	pop  si
 	pop  dx
 	pop  cx
 	pop  bx
 	pop  ax
 	; restore sp and bp
 	mov  sp, bp
 	pop  bp
 	ret 0
  
 SaveHighscore ENDP
 
 SetHighscore PROC NEAR
 
 	push  bp  ; save dynamic link
 	mov  bp, sp  ; update bp
	; save context on stack
 	push  ax
 	push  bx
 	push  cx
 	push  dx
 	push  si  
	  
 ; open file
 	mov  ax,3d00h
 	lea  dx,[filename]
 	int  21h
 	jnc readHighScore    ;als de carry niet gezet is dan kan men voort gaan met het lezen van de file
	 
	;anders moet men de highscore gewoon op nul initializeren
 	mov [highscore], 0
 	jmp done
	
 	readHighScore:
 	mov bx, ax ; put handle in BX
 	
	; read from file
 	mov  ah,3fh
 	mov  cx,2
 	lea  dx,[highscore]
 	int  21h
	 
 	done:
 	; restore context (reverse pop the registers)
 	pop  si
 	pop  dx
 	pop  cx
 	pop  bx
 	pop  ax
 	; restore sp and bp
 	mov  sp, bp
 	pop  bp
 	ret 0
	
SetHighscore ENDP

; _------------------------------- END OF CODE ---------------------------------
END main

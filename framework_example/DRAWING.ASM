.MODEL large	; multiple data segments and multiple code segments
.STACK 2048  	; stack

; --- INCLUDES -----------------------------------------------------------------

include VIDEO.INC
include KEYB.INC

; --- CONSTANTS ---------------------------------------------------------------

; Other constants	
SCREENW		equ 320
SCREENH		equ 200
BarWidthorg	equ 31
BarHeight	equ 3

rlimit	equ 300	; right screen limit
llimit	equ 10	; left screen limit
ulimit	equ 10	; upper screen limit
blimit	equ 200	; buttom screen limit


; --- DATA SEGMENT -------------------------------------------------------------
.DATA        ; data segment, variables
oldVideoMode	db ?

;BAR
posBAR 	dw 150, 170
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
speedBALL 	dw 2 dup(?)
speedBALLinit	dw 5, -5 
aangepast dw 0

;BRICKS
brickwidth equ  70
heightBrick   equ  10
;BRICKS db x1,y1,	x2,y2, ...
posBrick dw 100,70 ;x en y

;BRICKScolour db colours

LIFE dw 3
MAXLIFE dw 3

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
	
	; set mode 13h
	mov	ax, 13h
	push	ax
	call	setVideoMode
	mov		[oldVideoMode], al
	
start_over:
	; set initial ball conditions
	call setInit
   call updateScreenBuffer 
	
	;wait for spacebar to begin
    mov	ax, seg __keysActive
    mov	es, ax
   
@@:
	mov	al, es:[__keyboardState][SCANCODE_SPACEBAR]
	cmp	al, 0
	je		@B
	jmp @main_loop

start_over_decrement: 
  dec [MAXLIFE]
  jmp start_over
	
; --- DRAWLOOP ---------------------------------------
@main_loop:
	
	mov ax, [LIFE]
	cmp ax, [MAXLIFE]
	jne start_over_decrement
	
	call updateScreenBuffer
	
	call brickDetection
	
	call paddleDetection
	
	call wallDetection
	
	cmp [aangepast], 1
	je @F
	call updateBall

@@: 
	mov [aangepast], 0
	;decrement the timer
	dec 	[longBARtime]
	mov 	ax, [longBARtime]
	cmp 	ax, 0
	jg @F   
	mov [widthBAR], BarWidthorg ; set the orginal length of bar
	@@:
	cmp [LIFE], 0	
	jnz @main_loop
	
	; end program when LIFE = 0
	@main_drawdone:
	call endProgram
main ENDP

updateScreenBuffer PROC NEAR
	
	call	clearScreenBuffer

	;	draw ball
	mov 	ax, offset BALLcolour
	push 	ax
	mov 	ax, offset BALL
	push 	ax
	mov 	ax, offset posBALL
	push 	ax
	call 	drawObject

	;draw brick
	mov 	ax, [brickwidth]
	push	ax
	mov 	ax, [heightBrick]
	push	ax
	call 	drawBrick

	; draw bar
	mov 	ax, [widthBAR]
	push	ax
	mov 	ax, BarHeight
	push	ax
	call 	drawBar

	; draw the screen buffer
	call 	updateScreen
	
	ret 0
	
updateScreenBuffer ENDP

setInit PROC NEAR
	;initialisten van de vector
	
	mov ax, [speedBALLinit][0]
	mov [speedBALL][0], ax
	mov ax, [speedBALLinit][2]
	mov [speedBALL][2], ax

	;initialiseren van start positie van de bal

	mov 	[widthBAR], BarWidthorg
	mov 	ax, [posBAR][0]
	mov	[posBALL][0], ax
	
	mov	ax, [posBAR][2]
	sub 	ax, [BALL][2]
	mov 	[posBALL][2], ax
	
	ret 0

setInit ENDP


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
	mov	al, es:[__keyboardState][SCANCODE_ESC]	; test ESC

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
	add	ax, [widthBAR]
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
	
	; controleren van de left wall
	mov 	ax, [posBALL][0]
	add 	ax, [speedBALL][0]
	sub	ax, llimit
	cmp ax, 0                 
	jge @F    ;jump to forward 
	neg ax
	add	ax, llimit
	mov [posBall][0], ax
	mov ax, [posBall][2]
	add ax, [speedBall][2]
	mov [posBall][2], ax
	neg [speedBALL][0]        ;zet snelheid negatief
	mov [aangepast], 1
	jmp wallDetection_done
	
   ; controleren van de right wall
@@:
	mov ax, [posBALL][0]
	add ax, [speedBALL][0]
	add ax, [BALL][0]   
	sub ax, rlimit 
	cmp ax, 0
	jle @F
	mov bx, rlimit
	sub bx, ax
	sub bx, [BALL][0] 
	mov [posBall][0], bx
	mov ax, [posBall][2]
	add ax, [speedBall][2]
	neg [speedBALL][0]
	mov [aangepast], 1
	jmp wallDetection_done
		
	; controleren van de upper wall
@@:
	mov ax, [posBALL][2]
	add ax, [speedBALL][2]
	cmp ax, 0
	jge @F
	neg ax
	mov [posBall][2], ax
	mov ax, [posBall][0]
	add ax, [speedBall][0]
	mov [posBall][0], ax
	neg [speedBALL][2]        ;zet snelheid negatief
	mov [aangepast], 1
	jmp wallDetection_done

   ; controleren van de onderkant
@@:
	mov ax, [posBALL][2]
	add ax, [speedBALL][2]
	add ax, [BALL][2]
	sub ax, blimit
	cmp ax, 0
	jle wallDetection_done 
	dec [LIFE]
	call setInit
	  ;sluit alles af , videomode terugzetten, "je bent eraan!"

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
	mov ax, [posBALL][0]      
	add ax, [speedBALL][0]
	mov bx, ax                 ; opslaan  
	
	; rechterlimiet van de botsingszone
	mov ax, [posBAR][0]       	
	add ax, [widthBAR]
	cmp bx, ax
	jg paddleDetection_done   	; als het groter is dan de rechter dan buiten botsingszone
	
	;linkerlimiet van de bostingszone
	
	mov ax, [posBAR][0] 			; limiet van de botsingszone
	sub ax, [BALL][0]
	;sub ax, [BALL][0]       	; trek de breedte van de bal eraf 
	cmp bx, ax              	
	jl paddleDetection_done 	; als het kleiner is dan de linkerlimiet dan buiten botsingszone
	
	; update y position of ball
	mov ax, [posBar][2]
	sub ax, [Ball][2]
	sub ax, cx
	mov [posBall][2], ax
	
	; update x position of ball
	mov ax, [posBall][0]
	add ax, [speedBall][0]
	mov [posBall][0], ax
	mov [aangepast], 1
	
	; update speedvector
	neg [speedBALL][2]

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

	push	bp
	mov	bp, sp
	
	push	ax
	push	bx
	push	cx
	push	dx
	push	di
	push	es
	
	;------------------
	;BOVENKANT checken
	;------------------


    ;|Vergelijken of de bal erboven zit |
    ;------------------------------------
    
    
	mov ax, [posBALL][2]      ;nieuwe positie y coordinaten berekenen
	add ax, [speedBALL][2]     
	
	add ax, [BALL][2]         ; y breedte van de bal
	mov dx, [posBrick][2] 
	
	cmp ax, dx                ; je vergelijk de hoogte van de bovenkant van bal met de onderkant van de brick
	jl brickDetection_done    ;jump to last want je weet dat de bal boven de blok zit
	
	
   
    ;|Vergelijken of de bal binnen de breedte zit onder de hoogte|
    ;-------------------------------------------------------------
	mov ax, [posBALL][0]      ; x positie updaten
	add ax, [speedBALL][0]
	mov bx, ax                 ; ax opslagen  in bx , in bx zit dus de x positie  

	
	; eerste vergelijking ivm de positie van de brick en de bal : rechterlimiet
	
	
	mov ax, [posBrick][0]            
	dec ax                  ; limiet van de botsingszone
	add ax, [brickwidth]       
	cmp bx, ax
	jg brickDetection_done   ;als de je buiten de zone van de rechterlimiet  bent mag je verder spelen
	
	
	;tweede vergelijking ivm  de positie van de brick en de bal : linkerlimiet
	
	
	mov ax, [posBrick][0]
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
	mov dx, [posBrick][2] 
	add dx, [heightBrick]
	cmp ax, dx                ; je vergelijk de hoogte van de bovenkant van bal met de onderkant van de brick
	jg brickDetection_done    ;jump to last want je weet dat de bal onder de blok zit
	
	
	
	
	;|Vergelijken of de bal binnen de breedte zit onder de basis|
    ;-------------------------------------------------------------
    
	
	mov ax, [posBALL][0]      ; x positie updaten
	add ax, [speedBALL][0]
	mov bx, ax                 ; ax opslagen  in bx , in bx zit dus de x positie  
	
	
	; eerste vergelijking ivm de positie van de brick en de bal : rechterlimiet
	
	
	mov ax, [posBrick][0]            
	dec ax                  ; limiet van de botsingszone
	add ax, [brickwidth]       
	cmp bx, ax
	jg brickDetection_done   ;als de je buiten de zone van de rechterlimiet  bent mag je verder spelen
	
	
	;tweede vergelijking ivm  de positie van de brick en de bal : linkerlimiet
	
	
	mov ax, [posBrick][0]
	inc ax                  ; limiet van de botsingszone
	sub ax, [BALL][0]       ; trek de breedte van de bal eraf 
	cmp bx, ax              ; positie van de bal  moet kleiner zijn  dan de linkerlimiet
	jl brickDetection_done ;als het kleiner is dan de linkerlimiet dan zit je goed
	
	
	;nu weten we dat de bal zowiezo een collision heeft, nu is de vraag welke collision
	;dit doen we door te kijken van waar dat de bal komt
	
	
	mov ax, [posBall] [0]    ;voorafgaande positie ball
	mov bx, ax
	;in bx zit voorgaande positie ball
	mov ax, [posBrick] [0]
	cmp ax, bx 
	jg bricksidecollision
	
	
	add ax, [brickwidth]
	cmp ax, bx
	jl bricksidecollision
	
brickbasiscollision:
	mov ax, [speedBALL][2]   ;aanpassen van de speedvector
	neg ax                   ;inverteren
	mov [speedBALL][2], ax   ;opslagen in speedbal
	jmp brickDetection_done


bricksidecollision:
    mov ax, [speedBALL][0]   ;aanpassen van de speedvector
	neg ax                   ;inverteren
	mov [speedBALL][0], ax   ;opslagen in speedbal
 

brickDetection_done:
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

brickDetection ENDP

; --- DRAWING -------------------------------------
; Draw a rectangle at the center of the screen buffer.
; W, H passed on stack.


;tekenen van de brick

drawBrick PROC NEAR
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
	mov 	dx, [posBrick][2]
	mul	dx    
	add   ax, [posBrick][0]
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
drawBrick ENDP

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
	
	mov 	si, [bp + 4] ; adress of position
	
	mov	ax, SCREENW
	mov 	dx, [si][2]
	mul	dx    
	add   ax, [si][0]
	add	ax, offset screenBuffer
	mov	di, ax
	
	mov cx, 0 ; rij
	mov bx, 0 ; kolom
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
	ret	6
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

printint PROC NEAR
	; argument/local variables addresses
	argBytes EQU 2 ; EQU === equates to
	arg1 EQU [bp + 4][0] 
	; code
	push	bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push	ax
	push	bx
	push	cx
	push	dx
	push	si	
	; load param in bx
	mov	bx, arg1	; near proc, one word return address
	; handle special case of zero
	test	bx, 0FFFFh ; test if bx is negative
	jnz	@F	; jmp forward to next @@ label
	mov	ah, 02h
	mov	dl, '0'
	int	21h		; print the '0' character
	jmp	@printint_done
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
	; from now on bx is strictly positive
	; determine largest power of ten smaller than bx
	; init si to point to first element of powersoften array
	; while bx < cx, pop cx 
@@:
	pop	cx
	cmp	bx, cx
	jb	@B	; jmp back to @@ label
@@:
	; ok now print digits
	mov	ax, bx
	cwd		; sign extend to DX:AX (32-bit)
	idiv	cx	; divide DX:AX by current power of ten
				; result in AX, remainder in DX
	mov	bx, dx	; move remainder to bx
	mov	ah, 02h	; print one character
	mov	dl, al	; al contains the digit, move into dl
	add	dl, 48	; add 48 to convert it to ASCII digit
	int	21h	; call DOS function
	; was this the last digit? i.e. [si] equals 1
	cmp	cx, 1
	je	@printint_done
	pop	cx	; next power of ten
	jmp	@B ; repeat for next digit
@printint_done:
	; restore context (reverse pop the registers)
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	; restore sp and bp
	mov	sp, bp
	pop	bp
	; return freeing param from stack (2 bytes)
	ret	argBytes
printint ENDP

; print a signed integer to stdout
; value on stack
printints PROC NEAR
	; argument/local variables addresses
	argBytes EQU 2
	arg1 EQU [bp + 4][0]
	; code
	push	bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push	ax
	push	bx
	push	dx
	; load param in bx
	mov	bx, arg1	; near proc, one word return address
	; handle special case of zero and test for sign
	cmp	bx, 0
	jge	@F
	; if negative, print sign and invert
	; print sign (int 21h, function 02h)
	mov	ah, 2
	mov	dl, '-'
	int	21h
	; invert sign of bx
	neg	bx
@@:
	push	bx
	call	printint	
	; restore context (reverse pop the registers)
	pop	dx
	pop	bx
	pop	ax
	; restore sp and bp
	mov	sp, bp
	pop	bp
	; return freeing param from stack (2 bytes)
	ret	argBytes
printints ENDP

; _------------------------------- END OF CODE ---------------------------------
END main

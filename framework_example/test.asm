; ==============================================================================
; HANDLE DETECTION
; ==============================================================================

; --- WALL DETECTION -----------------------------------------------------------
wallDetection PROC NEAR

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
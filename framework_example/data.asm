; ==============================================================================
; SCREEN CONSTANTS
; ==============================================================================

SCREENW		equ 320
SCREENH		equ 200

rlimit	equ SCREENW-8	; right screen limit
llimit	equ 0+8	; left screen limit
ulimit	equ 35	; upper screen limit
blimit	equ 200	; buttom screen limit


; ==============================================================================
; DATA
; ==============================================================================
.DATA        ; data segment, variables
oldVideoMode	db ?

; ------------------------------------------------------------
; MENU DATA
; ------------------------------------------------------------
msgMenu1 db "Press P to play$"
msgNewgame db "Press P to start a new game$"
msgMenu2 db "Press Q to quit$"
msgMenu3 db "Press spacebar to begin$"  
msgExit db "Press ESC to exit$"
msgScore db "Score: $"
msgHighScore db "Highscore: $"
msgLevels db "Level $"
msgYScore db "Your Score: $" 
msgNewhigh db "NEW HIGHSCORE$"

characterA 	word 28, 22
				byte 12 dup(0), 4 dup(1),  12 dup(0)
				byte 11 dup(0), 6 dup(1), 11 dup(0)
				byte 11 dup(0), 6 dup(1), 11 dup(0)
				byte 10 dup(0), 3 dup(1), 0, 4 dup(1), 10 dup(0)
				byte 10 dup(0), 3 dup(1), 2 dup(0), 3 dup(1), 10 dup(0)
				byte 9 dup(0), 3 dup(1), 3 dup(0), 4 dup(1), 9 dup(0)
				byte 8 dup(0), 4 dup(1), 4 dup(0), 3 dup(1), 9 dup(0) 
				byte 8 dup(0), 3 dup(1), 5 dup(0), 4 dup(1), 8 dup(0) 
				byte 7 dup(0), 4 dup(1), 6 dup(0), 4 dup(1), 7 dup(0) 
				byte 7 dup(0), 3 dup(1), 7 dup(0), 4 dup(1), 7 dup(0) 
				byte 6 dup(0), 4 dup(1), 8 dup(0), 4 dup(1), 6 dup(0) 
				byte 6 dup(0), 3 dup(1), 9 dup(0), 4 dup(1), 6 dup(0) 
				byte 5 dup(0), 4 dup(1), 10 dup(0), 4 dup(1), 5 dup(0) 
				byte 5 dup(0), 3 dup(1), 11 dup(0), 4 dup(1), 5 dup(0) 
				byte 4 dup(0), 20 dup(1), 4 dup(0) 
				byte 4 dup(0), 20 dup(1), 4 dup(0) 
				byte 3 dup(0), 22 dup(1), 3 dup(0) 
				byte 2 dup(0), 4 dup(1), 15 dup(0), 5 dup(1), 2 dup(0) 
				byte 2 dup(0), 4 dup(1), 16 dup(0), 4 dup(1), 2 dup(0) 
				byte 1 dup(0), 4 dup(1), 18 dup(0), 4 dup(1), 1 dup(0) 
				byte 1 dup(0), 3 dup(1), 19 dup(0), 4 dup(1), 1 dup(0) 
				byte 4 dup(1), 20 dup(0), 4 dup(1)		
SIZEOFcharacterA	equ $-characterA 

characterAcolour	db SIZEOFcharacterA dup(15)	
poscharacterA dw 51, 48

characterR 	word 20, 18
				byte 17 dup(1), 3 dup(0)
				byte 18 dup(1), 2 dup(0)
				byte 18 dup(1), 2 dup(0)
				byte 3 dup(1), 12 dup(0), 3 dup(1), 2 dup(0)
				byte 3 dup(1), 12 dup(0), 3 dup(1), 2 dup(0)
				byte 3 dup(1), 12 dup(0), 3 dup(1), 2 dup(0)
				byte 3 dup(1), 12 dup(0), 3 dup(1), 2 dup(0)
				byte 3 dup(1), 12 dup(0), 3 dup(1), 2 dup(0)
				byte 18 dup(1), 2 dup(0)
				byte 18 dup(1), 2 dup(0)
				byte 17 dup(1), 3 dup(0)
				byte 3 dup(1), 6 dup(0), 3 dup(1), 8 dup(0)
				byte 3 dup(1), 7 dup(0), 4 dup(1), 6 dup(0)
				byte 3 dup(1), 8 dup(0), 4 dup(1), 5 dup(0)
				byte 3 dup(1), 9 dup(0), 4 dup(1), 4 dup(0)
				byte 3 dup(1), 10 dup(0), 4 dup(1), 3 dup(0)
				byte 3 dup(1), 11 dup(0), 4 dup(1), 2 dup(0)
				byte 3 dup(1), 12 dup(0), 5 dup(1)
SIZEOFcharacterR	equ $-characterR 

characterRcolour	db SIZEOFcharacterR dup(15)	
poscharacterR dw 51+28+4, 48+4

characterK 	word 21, 18
				byte 3 dup(1), 11 dup(0), 5 dup(1), 2 dup(0)
				byte 3 dup(1), 9 dup(0), 5 dup(1), 4 dup(0)
				byte 3 dup(1), 8 dup(0), 5 dup(1), 5 dup(0)
				byte 3 dup(1), 6 dup(0), 5 dup(1), 7 dup(0)
				byte 3 dup(1), 5 dup(0), 5 dup(1), 8 dup(0)
				byte 3 dup(1), 3 dup(0), 5 dup(1), 10 dup(0)
				byte 3 dup(1), 2 dup(0), 4 dup(1), 12 dup(0)
				byte 3 dup(1), 1 dup(0), 4 dup(1), 13 dup(0)
				byte 6 dup(1), 15 dup(0)
				byte 7 dup(1), 14 dup(0)
				byte 3 dup(1), 1 dup(0), 4 dup(1), 13 dup(0)
				byte 3 dup(1), 2 dup(0), 4 dup(1), 12 dup(0)
				byte 3 dup(1), 3 dup(0), 5 dup(1), 10 dup(0)
				byte 3 dup(1), 5 dup(0), 5 dup(1), 8 dup(0)
				byte 3 dup(1), 6 dup(0), 5 dup(1), 7 dup(0)
				byte 3 dup(1), 8 dup(0), 5 dup(1), 5 dup(0)
				byte 3 dup(1), 9 dup(0), 5 dup(1), 4 dup(0)
				byte 3 dup(1), 11 dup(0), 7 dup(1)
SIZEOFcharacterK	equ $-characterK 

characterKcolour	db SIZEOFcharacterK dup(15)	
poscharacterK dw 51+28+4+21+6, 48+4

characterAs	word 24, 18
				byte 10 dup(0), 4 dup(1),  10 dup(0)
				byte 9 dup(0), 5 dup(1), 10 dup(0)
				byte 9 dup(0), 6 dup(1),  9 dup(0)
				byte 8 dup(0), 3 dup(1), 0, 3 dup(1), 9 dup(0)
				byte 8 dup(0), 3 dup(1), 2 dup(0), 3 dup(1), 8 dup(0)
				byte 7 dup(0), 3 dup(1), 3 dup(0), 4 dup(1), 7 dup(0)
				byte 7 dup(0), 3 dup(1), 4 dup(0), 3 dup(1), 7 dup(0)
				byte 6 dup(0), 3 dup(1), 5 dup(0), 4 dup(1), 6 dup(0)
				byte 5 dup(0), 3 dup(1), 7 dup(0), 3 dup(1), 6 dup(0)
				byte 5 dup(0), 3 dup(1), 8 dup(0), 3 dup(1), 5 dup(0)
				byte 4 dup(0), 3 dup(1), 9 dup(0), 4 dup(1), 4 dup(0)
				byte 4 dup(0), 16 dup(1), 4 dup(0)
				byte 3 dup(0), 18 dup(1), 3 dup(0)
				byte 3 dup(0), 18 dup(1), 3 dup(0)
				byte 2 dup(0), 3 dup(1), 13 dup(0), 4 dup(1), 2 dup(0)
				byte 1 dup(0), 4 dup(1), 14 dup(0), 4 dup(1), 1 dup(0)
				byte 1 dup(0), 3 dup(1), 15 dup(0), 4 dup(1), 1 dup(0)
				byte 4 dup(1), 16 dup(0), 4 dup(1)
SIZEOFcharacterAs	equ $-characterAs 

characterAscolour	db SIZEOFcharacterAs dup(15)	
poscharacterAs dw 51+28+4+21+6+21+1, 48+4

characterN	word 21, 18
				byte 3 dup(1), 15 dup(0), 3 dup(1)
				byte 4 dup(1), 14 dup(0), 3 dup(1)
				byte 5 dup(1), 13 dup(0), 3 dup(1)
				byte 7 dup(1), 11 dup(0), 3 dup(1)
				byte 3 dup(1), 0, 4 dup(1), 10 dup(0), 3 dup(1)
				byte 3 dup(1), 2 dup(0), 4 dup(1), 9 dup(0), 3 dup(1)
				byte 3 dup(1), 3 dup(0), 4 dup(1), 8 dup(0), 3 dup(1)
				byte 3 dup(1), 4 dup(0), 4 dup(1), 7 dup(0), 3 dup(1)
				byte 3 dup(1), 5 dup(0), 4 dup(1), 6 dup(0), 3 dup(1)
				byte 3 dup(1), 6 dup(0), 4 dup(1), 5 dup(0), 3 dup(1)
				byte 3 dup(1), 7 dup(0), 4 dup(1), 4 dup(0), 3 dup(1)
				byte 3 dup(1), 8 dup(0), 5 dup(1), 2 dup(0), 3 dup(1)
				byte 3 dup(1), 9 dup(0), 5 dup(1), 1 dup(0), 3 dup(1)
				byte 3 dup(1), 11 dup(0), 3 dup(1), 1 dup(0), 3 dup(1)
				byte 3 dup(1), 12 dup(0), 6 dup(1)
				byte 3 dup(1), 13 dup(0), 5 dup(1)
				byte 3 dup(1), 14 dup(0), 4 dup(1)
				byte 3 dup(1), 15 dup(0), 3 dup(1)
SIZEOFcharacterN	equ $-characterN 

characterNcolour	db SIZEOFcharacterN dup(15)	
poscharacterN dw 51+28+4+21+6+21+1+24+6, 48+4

characterO	word 21, 18
				byte 0, 19 dup(1), 0
				byte 21 dup(1)
				byte 21 dup(1)
				byte 3 dup(1), 15 dup(0), 3 dup(1)
				byte 3 dup(1), 15 dup(0), 3 dup(1)
				byte 3 dup(1), 15 dup(0), 3 dup(1)
				byte 3 dup(1), 15 dup(0), 3 dup(1)
				byte 3 dup(1), 15 dup(0), 3 dup(1)
				byte 3 dup(1), 15 dup(0), 3 dup(1)
				byte 3 dup(1), 15 dup(0), 3 dup(1)
				byte 3 dup(1), 15 dup(0), 3 dup(1)
				byte 3 dup(1), 15 dup(0), 3 dup(1)
				byte 3 dup(1), 15 dup(0), 3 dup(1)
				byte 3 dup(1), 15 dup(0), 3 dup(1)
				byte 3 dup(1), 15 dup(0), 3 dup(1)
				byte 21 dup(1)
				byte 21 dup(1)
				byte 0, 19 dup(1), 0
SIZEOFcharacterO	equ $-characterO 

characterOcolour	db SIZEOFcharacterO dup(15)	
poscharacterO dw 51+28+4+21+6+21+1+24+6+21+8, 48+4

characterI	word 3, 18
				byte 3 dup(1)
				byte 3 dup(1)
				byte 3 dup(1)
				byte 3 dup(1)
				byte 3 dup(1)
				byte 3 dup(1)
				byte 3 dup(1)
				byte 3 dup(1)
				byte 3 dup(1)
				byte 3 dup(1)
				byte 3 dup(1)
				byte 3 dup(1)
				byte 3 dup(1)
				byte 3 dup(1)
				byte 3 dup(1)
				byte 3 dup(1)
				byte 3 dup(1)
				byte 3 dup(1)
SIZEOFcharacterI	equ $-characterI 

characterIcolour	db SIZEOFcharacterI dup(15)	
poscharacterI dw 51+28+4+21+6+21+1+24+6+21+8+21+8, 48+4

characterD	word 21, 18
				byte 15 dup(1), 6 dup(0)
				byte 17 dup(1), 4 dup(0)
				byte 19 dup(1), 2 dup(0)
				byte 3 dup(1), 11 dup(0), 5 dup(1), 2 dup(0)
				byte 3 dup(1), 13 dup(0), 4 dup(1), 1 dup(0)
				byte 3 dup(1), 14 dup(0), 3 dup(1), 1 dup(0)
				byte 3 dup(1), 15 dup(0), 3 dup(1)
				byte 3 dup(1), 15 dup(0), 3 dup(1)
				byte 3 dup(1), 15 dup(0), 3 dup(1)
				byte 3 dup(1), 15 dup(0), 3 dup(1)
				byte 3 dup(1), 15 dup(0), 3 dup(1)
				byte 3 dup(1), 15 dup(0), 3 dup(1)
				byte 3 dup(1), 14 dup(0), 3 dup(1), 1 dup(0)
				byte 3 dup(1), 13 dup(0), 4 dup(1), 1 dup(0)
				byte 3 dup(1), 11 dup(0), 5 dup(1), 2 dup(0)
				byte 19 dup(1), 2 dup(0)
				byte 17 dup(1), 4 dup(0)
				byte 15 dup(1), 6 dup(0)
SIZEOFcharacterD	equ $-characterD 

characterDcolour	db SIZEOFcharacterD dup(15)	
poscharacterD dw 51+28+4+21+6+21+1+24+6+21+8+21+8+3+10, 48+4

MENUbar dw SCREENW, 4
posMENUbar dw 0, 26

; ------------------------------------------------------------
; TIMER DATA
; ------------------------------------------------------------
tik	dw ? 

; ------------------------------------------------------------
; BAR DATA
; ------------------------------------------------------------
BAR	word 30 , 3			;	width / height
		byte 30 dup(1)
		byte 30 dup(1)
		byte 30 dup(1)
SIZEOFbar	equ $-BAR

BARcolour	db SIZEOFbar dup(15)		

iposBARx equ 150	; intiële bar position
posBAR 	dw iposBARx, 170
speedBAR	equ 12


; ------------------------------------------------------------
; BALL DATA
; ------------------------------------------------------------
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
speedBALLinit	dw 3, -3 
abs2speedBALL1 dw 50

abs2speedBALL dw 18
newspeedBaLL 	db -4, -4, -4, -4, -3, -3, -3, -3, -2, -2, -2, -2, -1, -1, -1, -1, -0, -0
					db 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4	
					
detected dw 0

; ------------------------------------------------------------
; HARTS DATA
; ------------------------------------------------------------
HART	word 8, 7
		byte 0,1,1,0,0,1,1,0
		byte 8 dup(1)
		byte 8 dup(1)
		byte 8 dup(1)
		byte 0,1,1,1,1,1,1,0
		byte 0,0,1,1,1,1,0,0
		byte 0,0,0,1,1,0,0,0
SIZEOFhart	equ $-HART

HARTcolour	db SIZEOFhart dup(4)
posHART 	word llimit+10, 180
			word llimit+20, 180 
			word llimit+30, 180
			
; ------------------------------------------------------------
; LIFE DATA
; ------------------------------------------------------------
LIFE dw 3
lostlife dw 0

; ------------------------------------------------------------
; BRICK DATA
; ------------------------------------------------------------
BRICK	word 15, 8	; x, y

currentvisBRICKS db 100 dup(1) ; visible bricks

; ------------------------------------------------------------
; LEVEL DATA
; ------------------------------------------------------------
nbrLEVELS 	dw 5
LEVEL			dw ?
SCORE			dw	0
highscore  	dw ?
filename 	db 'highscore', 0

posBRICKS dw offset posBRICK1,  offset posBRICK2, offset posBRICK3, offset posBRICK4, offset posBRICK5
inposBRICKS dw offset inposBRICK1,  offset inposBRICK2, offset inposBRICK3, offset inposBRICK4, offset inposBRICK5 ; intiële possities van de blokken
currentposBRICK dw ?

nbrBRICKS dw nbrBRICKS1, nbrBRICKS2, nbrBRICKS3, nbrBRICKS4, nbrBRICKS5
currentnbrBRICKS dw ?
								
colourBRICKs dw offset colourBRICK1, offset colourBRICK2,  offset colourBRICK3, offset colourBRICK4, offset colourBRICK5
currentcolourBRICK dw ?

stateBRICKS dw offset stateBRICKS1, offset stateBRICKS2, offset stateBRICKS3, offset stateBRICKS4, offset stateBRICKS5
currentstateBRICKS dw ?

moveBrickspeed dw 1 , 1 , 1 , 2 , 4

; LEVEL 1
; -------------------------------------
posBRICK1	word  llimit+10+0, ulimit+10+0 ; x, y
			word  llimit+10+17, ulimit+10+0 ; x, y
			word  llimit+10+34, ulimit+10+0 ; x, y
			word  llimit+10+51, ulimit+10+0 ; x, y
			word  llimit+10+68, ulimit+10+0 ; x, y
			word  llimit+10+85, ulimit+10+0 ; x, y
			word  llimit+10+102, ulimit+10+0 ; x, y
			word  llimit+10+119, ulimit+10+0 ; x, y
			word  llimit+10+136, ulimit+10+0 ; x, y
			word  llimit+10+153, ulimit+10+0 ; x, y
			word  llimit+10+170, ulimit+10+0 ; x, y
			word  llimit+10+187, ulimit+10+0 ; x, y
			word  llimit+10+204, ulimit+10+0 ; x, y
			word  llimit+10+221, ulimit+10+0 ; x, y
			word  llimit+10+238, ulimit+10+0 ; x, y
			word  llimit+10+255, ulimit+10+0 ; x, y
			word  llimit+10+272, ulimit+10+0 ; x, y
			word  llimit+10+0, ulimit+10+10 ; x, y
			word  llimit+10+17, ulimit+10+10 ; x, y
			word  llimit+10+34, ulimit+10+10 ; x, y
			word  llimit+10+51, ulimit+10+10 ; x, y
			word  llimit+10+68, ulimit+10+10 ; x, y
			word  llimit+10+85, ulimit+10+10 ; x, y
			word  llimit+10+102, ulimit+10+10 ; x, y
			word  llimit+10+119, ulimit+10+10 ; x, y
			word  llimit+10+136, ulimit+10+10 ; x, y
			word  llimit+10+153, ulimit+10+10 ; x, y
			word  llimit+10+170, ulimit+10+10 ; x, y
			word  llimit+10+187, ulimit+10+10 ; x, y
			word  llimit+10+204, ulimit+10+10 ; x, y
			word  llimit+10+221, ulimit+10+10 ; x, y
			word  llimit+10+238, ulimit+10+10 ; x, y
			word  llimit+10+255, ulimit+10+10 ; x, y
			word  llimit+10+272, ulimit+10+10 ; x, y
			word  llimit+10+0, ulimit+10+20 ; x, y
			word  llimit+10+17, ulimit+10+20 ; x, y
			word  llimit+10+34, ulimit+10+20 ; x, y
			word  llimit+10+51, ulimit+10+20 ; x, y
			word  llimit+10+68, ulimit+10+20 ; x, y
			word  llimit+10+85, ulimit+10+20 ; x, y
			word  llimit+10+102, ulimit+10+20 ; x, y
			word  llimit+10+119, ulimit+10+20 ; x, y
			word  llimit+10+136, ulimit+10+20 ; x, y
			word  llimit+10+153, ulimit+10+20 ; x, y
			word  llimit+10+170, ulimit+10+20 ; x, y
			word  llimit+10+187, ulimit+10+20 ; x, y
			word  llimit+10+204, ulimit+10+20 ; x, y
			word  llimit+10+221, ulimit+10+20 ; x, y
			word  llimit+10+238, ulimit+10+20 ; x, y
			word  llimit+10+255, ulimit+10+20 ; x, y
			word  llimit+10+272, ulimit+10+20 ; x, y

inposBRICK1	word  llimit+10+0, ulimit+10+0 ; x, y
			word  llimit+10+17, ulimit+10+0 ; x, y
			word  llimit+10+34, ulimit+10+0 ; x, y
			word  llimit+10+51, ulimit+10+0 ; x, y
			word  llimit+10+68, ulimit+10+0 ; x, y
			word  llimit+10+85, ulimit+10+0 ; x, y
			word  llimit+10+102, ulimit+10+0 ; x, y
			word  llimit+10+119, ulimit+10+0 ; x, y
			word  llimit+10+136, ulimit+10+0 ; x, y
			word  llimit+10+153, ulimit+10+0 ; x, y
			word  llimit+10+170, ulimit+10+0 ; x, y
			word  llimit+10+187, ulimit+10+0 ; x, y
			word  llimit+10+204, ulimit+10+0 ; x, y
			word  llimit+10+221, ulimit+10+0 ; x, y
			word  llimit+10+238, ulimit+10+0 ; x, y
			word  llimit+10+255, ulimit+10+0 ; x, y
			word  llimit+10+272, ulimit+10+0 ; x, y
			word  llimit+10+0, ulimit+10+10 ; x, y
			word  llimit+10+17, ulimit+10+10 ; x, y
			word  llimit+10+34, ulimit+10+10 ; x, y
			word  llimit+10+51, ulimit+10+10 ; x, y
			word  llimit+10+68, ulimit+10+10 ; x, y
			word  llimit+10+85, ulimit+10+10 ; x, y
			word  llimit+10+102, ulimit+10+10 ; x, y
			word  llimit+10+119, ulimit+10+10 ; x, y
			word  llimit+10+136, ulimit+10+10 ; x, y
			word  llimit+10+153, ulimit+10+10 ; x, y
			word  llimit+10+170, ulimit+10+10 ; x, y
			word  llimit+10+187, ulimit+10+10 ; x, y
			word  llimit+10+204, ulimit+10+10 ; x, y
			word  llimit+10+221, ulimit+10+10 ; x, y
			word  llimit+10+238, ulimit+10+10 ; x, y
			word  llimit+10+255, ulimit+10+10 ; x, y
			word  llimit+10+272, ulimit+10+10 ; x, y
			word  llimit+10+0, ulimit+10+20 ; x, y
			word  llimit+10+17, ulimit+10+20 ; x, y
			word  llimit+10+34, ulimit+10+20 ; x, y
			word  llimit+10+51, ulimit+10+20 ; x, y
			word  llimit+10+68, ulimit+10+20 ; x, y
			word  llimit+10+85, ulimit+10+20 ; x, y
			word  llimit+10+102, ulimit+10+20 ; x, y
			word  llimit+10+119, ulimit+10+20 ; x, y
			word  llimit+10+136, ulimit+10+20 ; x, y
			word  llimit+10+153, ulimit+10+20 ; x, y
			word  llimit+10+170, ulimit+10+20 ; x, y
			word  llimit+10+187, ulimit+10+20 ; x, y
			word  llimit+10+204, ulimit+10+20 ; x, y
			word  llimit+10+221, ulimit+10+20 ; x, y
			word  llimit+10+238, ulimit+10+20 ; x, y
			word  llimit+10+255, ulimit+10+20 ; x, y
			word  llimit+10+272, ulimit+10+20 ; x, y
	
nbrBRICKS1 equ 51

colourBRICK1 	byte 17 dup(12)	; row 1
					byte 17 dup(2)		; row 2
					byte 17 dup(5)		; row 3

stateBRICKS1 db	nbrBRICKS1 dup(0) ; 0: static/ 1: move right/ 2: move left

; LEVEL 2
; -------------------------------------
posBRICK2	word  llimit+10+0, ulimit+10+0 ; x, y
			word  llimit+10+34, ulimit+10+0 ; x, y
			word  llimit+10+68, ulimit+10+0 ; x, y
			word  llimit+10+102, ulimit+10+0 ; x, y
			word  llimit+10+136, ulimit+10+0 ; x, y
			word  llimit+10+170, ulimit+10+0 ; x, y
			word  llimit+10+204, ulimit+10+0 ; x, y
			word  llimit+10+238, ulimit+10+0 ; x, y
			word  llimit+10+272, ulimit+10+0 ; x, y
			word  llimit+10+17, ulimit+10+10 ; x, y
			word  llimit+10+51, ulimit+10+10 ; x, y
			word  llimit+10+85, ulimit+10+10 ; x, y
			word  llimit+10+119, ulimit+10+10 ; x, y
			word  llimit+10+153, ulimit+10+10 ; x, y
			word  llimit+10+187, ulimit+10+10 ; x, y
			word  llimit+10+221, ulimit+10+10 ; x, y
			word  llimit+10+255, ulimit+10+10 ; x, y
			word  llimit+10+0, ulimit+10+20 ; x, y
			word  llimit+10+34, ulimit+10+20 ; x, y
			word  llimit+10+68, ulimit+10+20 ; x, y
			word  llimit+10+102, ulimit+10+20 ; x, y
			word  llimit+10+136, ulimit+10+20 ; x, y
			word  llimit+10+170, ulimit+10+20 ; x, y
			word  llimit+10+204, ulimit+10+20 ; x, y
			word  llimit+10+238, ulimit+10+20 ; x, y
			word  llimit+10+272, ulimit+10+20 ; x, y
			word  llimit+10+17, ulimit+10+30 ; x, y
			word  llimit+10+51, ulimit+10+30 ; x, y
			word  llimit+10+85, ulimit+10+30 ; x, y
			word  llimit+10+119, ulimit+10+30 ; x, y
			word  llimit+10+153, ulimit+10+30 ; x, y
			word  llimit+10+187, ulimit+10+30 ; x, y
			word  llimit+10+221, ulimit+10+30 ; x, y
			word  llimit+10+255, ulimit+10+30 ; x, y
			word  llimit+10+0, ulimit+10+40 ; x, y
			word  llimit+10+34, ulimit+10+40 ; x, y
			word  llimit+10+68, ulimit+10+40 ; x, y
			word  llimit+10+102, ulimit+10+40 ; x, y
			word  llimit+10+136, ulimit+10+40 ; x, y
			word  llimit+10+170, ulimit+10+40 ; x, y
			word  llimit+10+204, ulimit+10+40 ; x, y
			word  llimit+10+238, ulimit+10+40 ; x, y
			word  llimit+10+272, ulimit+10+40 ; x, y
			word  llimit+10+17, ulimit+10+50 ; x, y
			word  llimit+10+51, ulimit+10+50 ; x, y
			word  llimit+10+85, ulimit+10+50 ; x, y
			word  llimit+10+119, ulimit+10+50 ; x, y
			word  llimit+10+153, ulimit+10+50 ; x, y
			word  llimit+10+187, ulimit+10+50 ; x, y
			word  llimit+10+221, ulimit+10+50 ; x, y
			word  llimit+10+255, ulimit+10+50 ; x, y

inposBRICK2	word  llimit+10+0, ulimit+10+0 ; x, y
			word  llimit+10+34, ulimit+10+0 ; x, y
			word  llimit+10+68, ulimit+10+0 ; x, y
			word  llimit+10+102, ulimit+10+0 ; x, y
			word  llimit+10+136, ulimit+10+0 ; x, y
			word  llimit+10+170, ulimit+10+0 ; x, y
			word  llimit+10+204, ulimit+10+0 ; x, y
			word  llimit+10+238, ulimit+10+0 ; x, y
			word  llimit+10+272, ulimit+10+0 ; x, y
			word  llimit+10+17, ulimit+10+10 ; x, y
			word  llimit+10+51, ulimit+10+10 ; x, y
			word  llimit+10+85, ulimit+10+10 ; x, y
			word  llimit+10+119, ulimit+10+10 ; x, y
			word  llimit+10+153, ulimit+10+10 ; x, y
			word  llimit+10+187, ulimit+10+10 ; x, y
			word  llimit+10+221, ulimit+10+10 ; x, y
			word  llimit+10+255, ulimit+10+10 ; x, y
			word  llimit+10+0, ulimit+10+20 ; x, y
			word  llimit+10+34, ulimit+10+20 ; x, y
			word  llimit+10+68, ulimit+10+20 ; x, y
			word  llimit+10+102, ulimit+10+20 ; x, y
			word  llimit+10+136, ulimit+10+20 ; x, y
			word  llimit+10+170, ulimit+10+20 ; x, y
			word  llimit+10+204, ulimit+10+20 ; x, y
			word  llimit+10+238, ulimit+10+20 ; x, y
			word  llimit+10+272, ulimit+10+20 ; x, y
			word  llimit+10+17, ulimit+10+30 ; x, y
			word  llimit+10+51, ulimit+10+30 ; x, y
			word  llimit+10+85, ulimit+10+30 ; x, y
			word  llimit+10+119, ulimit+10+30 ; x, y
			word  llimit+10+153, ulimit+10+30 ; x, y
			word  llimit+10+187, ulimit+10+30 ; x, y
			word  llimit+10+221, ulimit+10+30 ; x, y
			word  llimit+10+255, ulimit+10+30 ; x, y
			word  llimit+10+0, ulimit+10+40 ; x, y
			word  llimit+10+34, ulimit+10+40 ; x, y
			word  llimit+10+68, ulimit+10+40 ; x, y
			word  llimit+10+102, ulimit+10+40 ; x, y
			word  llimit+10+136, ulimit+10+40 ; x, y
			word  llimit+10+170, ulimit+10+40 ; x, y
			word  llimit+10+204, ulimit+10+40 ; x, y
			word  llimit+10+238, ulimit+10+40 ; x, y
			word  llimit+10+272, ulimit+10+40 ; x, y
			word  llimit+10+17, ulimit+10+50 ; x, y
			word  llimit+10+51, ulimit+10+50 ; x, y
			word  llimit+10+85, ulimit+10+50 ; x, y
			word  llimit+10+119, ulimit+10+50 ; x, y
			word  llimit+10+153, ulimit+10+50 ; x, y
			word  llimit+10+187, ulimit+10+50 ; x, y
			word  llimit+10+221, ulimit+10+50 ; x, y
			word  llimit+10+255, ulimit+10+50 ; x, y

nbrBRICKS2 equ 51

colourBRICK2	byte 13,	7,	13, 12, 14,	15, 12, 6,  4,  11, 1,  12, 2, 8, 8, 2,  14	; row 1
					byte 13, 6,	13, 2,  9,  14, 5,  11, 9,  4,  12, 3,  2, 5, 9, 14, 6	; row 2
					byte 8,  10, 4, 8,  8,  1,  5,  13, 14, 6,  1,  4,  8, 4, 8, 6,  8	; row 3

stateBRICKS2 db	nbrBRICKS2 dup(0) ; 0: static/ 1: move right/ 2: move left

; LEVEL 3
; -------------------------------------
posBRICK3	word  llimit+10+0, ulimit+10+0 ; x, y
			word  llimit+10+17, ulimit+10+0 ; x, y
			word  llimit+10+34, ulimit+10+0 ; x, y
			word  llimit+10+51, ulimit+10+0 ; x, y
			word  llimit+10+68, ulimit+10+0 ; x, y
			word  llimit+10+85, ulimit+10+0 ; x, y
			word  llimit+10+102, ulimit+10+0 ; x, y
			word  llimit+10+119, ulimit+10+0 ; x, y
			word  llimit+10+136, ulimit+10+0 ; x, y
			word  llimit+10+153, ulimit+10+0 ; x, y
			word  llimit+10+170, ulimit+10+0 ; x, y
			word  llimit+10+187, ulimit+10+0 ; x, y
			word  llimit+10+204, ulimit+10+0 ; x, y
			word  llimit+10+221, ulimit+10+0 ; x, y
			word  llimit+10+238, ulimit+10+0 ; x, y
			word  llimit+10+255, ulimit+10+0 ; x, y
			word  llimit+10+272, ulimit+10+0 ; x, y
			word  llimit+10+0, ulimit+10+20 ; x, y
			word  llimit+10+17, ulimit+10+20 ; x, y
			word  llimit+10+34, ulimit+10+20 ; x, y
			word  llimit+10+51, ulimit+10+20 ; x, y
			word  llimit+10+68, ulimit+10+20 ; x, y
			word  llimit+10+85, ulimit+10+20 ; x, y
			word  llimit+10+102, ulimit+10+20 ; x, y
			word  llimit+10+119, ulimit+10+20 ; x, y
			word  llimit+10+136, ulimit+10+20 ; x, y
			word  llimit+10+153, ulimit+10+20 ; x, y
			word  llimit+10+170, ulimit+10+20 ; x, y
			word  llimit+10+187, ulimit+10+20 ; x, y
			word  llimit+10+204, ulimit+10+20 ; x, y
			word  llimit+10+221, ulimit+10+20 ; x, y
			word  llimit+10+238, ulimit+10+20 ; x, y
			word  llimit+10+255, ulimit+10+20 ; x, y
			word  llimit+10+272, ulimit+10+20 ; x, y
			word  llimit+10+0, ulimit+10+40 ; x, y
			word  llimit+10+17, ulimit+10+40 ; x, y
			word  llimit+10+34, ulimit+10+40 ; x, y
			word  llimit+10+51, ulimit+10+40 ; x, y
			word  llimit+10+68, ulimit+10+40 ; x, y
			word  llimit+10+85, ulimit+10+40 ; x, y
			word  llimit+10+102, ulimit+10+40 ; x, y
			word  llimit+10+119, ulimit+10+40 ; x, y
			word  llimit+10+136, ulimit+10+40 ; x, y
			word  llimit+10+153, ulimit+10+40 ; x, y
			word  llimit+10+170, ulimit+10+40 ; x, y
			word  llimit+10+187, ulimit+10+40 ; x, y
			word  llimit+10+204, ulimit+10+40 ; x, y
			word  llimit+10+221, ulimit+10+40 ; x, y
			word  llimit+10+238, ulimit+10+40 ; x, y
			word  llimit+10+255, ulimit+10+40 ; x, y
			word  llimit+10+272, ulimit+10+40 ; x, y
			
inposBRICK3	word  llimit+10+0, ulimit+10+0 ; x, y
			word  llimit+10+17, ulimit+10+0 ; x, y
			word  llimit+10+34, ulimit+10+0 ; x, y
			word  llimit+10+51, ulimit+10+0 ; x, y
			word  llimit+10+68, ulimit+10+0 ; x, y
			word  llimit+10+85, ulimit+10+0 ; x, y
			word  llimit+10+102, ulimit+10+0 ; x, y
			word  llimit+10+119, ulimit+10+0 ; x, y
			word  llimit+10+136, ulimit+10+0 ; x, y
			word  llimit+10+153, ulimit+10+0 ; x, y
			word  llimit+10+170, ulimit+10+0 ; x, y
			word  llimit+10+187, ulimit+10+0 ; x, y
			word  llimit+10+204, ulimit+10+0 ; x, y
			word  llimit+10+221, ulimit+10+0 ; x, y
			word  llimit+10+238, ulimit+10+0 ; x, y
			word  llimit+10+255, ulimit+10+0 ; x, y
			word  llimit+10+272, ulimit+10+0 ; x, y
			word  llimit+10+0, ulimit+10+20 ; x, y
			word  llimit+10+17, ulimit+10+20 ; x, y
			word  llimit+10+34, ulimit+10+20 ; x, y
			word  llimit+10+51, ulimit+10+20 ; x, y
			word  llimit+10+68, ulimit+10+20 ; x, y
			word  llimit+10+85, ulimit+10+20 ; x, y
			word  llimit+10+102, ulimit+10+20 ; x, y
			word  llimit+10+119, ulimit+10+20 ; x, y
			word  llimit+10+136, ulimit+10+20 ; x, y
			word  llimit+10+153, ulimit+10+20 ; x, y
			word  llimit+10+170, ulimit+10+20 ; x, y
			word  llimit+10+187, ulimit+10+20 ; x, y
			word  llimit+10+204, ulimit+10+20 ; x, y
			word  llimit+10+221, ulimit+10+20 ; x, y
			word  llimit+10+238, ulimit+10+20 ; x, y
			word  llimit+10+255, ulimit+10+20 ; x, y
			word  llimit+10+272, ulimit+10+20 ; x, y
			word  llimit+10+0, ulimit+10+40 ; x, y
			word  llimit+10+17, ulimit+10+40 ; x, y
			word  llimit+10+34, ulimit+10+40 ; x, y
			word  llimit+10+51, ulimit+10+40 ; x, y
			word  llimit+10+68, ulimit+10+40 ; x, y
			word  llimit+10+85, ulimit+10+40 ; x, y
			word  llimit+10+102, ulimit+10+40 ; x, y
			word  llimit+10+119, ulimit+10+40 ; x, y
			word  llimit+10+136, ulimit+10+40 ; x, y
			word  llimit+10+153, ulimit+10+40 ; x, y
			word  llimit+10+170, ulimit+10+40 ; x, y
			word  llimit+10+187, ulimit+10+40 ; x, y
			word  llimit+10+204, ulimit+10+40 ; x, y
			word  llimit+10+221, ulimit+10+40 ; x, y
			word  llimit+10+238, ulimit+10+40 ; x, y
			word  llimit+10+255, ulimit+10+40 ; x, y
			word  llimit+10+272, ulimit+10+40 ; x, y
			
nbrBRICKS3 equ 51

colourBRICK3	byte 17 dup(5)		; row 1
					byte 17 dup(9)		; row 2
					byte 17 dup(13)	; row 3
	
stateBRICKS3 	byte	17 dup(1) ; 0: static/ 1: move right/ 2: move left
					byte 17 dup(2) ; 0: static/ 1: move right/ 2: move left
					byte 17 dup(1) ; 0: static/ 1: move right/ 2: move left
					
; LEVEL 4
; -------------------------------------   
posbrick4  word  llimit+10+0, ulimit+10+0 ; x, y
      word  llimit+10+17, ulimit+10+0 ; x, y
      word  llimit+10+34, ulimit+10+0 ; x, y
      word  llimit+10+51, ulimit+10+0 ; x, y
      word  llimit+10+68, ulimit+10+0 ; x, y
      word  llimit+10+85, ulimit+10+0 ; x, y
      word  llimit+10+102, ulimit+10+0 ; x, y
      word  llimit+10+119, ulimit+10+0 ; x, y
      word  llimit+10+136, ulimit+10+0 ; x, y
      word  llimit+10+153, ulimit+10+0 ; x, y
      word  llimit+10+170, ulimit+10+0 ; x, y
      word  llimit+10+187, ulimit+10+0 ; x, y
      word  llimit+10+204, ulimit+10+0 ; x, y
      word  llimit+10+221, ulimit+10+0 ; x, y
      word  llimit+10+238, ulimit+10+0 ; x, y
      word  llimit+10+255, ulimit+10+0 ; x, y
      word  llimit+10+272, ulimit+10+0 ; x, y
      word  llimit+10+0, ulimit+10+10 ; x, y
      word  llimit+10+17, ulimit+10+10 ; x, y
      word  llimit+10+34, ulimit+10+10 ; x, y
      word  llimit+10+51, ulimit+10+10 ; x, y
      word  llimit+10+68, ulimit+10+10 ; x, y
      word  llimit+10+85, ulimit+10+10 ; x, y
      word  llimit+10+102, ulimit+10+10 ; x, y
      word  llimit+10+119, ulimit+10+10 ; x, y
      word  llimit+10+136, ulimit+10+10 ; x, y
      word  llimit+10+153, ulimit+10+10 ; x, y
      word  llimit+10+170, ulimit+10+10 ; x, y
      word  llimit+10+187, ulimit+10+10 ; x, y
      word  llimit+10+204, ulimit+10+10 ; x, y
      word  llimit+10+221, ulimit+10+10 ; x, y
      word  llimit+10+238, ulimit+10+10 ; x, y
      word  llimit+10+255, ulimit+10+10 ; x, y
      word  llimit+10+272, ulimit+10+10 ; x, y
      word  llimit+10+0, ulimit+10+20 ; x, y
      word  llimit+10+17, ulimit+10+20 ; x, y
      word  llimit+10+34, ulimit+10+20 ; x, y
      word  llimit+10+51, ulimit+10+20 ; x, y
      word  llimit+10+68, ulimit+10+20 ; x, y
      word  llimit+10+85, ulimit+10+20 ; x, y
      word  llimit+10+102, ulimit+10+20 ; x, y
      word  llimit+10+119, ulimit+10+20 ; x, y
      word  llimit+10+136, ulimit+10+20 ; x, y
      word  llimit+10+153, ulimit+10+20 ; x, y
      word  llimit+10+170, ulimit+10+20 ; x, y
      word  llimit+10+187, ulimit+10+20 ; x, y
      word  llimit+10+204, ulimit+10+20 ; x, y
      word  llimit+10+221, ulimit+10+20 ; x, y
      word  llimit+10+238, ulimit+10+20 ; x, y
      word  llimit+10+255, ulimit+10+20 ; x, y
      word  llimit+10+272, ulimit+10+20 ; x, y

inposbrick4  word  llimit+10+0, ulimit+10+0 ; x, y
      word  llimit+10+17, ulimit+10+0 ; x, y
      word  llimit+10+34, ulimit+10+0 ; x, y
      word  llimit+10+51, ulimit+10+0 ; x, y
      word  llimit+10+68, ulimit+10+0 ; x, y
      word  llimit+10+85, ulimit+10+0 ; x, y
      word  llimit+10+102, ulimit+10+0 ; x, y
      word  llimit+10+119, ulimit+10+0 ; x, y
      word  llimit+10+136, ulimit+10+0 ; x, y
      word  llimit+10+153, ulimit+10+0 ; x, y
      word  llimit+10+170, ulimit+10+0 ; x, y
      word  llimit+10+187, ulimit+10+0 ; x, y
      word  llimit+10+204, ulimit+10+0 ; x, y
      word  llimit+10+221, ulimit+10+0 ; x, y
      word  llimit+10+238, ulimit+10+0 ; x, y
      word  llimit+10+255, ulimit+10+0 ; x, y
      word  llimit+10+272, ulimit+10+0 ; x, y
      word  llimit+10+0, ulimit+10+10 ; x, y
      word  llimit+10+17, ulimit+10+10 ; x, y
      word  llimit+10+34, ulimit+10+10 ; x, y
      word  llimit+10+51, ulimit+10+10 ; x, y
      word  llimit+10+68, ulimit+10+10 ; x, y
      word  llimit+10+85, ulimit+10+10 ; x, y
      word  llimit+10+102, ulimit+10+10 ; x, y
      word  llimit+10+119, ulimit+10+10 ; x, y
      word  llimit+10+136, ulimit+10+10 ; x, y
      word  llimit+10+153, ulimit+10+10 ; x, y
      word  llimit+10+170, ulimit+10+10 ; x, y
      word  llimit+10+187, ulimit+10+10 ; x, y
      word  llimit+10+204, ulimit+10+10 ; x, y
      word  llimit+10+221, ulimit+10+10 ; x, y
      word  llimit+10+238, ulimit+10+10 ; x, y
      word  llimit+10+255, ulimit+10+10 ; x, y
      word  llimit+10+272, ulimit+10+10 ; x, y
      word  llimit+10+0, ulimit+10+20 ; x, y
      word  llimit+10+17, ulimit+10+20 ; x, y
      word  llimit+10+34, ulimit+10+20 ; x, y
      word  llimit+10+51, ulimit+10+20 ; x, y
      word  llimit+10+68, ulimit+10+20 ; x, y
      word  llimit+10+85, ulimit+10+20 ; x, y
      word  llimit+10+102, ulimit+10+20 ; x, y
      word  llimit+10+119, ulimit+10+20 ; x, y
      word  llimit+10+136, ulimit+10+20 ; x, y
      word  llimit+10+153, ulimit+10+20 ; x, y
      word  llimit+10+170, ulimit+10+20 ; x, y
      word  llimit+10+187, ulimit+10+20 ; x, y
      word  llimit+10+204, ulimit+10+20 ; x, y
      word  llimit+10+221, ulimit+10+20 ; x, y
      word  llimit+10+238, ulimit+10+20 ; x, y
      word  llimit+10+255, ulimit+10+20 ; x, y
      word  llimit+10+272, ulimit+10+20 ; x, y
  
nbrBRICKS4 equ 51

colourBRICK4   db nbrBRICKS4 dup(9)
          
          
stateBRICKS4   byte 3, 4, 3, 4, 3, 4, 3, 4, 3, 4, 3, 4, 3, 4, 3, 4, 3  ; 0: static/ 1: move right/ 2: move left/ 3: move up/ 4: move down
        byte 3, 4, 3, 4, 3, 4, 3, 4, 3, 4, 3, 4, 3, 4, 3, 4, 3  ; 0: static/ 1: move right/ 2: move left/ 3: move up/ 4: move down
        byte 3, 4, 3, 4, 3, 4, 3, 4, 3, 4, 3, 4, 3, 4, 3, 4, 3  ; 0: static/ 1: move right/ 2: move left/ 3: move up/ 4: move down

; LEVEL 5
; -------------------------------------
posBRICK5  	word  llimit+10+0, ulimit+10+0 ; x, y
      		word  llimit+10+34, ulimit+10+0 ; x, y
      word  llimit+10+68, ulimit+10+0 ; x, y
      word  llimit+10+102, ulimit+10+0 ; x, y
      word  llimit+10+136, ulimit+10+0 ; x, y
      word  llimit+10+170, ulimit+10+0 ; x, y
      word  llimit+10+204, ulimit+10+0 ; x, y
      word  llimit+10+238, ulimit+10+0 ; x, y
      word  llimit+10+272, ulimit+10+0 ; x, y
      word  llimit+10+17, ulimit+10+10 ; x, y
      word  llimit+10+51, ulimit+10+10 ; x, y
      word  llimit+10+85, ulimit+10+10 ; x, y
      word  llimit+10+119, ulimit+10+10 ; x, y
      word  llimit+10+153, ulimit+10+10 ; x, y
      word  llimit+10+187, ulimit+10+10 ; x, y
      word  llimit+10+221, ulimit+10+10 ; x, y
      word  llimit+10+255, ulimit+10+10 ; x, y
      word  llimit+10+0, ulimit+10+20 ; x, y
      word  llimit+10+34, ulimit+10+20 ; x, y
      word  llimit+10+68, ulimit+10+20 ; x, y
      word  llimit+10+102, ulimit+10+20 ; x, y
      word  llimit+10+136, ulimit+10+20 ; x, y
      word  llimit+10+170, ulimit+10+20 ; x, y
      word  llimit+10+204, ulimit+10+20 ; x, y
      word  llimit+10+238, ulimit+10+20 ; x, y
      word  llimit+10+272, ulimit+10+20 ; x, y
      word  llimit+10+17, ulimit+10+30 ; x, y
      word  llimit+10+51, ulimit+10+30 ; x, y
      word  llimit+10+85, ulimit+10+30 ; x, y
      word  llimit+10+119, ulimit+10+30 ; x, y
      word  llimit+10+153, ulimit+10+30 ; x, y
      word  llimit+10+187, ulimit+10+30 ; x, y
      word  llimit+10+221, ulimit+10+30 ; x, y
      word  llimit+10+255, ulimit+10+30 ; x, y
      word  llimit+10+0, ulimit+10+40 ; x, y
      word  llimit+10+34, ulimit+10+40 ; x, y
      word  llimit+10+68, ulimit+10+40 ; x, y
      word  llimit+10+102, ulimit+10+40 ; x, y
      word  llimit+10+136, ulimit+10+40 ; x, y
      word  llimit+10+170, ulimit+10+40 ; x, y
      word  llimit+10+204, ulimit+10+40 ; x, y
      word  llimit+10+238, ulimit+10+40 ; x, y
      word  llimit+10+272, ulimit+10+40 ; x, y
      word  llimit+10+17, ulimit+10+50 ; x, y
      word  llimit+10+51, ulimit+10+50 ; x, y
      word  llimit+10+85, ulimit+10+50 ; x, y
      word  llimit+10+119, ulimit+10+50 ; x, y
      word  llimit+10+153, ulimit+10+50 ; x, y
      word  llimit+10+187, ulimit+10+50 ; x, y
      word  llimit+10+221, ulimit+10+50 ; x, y
      word  llimit+10+255, ulimit+10+50 ; x, y

inposBRICK5  	word  llimit+10+0, ulimit+10+0 ; x, y
      		word  llimit+10+34, ulimit+10+0 ; x, y
      word  llimit+10+68, ulimit+10+0 ; x, y
      word  llimit+10+102, ulimit+10+0 ; x, y
      word  llimit+10+136, ulimit+10+0 ; x, y
      word  llimit+10+170, ulimit+10+0 ; x, y
      word  llimit+10+204, ulimit+10+0 ; x, y
      word  llimit+10+238, ulimit+10+0 ; x, y
      word  llimit+10+272, ulimit+10+0 ; x, y
      word  llimit+10+17, ulimit+10+10 ; x, y
      word  llimit+10+51, ulimit+10+10 ; x, y
      word  llimit+10+85, ulimit+10+10 ; x, y
      word  llimit+10+119, ulimit+10+10 ; x, y
      word  llimit+10+153, ulimit+10+10 ; x, y
      word  llimit+10+187, ulimit+10+10 ; x, y
      word  llimit+10+221, ulimit+10+10 ; x, y
      word  llimit+10+255, ulimit+10+10 ; x, y
      word  llimit+10+0, ulimit+10+20 ; x, y
      word  llimit+10+34, ulimit+10+20 ; x, y
      word  llimit+10+68, ulimit+10+20 ; x, y
      word  llimit+10+102, ulimit+10+20 ; x, y
      word  llimit+10+136, ulimit+10+20 ; x, y
      word  llimit+10+170, ulimit+10+20 ; x, y
      word  llimit+10+204, ulimit+10+20 ; x, y
      word  llimit+10+238, ulimit+10+20 ; x, y
      word  llimit+10+272, ulimit+10+20 ; x, y
      word  llimit+10+17, ulimit+10+30 ; x, y
      word  llimit+10+51, ulimit+10+30 ; x, y
      word  llimit+10+85, ulimit+10+30 ; x, y
      word  llimit+10+119, ulimit+10+30 ; x, y
      word  llimit+10+153, ulimit+10+30 ; x, y
      word  llimit+10+187, ulimit+10+30 ; x, y
      word  llimit+10+221, ulimit+10+30 ; x, y
      word  llimit+10+255, ulimit+10+30 ; x, y
      word  llimit+10+0, ulimit+10+40 ; x, y
      word  llimit+10+34, ulimit+10+40 ; x, y
      word  llimit+10+68, ulimit+10+40 ; x, y
      word  llimit+10+102, ulimit+10+40 ; x, y
      word  llimit+10+136, ulimit+10+40 ; x, y
      word  llimit+10+170, ulimit+10+40 ; x, y
      word  llimit+10+204, ulimit+10+40 ; x, y
      word  llimit+10+238, ulimit+10+40 ; x, y
      word  llimit+10+272, ulimit+10+40 ; x, y
      word  llimit+10+17, ulimit+10+50 ; x, y
      word  llimit+10+51, ulimit+10+50 ; x, y
      word  llimit+10+85, ulimit+10+50 ; x, y
      word  llimit+10+119, ulimit+10+50 ; x, y
      word  llimit+10+153, ulimit+10+50 ; x, y
      word  llimit+10+187, ulimit+10+50 ; x, y
      word  llimit+10+221, ulimit+10+50 ; x, y
      word  llimit+10+255, ulimit+10+50 ; x, y


nbrBRICKS5 equ 51

colourBRICK5  byte 13,  7,  13, 12, 14,  15, 12, 6,  4,  11, 1,  12, 2, 8, 8, 2,  14  ; row 1
           byte 13, 6,  13, 2,  9,  14, 5,  11, 9,  4,  12, 3,  2, 5, 9, 14, 6  ; row 2
        byte 8,  10, 4, 8,  8,  1,  5,  13, 14, 6,  1,  4,  8, 4, 8, 6,  8  ; row 3

stateBRICKS5 byte  17 dup(1) ; 0: static/ 1: move right/ 2: move left
      byte  17 dup(2 ) ; 0: static/ 1: move right/ 2: move left
      byte  17 dup(1) ; 0: static/ 1: move right/ 2: move left			
	
; ------------------------------------------------------------
; BACKGROUND
; ------------------------------------------------------------

backgrColour equ 0

; TUBES
; -------------------------------------
TUBE1		word 8, 27
			byte 2 dup(0), 4 dup(1), 2 dup(0)
			byte 0, 6 dup(1), 0
			byte 8 dup(1)
			byte 8 dup(1)
			byte 8 dup(1)
			byte 8 dup(1)
			byte 8 dup(1)
			byte 8 dup(1)
			byte 8 dup(1)
			byte 8 dup(1)
			byte 8 dup(1)
			byte 8 dup(1)
			byte 8 dup(1)
			byte 8 dup(1)
			byte 8 dup(1)
			byte 8 dup(1)
			byte 8 dup(1)
			byte 8 dup(1)
			byte 8 dup(1)
			byte 8 dup(1)
			byte 8 dup(1)
			byte 8 dup(1)
			byte 8 dup(1)
			byte 8 dup(1)
			byte 8 dup(1)
			byte 0, 6 dup(1), 0
			byte 2 dup(0), 4 dup(6), 2 dup(0)

TUBE1colour	byte 4 dup(0);maakt niet uit
				byte 8 dup(0)
				byte 8 dup(7)
				byte 8 dup(7)
				byte 8 dup(7)
				byte 8 dup(7)
				byte 8 dup(7)
				byte 8 dup(7)
				byte 8 dup(7)
				byte 8 dup(7)
				byte 8 dup(7)
				byte 8 dup(0)
				byte 8 dup(7)
				byte 8 dup(0)
				byte 8 dup(7)
				byte 8 dup(0)
				byte 8 dup(7)
				byte 8 dup(0)
				byte 8 dup(7)
				byte 8 dup(7)
				byte 8 dup(7)
				byte 8 dup(7)
				byte 8 dup(7)
				byte 8 dup(7)
				byte 8 dup(7)
				byte 8 dup(7)
				byte 8 dup(7)
				byte 8 dup(0)

posTUBE1	word llimit-8, ulimit+15
			word llimit-8, ulimit+55
			word llimit-8, ulimit+95
			word llimit-8, ulimit+135
			word rlimit, ulimit+15
			word rlimit, ulimit+55
			word rlimit, ulimit+95
			word rlimit, ulimit+135
			
nbrTUBES1	dw 8
			
TUBE2		word 27, 8
			byte 3 dup(0), 21 dup(1), 3 dup(0)
			byte 1 dup(0), 25 dup(1), 1 dup(0)
			byte 27 dup(1)
			byte 27 dup(1)
			byte 27 dup(1)
			byte 27 dup(1)
			byte 1 dup(0), 25 dup(1), 1 dup(0)
			byte 3 dup(0), 21 dup(1), 3 dup(0)

posTUBE2	word llimit+20, ulimit-8
			word llimit+60, ulimit-8
			word llimit+100, ulimit-8
			word llimit+140, ulimit-8
			word llimit+180, ulimit-8
			word llimit+220, ulimit-8
			word llimit+260, ulimit-8
			
nbrTUBES2	dw 7

TUBE2colour	byte 4 dup(0);maakt niet uit
				byte 10 dup(7), 0, 7, 0, 7, 0, 7, 0, 10 dup(7)
				byte 10 dup(7), 0, 7, 0, 7, 0, 7, 0, 10 dup(7)
				byte 0, 9 dup(7), 0, 7, 0, 7, 0, 7, 0, 9 dup(7), 0
				byte 0, 9 dup(7), 0, 7, 0, 7, 0, 7, 0, 9 dup(7), 0
				byte 0, 9 dup(7), 0, 7, 0, 7, 0, 7, 0, 9 dup(7), 0
				byte 0, 9 dup(7), 0, 7, 0, 7, 0, 7, 0, 9 dup(7), 0
				byte 10 dup(7), 0, 7, 0, 7, 0, 7, 0, 10 dup(7)
				byte 10 dup(7), 0, 7, 0, 7, 0, 7, 0, 10 dup(7)


; PIPES
; -------------------------------------
PIPE1		word 8, 13
			byte 2 dup(0), 4 dup(1), 2 dup(0)
			byte 2 dup(0), 4 dup(1), 2 dup(0)
			byte 2 dup(0), 4 dup(1), 2 dup(0)
			byte 2 dup(0), 4 dup(1), 2 dup(0)
			byte 2 dup(0), 4 dup(1), 2 dup(0)
			byte 2 dup(0), 4 dup(1), 2 dup(0)
			byte 2 dup(0), 4 dup(1), 2 dup(0)
			byte 2 dup(0), 4 dup(1), 2 dup(0)
			byte 2 dup(0), 4 dup(1), 2 dup(0)
			byte 2 dup(0), 4 dup(1), 2 dup(0)
			byte 2 dup(0), 4 dup(1), 2 dup(0)
			byte 2 dup(0), 4 dup(1), 2 dup(0)
			byte 2 dup(0), 4 dup(1), 2 dup(0)
			

posPIPE1	word llimit-8, ulimit+15-13-13
			word llimit-8, ulimit+15-13
			word llimit-8, ulimit+55-13
			word llimit-8, ulimit+95-13
			word llimit-8, ulimit+135-13
			word rlimit, ulimit+15-13-13
			word rlimit, ulimit+15-13
			word rlimit, ulimit+55-13
			word rlimit, ulimit+95-13
			word rlimit, ulimit+135-13
			
nbrPIPES1	dw 10

SIZEOFPIPE1	equ $-PIPE1
PIPE1colour	db SIZEOFPIPE1 dup(7)

PIPE2		word 13, 8
			byte 13 dup(0)
			byte 13 dup(0)
			byte 13 dup(1)
			byte 13 dup(1)
			byte 13 dup(1)
			byte 13 dup(1)
			byte 13 dup(0)
			byte 13 dup(0)

posPIPE2	word llimit+20-13-13, ulimit-8
			word llimit+20-13, ulimit-8
			word llimit+60-13, ulimit-8
			word llimit+100-13, ulimit-8
			word llimit+140-13, ulimit-8
			word llimit+180-13, ulimit-8
			word llimit+220-13, ulimit-8
			word llimit+260-13, ulimit-8
			word llimit+300-13, ulimit-8
			word llimit+300-5, ulimit-8
			
nbrPIPES2	dw 10

SIZEOFPIPE2	equ $-PIPE2
PIPE2colour	db SIZEOFPIPE2 dup(7)

; ==============================================================================
; SCREEN BUFFER
; ==============================================================================
.FARDATA?	; segment that contains the screenBuffer for mode 13h drawing
palette			db 768 dup(0)
screenBuffer	db 64000 dup(backgrColour)	; the 64000 bytes for the screen

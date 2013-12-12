.MODEL large	; multiple data segments and multiple code segments
.STACK 2048  	; stack

; ==============================================================================
; INCLUDES
; ==============================================================================

include VIDEO.INC
include KEYB.INC

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
SCORE		dw	0
msgScore db "Score: $"
msgHighscore db "Higscore: $"
msgLevels db "Level $"
msgYScore db "Your Score: $"  

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
MAXLIFE dw 3
filename	db 'SCORE.TXT',0
highscore	dw ?

; ------------------------------------------------------------
; OBJECT DATA
; ------------------------------------------------------------
adressObject dw ?
adressColour dw ?

; ------------------------------------------------------------
; BRICK DATA
; ------------------------------------------------------------
BRICK	word 15, 8	; x, y

posBRICKS dw offset posBRICK1,  offset posBRICK2, offset posBRICK3
currentposBRICK dw ?

nbrBRICKS dw nbrBRICKS1, nbrBRICKS2, nbrBRICKS1
currentnbrBRICKS dw ?
								
colourBRICKs dw offset colourBRICK1, offset colourBRICK2,  offset colourBRICK3
currentcolourBRICK dw ?

stateBRICKS dw offset stateBRICKS1, offset stateBRICKS2, offset stateBRICKS3
currentstateBRICKS dw ?

currentvisBRICKS db 100 dup(1) ; visible bricks

; ------------------------------------------------------------
; LEVEL DATA
; ------------------------------------------------------------
nbrLEVELS dw 3
LEVEL	dw ?

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

nbrBRICKS3 dw 51

colourBRICK3	byte 17 dup(5)		; row 1
					byte 17 dup(9)		; row 2
					byte 17 dup(13)	; row 3
	
stateBRICKS3 	byte	17 dup(1) ; 0: static/ 1: move right/ 2: move left
					byte 17 dup(2) ; 0: static/ 1: move right/ 2: move left
					byte 17 dup(1) ; 0: static/ 1: move right/ 2: move left
	
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
	call SetHighscore
	
	call printArkanoid
	
	call updateScreen
	mov ax,[highscore]
	push ax
	mov ah, 02h
	mov dh, 0
	mov dl, 9
	xor bh,bh
	int 10h
	call printint
	
	; MENU
	; -------------------------------------
	mov ah, 02h							; select function 09h (set cursor)
	mov	dh, 15							; y position of cursor
	mov	dl, 12 						; x position of cursor
	xor 	bh, bh 						; viode page 0
	int 10h								; set cursor
	mov	ah, 09h						; select function 09h (print string)
	mov	dx, offset msgMenu1		; load offset address of msgMenu1 (press P to begin)
	int	21h
	mov ah, 02h							; select function 09h (set cursor)
	mov	dh, 17						; y position of cursor
	mov	dl, 11 						; x position of cursor
	xor 	bh, bh 						; viode page 0
	int 10h								; set cursor
	mov	ah, 09h						; select function 09h (print string)
	mov	dx, offset msgExit		; load offset address of msgMenu1 (press Q to exit)
	int	21h
	
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
	call 	printint
	
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
 	mov ah, 02h							; select function 02h (set cursor)
 	mov	dh, 15						; y position of cursor
 	mov	dl, 9							; x position of cursor
	xor 	bh, bh 						; viode page 0
 	int 10h								; set cursor
 	mov	ah, 09h						; select function 09h (print string)
 	mov	dx, offset msgMenu3		; load offset address of msgMenu3 (press P to begin)
 	int	21h
	
   mov	ax, seg __keysActive
   mov	es, ax
	
	; wait (for smooth transition between levels)
	@@:
	mov cx, 999999999
	watiloop:
		mov ax, 99
		mul ax
		mul ax
		mul ax
		inc cx
		cmp cx, 0
		jnz watiloop
	
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

printScore PROC NEAR
	
	push ax
	push bx
	push cx
	push dx
	
	mov ah, 02h				; select function 09h (set cursor)
	mov	dh, 1				; y position of cursor
	mov	dl, 24			; x position of cursor
	xor 	bh, bh 			; viode page 0
	int 10h					; set cursor
	mov	ax, [SCORE]
	push  ax
	call printint
	
	pop dx
	pop cx
	pop bx
	pop ax
	
	ret 0
printScore ENDP

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
	mov ah, 02h							; select function 02h (set cursor)
	mov	dh, 1							; y position of cursor
	mov	dl, 17						; x position of cursor
	xor 	bh, bh 						; viode page 0
	int 10h								; set cursor
	mov	ah, 09h						; select function 09h (print string)
	mov	dx, offset msgScore		; load offset address of msgScore (highscore)
	int	21h
	
	mov ah, 02h							; select function 02h (set cursor)
	mov	dh, 1							; y position of cursor
	mov	dl, 1							; x position of cursor
	xor 	bh, bh 						; viode page 0
	int 10h								; set cursor
	mov	ah, 09h						; select function 09h (print string)
	mov	dx, offset msgLevels		; load offset address of msgScore (highscore)
	int	21h
		
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
		push ax					; arg1 (x position)
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

	push	ax
	push	bx
	push	cx
	push	dx
	
	mov	cx, [currentnbrBRICKS]
	mov 	bx, [currentstateBRICKS]
	mov	si, 0										; array index number
	@@:
		xor ah, ah
		mov	al, [bx][si]
		cmp al, 0
		je nextBrick
		push bx ; save bx
		push si
		sal si, 1
		sal si, 1
		cmp al, 1 ; check witch direction
		je moveright
		; move left
			mov 	bx, [currentposBRICK]
			mov	ax, [bx][si]
			mov	dx, ax
			add	dx, [BRICK][0]
			cmp	dx, llimit
			jge add1
			mov 	ax, rlimit		; if crossed set to the other edge
			jmp saveNewpos
			add1:
			dec ax
			jmp saveNewpos
		
		; move right
		moveright:
			mov 	bx, [currentposBRICK]
			mov	ax, [bx][si]
			cmp 	ax, rlimit	; check if brick crossed edge
			jle add2
			mov ax, llimit		; if crossed set to the other edge
			sub	ax, [BRICK][0]
			jmp saveNewpos
			add2:
			inc ax
		saveNewpos:
		mov	[bx][si], ax
		pop 	si
		pop 	bx	; restore bx
		nextBrick:
		dec 	cx
		inc 	si
		cmp 	cx, 0
		jnz	@B	
		
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret	0

moveBricks ENDP

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
	
	; set segment
	mov	ax, seg screenBuffer
	mov	es, ax
	
	mov 	bx, [bp + 4] ; adress of position
	
	mov	ax, SCREENW
	mov 	dx, [bx][2]
	mul	dx    
	add   ax, [bx][0]
	add	ax, offset screenBuffer
	mov	di, ax
	mov 	bx, [bp + 6]
	mov	cx, [bx][2]
	 drawloop:
	 	push cx  
	 	mov  cx, [bx][0]  ; rect Width
	 	mov  al, [bp + 8]  ; color
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
	
	mov 	ax, [bp + 6]
	mov 	[adressObject], ax
	mov 	ax, [bp + 8]
	mov 	[adressColour], ax
	
	draw_newline: 
		mov 	bx, [adressObject]
		mov 	ax, [bx][si]
		cmp 	al,0
		je	nextpos
		draw:
		mov 	bx, [adressColour]
		mov 	al, [bx][si]
		mov	es:[di], al	; set pixel
		nextpos:
		inc 	si
		inc 	dx
		inc	di
		mov 	bx, [adressObject]
		cmp	dx, [bx][0]
		je nextline
		jmp draw_newline
		nextline:
		inc	cx
		add 	di, SCREENW
		mov 	bx, [adressObject]
		cmp 	cx, [bx][2]
		je draw_done
		mov 	bx, [adressObject]
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
	
	;Checken van de Highscore
	call SaveHighscore
	
 	call clearScreenBuffer
 	call updateScreen
	
	; MENU
	mov ah, 02h							; select function 09h (set cursor)
	mov	dh, 5							; y position of cursor
	mov	dl, 15 						; x position of cursor
	xor 	bh, bh 						; viode page 0
	int 10h								; set cursor
	mov	ah, 09h						; select function 09h (print string)
	mov	dx, offset msgYScore		; load offset address of msgYScore (Your Score: )
	int	21h
	
	mov ah, 02h							; select function 09h (set cursor)
	mov	dh, 7							; y position of cursor
	mov	dl, 18 						; x position of cursor
	xor 	bh, bh 						; viode page 0
	int 10h	
	mov	ax, [SCORE]
	push  ax
	call printint
	
	mov ah, 02h							; select function 09h (set cursor)
	mov	dh, 17						; y position of cursor
	mov	dl, 7 						; x position of cursor
	xor 	bh, bh 						; viode page 0
	int 10h								; set cursor
	mov	ah, 09h						; select function 09h (print string)
	mov	dx, offset msgNewgame	; load offset address of msgNewgame (press P to start a new game)
	int	21h	
	
	mov ah, 02h							; select function 09h (set cursor)
	mov	dh, 19						; y position of cursor
	mov	dl, 7 						; x position of cursor
	xor 	bh, bh 						; viode page 0
	int 10h								; set cursor
	mov	ah, 09h						; select function 09h (print string)
	mov	dx, offset msgExit		; load offset address of msgMenu1 (press ESC to exit)
	int	21h
	
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
	
	ret
beep ENDP




SaveHighscore PROC NEAR

; code
	push	bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push	ax
	push	bx
	push	cx
	push	dx
	push	si	

	; open file
	mov	ax,3d00h
	lea	dx,[filename]
	int	21h
	jnc @F     ;als de carry niet gezet is dan kan men voort gaan met het lezen van de file
	
;anders moet men de highscore gewoon op nul initializeren 
	mov ax , [SCORE]
	mov [highscore], ax
	jmp @@save
	



@@:
	mov bx, ax ; put handle in BX

	; read from file
	mov	ah,3fh
	mov	cx,2
	lea	dx,[highscore]
	int	21h
	jnc  @F
	
	
	;min highscore gewoon megeven zodanig score zowiezo wordt weggeschreven
	
	mov highscore,0


@@:
;compare de 2 scores

mov ax, [SCORE]  ;we halen de behaalde score van de stack 
cmp ax, [highscore]
jle done

mov [highscore], ax
@@save:
	;file open for writing
	mov	ax,3d01h
	lea	dx,[filename]
	int	21h
	jnc @F

  ; try to create the file
	mov ah, 3ch
	mov cl, 0
	lea dx, [filename]
	int 21h
	jc done ; error occured
	
@@:
	mov	bx, ax ; put handle in BX

	; write score to file
	mov	ah,40h
	mov	cx,2
	lea	dx,[highscore]
	int	21h

	; close file
	mov	ah,3eh
	int	21h

	done:
	; restore context (reverse pop the registers)
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	; restore sp and bp
	mov	sp, bp
	pop	bp
	ret
	
SaveHighscore ENDP


SetHighscore PROC NEAR

	push	bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push	ax
	push	bx
	push	cx
	push	dx
	push	si	
	
; open file
	mov	ax,3d00h
	lea	dx,[filename]
	int	21h
	jnc read    ;als de carry niet gezet is dan kan men voort gaan met het lezen van de file
	
;anders moet men de highscore gewoon op nul initializeren
	mov [highscore], 0
	
	
	; try to create the file
	mov ah, 3ch
	mov cl, 0
	lea dx, [filename]
	int 21h
	jmp done
	
	
	read:
	mov bx, ax ; put handle in BX

	; read from file
	mov	ah,3fh
	mov	cx,2
	lea	dx,[highscore]
	int	21h
	
	done:
	
	; restore context (reverse pop the registers)
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	; restore sp and bp
	mov	sp, bp
	pop	bp
	ret
	
	SetHighscore ENDP
	
	


; ------------------------------- END OF CODE ---------------------------------
END main

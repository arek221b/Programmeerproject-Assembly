; This program demonstrates how to do the fire effect. 
; Send comments, questions or whatever to me: 
; Jesper L. Poulsen
; jesper_lp@hotmail.com
; Homepage: jlp.freeservers.com

.MODEL TINY
.486
.DATA
randnumber dw 4321h
.CODE
.STARTUP

			; virtual screen
buffer db 64000 dup(0)

			; enter mode 13h
mov	ax,0013h
int	10h

			; setup the palette

			; black to red
xor	cx,cx
blacktored:
mov	dx,3c8h
mov	al,cl		; what color
out	dx,al
mov	dx,3c9h
out	dx,al		; red
mov	al,0
out	dx,al		; green
mov	al,0
out	dx,al		; blue

inc	cl
cmp	cl,64
jne	blacktored

			; red to yellow
xor	cl,cl
mov	ch,64
redtoyellow:
mov	dx,3c8h
mov	al,ch		; what color
out	dx,al
mov	dx,3c9h
mov	al,63
out	dx,al		; red
mov	al,cl
out	dx,al		; green
mov	al,0
out	dx,al		; blue

inc	cl
inc	ch
cmp	cl,64
jne	redtoyellow

			; yellow to white
xor	cl,cl
mov	ch,128
yellowtowhite:
mov	dx,3c8h
mov	al,ch		; what color
out	dx,al
mov	dx,3c9h
mov	al,63
out	dx,al		; red
mov	al,63
out	dx,al		; green
mov	al,cl
out	dx,al		; blue

inc	cl
inc	ch
cmp	cl,64
jne	yellowtowhite

			; fire effect
push	0a000h
pop	es
fire:

			; find new randnumber
mov	ah,2ch
int	21h
mov	randnumber,dx
mov	ah,2ch
int	21h
add	randnumber,dx

			; draw random line
			; draw 4 pixels for each random value
mov	si,64000
randomline:
call	random
mov	ds:[si],al
mov	ds:[si-1],al
mov	ds:[si-2],al
mov	ds:[si-3],al
sub	si,4
cmp	si,64000-320*2
jne	randomline

			; blur
blur:
			;   x
			; a b c
			; x = (a + c) / 2 + (b + x) / 2
xor	ax,ax
mov	al,ds:[si+320-1]
mov	bx,ax
mov	al,ds:[si+320+1]
add	bx,ax
shr	bx,1
mov	al,ds:[si+320]
add	bx,ax
shr	bx,1
mov	al,ds:[si]
add	bx,ax
shr	bx,1
mov	al,bl
mov	ds:[si],al

dec	si
cmp	si,64000-150*320
jne	blur

			; wait for the screen to finish updating
refresha:
mov	dx,03dah
in	al,dx
and	al,8
jz	refresha
refreshb:
mov	dx,03dah
in	al,dx
and	al,8
jnz	refreshb

			; copy virtual screen to display memory
xor	si,si
xor	di,di
mov	cx,(64000-2*320)/4
rep	movsd



			; check if a key is pressed
mov	ah,1
int	16h
jz	fire

			; return to text mode
mov	ax,0003h
int	10h

			; terminate program
mov	ax,4c00h
int	21h

proc	random
	mov	ax,randnumber
	mov	dx,4321h
	mul	dx
	inc	ax
	mov	randnumber,ax

	cmp	al,127
	ja	randa
	mov	al,0
	jmp	randb
	randa:
	mov	al,191
	randb:

	ret
endp

end
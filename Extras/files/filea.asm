; This program creates a file and writes a string to it
; Send comments, questions or whatever to me: 
; Jesper L. Poulsen
; jesper_lp@hotmail.com
; Homepage: jlp.freeservers.com

.MODEL TINY
.486
.DATA
filename db 'c:\file.txt',0
string db 'Ah yeah!'
handle dw 0
.CODE
.STARTUP

			; create file
mov	ah,3ch
mov	cx,00000000b
lea	dx,filename
int	21h
jc	error
mov	handle,ax

			; write string to file
mov	ah,40h
mov	bx,handle
mov	cx,8
lea	dx,string
int	21h
jc	error

			; close file
mov	ah,3eh
mov	bx,handle
int	21h

error:

			; terminate program
mov	ax,4c00h
int	21h

end
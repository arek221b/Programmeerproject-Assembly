; This program opens a file, reads from it 
; and the delete it
; Send comments, questions or whatever to me: 
; Jesper L. Poulsen
; jesper_lp@hotmail.com
; Homepage: jlp.freeservers.com

.MODEL TINY
.486
.DATA
filename db 'c:\file.txt',0
string db 8 dup(0)
endchar db '$'		; used when displaying the string
handle dw 0
.CODE
.STARTUP

			; open file
mov	ax,3d02h
lea	dx,filename
int	21h
jc	error
mov	handle,ax

			; read from file
mov	ah,3fh
mov	bx,handle
mov	cx,8
lea	dx,string
int	21h
jc	error

			; close file
mov	ah,3eh
mov	bx,handle
int	21h
			; delete file
mov	ah,41h
lea	dx,filename
int	21h
jc	error


			; display string
mov	ah,09h
lea	dx,string
int	21h

			; wait for keystroke
xor	ax,ax
int	16h

error:

			; terminate program
mov	ax,4c00h
int	21h

end
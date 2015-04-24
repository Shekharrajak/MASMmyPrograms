.model tiny
code segment

ASSUME CS:CODE DS:DATA
ORG 100H
begin:
jmp init
off1 dw ?
seg1 dw ?
hr db ?
min db ?
sec db ?

test1:
push ax
push bx
push cx
push dx
push si
push di
push sp
push bp
mov ax, 0B800H
mov es, ax
mov ah, 02h
int 1AH
mov hr, ch
mov min, cl
mov sec, dh
mov bx, 1992
mov al, hr
call disp
call colon
mov al, min
call disp
call colon
mov al, sec
call disp
pop bp
pop sp
pop di
pop si
pop dx
pop cx
pop bx
pop ax
jmp dword ptr off1


disp proc
mov ch, 02h
mov cl, 04h
back:
rol al, cl
mov dl, al
and dl, 0fh
add dl, 30h
mov es:[bx], dl
inc bx
mov byte ptr es:[bx],0bh
inc bx
dec ch
jnz back
ret
disp endp


colon proc
mov byte ptr es:[bx],':'
inc bx
mov byte ptr es:[bx],8eh
inc bx
ret
colon endp

init:
push cs
pop ds
mov ax, 0002
int 10h
cli
mov ah, 35h
mov al,08h
int 21h
mov off1, bx
mov seg1, es
mov ah,25h
mov al, 08h
lea dx, test1
int 21h
sti
mov ah,31h
mov al,00
lea dx,init
int 21h

exit: 
mov ah, 4ch
mov AL, 00H
int 21h
code ends
end begin
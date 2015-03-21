; Draw a line in a graphics mode

;By extension, draws a yellow line in the upper-left.
;A good example of how to efficiently use INC, CMP,
;and a conditional jump for repetitive tasks.


.model small
.data

.code
mov ah,00h
mov al,13h
int 10h

;The above three lines just switch to 320x200 256-color VGA.
mov ax,@data
mov ds,ax
;a000h = 40960 decimal
mov ax, 44h
;44h is yellow! ;)
mov bx,0000
START:
mov [bx],ax
inc bx
cmp bx,100
JL START

;This waits until BX reaches 20, then exits!

mov ah,4Ch  ;terminate program
int 21h

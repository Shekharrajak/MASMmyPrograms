.MODEL SMALL
.STACK
.DATA
    upstring db 'Up pressed','$'
downstring db "Down pressed",13,10,'$'
leftstring db "Left pressed",13,10,'$'
rightstring db "Right pressed",13,10,'$'

.CODE
repeat:
; Get keystroke
mov ah,0
int 16H
; AH = BIOS scan code
cmp ah,48H
je up
cmp ah,4BH
je left
cmp ah,4DH
je right
cmp ah,50H
je down
cmp ah,1
jne repeat  ; loop until Esc is pressed

mov ah,04cH
int 021H

up:

mov ah,09H
LEA dx,upstring
int 21H
jmp repeat

down:

mov ah,9
LEA dx,downstring
int 21H
jmp repeat

left:
LEA dx,leftstring
mov ah,9
int 021H
jmp repeat

right:
LEA dx,rightstring
mov ah,9
int 021H
jmp repeat

END

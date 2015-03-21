.MODEL SMALL
.STACK
.DATA
    upstring db 10,13,"Up pressed $"
downstring db 10,13,"Down pressed  $"
leftstring db 10,13,"Left pressed  $"
rightstring db 10,13,"Right pressed  $"

.CODE

print macro m
mov ah,09h
mov dx,offset m
int 21h
endm

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

PRINT UPSTRING 
jmp repeat

down:
PRINT DOWNSTRING 
jmp repeat

left:
PRINT LEFTSTRING
jmp repeat

right:

PRINT RIGHTSTRING
jmp repeat

END

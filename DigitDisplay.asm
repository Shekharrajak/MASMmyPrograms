; code.cheraus.com


; Code for displaying a two digit number
; number is store in the data segment in the variable name num


.model small    ;one code segment one data segment

.data          ; start of code segment

num1 db 69h    ;variable declaration num1=69

.code          ;start of code segment
start:         ;start label
mov ax,@data   ;initialization of data segment
mov ds,ax      ;

mov bl,num1    ; load the number in "BL" register
mov cl,04h     ; load a count value in "CL" regiser
mov al,bl      ;copy the number in "AL" register
and al,0f0h    ; ANDing the number with "F0". 0 at the begining suggestts
               ; that we are anding with a numeric value and not a register
               ; value or anything else



; ANDing the number in this way masks the numbers LSB bit and only MSB is
; present in the "AL" register.
;
; Ex:       6 9     in AL
;    AND    F 0
;    ---------------
;           6 0     in AL after ANDing
;
; Now first we need to print the MSB digit therefore we have ANDed with F0
; first.
; To print it we'll have to rotate the number to bring it to LSB postion
; only one digit can be displayed at a time.
; We'll have to shift the number 4 times. That count value is loaded in "CL"
; register.
;



shr al,cl  ; shifting right "CL" times

add al,30h ; Adding 30H gives the ASCII value of the number to be displayed


mov dl,al  ; anything to be displayed is copied to "DX" here "dl" register
mov ah,02h ; prints the 1 digit value from the "DL" register
int 21h    ; interrupt


;printing the LSB number

mov cl,04h    ;count for number of rotations
mov al,bl     ;number copied to al
and al,00fh   ; ANDing with 0F to mask the MSB

; Here since we need to print LSB number only, no need to rotate or shift
; the number. Directly print the LSB number.

add al,30h    ;make ASCII value
mov dl,al     ;copy to "DL" for display
mov ah,02h    ; function call
int 21h



mov ah,4ch   ;terminate program
int 21h


end start
end
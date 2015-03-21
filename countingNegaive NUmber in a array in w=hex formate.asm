;************************************************
;   code.cheraus.com
;
;# Algorithm:    ANDs the given number with 80H:
;                If the result is zero     -> number is positive
;                If the result is non-zero -> number is negative

;   The number should be stored in the correct format
;;   80H -negative (as 128 in decimal.Since max limit for signed number in
;                  8 bit format is 127, 128 is negative)
;   However if simply 80 is stored, it is non negative
;
;************************************************

;macro to print the number

print macro m
mov ah,09h
mov dx,offset m
int 21h
endm



.model small

.data

list db 10,20,80h,86h,23,26,12,57,89h  ;array of numbers
count db (0)                           ;count variable(to store answer) 

msg db 10,13, "The number of negative numbers is: $"  ;output message

.code

start:  mov ax,@data
        mov ds,ax

        mov ch,00                 ; temp storage of ans
        mov si,offset list        ;point to start of array
        mov cl,09                 ;count of numbers in the array

again:  mov al,[si]               ;copy num in al
        and al,80h                ;AND with 80H
        jz next                   ; jump to next statement if result is zero
                                  ; i.e. positive number. Else increase count

        inc ch                    ;increment count if negative number if ANDing
                                  ; gives non zero value 


next:

        inc si                   ;inc si to point to next location in array
        dec cl                   ;decrement count of the array to check
        jnz again                ;if all numbers aare not covered do again


        mov bl,ch                ;store the answer in bl



     ;printing the result

        print msg              ;print the string

        mov cl,04              ;count for shifting to display a number
        mov al,bl              ;copy ans in "AL" register

        and al,0f0h            ;Mask the LSB and take only MSB
        shr al,cl              ;shift the numberto bring MSB to LSB

        cmp al,09              ;if it is number 0-9 just add 30H
        jbe alpha              ; if character A-F add additional 7
        add al,07              ; for correct ASCII value to display


alpha:  add al,30h             ; add 30H to make the number ASCII
        mov ah,02              ; display function
        mov dl,al              ; content to be displyed needs to be in DL
                               ;  for 02 function
        int 21h


       ;printing LSB digit

        mov ah,02           ;02 function for single digit display
        mov al,bl           ;copy ans in Al register
        and al,00fh         ; Mask the MSB. Since number is in LSB no need to
                            ; shift

        cmp al,09           ; check if number in 0-9
        jbe alpha2          ; if alphabet add additional 7 to make correct 
        add al,07           ;  ASCII value

alpha2:  add al,30h         ; add 30H for ASCII value
         mov dl,al          ; display content in DL for 02 function
         int 21h

         mov ah,4ch         ; 4ch function to terminate program and return  
         int 21h            ;  to DOS prompt

         end start
         end                ; end of file
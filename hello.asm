; code.cheraus.com

;Displays a message using a macro


; Macro definition.Generally done at the start of the program.
; disp id the name of the macro. A Macro is like a small procedure
; or a piece of code that gets replaced whereever it is called(like the
; #define in C)

; macro is a keyword that signifies that this is a macro."message" is like
; an argument(or variable) passed to th macro which is to be displayed.
;


disp macro message
mov ah,09h                ;display function.Prints the string untill the end

                          ; denoted by $ sign. Always use 'AH' register for
                          ; storing the function call values



mov dx,offset message    ;the address of the string to be displayed is always

                         ;stored in the 'DX' register.Anything that needs to
                         ;be displayed its address is always transferred to  
                         ;"DX" register
int 21h
endm                     ;end of macro

.model small             ;1 code segment 1 data segment
.data                    ; start of data segment


; DATA SEGMENT:
;
; This is used to store any kind of variable that may be used. As in C
; we declare the variables before using them,similarly we declare our 
; variables here in the data segment to reserve space in the memory for them.
;


mes db "hello $"    ; mes is the name of thee variable.
                    ; db-define byte(storage space) needed
                    ; the string is entered in quotes(single or double)
                    ; the string is always terminated by $ sign.


.code              ;start of code segment

start:             ;label

mov ax,@data       ;initialization of data segment.
mov ds,ax          ;copy address from "AX" to "DS" to make it point to
                   ; data segment

disp mes           ;calling the macro definition with variable mes


mov ah,4ch         ;terminate the program . "4C" function
int 21h
end start          ;

end
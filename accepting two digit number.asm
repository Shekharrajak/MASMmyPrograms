;**************************************************************
; code.cheraus.com
;
; Code for accepting a two digit number
; The accepted number is stored in the data segment in the variable name "num".
;*************************************************************


;*************** Macro ************************************


; Macro Definition for printing string

print macro m                   ;macro definition for printing a string
mov ah,09h                      ; 09 function for printing string
mov dx,offset m                 ; content to be printed moved to DX
int 21h
endm                            ; end of macro




.model small    ;one code segment one data segment


;************** Data Segment ***************************************


.data          ; start of data segment

mes1 db 10,13, "Enter a two digit number: $"   ;prompt for the user
mes2 db 10,13, "The accepted number is : $"    ; string message
num1 db  ?                                      ;memory location for number

;************** Start of Code Segment ******************************

.code
start:  
        mov ax,@data           ;initialization of data segment
		mov ds,ax

        print mes1             ;user prompt
 		
        mov ah,01              ; 01 function to accept a single digit
        int 21h

        sub al,30h            ;Since we get the ASCII value of the number pressed on keyboard
		                      ;by the user, we'll have to convert it to a valid number.
							  
                              ;First we subtract 30h (48 in decimal) from the ASCII value
							  ;obtained from the user. Now since the user enters the number in
							  ;HEX format,it can be a numeric digit(0-9) or letter (A-F).
							  ;By subtracting 30H from the ASCII value,we get the correct 
							  ;number for the corresponding key pressed.
							  ;
							  ;However if the user enterd a letter then we  have to further subtract
							  ;07H to get to the correct representation of the number in memory.
							  
;eg: If the user wants to enter numeric "1" then he presses the "1" key.
;
;    We get the ASCII value of "1" that is 31H (49 in decimal). If we subtract 30H(48 in decimal)
;    from this we get 01H, which is "1" in numeric format. Thus we get the desired value in number
;    format for the respective key pressed. Same is the case with all the numbers 0-9.
;    (Refer ASCII table to get a clear understanding).
;
;    For alphabetic digits, "A" is used to represent "10" in HEX.
;    ASCII value of "A" is 41H (65 in decimal). If we subtract 30H we get 11H(17 in decimal).
;    Clearly we want "A" to represent "10" in decimal not "17". Therefore we further subtract
;    "07h" from the value to get to "AH"(10 in decimal) as required. Same is the case with all
;    other letters A-F.
;    
;     Be careful here. This procedure takes care of only capital letter(A-F) which are 
;     correctly converted to proper number. For small letters the code will have to be
;     modified as they have different ASCII values. 
;							  
                                							  
        cmp al,09             ;test to check whether number is less than 9
        jbe num               ;don't subtract 7 if number less than 9(not a letter)
		
		
        sub al,07             ;subtract 7 if letter
num:    mov cl,04             ;count value
        rol al,cl             ;rotate the digit to MSB position
        mov bl,al             ;save to BL register
                              
        mov ah,01            ;accept second digit the same way
        int 21h
        sub al,30h
        cmp al,09
        jbe num2
        sub al,07

num2:  or bl,al           ; ORing is necessary to store the 8 bit num in
                          ; appropriate format. Adding would also work.
						  ; eg: add bl,al
        
		
		;saving the number in memory and printing it to test the accepted input
		
		mov num1,bl       ;save the number to memory location "num"

		mov bl,num1       ;transfer the contents from memory to BL register
		
		print mes2       ; print message2
		call displaynum  ;displays the number
		
		mov ah,4ch       ;termination of program
		int 21h
		
;******************** End of main program **************************		
		
		
;******************** Procedures ***********************************		


;display procedure. Expects the number to be displayed in "BL"

displaynum proc near


        mov al,bl
        mov cl,04
        and al,0f0h
        shr al,cl
        cmp al,09
        jbe number
        add al,07

number: add al,30h
        mov dl,al
        mov ah,02
        int 21h

        mov al,bl
        and al,00fh
        cmp al,09
        jbe number2
        add al,07
number2: add al,30h
         mov  dl,al
         mov ah,02
         int 21h

ret                          ;return from procedure 
displaynum endp              ;end of "displaynum" procedure

end start                 
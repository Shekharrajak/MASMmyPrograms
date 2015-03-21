DATA SEGMENT
        STR1 DB 0ah,0ch,"ENTER YOUR STRING HERE ->",'$' 
        len equ $ -STR1-1
        STR3 DB "YOUR STRING IS ->$"
        STR2 DB 80 DUP("$")
        NEWLINE DB 10,13,"$"  
        col db 00h
        
        
DATA ENDS

CODE SEGMENT  
    
    setcurser macro col
        mov ah,02h
        mov dh,00
        mov dl,col
        int 10h
    endm
    
        ASSUME DS:DATA,CS:CODE
START:

        MOV AX,DATA
        MOV DS,AX 
        
        lea si,str1
         setcurser col 
        

    loop: 
        setcurser col 
       
       
       mov ah,09h
       mov al,[si]
       mov bh,00
       mov bl,25
       mov cx,1
       int 10h
       
       inc si 
       inc col
       CMP COL,LEN
       jBE loop ;here give the ending point to end the printing
       
        
        MOV AH,4CH
        INT 21H


CODE ENDS
END START

;OUTPUT:-
;Z:\SEM3\SS\21-30>p21
;ENTER YOUR STRING HERE ->jinesh
;YOUR STRING IS ->jinesh
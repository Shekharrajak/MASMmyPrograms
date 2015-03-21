DATA SEGMENT
    MSG1 DB 10,13,'ENTER STRING HERE :- $'   
    MSG2 DB 10,13,'ENCRYPTED STRING IS :- $'
    MSG3 DB 10,13,'DECRYPTED STRING IS : $'
   
    P1 LABEL BYTE
    M1 DB 0FFH
    L1 DB ?
    P11 DB 0FFH DUP ('$')
DATA ENDS
DISPLAY MACRO MSG
    MOV AH,9
    LEA DX,MSG
    INT 21H
ENDM   
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
        MOV AX,DATA
        MOV DS,AX                
               
        DISPLAY MSG1
       
        LEA DX,P1
        MOV AH,0AH    
        INT 21H
                      
        LEA SI,P11
        MOV CL,L1
        CALL ENCRYPT
       
        DISPLAY MSG2
        DISPLAY P11
                               
        LEA SI,P11
        MOV CL,L1
        CALL DECRYPT
       
        DISPLAY MSG2
        DISPLAY P11
       
        MOV AH,4CH
        INT 21H
CODE ENDS
ENCRYPT PROC NEAR
        MOV CH,0       
NEXT1:    
        SUB [SI],05
               
        INC SI
        LOOP NEXT1
       RET
ENCRYPT ENDP
DECRYPT PROC NEAR
       MOV CH,0       
NEXT2:    
        ADD [SI],05
               
        INC SI
        LOOP NEXT2      
       RET
DECRYPT ENDP
   
END START
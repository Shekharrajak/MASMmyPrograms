DATA SEGMENT
    MSG1 DB 10,13,'ENTER FIRST STRING :- $'
   
    ARRAY DB 50 DUP ('$')
   
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
        LEA DI,ARRAY
               
        MOV CL,L1
        MOV CH,0
       
COPY1:  MOV AL,[SI]
        MOV [DI],AL
  
        INC DI
        INC SI
        LOOP COPY1                    
      
        MOV AH,4CH
        INT 21H
CODE ENDS
END START          
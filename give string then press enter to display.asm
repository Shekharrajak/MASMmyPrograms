DATA SEGMENT
        STR1 DB "ENTER YOUR STRING HERE ->$"
        STR3 DB "YOUR STRING IS ->$"
        STR2 DB 80 DUP("$")
        NEWLINE DB 10,13,"$"
DATA ENDS

CODE SEGMENT
        ASSUME DS:DATA,CS:CODE
START:

        MOV AX,DATA
        MOV DS,AX

        LEA SI,STR2

        MOV AH,09H
        LEA DX,STR1
        INT 21H

        MOV AH,0AH
        MOV DX,SI
        INT 21H

        MOV AH,09H
        LEA DX,NEWLINE
        INT 21H

        MOV AH,09H
        LEA DX,STR3
        INT 21H

        MOV AH,09H
        LEA DX,STR2+2
        INT 21H
        
        
        MOV AH,4CH
        INT 21H


CODE ENDS
END START

;OUTPUT:-
;Z:\SEM3\SS\21-30>p21
;ENTER YOUR STRING HERE ->jinesh
;YOUR STRING IS ->jinesh
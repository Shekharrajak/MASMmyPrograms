
		.MODEL  SMALL
		.STACK  64
; ---------------------------------------------------
		.DATA
;LEN_STKNO EQU	  03					;Length stock no.
LEN EQU	  10					;  and description
;STOCKN_IN	DB	  '123'
COUNT1 EQU 0                 
COUNT2 EQU 0
C3 DB 0  
TNAMELENGTH DB 50H 
C1 DB 00


TBL	DB	'Excavators'	;Define table
		DB	  'Lifters   '
		DB	  'Presses   '
		DB	  'Valves    '
		DB	  'Processors'
		DB	  'Pumps     '
		DB	   10 DUP(' ')	;End of table   

; ----------------------------------------------------
		.CODE
A10MAIN	PROC   FAR
		MOV	  AX,@data		;Initialize segment
		MOV	  DS,AX			;  registers
		MOV	  ES,AX
		;CLD
				;Initialize table address
AGAIN: 
        LEA	  DI,TBL+COUNT1
       ; MOV DI,AL+COUNT1

A20:
		
		MOV	  CX,LEN		
		LEA	  SI,TBL+LEN+COUNT2		;Init'ze stock# address
		REPE CMPSB			;Stock# : table
		JB	  A30			;  equal, exit
		;JB	  A40			;  low, not in table
		;ADD	  DI,CX	 
		;MOV AL,LEN
		ADD C1,AL
		MOV COUNT2,C1		
		;ADD	  DI,LEN_DESCR		;Next table item
		MOV AX,COUNT1
		ADD AX,COUNT2
		CMP AX,05H
		JNZ	  A20 
		JMP OUTERLOOP

A30:    
        MOV TEMP,[SI]
        MOV [SI],[DI]
        MOV [DI],TEMP
        INC C3
        CMP C3,10H
        JNZ A30
        
        ADD COUNT2,LEN
        MOV C3,00H
        MOV AX,COUNT1
		ADD AX,COUNT2
		CMP AX,TNAMELENGTH
		JNZ	  A20 
		JMP OUTERLOOP

OUTERLOOP:
        ADD,COUNT1,LEN
        CMP COUNT1,TNAMELENGTH
        JNZ AGAIN
        JMP PRINT		



PRINT:  
        LEA DI,TBL
        
		MOV	  AX,1301H		;Request display
		MOV	  BP,DI			;Stock description
		MOV	  BX,0061H		;Page:attribute
		MOV	  CX,TNAMELENGTH		;10 characters
		MOV	  DX,0812H		;Row:column
		INT	  10H
		JMP	  A90

;				<Display error message>
A90:
		MOV	  AX,4C00H		;End processing
		INT	  21H
A10MAIN	ENDP
		END	  A10MAIN

TITLE	A14STRSR (EXE)  Table search using CMPSB
		.MODEL  SMALL
		.STACK  64
; ---------------------------------------------------
		.DATA
LEN_STKNO EQU	  03					;Length stock no.
LEN_DESCR EQU	  10					;  and description
STOCKN_IN	DB	  '123'
STOCK_TBL	DB	  '035','Excavators'	;Define table
		DB	  '038','Lifters   '
		DB	  '049','Presses   '
		DB	  '102','Valves    '
		DB	  '123','Processors'
		DB	  '127','Pumps     '
		DB	  '999', 10 DUP(' ')	;End of table
; ----------------------------------------------------
		.CODE
A10MAIN	PROC   FAR
		MOV	  AX,@data		;Initialize segment
		MOV	  DS,AX			;  registers
		MOV	  ES,AX
		CLD
		LEA	  DI,STOCK_TBL		;Initialize table address
A20:
		MOV	  CX,LEN_STKNO		;Set to compare 3 bytes
		LEA	  SI,STOCKN_IN		;Init'ze stock# address
		REPE CMPSB			;Stock# : table
		JE	  A30			;  equal, exit
		JB	  A40			;  low, not in table
		ADD	  DI,CX			;Add CX value to offset
		ADD	  DI,LEN_DESCR		;Next table item
		JMP	  A20
A30:
		MOV	  AX,1301H		;Request display
		MOV	  BP,DI			;Stock description
		MOV	  BX,0061H		;Page:attribute
		MOV	  CX,LEN_DESCR		;10 characters
		MOV	  DX,0812H		;Row:column
		INT	  10H
		JMP	  A90
A40:
;				<Display error message>
A90:
		MOV	  AX,4C00H		;End processing
		INT	  21H
A10MAIN	ENDP
		END	  A10MAIN

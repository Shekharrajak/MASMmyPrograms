TITLE	A13BINAS (COM)  Convert binary format to ASCII
		.MODEL  SMALL
		.CODE
		ORG	  100H
BEGIN:	JMP	  SHORT A10MAIN
; ------------------------------------------------- 
ASCVALUE	DB	  4 DUP(' ')		;Data items
BINVALUE	DW	  0DF1H
; ------------------------------------------------- 
A10MAIN	PROC   NEAR			;Main procedure
		MOV	  CX,0010			;Division factor
		LEA	  SI,ASCVALUE+3	;Address of ASCVALUE
		MOV	  AX,BINVALUE		;Get binary amount
A20:
		CMP	  AX,CX			;Value < 10?
		JB	  A30			;  yes, exit
		XOR	  DX,DX			;Clear upper quotient
		DIV	  CX				;Divide by 10
		OR	  DL,30H			;Insert ASCII 3
		MOV	  [SI],DL			;Store ASCII character
		DEC	  SI
		JMP	  A20
A30:
		OR	  AL,30H			;Store last quotient
		MOV	  [SI],AL			;  as ASCII character
		MOV	  AX,1300H		;Request display
		MOV	  BX,0031H		;Page and attribute
		LEA	  BP,ASCVALUE		;ASCII line
		MOV	  CX,04			;Length of line
		MOV	  DX,0824H		;Row
		INT	  10H
		MOV	  AX,4C00H		;End processing
		INT	  21H
A10MAIN	ENDP
		END	  BEGIN

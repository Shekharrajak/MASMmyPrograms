TITLE	A13ASCMU (COM)  Multiplying ASCII numbers
		.MODEL SMALL
		.CODE
		ORG	  100H
BEGIN:	JMP	  A10MAIN
;--------------------------------------------
MULTCAND	DB	  '3783'			;ASCII items
MULTPLER	DB	  '5'
ASCPROD	DB	  5 DUP(0)
;--------------------------------------------
A10MAIN	PROC   NEAR			;Multiply ASCII numbers:
		MOV	  CX,04			;Initialize 4 loops
		LEA	  SI,MULTCAND+3
		LEA	  DI,ASCPROD+4
		AND	  MULTPLER,0FH		;Clear ASCII 3
A20:
		MOV	  AL,[SI]			;Load ASCII character
		AND	  AL,0FH			;Clear ASCII 3
		MUL	  MULTPLER		;Multiply
		AAM					;Adjust for ASCII
		ADD	  AL,[DI]			;Add to
		AAA					;  stored
		MOV	  [DI],AL			;  product
		DEC	  DI
		MOV	  [DI],AH			;Store product carry
		DEC	  SI
		LOOP	  A20			;Loop 4 times
		LEA	  BX,ASCPROD+4		;Convert product to ASCII:
		MOV	  CX,05			;Right to left, 5 bytes
A30:
		OR	  BYTE PTR[BX],30H
		DEC	  BX
		LOOP   A30			;Loop 5 times
		MOV	  AX,1300H		;Request display
		MOV	  BX,0031H		;Page and attribute
		LEA	  BP,ASCPROD		;ASCII line
		MOV	  CX,05			;Length of line
		MOV	  DX,0824H		;Row
		INT	  10H
		MOV	  AX,4C00H		;End processing
		INT	  21H
A10MAIN	ENDP
		END	  BEGIN


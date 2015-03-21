TITLE	A13ASCDV (COM)  Dividing ASCII numbers
		.MODEL SMALL
		.CODE
		ORG	  100H
BEGIN:	JMP	  SHORT A10MAIN
;---------------------------------------------------
DIVIDEND	DB	  '3698'			;ASCII items
DIVISOR	DB	  '4'
ASCQUOT	DB	  4 DUP(0), '$'
;---------------------------------------------------
A10MAIN	PROC   NEAR
							;Divide ASCII numbers:
		MOV	  CX,04			;Initialize 4 loops
		SUB	  AH,AH			;Clear left byte of dividend
		AND	  DIVISOR,0FH		;Clear divisor of ASCII 3
		LEA	  SI,DIVIDEND
		LEA	  DI,ASCQUOT
A20:
		LODSB	  			;Load ASCII byte
		AND	  AL,0FH			;Clear ASCII 3
		AAD					;Adjust for divide
		DIV	  DIVISOR			;Divide
		STOSB	  			;Store quotient
		LOOP   A20			;Loop 4 times
							;Convert product to ASCII:
		LEA	  BX,ASCQUOT		;Leftmost byte,
		MOV	  CX,04			;  4 bytes
A30:
		OR	  BYTE PTR[BX],30H	;Clear ASCII 3
		INC	  BX				;Next byte
		LOOP   A30			;Loop 4 times
		MOV	  AH,09H			;Display
		LEA	  DX,ASCQUOT		;  quotient
		INT	  21H
		MOV	  AX,4C00H		;End processing
		INT	  21H
A10MAIN	ENDP
		END	  BEGIN

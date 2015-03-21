TITLE	A14DIREC (COM)  Direct table addressing
		.MODEL SMALL
		.CODE
		ORG	  100H
BEGIN:	JMP	  SHORT A10MAIN
; ----------------------------------------------------
LEN_ENTRY EQU	  9			;Length of table entries
MONTH_IN	DB	  '12'		;ASCII '3132'
MONTH_TBL	DB	  'January  ', 'February ', 'March    '
		DB	  'April    ', 'May      ', 'June     '
		DB	  'July     ', 'August   ', 'September'
		DB	  'October  ', 'November ', 'December '
; -----------------------------------------------------
.386
A10MAIN	PROC   NEAR
;			  Convert ASCII month to binary:
;			  -----------------------------
		XOR	  WORD PTR MONTH_IN,3030H ;Clear ASCII 3s
		MOVZX  AX,MONTH_IN		;Mult left digit
		IMUL	  AX,10			;  by 10 and add
		ADD	  AL,MONTH_IN+1	;  right digit
;			  Locate month in table:
;			  ---------------------
		DEC	  AL				;Correct for table
		IMUL	  AX,LEN_ENTRY		;Multiply AL by 9
		LEA	  BP,MONTH_TBL		;Add offset to
		ADD	  BP,AX			;  address of table
;			  Display alpha month:
;			  ------------------- ;ES:BP already loaded
		MOV	  AX,1301H		;Request display
		MOV	  BX,0016H		;Page:attribute
		MOV	  CX,LEN_ENTRY		;9 characters
		MOV	  DX,0812H		;Row:column
		INT	  10H			;
		MOV	  AX,4C00H		;End processing
		INT	  21H
A10MAIN	ENDP
		END	  BEGIN


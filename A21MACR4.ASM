TITLE	A21MACR4 (EXE)  Use of LOCAL
DIVIDE	MACRO  DIVIDEND,DIVISOR,QUOTIENT
		LOCAL	  COMP
		LOCAL	  OUT
;		AX = div'd, BX = divisor, CX = quotient
		MOV	  AX,DIVIDEND	;Set dividend
		MOV	  BX,DIVISOR	;Set divisor
		SUB	  CX,CX		;Clear quotient
COMP:
		CMP	  AX,BX		;Dividend < divisor?
		JB	  OUT		;  yes, exit
		SUB	  AX,BX		;Dividend - divisor
		INC	  CX			;Add to quotient
		JMP	  COMP
OUT:
		MOV	  QUOTIENT,CX	;Store quotient
		ENDM				;End macro
; ---------------------------------------------
		.MODEL SMALL
		.STACK 64
		.DATA
DIVDND1	DW	  150		;Dividend
DIVSOR1	DW	  27			;Divisor
QUOTNT1	DW	  ?			;Quotient
DIVDND2	DW	  265		;Dividend
DIVSOR2	DW	  34			;Divisor
QUOTNT2	DW	  ?			;Quotient
; ---------------------------------------------
		.CODE
BEGIN	PROC   FAR
		MOV	  AX,@DATA
		MOV	  DS,AX
		MOV	  ES,AX
		DIVIDE DIVDND1,DIVSOR1,QUOTNT1
		DIVIDE DIVDND2,DIVSOR2,QUOTNT2
		MOV	  AX,4C00H
		INT	  21H
BEGIN	ENDP
		END	  BEGIN


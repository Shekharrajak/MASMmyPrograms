TITLE	A21MACR5 (EXE)  Test of IF and IFNDEF
DIVIDE	MACRO  DIVIDEND,DIVISOR,QUOTIENT
		LOCAL  COMP
		LOCAL  OUT
		CNTR   = 0
;		AX = div'nd, BX = div'r, CX = quot't
		IFNDEF DIVIDEND
;			  Dividend not defined
		CNTR   = CNTR +1
		ENDIF
		IFNDEF DIVISOR
;			  Divisor not defined
		CNTR   = CNTR +1
		ENDIF
		IFNDEF QUOTIENT
;			  Quotient not defined
		CNTR   = CNTR + 1
		ENDIF
		IF	  CNTR
;			  Macro expansion terminated
		EXITM
		ENDIF
		PUSHA			;Preserve registers
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
		POPA				;Restore registers
		ENDM
.286  ; -------------------------------------------
		.MODEL SMALL
		.STACK 64
		.DATA
DIVDEND	DW	  150			;Dividend
DIVISOR	DW	  27				;Divisor
QUOTENT	DW	  ?				;Quotient
		.CODE
MAIN		PROC   FAR
		MOV	AX,@data			;Initialize segment
		MOV	DS,AX			;  registers
		MOV	ES,AX
		.LALL
		DIVIDE DIVDEND,DIVISOR,QUOTENT
		DIVIDE DIDND,DIVISOR,QUOT
		MOV	AX,4C00H			;End processing
		INT	21H
MAIN		ENDP
		END	  MAIN

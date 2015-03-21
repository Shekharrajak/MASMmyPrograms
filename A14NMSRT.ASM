TITLE	A14NMSRT (EXE)  Sort names entered from keyboard
		.MODEL SMALL
		.STACK 64
		.DATA
LEN_NAME	EQU	  20				;Length of name
ENDADDR	DW	  ?
MESSG1	DB	  'Name? '
NAMECTR	DB	  00
NAMESAVE	DB	  20 DUP(?)
NAME_TBL	DB	  30 DUP(20 DUP(' ')) ;Name table
ROW		DB	  00				;Screen row
SWAPPED	DB	  00
NAMEPAR	LABEL  BYTE			;Name parameter list:
MAXNLEN	DB	  21				;  maximum length
NAMELEN	DB	  ?				;  no. of chars entered
NAMEFLD	DB	  21 DUP(' ')		;  input name
;.386  ; ------------------------------------------------
		.CODE
A10MAIN	PROC   FAR
		MOV	  AX,@data		;Initialize DS and
		MOV	  DS,AX			;  ES registers
		MOV	  ES,AX
		CLD
		CALL   Q10CLEAR		;Clear screen
		LEA	  DI,NAME_TBL		;Initialize table address
A20:
		CALL   B10ENTER		;Accept name from KB
		CMP	  NAMELEN,00		;Any more names?
		JE	  A30			;  no,  go to sort
		CMP	  NAMECTR,30		;30 names entered?
		JE	  A30			;  yes, go to sort
		CALL   C10STORE		;Store entered name in table
		JMP	  A20			;Repeat
A30:							;End of input
		CALL   Q10CLEAR		;Clear screen
		CMP	  NAMECTR,01		;One or no name entered?
		JBE	  A90			;  yes, exit
		CALL   D10SORT			;Sort stored names
		CALL   F10NAMES		;Display sorted names
A90:		MOV	  AX,4C00H		;End processing
		INT	  21H
A10MAIN	ENDP
;			  Accept name as input, clear to right:
;			  ------------------------------------
							;DI set on entry
B10ENTER	PROC	  NEAR			;Uses AH, BP, BX, CX, DX
		LEA	  BP,MESSG1		;Prompt
		MOV	  CX,06			;No. of characters
		CALL	  G10DISPLY		;Call display routine
		INC	  ROW			;Next row
		MOV	  AH,0AH
		LEA	  DX,NAMEPAR		;Accept name
		INT	  21H
		MOVZX  BX,NAMELEN		;Get count of characters
		MOVZX  CX,MAXNLEN		;Maximum length - actual
		SUB	  CX,BX			;  = remaining length
B20:		MOV	  NAMEFLD[BX],20H	;Clear rest of name 
		INC	  BX				;  to blank
		LOOP   B20
		RET
B10ENTER	ENDP
;			  Store entered name in table:
;			  ---------------------------
							;DI for table set on entry
C10STORE	PROC	  NEAR			;Uses AH, BP, BX, CX
		INC	  NAMECTR			;Add to number of names
		CLD
		LEA	  SI,NAMEFLD		;Transfer
		MOV	  CX,LEN_NAME		;  name (SI)
		REP MOVSB				;  to table (DI)
		RET
C10STORE	ENDP
;			  Sort names in table in ascending sequence:
;			  -----------------------------------------
							;DI for table set on entry
D10SORT	PROC	  NEAR			;Uses AX, BX, CX, DI, SI
		SUB	  DI,40			;Set up stop address for
		MOV	  ENDADDR,DI		;  last name in table
D20:
		MOV	  SWAPPED,00		;Set up start
		LEA	  SI,NAME_TBL		; of table
D30:
		MOV	  CX,LEN_NAME		;Length of compare
		MOV	  DI,SI
		ADD	  DI,LEN_NAME		;Next name for compare
		MOV	  AX,DI			;Save
		MOV	  BX,SI			;  addresses
		REPE CMPSB			;Compare name to next
		JBE	  D40			;  no exchange
		CALL   E10XCHNG		;  exchange
D40:
		MOV	  SI,AX
		CMP	  SI,ENDADDR		;End of table?
		JBE	  D30			;  no, continue
		CMP	  SWAPPED,00		;Any swaps?
		JNZ	  D20			;  yes, continue
		RET					;  no, end of sort
D10SORT	ENDP
;			  Exchange table entries:
;			  ----------------------
							;BX set on entry
E10XCHNG	PROC	  NEAR			;Uses CX, DI, SI
		MOV	  CX,LEN_NAME		;Number of characters
		LEA	  DI,NAMESAVE		;Save lower
		MOV	  SI,BX			;  item
		REP MOVSB				;  temporarily

		MOV	  CX,LEN_NAME		;Move 
		MOV	  DI,BX			;  higher item 
		REP MOVSB				;  to lower

		MOV	  CX,LEN_NAME		;Move 
		LEA	  SI,NAMESAVE		;  saved item to 
		REP MOVSB				;  higher item
		MOV	  SWAPPED,01		;Signal exchange made
		RET
E10XCHNG	ENDP
;			  Display sorted names in table:
;			  -----------------------------
F10NAMES	PROC	  NEAR			;Uses BP, CX
		MOV	  ROW,00			;Initialize row
		LEA	  BP,NAME_TBL		;Init'ze start of table
F20:
		MOV	  CX,LEN_NAME		;No. of characters 
		CALL	  G10DISPLY		;Call display routine
		INC	  ROW			;Next row
		ADD	  BP,LEN_NAME		;Next name in table
		DEC	  NAMECTR			;Is this last one?
		JNZ	  F20			;  no, repeat
		RET					;  yes, exit
F10NAMES	ENDP
;			  Common display routine:
;			  ----------------------
							;BP, CX set on entry
G10DISPLY	PROC	  NEAR			;Uses AX, BX, DX
		MOV	  AX,1301H		;Request display
		MOV	  BX,0016H		;Attribute
		MOV	  DH,ROW			;Row
		MOV	  DL,10			;Column
		INT	  10H
		RET
G10DISPLY	ENDP
;			  Clear screen, set attribute:
;			  ---------------------------
Q10CLEAR	PROC	  NEAR			;Uses AX, BH, CX, DX
		MOV	  AX,0600H
		MOV	  BH,61H			;Attribute
		MOV	  CX,00			;Full screen
		MOV	  DX,184FH
		INT	  10H
		RET
Q10CLEAR	ENDP
		END	  A10MAIN

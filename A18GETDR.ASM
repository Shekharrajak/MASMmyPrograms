TITLE	A18GETDR (EXE)  Get current directory
		.MODEL SMALL
		.STACK 64
		.DATA
PATH_LEN	EQU	  64
DRIVE	DB     ' ', ':\'		;Drive
PATHNAME	DB     64 DUP(' ')		;Current pathname
; --------------------------------------------------
		.CODE
A10MAIN	PROC   NEAR
		MOV	  AX,@data		;Initialize 
		MOV	  DS,AX			;  segment
		MOV	  ES,AX			;  registers
		MOV	  AH,19H			;Request default drive
		INT	  21H
		ADD	  AL,41H			;Change hex no. to letter
		MOV	  DRIVE,AL		;  0=A, 1=B, etc.
		MOV	  AH,47H			;Request pathname
		MOV	  DL,00			;  for default
		LEA	  SI,PATHNAME		;  drive
		INT	  21H
A20:
		MOV	  AL,00H			;Scan for
		MOV	  CX,PATH_LEN		;  00H in
		LEA	  DI,PATHNAME		;  PATHNAME
		REPNE SCASB
		CMP	  CX,PATH_LEN		;No delimiter?
		JE	  A90			;  if so, exit
		NEG	  CX				;Reverse sign
		ADD	  CX,PATH_LEN+2	;Length DRIVE + path
		MOV	  AX,1301H		;Display pathname
		MOV	  BX,0016H		;  page:attribute
		LEA	  BP,DRIVE		;  starting address
		MOV	  DX,0A0CH		;  row:column
		INT	  10H
A90:
		MOV    AH,10H			;Pause until user
		INT    16H			;  presses a key
		MOV	  AX,4C00H		;End processing
		INT	  21H
A10MAIN	ENDP
		END	  A10MAIN

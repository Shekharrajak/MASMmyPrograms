TITLE	A09BIOAS (EXE)  INT 10H to display ASCII character set
		.MODEL SMALL
		.STACK 64
		.DATA
CHAR_CTR	DB	  00			;Counter for ASCII characters
COL		DB	  24			;Column of screen
ROW		DB	  04			;Row of screen
MODE		DB	  ?			;Video mode
.286  ;-----------------------------------------------------------
		.CODE
A10MAIN	PROC   NEAR
		MOV	  AX,@DATA	;Initialize
		MOV	  DS,AX		;  segment
		MOV	  ES,AX		;  registers
		CALL   B10MODE		;Get/set video mode
		CALL   C10CLEAR	;Clear screen
A20:	
		CALL   D10CURSOR	;Set cursor
		CALL   E10DISPLY	;Display characters
		CMP    CHAR_CTR,0FFH ;Last character displayed?
		JE	  A30		;  yes, exit
		INC	  CHAR_CTR	;Increment char. counter
		ADD	  COL,02		;Increment column
		CMP	  COL,56		;At end of column?
		JNE	  A20		;  no, bypass
		INC	  ROW		;  yes, increment row
		MOV	  COL,24		;  and reset column
		JMP	  A20
A30:
		MOV	  AH,10H		;Request get character
		INT	  16H		;  from keyboard
		MOV	  AH,00H		;Request reset mode
		MOV	  AL,MODE		;  to original value
		INT	  10H
		MOV	  AX,4C00H	;End of processing
		INT	  21H
A10MAIN	ENDP
;			  Get and save current mode, set new mode:
;			  ---------------------------------------
B10MODE	PROC   NEAR
		MOV	  AH,0FH		;Request get mode
		INT	  10H
		MOV	  MODE,AL		;Save mode
		MOV	  AH,00H		;Request set new mode
		MOV	  AL,03		;Standard color
		INT	  10H
		RET
B10MODE	ENDP
;			  Clear screen, create window, set attribute:
;			  ------------------------------------------
C10CLEAR	PROC   NEAR
		PUSHA			;Preserve general registers
		MOV	  AH,08H		;Request get current
		INT	  10H		;  attribute in AH
		MOV	  BH,AH		;Move it to BH
		MOV	  AX,0600H	;Scroll whole screen
		MOV	  CX,0000		;Upper left location
		MOV	  DX,184FH	;Lower right location
		INT	  10H
		MOV	  AX,0610H	;Create 16-line window
		MOV	  BH,16H		;Blue backgrd, brown foregrd
		MOV	  CX,0418H	;Upper left corner  04:24
		MOV	  DX,1336H	;Lower right corner 19:54
		INT	  10H
		POPA				;Restore registers
		RET
C10CLEAR	ENDP
;			  Set cursor to row and column:
;			  ----------------------------
D10CURSOR	PROC   NEAR
		PUSHA			;Preserve general registers
		MOV	  AH,02H		;Request set cursor
		MOV	  BH,00		;Page 0 (normal)
		MOV	  DH,ROW		;New row
		MOV	  DL,COL		;New column
		INT	  10H
		POPA				;Restore registers
		RET
D10CURSOR	ENDP
;			  Display ASCII characters one at a time:
;			  --------------------------------------
E10DISPLY	PROC   NEAR
		PUSHA			;Preserve general registers
		MOV	  AH,0AH		;Request display
		MOV	  AL,CHAR_CTR	;ASCII character
		MOV	  BH,00		;Page 0
		MOV	  CX,01		;One character
		INT	  10H
		POPA				;Restore registers
		RET
E10DISPLY	ENDP
		END	  A10MAIN


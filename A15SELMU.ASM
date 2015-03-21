TITLE	A15SELMU (EXE) Select item from menu
		.MODEL SMALL
		.STACK 64
		.DATA
TOPROW	EQU	  08				;Top row of menu
BOTROW	EQU	  16				;Bottom row of menu
LEFTCOL	EQU	  26				;Left column of menu
LEN_LINE	EQU	  19				;Length of menu line
ATTRIB	DB	  ?				;Screen attribute
COL		DB	  00				;Screen column
ROW		DB	  00				;Screen row
SHADOW	DB	  19 DUP(0DBH)		;Shadow characters
MENU		DB	  0C9H, 17 DUP(0CDH), 0BBH
		DB	  0BAH, ' Add records     ', 0BAH
		DB	  0BAH, ' Delete records  ', 0BAH
		DB	  0BAH, ' Enter orders    ', 0BAH
		DB	  0BAH, ' Print report    ', 0BAH
		DB	  0BAH, ' Update accounts ', 0BAH
		DB	  0BAH, ' View records    ', 0BAH
		DB	  0BAH, ' Exit program    ', 0BAH
		DB	  0C8H, 17 DUP(0CDH), 0BCH
PROMPT	DB	  'To select an item, press left '
		DB	  'button of mouse pointer.'
.386 ; ------------------------------------------------
		.CODE
A10MAIN	PROC   FAR
		MOV	  AX,@data		;Initialize segment
		MOV	  DS,AX			;  registers
		MOV	  ES,AX
		CALL   Q10CLEAR		;Clear screen
		CALL	  B10INITZ		;Initialize mouse
		CMP	  AX,00			;Mouse installed?
		JE	  A90			;  no, exit
		CALL   C10MENU			;Display menu
A20:
		MOV	  ROW,TOPROW+1		;Set row to top item
		MOV	  ATTRIB,16H		;Set reverse video
		CALL   E10DISPLY		;Highlight current menu line
		CALL	  D10POINTR		;Call mouse routine
		CMP	  DX,BOTROW-1		;Exit requested?
		JNE	  A20			;  no, continue
		MOV	  AX,02H			;Hide mouse pointer
		INT	  33H
		MOV	  AX,0600H		;Clear 
		CALL   Q10CLEAR		;  screen
A90:		MOV	  AX,4C00H		;End of processing
		INT	  21H
A10MAIN	ENDP
;			  Initialize mouse pointer, set
;			  horizontal and vertical limits:
;			  ------------------------------
B10INITZ	PROC   NEAR			;Uses AX, CX, DX
		MOV    AX,00H			;Request initialize 
		INT    33H			;  mouse
		CMP    AX,00			;Mouse installed?
		JE     B90			;  no, exit
		MOV    AX,01H			;Show pointer
		INT    33H
		MOV    AX,04H			;Set pointer
		MOV    CX,256
		MOV    DX,108
		INT    33H

		MOV	  AX,07H			;Horizontal limits
		MOV	  CX,LEFTCOL+1		;  left column
		MOV	  DX,LEFTCOL+17	;  right column
		SHL	  CX,03			;Multiply by 8 for
		SHL	  DX,03			;  pixel value
		INT	  33H
		MOV	  AX,08H			;Vertical limits
		MOV	  CX,TOPROW+1		;  top row
		MOV	  DX,BOTROW-1		;  bottom row
		SHL	  CX,03			;Divide by 8
		SHL	  DX,03
		INT	  33H
B90:		RET
B10INITZ	ENDP
;			  Display shadow box and full menu:
;			  --------------------------------
C10MENU	PROC   NEAR			;Uses AX, BP, BX, CX, DX
		MOV	  AX,1301H		;Request display
		MOV	  BX,0060H		;Black on brown
		LEA	  BP,SHADOW		;Address of shadow
		MOV	  CX,LEN_LINE		;Length of line
		MOV	  DH,TOPROW+1		;Screen row
		MOV	  DL,LEFTCOL+1		;  and column
C20:		INT	  10H
		INC	  DH				;Next row
		CMP	  DH,BOTROW+2		;All rows displayed?
		JNE	  C20			;  no, repeat

		MOV	  ATTRIB,71H		;Blue on white
		MOV	  AX,1300H		;Request display
		MOV	  BH,00			;Page 0
		MOV	  BL,ATTRIB		;Attribute
		LEA	  BP,MENU			;Address of menu
		MOV	  CX,LEN_LINE		;Length of line
		MOV	  DH,TOPROW		;Screen row,
		MOV	  DL,LEFTCOL		;  column
C30:		INT	  10H
		ADD	  BP,LEN_LINE		;Next menu line
		INC	  DH				;Next row
		CMP	  DH,BOTROW+1		;All rows displayed?
		JNE	  C30			;  no, repeat

		MOV	  AX,1300H		;Request display
		MOV	  BH,00			;Page 0
		MOV	  BL,ATTRIB		;Attribute
		LEA	  BP,PROMPT		;Prompt line
		MOV	  CX,45			;Length of prompt
		MOV	  DH,BOTROW+4		;Screen row,
		MOV	  DL,15			;  column
		INT	  10H
		RET
C10MENU	ENDP
;			  If left button pressed, set old menu line to 
;			  normal video, new line to reverse video:
;			  --------------------------------------------
D10POINTR	PROC   NEAR			;Uses AX, BX, DX
D20:		MOV	  AX,03H			;Get button status
		INT	  33H
		CMP	  BX,00000001B		;Left button pressed?
		JNE	  D20			;  no, repeat
		SHR	  DX,03			;Divide vertical by 8
		CMP	  DX,BOTROW-1		;Request for exit?
		JE	  D90			;  yes, exit
		PUSH	  DX				;  no, save row
		MOV	  ATTRIB,71H		;Blue on white
		CALL   E10DISPLY		;Set old line to normal video
		POP	  DX				;Get row
		MOV	  ROW,DL
		MOV	  ATTRIB,17H		;White on blue
		CALL   E10DISPLY		;Set new line to reverse video
		JMP	  D20			;Repeat
D90:		RET
D10POINTR	ENDP
;			  Set menu line to normal or highlight:
;			  ------------------------------------
E10DISPLY	PROC   NEAR			;Uses AX, BX, BP, CX, DX
		MOVZX  AX,ROW			;Row tells which menu line 
		SUB	  AX,TOPROW
		IMUL	  AX,LEN_LINE		;Multiply by length of line
		LEA	  SI,MENU+1		;  for selected menu line
		ADD	  SI,AX
		MOV	  AX,1300H		;Request display
		MOV	  BH,00			;Page
		MOV	  BL,ATTRIB		;New attribute
		MOV	  BP,SI			;Menu line
		MOV	  CX,LEN_LINE-2	;Length of string
		MOV	  DH,ROW			;Row
		MOV	  DL,LEFTCOL+1		;Column
		INT	  10H
		RET
E10DISPLY	ENDP
;			   Clear screen, set attribute:
;			   ---------------------------
Q10CLEAR	PROC   NEAR			;Uses AX, BH, CX, DX
		MOV	  AX,0600H		;Request scroll
		MOV	  BH,61H			;Blue on brown
		MOV	  CX,0000			;Full screen
		MOV	  DX,184FH
		INT	  10H
		RET
Q10CLEAR	ENDP
		END	  A10MAIN


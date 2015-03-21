TITLE	A15MOUSE (EXE)  Handling the mouse
		.MODEL SMALL
		.STACK 64
		.DATA
LEN_DATA	EQU    14				;Display length
XCOORD	DW     0				;Binary X coordinate
YCOORD	DW     0				;Binary Y coordinate
ASCVAL	DW     ?				;ASCII field

DISPDATA	LABEL  BYTE			;Screen display fields:
XMSG		DB     'X = '			;X message
XASCII	DW     ?				;X ASCII value
		DB     '  '			;
YMSG		DB     'Y = '			;Y message
YASCII	DW     ?				;Y ASCII value
.386  ; ---------------------------------------------------
		.CODE
A10MAIN	PROC   FAR
		MOV    AX,@data		;Initialize
		MOV    DS,AX			;  DS and ES
		MOV    ES,AX			;  addressability
		CALL   Q10CLEAR		;Clear screen
		CALL   B10INITZ		;Initialize mouse
		CMP    AX,00			;Mouse installed?
		JE     A90			;  no, exit
A20:
		CALL   C10POINTR		;Get mouse pointer
		CMP    BX,01			;Button pressed?
		JE     A80			;  yes, exit
		MOV    AX,XCOORD		;Convert
		CALL   D10CONVRT		;  X to ASCII
		MOV    AX,ASCVAL		;
		MOV    XASCII,AX		;
		MOV    AX,YCOORD		;Convert
		CALL   D10CONVRT		;  Y to ASCII
		MOV    AX,ASCVAL		;
		MOV    YASCII,AX		;Display 
		CALL   E10DISPLY		;  X and Y values
		JMP    A20			;Repeat
A80:
		MOV    AX,02H			;Request hide pointer
		INT    33H
A90:		CALL   Q10CLEAR		;Clear screen
		MOV    AX,4C00H		;End processing
		INT    21H
A10MAIN	ENDP
;			  Initialize mouse pointer:
;                ------------------------
B10INITZ	PROC   NEAR			;Uses AX
		MOV    AX,00H			;Request initialize 
		INT    33H			;  mouse
		CMP    AX,00			;Mouse installed?
		JE     B90			;  no, exit
		MOV    AX,01H			;Show pointer
		INT    33H
B90:		RET					;Return to caller
B10INITZ	ENDP
;			  Get mouse pointer location:
;                --------------------------
C10POINTR	PROC   NEAR			;Uses AX, BX, CX, DX
C20:		MOV    AX,03H			;Get pointer location
		INT    33H
		CMP    BX,00000001B		;Left button pressed?
		JE     C90			;  yes, means exit
		SHR    CX,03			;Divide pixel 
		SHR    DX,03			;  coordinates by 8
		CMP    CX,XCOORD		;Has pointer location
		JNE    C30			;  changed?
		CMP    DX,YCOORD		;
		JE     C20			;  no, repeat operation
C30:							;  yes, 
		MOV    XCOORD,CX		;  save new locations
		MOV    YCOORD,DX		;
C90:		RET					;Return to caller
C10POINTR	ENDP
;			  Convert binary X or Y location to ASCII:
;                ---------------------------------------
					;AX set on entry = binary X or Y
D10CONVRT	PROC   NEAR			;Uses CX, SI
		MOV    ASCVAL,2020H		;Clear ASCII field
		MOV    CX,10			;Set divide factor
		LEA    SI,ASCVAL+1		;Load ASCVAL address
		CMP    AX,CX			;Compare location to 10
		JB     D20			;  lower, bypass
		DIV    CL				;  higher, divide by 10
		OR     AH,30H			;Insert ASCII 3s
		MOV    [SI],AH			;Store in rightmost byte
		DEC    SI				;Decr address of ASCVAL
D20:
		OR     AL,30H			;Insert ASCII 3s
		MOV    [SI],AL			;Store in leftmost byte
		RET					;Return to caller
D10CONVRT	ENDP
;			  Display X, Y locations:
;			  ----------------------
E10DISPLY	PROC   NEAR			;Uses AX, BX, BP, CX, DX
		MOV	  AX,1300H		;Request display
		MOV	  BX,0031H		;Page:attribute
		LEA	  BP,DISPDATA		;Address of string
		MOV	  CX,LEN_DATA		;No. of characters
		MOV	  DX,0020H		;Screen row:column
		INT	  10H
		RET					;Return to caller
E10DISPLY	ENDP
;			  Clear screen, set attribute:
;                ---------------------------
Q10CLEAR	PROC   NEAR			;Uses AX, BH, CX, DX
		MOV    AX,0600H		;Request clear screen
		MOV    BH,30H			;Colors
		MOV    CX,00			;Full
		MOV    DX,184FH		;  screen
		INT    10H
		RET					;Return to caller
Q10CLEAR	ENDP
		END    A10MAIN


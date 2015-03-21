; To assemble and link from within WinAsm Studio, you must have a special 16-bit linker, 
; such as the one in the archive at this URL- http://win32assembly.online.fr/files/Lnk563.exe
; Run the archive to unpack Link.exe, rename the Link.exe file to Link16.exe and copy it
; into the \masm32\bin folder.
;
; To produce a .COM file, .model must be tiny, also you must add /tiny to the linker command line

.model tiny
.data
      
.code
	.startup
	mov ax, 013h		; SetVidMode(0x13)
	int     010h

	mov ax, 0A000h		;segment of screen mem for this mode (and some others)
	mov ds, ax
	xor si, si		; point to pixel 0,0
	mov ax, 0A0Ah		; 10d, 10d
	mov cx, 4		; want to do a 4 pixel side-length  square
	mov bx, 2		; doing two pixels at once, need to move SI forwards by 2 each time 
lineloop:
	mov ds:[si], ax
	add si, bx
	mov ds:[si], ax		; look ma! two pixels at once (we can do more)
	add si, 318
	dec cx			; decrement our loop counter
	jnz lineloop		; and go back for more, while loop counter <> 0
	
	mov   ah,0		; getch()
	int   16h

	mov ax, 03h		; SetVidMode(0x03)
	int     010h

	.exit
end
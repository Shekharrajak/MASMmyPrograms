.model small
.data
.code

mov ah,00h
mov al,13h
int 10h

;The above three lines just switch to 320x200 256-color VGA.

mov ax,@data
mov ds,ax
start:

lea ax, data
mov ds, ax
mov es, ax
; setting video mode
mov ah, 0
mov al, 03h
int 10h

mov al, 0             
mov ah, 6   

mov bh, 0h ;changing the color to black
mov ch, 0
mov cl, 0
mov dh, 24
mov dl, 79  
int 10h     

mov dh, 8
mov dl, 20
mov bh, 0ffh ;changing the color to white
int 10h     

choose:
mov ah, 1
int 21h
cmp al, 'e'
je finish
cmp al, 'r'
je right ;unnecessary.


right:
mov al, 0             
mov ah, 6   

mov bh, 0h 
mov ch, 0
mov cl, 0
mov dh, 24
mov dl, 79  
int 10h  

mov bh, 0ffh
mov ch, 0
mov cl, 20
mov dh, 8
mov dl, 40
int 10h

mov bh, 0h 
mov ch, 0
mov cl, 0
mov dh, 24
mov dl, 79  
int 10h

mov bh, 0ffh
mov ch, 0
mov cl, 40
mov dh, 8
mov dl, 60
int 10h    

mov bh, 0h 
mov ch, 0
mov cl, 0
mov dh, 24
mov dl, 79  
int 10h

mov bh, 0ffh
mov ch, 0
mov cl, 60
mov dh, 8
mov dl, 79
int 10h     

mov bh, 0h 
mov ch, 0
mov cl, 0
mov dh, 24
mov dl, 79  
int 10h 

mov bh, 0ffh
mov ch, 8
mov cl, 60
mov dh, 16
mov dl, 79
int 10h   

mov bh, 0h
mov ch, 0
mov cl, 0
mov dh, 24
mov dl, 79  
int 10h   

mov bh, 0ffh
mov ch, 16
mov cl, 60
mov dh, 24
mov dl, 79
int 10h

mov bh, 0h 
mov ch, 0
mov cl, 0
mov dh, 24
mov dl, 79  
int 10h 

mov bh, 0ffh
mov ch, 16
mov cl, 40
mov dh, 24
mov dl, 60
int 10h

mov bh, 0h 
mov ch, 0
mov cl, 0
mov dh, 24
mov dl, 79  
int 10h

mov bh, 0ffh
mov ch, 16
mov cl, 20
mov dh, 24
mov dl, 40
int 10h

mov bh, 0h 
mov ch, 0
mov cl, 0
mov dh, 24
mov dl, 79  
int 10h 

mov bh, 0ffh
mov ch, 16
mov cl, 0
mov dh, 24
mov dl, 20
int 10h  

mov bh, 0h 
mov ch, 0
mov cl, 0
mov dh, 24
mov dl, 79  
int 10h

mov bh, 0ffh
mov ch, 8
mov cl, 0
mov dh, 16
mov dl, 20
int 10h 

mov bh, 0h 
mov ch, 0
mov cl, 0
mov dh, 24
mov dl, 79  
int 10h

mov bh, 0ffh
mov ch, 0
mov cl, 0
mov dh, 8
mov dl, 20
int 10h

jmp choose


finish:
mov ax, 4c00h
int 21h  

ends

end start
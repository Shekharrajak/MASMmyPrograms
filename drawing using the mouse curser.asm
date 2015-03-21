 ;Free hand drawing using mouse
.model small
.stack
.data
.code 
start:
 mov ax, @data
 mov ds, ax  
 mov al, 13h
mov ah, 0   ; set graphics video mode.
int 10h   
mov ax, 0    ;initialize mouse
int 33h 
         
         mov ax, 1  ;shows mouse cursor
         int 33h
    
 start1:      
 
        mov ax, 3  ;get cursor positon in cx,dx
        int 33h   
        call putpix ;call procedure 
        jmp start1  
  
   ;defining procedure to print
    putpix proc
    mov al, 1100b    
    mov ah, 0ch    
    shr cx,1           ; cx will get double so we divide it by two
int 10h     ; set pixel.
ret
 
 
    putpix endp
    
 end:
     mov ah,4ch
     int 21h
code ends 
end start
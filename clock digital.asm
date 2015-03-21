.model small
.stack 64h
.data 
    h db 00h
    m db 00h
    s db 00h
    sixty db 05h      
   
.code 


setcurser macro col
    mov ah,02h
    mov bh,00
    mov dh,00
    mov dl,col
    int 10h
endm      
    
    
    mov ax,@data
    mov ds,ax
    
    MOV AX,0600h ;AH=06h & AL=00h
    MOV BH,74h ;White background (7)
               ;red foreground(4)
    MOV CX,0000h ;row 0 col 0
    MOV DX,184Fh ;row 24 col 79(inHex)
    INT 10h
    
    mov ah,02h
    mov dh,0ah
    mov dl,23h
    int 10h
    
    hh:
        mov al,h
        mov cl,10
        div cl
        
        add al,30h
        mov bl,ah
        mov dl,al
        
        mov ah,09h
        int 10h
        
        add bl,30h
        mov dl,bl
        mov ah,09h
        int 10h
        
        ;end hh
        
    mov ah,02h
    mov dl,':'
    int 21h 
    
    
    mm:  
         mov al,m
        mov cl,10
        div cl
        
        add al,30h
        mov bl,ah
        mov dl,al
        
        mov ah,09h
        int 10h
        
        add bl,30h
        mov dl,bl
        mov ah,09h
        int 10h 
    
      ;end mm
        
    mov ah,02h
    mov dl,':'
    int 21h 
             
             
    ss1:
        mov al,s
        mov cl,10
        div cl
        
        add al,30h
        mov bl,ah
        mov dl,al
        
        mov ah,09h
        int 10h
        
        add bl,30h
        mov dl,bl
        mov ah,09h
        int 10h 
        
        inc s  
        mov bl,sixty
        cmp s,bl
        jb ss1
        cmp m,bl
        jb minc
        mov bl,00h
        setcurser bl
        inc h
        jmp hh
    
      ;end ss
        
     minc :
        inc m  
        mov bl,03h
         setcurser bl
        jmp mm
        
    
    

      
    mov ah,4ch
    int 21h
    end
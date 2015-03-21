.model small
.data 
    n1 db 'khjdfhjse','$'
    l1 equ $-n1-1
    strt db 00h
    c db 00h
    temp db ?
.code
    mov ax,@data
    mov ds,ax
        
    lea si,n1 
        
    ;cmpare :
       loop1 : 
            ;mov cx,len 
            mov al,[si+c]
            mov bl,[si+c+1]
            cmp al,bl
            jg call swap
            inc c
            cmp c,l1
            jnz loop1  
            
       
       lea si,n1 
       mov cx ,l1
     print :
       mov ah, 02h
       mov dl,[si]
       inc si
       int 21h
       loop print
    
    
      swap proc near
        mov temp,al
        mov al,bl
        mov bl,temp
        ret
      endp

  mov ah,4ch
  int 21h
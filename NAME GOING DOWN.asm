 .model small
.stack 64
.data 
arr  db  'gopi','$' 
trl db ?
lp db ?
.code       
  main proc near
  mov ax,@data
  mov ds,ax
    
            mov ax,0000
            mov [trl],ah 
              
             x10:
                   mov ax,0000
            mov [trl],ah 
           l10:
            
          
            call clearscreen
            call setcursor
            call display
            dec lp
                   
               mov cl,trl
               cmp cl,50
               je x10
               
                   
           jnz l10
         
main endp  
            
 
;input proc near
;  
;push cx
;  lea si ,arr
;  mov cx,4h  
; 
; l20:
;   mov ah,1h
;    int 21h
;    mov [si],al 
;    inc si
;    loop l20 
;pop cx
;    ret  
; endp    
       
display  proc near
   
    mov ah,09h
    lea dx,arr 
    int 21h 
   
       ret
endp

clearscreen proc near 
   
             mov ax,0600h
             mov bh,71h
             mov cx,0000h
             mov dx,184fh
             int 10h 
     
             ret 
endp 


setcursor proc near
        
         
          mov ah,02h
          mov bh,00
          mov dh,trl
          mov dl,00
          int 10h
          inc [trl] 
                    ret
endp

        end   main
 
 

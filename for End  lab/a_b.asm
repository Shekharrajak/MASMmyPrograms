                                                  .model tiny
               codesg segment 
                assume cs:codesg,ds:codesg,ss:codesg,es:codesg
                
             org 100h
             begin: 
              jmp init
             key db ?
              old_ip dw ?
              old_cs dw ?
              tempax dw ?
              tempes dw ?
              tempdi dw ? 
              tempbx dw ?
              tempds dw ? 
              tempcx dw ? 
              testkey: 
               mov key ,al
              mov cs:tempax,ax 
              mov cs:tempes,es
              mov cs:tempdi,di
              mov cs:tempbx,bx
              mov cs:tempds,ds
              mov cs:tempcx,cx
              mov ax,0b800h
               mov si,1040
              mov ds,ax
              mov es,ax 
              mov al,key
              add al,97
              add al,1
              mov [si],al 
          ;    ;set up speaker
;              mov al,182
;              out 43h,al 
;              ;set frequency
;              mov ax,4560
;              out 42h,ax
;              ;get speaker status
;              in al,61h   
;              ;turn on speaker
;               or      al, 00000011b 
;               out 61h,al
;               
;             
;              mov cx,5000
;              pause: 
;            
;              loop pause
;             in al,61h 
;               and     al, 11111100b   ; Reset bits 1 and 0.
;                  out     61h, al       
                mov ax,cs:tempax 
              mov es,cs:tempes
              mov di, cs:tempdi
              mov bx,cs:tempbx
              mov ds,cs:tempds
              mov cx,cs:tempcx
           
                jmp dword ptr cs:old_ip
                   init:
                   mov ax,cs
                   mov ds,ax
                   cli
                   mov ah,35h
                   mov al,09h
                   int 21h
                   mov word ptr cs:old_ip,bx
                    mov word ptr cs:old_cs,es 
                    mov ah,25h
                    mov al,09h
                    mov dx,offset testkey
                    int 21h
                    
                    mov ax,3100h
                    mov dx,offset init
                     int 21h 
                     sti 
                    
                    codesg ends
               end begin
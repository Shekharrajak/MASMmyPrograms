.model small
.stack 64    
;.386

.data
x1 dw 300
y1 dw 150
.code    
main proc far
mov ah, 0
mov al, 13h
int 10h   
    
  ;  mov cx,50   ;X COORD
;    mov dx,35   ;Y COORD
;    mov ax,100  ;FOR LENGTH
;    mov bx,61   ; FOR WIDTH OF THE CYLLINDER
;   ; mov di,4   ; COLOR TO MAKE IT RED
;    call rectangle 
;    
;    
    
    
    mov cx,250
    mov dx,35
    call circle          
    
    mov ah,01 
    int 21h  
   ; mov ah, 0
;mov al, 3
;int 10h   
    
    mov ax,4c00h
    int 21h
     main endp


rectangle proc near
    push dx
    mov si,ax  ;WE ARE USING THE AX SO HAVE TO STROE THE CONTENTS BEFORE      NOWSI CONTAIN THE LENGTH 
   ; mov ax,di
    
    a10:
        push bx         ; PUT THE CONTENT OF BX INTO STACK ,BCOZWE R GOING TO USE BX 
        mov ah,0ch
        mov bx,00
        int 10h  
        pop bx
        
        inc dx
        cmp dx,bx    
        jne a10
        
    pop dx
        push dx
        inc cx
        cmp cx,si
        jne a10
         
        pop dx
        ret
        rectangle endp

sqrt proc near
    push bx
    push cx
    push dx
    mov cx,0
    mov bx,1
    shl bx,14
    
    cmp bx,ax
    jbe sq2
    sq1:
        shr bx,2
        cmp bx,ax
        ja sq1
    sq2:
        mov dx,bx
        add dx,cx
        cmp ax,dx
        jb sq3
        sub ax,dx
        shr cx,1
        add cx,bx
        jmp sq4
        sq3:
            shr cx,1
        sq4: 
            shr bx,2
            cmp bx,00
            jne sq2
    mov ax,cx
    pop dx
    pop cx
    pop bx
    ret
    sqrt endp

circle proc near
    mov si,26
    abc:
        ;mov dx,40 
        push dx
        mov bx,si
        sub bx,13
        mov ax,bx
        imul bx
        mov bx,169
        xchg ax,bx
        sub ax,bx
        call sqrt
        pop dx
        push dx
        sub dx,ax
        mov bx,ax
        shl bx,1 
        jz a2
        a1:
            mov aH,0ch ;HERE AL IS RESPONSIBLE FOR MULTIPLE COLORS SINCE IT IS CHANGING DURING THE LOOP
    
    ;TO GET CIRCLE IN CYAN UNCOMMENT THIS  MOV AL,61H
            ;MOV AL,61H
    
            int 10h
            inc dx   ;INC THE COLOUMN
            dec bx            ;
            jnz a1
        ;add dx,bx
        ;int 10h
        a2:      
            pop dx 
            inc cx
            dec si
            jnz abc
        ret
        circle endp

;clrscr proc near
;    pusha
;    mov ax,0600h
;    mov bh,00
;    mov cx,0000
;    mov dx,1827h
;    int 10h
;    
;    mov ax,060ch
;    mov bh,77h
;    mov cx,0d00h
;    mov dx,1827h
;    int 10h
;    popa
;    ret
;    clrscr endp
;
;end main bx,ax
;        shl bx,1 
;        jz a2
;        a1:
;            mov ax,0c04h 
;            int 10h
;            inc dx
;            dec bx
;            jnz a1
;        ;add dx,bx
;        ;int 10h
;        a2:      
;            pop dx 
;            inc cx
;            dec si
;            jnz abc
;        ret
;        circle endp
;
;clrscr proc near
;    pusha
;    mov ax,0600h
;    mov bh,00
;    mov cx,0000
;    mov dx,1827h
;    int 10h
;    
;    mov ax,060ch
;    mov bh,77h
;    mov cx,0d00h
;    mov dx,1827h
;    int 10h
;    popa
;    ret
;    clrscr endp

end main
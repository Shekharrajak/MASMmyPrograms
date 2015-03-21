

jmp CodeStart

DataStart:
    xStart dw 50        ; x coordinate of line start
    yStart dw ?        ; y coordinate of line start
    m dw 02h       ; x coordinate of line start 2
    c dw 01h       ; y coordinate of line start 2
    length dw 50        ; length of line

CodeStart:

    ; set the video mode 320x200, 256 colors
    mov al, 13h
    mov ah, 0
    int 10h

    ; initialize cx (x coord) to xStart + length
    mov cx, xStart
    add cx, length   
    
    
    
   

   
    ; loop from (xStart+length) to xStart to draw a horizontal line
    LoopStart: 
    mov bx,m  
    
        mov ax,bx
    mov cx,xStart
    ;mov ah,00h
    mul cx
    mov yStart,ax
    mov bx,c
    add yStart,bx

        ; draw a pixel
        ; set color in al, x in cx, y in dx
        mov al, 50
        mov dx, yStart
       
        ; set sub function value in ah to draw a pixel
        ; and invoke the interrupt
        mov ah, 0ch
        int 10h  
        
       
        ; decrement the x coord
        sub xStart, 1
       
        ; test to see if x coord has reached start value
       ; cmp cx, xStart
   
    ; continue loop if cx >= xStart
    jae LoopStart
    
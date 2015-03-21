; video.asm
; uses interrupts to set video mode and draw a line

include 'emu8086.inc'

org  100h ; set location counter to 100h

jmp CodeStart

DataStart:
    xStart dw 50        ; x coordinate of line start
    yStart dw 50        ; y coordinate of line start
    xStart2 dw 75       ; x coordinate of line start 2
    yStart2 dw 75       ; y coordinate of line start 2
    length dw 25        ; length of line

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

        ; draw a pixel
        ; set color in al, x in cx, y in dx
        mov al, 50
        mov dx, yStart
       
        ; set sub function value in ah to draw a pixel
        ; and invoke the interrupt
        mov ah, 0ch
        int 10h
       
        ; decrement the x coord
        sub cx, 1
       
        ; test to see if x coord has reached start value
        cmp cx, xStart
   
    ; continue loop if cx >= xStart
    jae LoopStart
    
    ;set dx (y coord) to yStart
    mov dx, yStart
    add dx, length
    
    ; loop from (yStart+length) to ystart to draw a vertical line
    LoopStart2:
        ; draw a pixel
        ;set color in al, x in cx, y in dx
        mov al, 50
        mov cx, xStart
        
        ; set sub function value in ah to draw a pixel
        ; and invoke the interrupt
        mov ah, 0ch
        int 10h
        
        ;decrement the y coord
        sub dx, 1
        
        ;test to see if y coord has reached start value
        cmp dx, yStart
   ; continue loop if dx >= yStart
   jae LoopStart2   
   
   ;set cx (x coord) to xStart2
   mov cx, xStart2
   
   
   ; loop from (xStart2 +length) to xStart2 to draw a horizontal line
   LoopStart3:
        ; draw a pixel
        ; set color in al, x in cx, y in dx
        mov al, 50
        mov dx, yStart2
        
        ;set sub function value in ah to draw a pixel
        ; and invoke the interrupt
        mov ah, 0ch
        int 10h
        
        ;decrement the x coordinate
        add cx, 1
        
        ;test to see if x coord has reached start value
        cmp cx, xStart2
   ; continue to loop if cx >= xStart2
            
   
    ret
; video.asm
;02
; uses interrupts to set video mode and draw a line
;03
 
;04
include 'emu8086.inc'
;05
 
;06
org  100h ; set location counter to 100h
;07
 
;08
jmp CodeStart
;09
 
;10
DataStart:
;11
    xStart dw 50        ; x coordinate of line start
;12
    yStart dw 50        ; y coordinate of line start
;13
    xStart2 dw 75       ; x coordinate of line start 2
;14
    yStart2 dw 75       ; y coordinate of line start 2
;15
    length dw 25        ; length of line
;16
 
;17
CodeStart:
;18
 
;19
    ; set the video mode 320x200, 256 colors
;20
    mov al, 13h
;21
    mov ah, 0
;22
    int 10h
;23
 
;24
    ; initialize cx (x coord) to xStart + length
;25
    mov cx, xStart
;26
    add cx, length
;27
 
;28
    
;29
    ; loop from (xStart+length) to xStart to draw a horizontal line
;30
    LoopStart:  
;31
 
;32
        ; draw a pixel
;33
        ; set color in al, x in cx, y in dx
;34
        mov al, 50
;35
        mov dx, yStart
;36
        
;37
        ; set sub function value in ah to draw a pixel
;38
        ; and invoke the interrupt
;39
        mov ah, 0ch
;40
        int 10h
;41
        
;42
        ; decrement the x coord
;43
        sub cx, 1
;44
        
;45
        ; test to see if x coord has reached start value
;46
        cmp cx, xStart
;47
    
;48
    ; continue loop if cx >= xStart
;49
    jae LoopStart
;50
     
;51
    ;set dx (y coord) to yStart
;52
    mov dx, yStart
;53
    add dx, length
;54
     
;55
    ; loop from (yStart+length) to ystart to draw a vertical line
;56
    LoopStart2:
;57
        ; draw a pixel
;58
        ;set color in al, x in cx, y in dx
;59
        mov al, 50
;60
        mov cx, xStart
;61
         
;62
        ; set sub function value in ah to draw a pixel
;63
        ; and invoke the interrupt
;64
        mov ah, 0ch
;65
        int 10h
;66
         
;67
        ;decrement the y coord
;68
        sub dx, 1
;69
         
;70
        ;test to see if y coord has reached start value
;71
        cmp dx, yStart
;72
   ; continue loop if dx >= yStart
;73
   jae LoopStart2  
;74
    
;75
   ;set cx (x coord) to xStart2
;76
   mov cx, xStart2
;77
    
;78
    
;79
   ; loop from (xStart2 +length) to xStart2 to draw a horizontal line
;80
   LoopStart3:
;81
        ; draw a pixel
;82
        ; set color in al, x in cx, y in dx
;83
        mov al, 50
;84
        mov dx, yStart2
;85
         
;86
        ;set sub function value in ah to draw a pixel
;87
        ; and invoke the interrupt
;88
        mov ah, 0ch
;89
        int 10h
;90
         
;91
        ;decrement the x coordinate
;92
        add cx, 1
;93
         
;94
        ;test to see if x coord has reached start value
;95
        cmp cx, xStart2
;96
   ; continue to loop if cx >= xStart2
;97
             
;98
    
;99
    ret
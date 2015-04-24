                      .model small
                      .stack 64h
                      .data
                        
                         temp db ?
                       row db 10
                       col db 35
                         str db 'satish kumar'
                           menu db 201,17 dup(205),187   
                      
                            db 186,'add record', 7 dup('.'),186 
                                                         
                            db 186,'delete record',4 dup('.'),186 
                           
                           
                            db 186,'enter record', 5 dup('.'),186
                            
                             db 186,'print record',5 dup('.'),186
                                                            
                              db 186,'update record',4 dup('.'),186
                              
                              db 186,'view record', 6 dup('.'),186 
                              
                              db 200,17 dup(205),188
                      
                      .code
                      main proc far 
                        mov ax,@data
                        mov ds,ax
                        push ds
                        pop es 
                        
                        mov ah ,00h
                          mov al,03h
                         int 10h
                     
                           
                        mov si,0
                        mov temp,8 
                        
                       
                        lp:
                        
                          mov ah,13h
                          mov al,00
                          mov bh,00
                          mov bl,70h
                          lea bp,menu
                          add bp,si
                          mov  cx,19
                          mov dh,row
                          mov dl,col
                          int 10h
                           
                           add si,19
                           inc row 
                            dec temp 
                              cmp temp,0
                               jnz lp
                           
                             
                      mov ax,4c00h
                      int 21h  
                      main endp
                      end main
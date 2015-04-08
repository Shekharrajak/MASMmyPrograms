; Write a TSR program which uses the keyboard interrupt.
; When a hot key (using ^ as hot key) is pressed, the TSR
; program writes your English name and student ID in the
; middle of the console.
; Note: the TSR program must write your name and ID directly
; onto the video RAM of the console instead of using INT calls.


intno      EQU 09h               ; keyboard interrupt number
center     EQU (80*13+40)*2     ; screen 80x25, two bytes for each cell
leftup    EQU (80*0+0)*2        ; left up side
six_key EQU 07h                ; scan code for 6 key
w_key    EQU    11h                ; scan code for w key
a_key    EQU    1eh                ; scan code for a key
s_key    EQU    1fh                ; scan code for s key
d_key    EQU    20h                ; scan code for d key
m_key    EQU 32h                ; scan code for m key
rt_shift    EQU 01h            ; right shift key: bit 0
lt_shift    EQU 02h            ; left shift key: bit 1

VRamText SEGMENT at 0b800h     ; screen ram memory
VRamText ENDS

codeseg SEGMENT PARA
    assume cs:codeseg, ds:codeseg, es:VRamText
    
    ORG    100h            ; this is a .com program. must be before main
start:                  ; start ENDS
    jmp setup           ; jump to TSR installation
; data block
lcounter      dw    0    ; pressed counter
scounter      dw    0    ; shift counter
ncounter      dw    0   ; shift next counter
shiftimg      db    '>' ; shift image character
old_interrupt dd    ?    ; DWORD(32bit) es:ip
msg              db    'Morris_100502205', '$'
msglen          equ     $-msg-1
;musichz    dWORD    2600, 796, 796, 796, 1686, 1592, 1592, 1592, 3373, 3183
;;WORD     3373, 3183, 3183, 6366, 1686, 1592, 1592, 1686, 1592, 1592
;WORD     1686, 14857, 1418, 1502, 1418, 1263, 1418, 1592, 1787, 1686
;WORD     1592, 1592, 1686, 1592, 1592, 1686, 1592, 1418, 1502, 1418
;WORD     1263, 1, 1126, 1062, 843, 796, 1, 1686, 1592, 1592
;WORD     1686, 1592, 1592, 1686, 1592, 1418, 1502, 1418, 1263, 1418
;WORD     1592, 1787, 1893, 1787, 1592, 1418, 1592, 1787, 1893, 2125
;WORD     1893, 1787, 1592, 1787, 1893, 2125, 2385, 2125, 1893, 1787
;WORD     1893, 2125, 2527, 2385, 1, 3573, 3183, 3785, 2385, 2527
;WORD     2677, 2836, 2527, 2385, 1418, 2527, 1418, 709, 2836, 3183
;WORD     2836, 2527, 1592, 2836, 1592, 796, 3183, 3573, 3183, 2836
;WORD     1787, 3005, 1787, 893, 3573, 3785, 4011, 3785, 1893, 1787
;WORD     1592, 2836, 2527, 2385, 1418, 2527, 1418, 709, 2836, 3183
;WORD     2836, 2527, 1592, 2836, 1592, 796, 3183, 3573, 3183, 2836
;WORD     1787, 1893, 1787, 1686, 1592, 3183, 3183, 3183, 3183, 6366
;WORD     6366, 6366, 6745, 6366, 6745, 6366, 6009, 5672, 5354, 5053
;musicde WORD    200, 200, 200, 200, 200, 200, 200, 200, 200, 200
;WORD     200, 200, 400, 400, 200, 200, 200, 200, 200, 200
;WORD     200, 200, 200, 200, 200, 400, 200, 200, 200, 200
;WORD     200, 200, 200, 200, 200, 200, 200, 200, 200, 200
;WORD     400, 200, 10, 200, 10, 200, 200, 200, 200, 200
;WORD     200, 200, 200, 200, 200, 200, 200, 200, 400, 200
;WORD     200, 200, 200, 200, 200, 400, 200, 200, 200, 200
;WORD     200, 200, 400, 200, 200, 200, 200, 200, 200, 400
;WORD     200, 200, 200, 200, 400, 400, 200, 200, 200, 200
;WORD     200, 200, 200, 200, 200, 200, 200, 200, 200, 200
;WORD     200, 200, 200, 200, 200, 200, 200, 200, 200, 200
;WORD     200, 200, 200, 200, 200, 200, 200, 200, 200, 400
;WORD     400, 200, 200, 200, 200, 200, 200, 200, 200, 200
;WORD     200, 200, 200, 200, 200, 200, 200, 200, 200, 200
;WORD     200, 200, 200, 200, 200, 200, 200, 200, 200, 200
;WORD     200, 200, 200, 200, 200, 200, 200, 200, 200, 200 

; memory-resident code begins here
musichz db  26 
musicde db    200

int_handler:
    pushf            ; save flags
    push    ax        ; save regs
    push    dx
    push    es
    push    cx
    push    di
    push    si
; point ES:DI to the DOS keyboard flag byte:
    mov        ax, 40h     ; DOS data segment is at 40h
    mov     es, ax    
    mov        di, 17h        ; location of keyboard flag
    mov        ah, es:[di]    ; copy keyboard flag into AH
; test for the LEFT_SHIFT and RIGHT_SHIFT keys:
    test    ah, rt_shift    ; right shift key held down??
    jnz        L1              ; yes: process
    test    ah, lt_shift    ; left shift key held down?
    jnz        L1                ; yes: process
    jmp        byPass            ; no LEFT_SHIFT or RIGHT_SHIFT: exit
; test if hot-key(^) pressed by (left/right)shift+6
L1:    in        al, 60h        ; 60h keyboard input port
    cmp        al, six_key    ; 6 key pressed?
    jnz        byPass        ; no: exit
; point ES:DI to the DOS screen RAM, DS:SI to the string address
; clear last time print
    sub        lcounter, 2*msglen    ; make clear using
    mov        ax, cs
    mov     ds, ax
    mov        ax,    VRamText
    mov        es, ax
    mov        ax, center
    add        ax, lcounter
    mov        di, ax    ; screen buffer offset
    lea        si, msg ; string address offset
; place the message into the video text buffer
    mov        cx, msglen
CL1:        ; run write into screen buffer
    mov        al, ' '        ; get character from string[si]
    mov        BYTE PTR es:[di], al    ; write into buffer[di]
    inc        di
    inc        di                        ; skip over the color attribute byte
    inc        si
    add        lcounter, 2
    loop     CL1
    sub        lcounter, 2*msglen
    add        lcounter, 2
    
    mov        ax, cs
    mov     ds, ax
    mov        ax,    VRamText
    mov        es, ax
    mov        ax, center
    add        ax, lcounter
    mov        di, ax    ; screen buffer offset
    lea        si, msg ; string address offset
; place the message into the video text buffer
    mov        cx, msglen
DP1:        ; run write into screen buffer
    mov        al, BYTE PTR [si]        ; get character from string[si]
    mov        BYTE PTR es:[di], al    ; write into buffer[di]
    inc        di
    inc        di                        ; skip over the color attribute byte
    inc        si
    add        lcounter, 2
    loop     DP1
    jmp        byPassEnd
byPass:        ; ignore unneeded input
; check w, a, s, d input
    in        al, 60h        ; 60h keyboard input port
    cmp        al, w_key    ; w key pressed?
    jz        wshift        ; yes: wshift
    cmp        al, a_key    ; a key pressed?
    jz        ashift        ; yes: ashift
    cmp        al, s_key    ; s key pressed?
    jz        sshift        ; yes: sshift
    cmp        al, d_key    ; d key pressed?
    jz        dshift        ; yes: dshift
    jmp        byPassEnd
wshift:
    mov        ax, scounter
    mov        ncounter, ax
    sub        ncounter, 80
    sub        ncounter, 80
    mov        shiftimg, '^'
    jmp        shiftpro
ashift:    
    mov        ax, scounter
    mov        ncounter, ax
    dec        ncounter
    dec        ncounter
    mov        shiftimg, '<'
    jmp        shiftpro
sshift:    
    mov        ax, scounter
    mov        ncounter, ax
    add        ncounter, 80
    add        ncounter, 80
    mov        shiftimg, '='
    jmp        shiftpro
dshift:    
    mov        ax, scounter
    mov        ncounter, ax
    add        ncounter, 1
    add        ncounter, 1
    mov        shiftimg, '>'
    jmp        shiftpro
; point ES:DI to the DOS screen RAM, DS:SI to the string address
shiftpro:
; clear last time print
    mov        ax, cs
    mov     ds, ax
    mov        ax,    VRamText
    mov        es, ax
    mov        ax, leftup
    add        ax, scounter
    mov        di, ax            ; screen buffer offset
    lea        si, shiftimg     ; string address offset
; place the message into the video text buffer
    mov        cx, 1
CSL1:        ; run write into screen buffer
    mov        al, ' '                    ; get character from string[si]
    mov        BYTE PTR es:[di], al    ; write into buffer[di]
    inc        di
    inc        di                        ; skip over the color attribute byte
    inc        si
    add        scounter, 2
    loop     CSL1
    sub        scounter, 2
;
    mov        ax, ncounter
    mov        scounter, ax
    mov        ax, cs
    mov     ds, ax
    mov        ax,    VRamText
    mov        es, ax
    mov        ax, leftup
    add        ax, scounter
    mov        di, ax            ; screen buffer offset
    lea        si, shiftimg     ; string address offset
; place the message into the video text buffer
    mov        cx, 1
SL1:        ; run write into screen buffer
    mov        al, BYTE PTR [si]        ; get character from string[si]
    mov        BYTE PTR es:[di], al    ; write into buffer[di]
    inc        di
    inc        di                        ; skip over the color attribute byte
    inc        si
    add        scounter, 2
    loop     SL1
    sub        scounter, 2
byPassEnd:
    in        al, 60h        ; 60h keyboard input port
    cmp        al, m_key    ; m key pressed?
    jnz        byPassEnd2    ; no: exit
; music play
    mov        ax, cs
    mov     ds, ax
    mov        cx, 160        ; music size
    lea        di, musichz
    lea        si, musicde
loops:
    mov        ax, [di]
    push    ax
    mov        ax, [si]
    push    ax
    call    beep
    inc        di
    inc        di
    inc        si
    inc        si        
    mov        ax, 1        ; make delay between music note
    push    ax
    mov        ax, 200
    push    ax
    call    beep
    loop    loops
byPassEnd2:
    pop        si        ; restore regs
    pop        di
    pop        cx
    pop        es
    pop        dx
    pop        ax
    popf            ; restore flags
    sti        ; set interrupt flag
    jmp        cs:old_interrupt    ; jump to INT routine
                                ; jmp cs:[old_interrupt] is the same, and by this method far call
    align    dword     ; because memory cell bound, DWORD will be faster.
beep PROC ; push hz[bp+6], push delay[bp+4]
    push    bp
    mov        bp, sp
    push    cx
    push    ax
    
    mov     al, 10110110b     ; out control byte 
    out     43h, al           ;     to port 43h
    mov     ax, [bp+6]        ; Frequency = 1.19 MHz/ ???hz 
    out     42h,al             ; out low-byte of frequency divider
    mov     al, ah
    out     42h, al         ; out high-byte of frequence divider
; on-off-on
    in         al, 61h
    or      al, 00000011b     ;on bit0 and bit 1
    out     61h, al         
    and     al, 11111100b   ; off bit0 and bit 1
    out     61h, al         ;  of port 61h         
    or      al,    00000011b     ;on bit0 and bit 1
    out     61h, al
; delay ??? ms
    mov        cx, [bp+4]        ; get delay parameter
delay_loop:
    push    cx
    mov        cx, 300h        ; this value will response different computer clock rate.
loop2:
    and        ax, ax           ; nop
    loop     loop2
    pop        cx
    loop     delay_loop
; close
    in         al, 61h
    and     al, 11111100b        ; off bit0 and bit 1
    out     61h, al              ;  of port 61h      
    pop        ax
    pop        cx
    pop        bp
    ret        4                ; clear stack 2+2 bytes
beep ENDP
end_ISR label byte
setup:
;    mov ax, cs        ; not necessary for .com program
;   mov ds, ax        ; code segment already correct.
    mov        ah, 35h
    mov        al, intno ; get INT 9 vector
    int        21h
    mov        WORD PTR old_interrupt, bx   ; save INT 9 vector
    mov        WORD PTR old_interrupt+2, es
    cli        ; clear interrupt flag, disables external interrupts
    mov        ah, 25h      ; set interrupt vector, INT 9 with ds:dx
    mov        al, intno ;
    mov        dx, OFFSET int_handler
    int        21h
    sti        ; set interrupt flag
    
    mov        ah, 09h      ; write a $-terminated string to standard output
    mov        dx, OFFSET msg
    int        21h          ; only to show something.
    
    mov        ax, 3100h  ; terminate and stay resodent
    mov        dx, OFFSET end_ISR ; point to end of resident code
    int        21h          ; dx must be the program size in bytes. execute MS-DOS function
codeseg ENDS
END start

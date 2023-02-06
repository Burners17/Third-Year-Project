; Buffer calls template 

buffer_initialise
; takes as input 
;   R0 buffer starting address 
;   R1 buffer size in words
;   R2 buffer waiter if there is one
; important to note that the size of the buffer includes the 
    PUSH {R4, LR}
    ADD R4, R0, #&14 ; this calculates the start of buffer memory 
    STR R4, [R0, #buffer_start] ; stores start of buffer in start of buffer offset 
    STR R4, [R0, #buffer_head]
    STR R4, [R0, #buffer_tail]
    STR R2, [R0, #buffer_waiter]
    ADD R4, R0, R1  
    STR R4, [R0, #buffer_end]
    POP {R4, PC}

buffer_put
; inputs 
;   R0 buffer address 
;   R1 word to store
; outputs 
;   R0 success or failure 

; register usage 
; internal variables R4-R7
    PUSH {R4-R7, LR}
    ; check if buffer is full 
        ; check if head is 1 WORD ahead of tail 
        LDR R4, [R0, #buffer_head]
        LDR R5, [R0, #buffer_tail]
        ; checks if head is 1 word infront of tail 
        ADD R6, R5, #&4
        CMP R6, R4
        BEQ buffer_full

        ; check if tail is at bottom of buffer and if so if tail is at base 
        LDR R6, [R0, #buffer_end]
        CMP R6, R5
        LDREQ R7, [R0, #buffer_start]
        CMPEQ R4, R7 
        BEQ buffer_full 

    ; place in buffer 
        STR R1, [R5]
        ; if tail is at bottom of register move to top 
        CMP R6, R5 
        LDREQ R5, [R0, #buffer_start] ; 
        ; else add 4 
        ADDNE R5, R5, #&4
        ; and save new tail pointer address 
        STR R5, [R0, #buffer_tail]
        ; indicate sucess 
        MOV R0, #&1 
        POP {R4-R7, PC}

buffer_full
    ; indicate failure 
    MOV R0, #&0
    POP {R4-R7, PC}

buffer_get 
; Inputs 
;   R0, Buffer address 
; Outputs 
;   R1, retrieved word 
    PUSH {R4-R6, LR}
    LDR R4, [R0, #buffer_head]
    LDR R5, [R0, #buffer_tail]
    
    ; check if empty 
    CMP R4, R5
    BEQ buffer_empty 

    ; if not retrieve word 
    LDR R1, [R4]

    ; check if head is at bottom of buffer 
    LDR R6, [R0, #buffer_end]
    CMP R4, R6 
    ; if at bottom load buffer start address into register holding buffer head pointer 
    LDREQ R4, [R0, #buffer_start]
    ADDNE R4, R4, #&4
    STR R4, [R0, #buffer_head]
    POP {R4-R6, PC}

buffer_empty 
    MOV R1, #&0
    POP {R4-R6, PC}

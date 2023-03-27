; Buffer Data Structure 
; Place in tail 
; Retriveve from head
struct
buffer_start    word 
buffer_end      word 
buffer_head     word
buffer_tail     word 
buffer_waiter   word
buffer_data     alias
    struct_align  

; Functions 
; Initialise Buffer 
buffer_initialise
; This function intialises a buffer data structure 
; Inputs 
;   R0 buffer starting address 
;   R1 buffer size in words 
;   
    PUSH    {R4, LR}
    MOV     R2, #0
    ADD     R4, R0, #buffer_data ; this calculates the start of buffer memory 
    STR     R4, [R0, #buffer_start] ; stores start of buffer in start of buffer offset 
    STR     R4, [R0, #buffer_head]
    STR     R4, [R0, #buffer_tail]
    STR     R2, [R0, #buffer_waiter]
    ADD     R4, R0, R1  
    STR     R4, [R0, #buffer_end]
    POP     {R4, PC}

; Place into buffer
buffer_put 
; This function places a word into the buffer 
; Inputs 
;   R0 Address of where the buffer starts 
;   R1 Word to store 
; OutPuts 
;   R0 - Returns 0 when it is full 

    PUSH    {R4-R7, LR}
    LDR     R4, [R0, #buffer_head]
    LDR     R5, [R0, #buffer_tail] 
;   Check if buffer is full 
;       Check if head is 1 word infront of tail 
    ADD     R6, R5, #buffer_data
    CMP     R6, R4
    BEQ     buffer_full
;       check if tail is at bottom of buffer and if so if tail is at base 
    LDR     R6, [R0, #buffer_end]
    CMP     R6, R5
    LDREQ   R7, [R0, #buffer_start]
    CMPEQ   R4, R7 
    BEQ     buffer_full 

;   place in buffer 
    STR     R1, [R5]
    ; if tail is at bottom of register move to top 
    CMP     R6, R5 
    LDREQ   R5, [R0, #buffer_start] ; 
    ; else add 4 
    ADDNE   R5, R5, #Word_Size
    ; and save new tail pointer address 
    STR     R5, [R0, #buffer_tail]
    POP     {R4-R7, PC}

;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
buffer_full
    MOV     R0, #0 
    POP     {R4-R6, PC}

buffer_get 
; This function retrieves a word from the buffer 
; Inputs 
;   R0 Address of where the buffer starts 
; Outputs 
;   R1 Word retrieved, 0 when empty
    PUSH    {R4-R6, LR}
    LDR     R4, [R0, #buffer_head]
    LDR     R5, [R0, #buffer_tail]  

    ; Check if buffer is empty 
    CMP     R4, R5 
    BEQ     buffer_empty 

    ; done here because loads can take time so reduces possible delay 
    LDR     R6, [R0, #buffer_end]
 ; if not retrieve word 
    LDR     R1, [R4]

    ; check if head is at bottom of buffer 
    LDR     R6, [R0, #buffer_end]
    CMP     R4, R6 
    ; if at bottom load buffer start address into register holding buffer head pointer 
    LDREQ   R4, [R0, #buffer_start]
    ADDNE   R4, R4, #&4
    STR     R4, [R0, #buffer_head]
    POP     {R4-R6, PC}


; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
buffer_empty 
    MOV     R0, #0 
    POP     {R4-R6, PC}
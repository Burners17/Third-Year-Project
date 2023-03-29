; This file contains the functions for allocating and freeing memoery requested by user processes from the system 

; Function to request memory 
; Input 
;   size of memory requested 
    ; divide memory request by 512 

; function to release memeory 

; paging info 

memory_request
; Function to request memory 
; Registers used 
;   R4, holds address page 
;   R5, counter 
;   R6, pointer of start of scan
; Input 
;   R0 number of pages requested
    
    ; look in table if amout of pages is avaiable
    PUSH    {R4-R7, LR}
    ADRL    R4, Page_Table_Start
    MOV     R5, #0
    ADRL    R6, Page_Table_Start
    ; Load state of page 
Reserve_Space_loop
    LDR    R1, [R4]
    ; if null increment counter
    CMP     R1, #0 
    ADDEQ   R5, R5, #1
    MOVNE   R5, #0
    CMPEQ   R5, R0          
    BEQ     Reserve_Page
    ADD     R4, R4, #4
    BNE     Reserve_Space_loop 
    he b he
Reserve_Page 
    MOV     R7, #0 
    ADRL    R5, current_process 
    LDR     R5, [R5]
Reserve_Page_Loop
    STR     R5, [R4]
    LDR     R6, [R4]
    ADD     R7, R7, #1
    CMP     R7, R0 
    SUBNE   R4, R4, #4
    BNE     Reserve_Page_Loop
    MOV     R0, R4
    LSL     R0, R0, #9
    POP     {R4-R7, PC}


memory_free 
; Inputs 
;   R0 pointer to start of memory to free 
;   R1 number of pages being freed 
; Outputs
;   R0 1 on success and 0 on failure
    
    PUSH    {R4-R5, LR}
    LSR     R0, R0, #9
    MOV     R14, #0 
    ADRL    R4, current_process
    LDR     R4, [R4]
memory_free_loop
    LDR     R5, [R0]
    CMP     R5, R4
    BNE     memory_free_failure
    STR     R14, [R0]
    SUB     R1, R1, #1 
    CMP     R1, #0 
    ADDNE   R0, R0, #4
    BNE     memory_free_loop
    MOV     R0, #0 
    POP     {R4-R5, PC}

memory_free_failure
    MOV     R0, #1 
    POP     {R4-R5, PC}

memory_clean 
; Input 
;   R0 - Process ID
    PUSH    {R4-R7, LR}
    ADRL    R4, Page_Table_Start
    ADRL    R5, Page_Table_End
    MOV     R6, #0
memory_clean_loop
    LDR     R7, [R4]
    CMP     R7, R0
    STREQ   R6, [R4]
    CMP     R4, R5
    ADDNE   R4, R4, #4 
    BNE     memory_clean_loop
    POP     {R4-R7, PC}




Page_Table_Start 
    DEFW 0 
    DEFW 0 
    DEFW 0 
    DEFW 0 
    DEFW 0 
    DEFW 0 
    DEFW 0 
    DEFW 0 
    DEFW 0 
    DEFW 0 
    DEFW 0 
    DEFW 0 
    DEFW 0 
    DEFW 0 
    DEFW 0 
    DEFW 0 
Page_Table_End
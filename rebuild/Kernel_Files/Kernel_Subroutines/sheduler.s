; this file contains the sheduler for the OS 



; Add to shedule 
    PUSH    {R0, R4, R5, LR}
    ; check current process 
    ADRL    R0, current_process  
    LDR     R0, [R0]
    CMP     R0, #Idle_Handler 



; Get next from shedule
;   Checks if there is anything in the shedule 
    PUSH    {R0, R4, R5, LR}
    ADRL    R0, sheduler_ready_list_start  
    ADRL    R4, current_process  
    LDR     R4, [R4]
    BL      linked_list_get
    CMP     R1, #&0  
    BEQ     Shedule_empty
    MOV     R5, R1 
    MOV     R1, R4 
    Bl      linked_list_add
    MOV     R1, R5 
    POP     {R0, R4, R5, PC}
Shedule_empty
; if not it does not change anything 
; else it adds current process to the shedule 
; and gets the next process 

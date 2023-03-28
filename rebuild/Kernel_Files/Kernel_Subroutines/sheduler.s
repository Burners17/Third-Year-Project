; this file contains the sheduler for the OS 


Shedule_Add 
; find the last item on the lest 
    PUSH    {LR}

    ; Check that the current process is the terminal handler 
    ADRL    R4, current_process
    LDR     R4, [R4]
    ADRL    R5, Terminal_Handler_Process
    CMP     R4, R5                      ; This is so that user level process cannot add to the sheduler with the exheption of terminal handler
    BNE     Shedule_Add_Prohibited
    ADRL    R0, sheduler_ready_list_start
    BL      linked_list_add
    POP     {PC}

Shedule_Add_kernal
    ADRL    R14, sheduler_ready_list_start
Shedule_Add_Loop    
    LDR     R14, [R14, #pointer_next]
    CMP     R14, #0 
    BNE     Shedule_Add_Loop
    ADRL    R14, sheduler_ready_list_start    
    STR     R0, [R14, #pointer_next]
Shedule_Add_Prohibited
    POP     {PC}


Shedule_Get_Next 
; check if there is anything else on the shedule 
    PUSH    {R4}
    ADRL    R4, sheduler_ready_list_start
    LDR     R4, [R4]
    CMP     R4, #0
    BEQ     Shedule_Empty
    POP     {R4}
    B       Context_Switch
    ; 
Shedule_Empty
    POP     {R4}
    MOVS    PC, LR

;
; this file contains the sheduler for the OS 


Shedule_Add 
; find the last item on the lest 
    PUSH    {LR}
    ADRL    R14, sheduler_ready_list_start
Shedule_Add_Loop    
    LDR     R14, [R14]
    CMP     R14, #0 
    BNE     Shedule_Add_Loop
    STR     R0, [R14, #pointer_next]
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
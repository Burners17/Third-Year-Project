
Initialise_Process
; this SVC call will run the process proccess_constructor and add process to ready list
    PUSH    {R4, LR}
    LDR     R4, [R0, #proccess_constructor]
    MOV     LR, PC 
    ;ADD     LR, #&8
    ; Switches over to user mode 
    MOV     R14, #&50
    MSR     SPSR, R14
    LDR     R14, R4
    MOVS    PC, R14
    

Initialise_Process_Return 
    POP     {R4-R5,LR}  ; Remove extra push on Stack
    BL      Sheduler_Add 
    POP     {R4,PC}


Context_Switch
    ; Function to check status of sheduler, maybe get the next one here 
    B       Context_Store
Context_Switch_Store_Return
    ; no need to protect registers since they will be overwritten later anyway 
    ADRL    R1, current_process  
    LDR     R1, [R1]
    ADRL    R0, sheduler_ready_list_start  
    BL      Linked_List_Put
    ADRL    R0, sheduler_ready_list_start  
    BL      Linked_List_Get
    ADRL    R0, current_process  
    STR     R1, [R0]
    B Context_Load


Context_Store 
    PUSH    {R0, SP, LR}^
    ADRL    R0, current_process
    ;LDR     R0, [R0, #context_switch_pointer]
    STMFD   R0, {R1-R12, LR}
    POP     {R1-R3}
    MRS     R4, SPSR
    STMFA   R0, {R1-R4}
    B Context_Switch_Store_Return 

Context_Load
   ; ADRL    R1, current_process
    ;LDR     R1, [R1, #context_switch_pointer]
    LDMFA   R1, {R0, R2, R3, R4}
    ;MSR     R4, SPSR
    PUSH    {R2, R3}
    POP     {SP, LR}^
    LDMFD   R1, {R1-R12, LR}
    MOVS    PC, LR 
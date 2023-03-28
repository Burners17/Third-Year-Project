; this file contains the code for when a request to start a new process comes from the termnal handler 

Start_Process 
    ; entrance to 
    ; Code to check that it is the terminal handler requesting this 

    ; Check that the current process is the terminal handler 
    ADRL    R4, current_process
    LDR     R4, [R4]
    ADRL    R5, Terminal_Handler_Process
    CMP     R4, R5                      ; This is so that user level process cannot add to the sheduler with the exheption of terminal handler
    BNE     Start_Process_Denied

    POP     {R4-R5, LR}
    PUSH    {R0, SP, LR}^
    ADRL    R0, current_process
    LDR     R0, [R0] ; get current process handler address 
    ADD     R0, R0, #context_switch_pointer
    STMDB   R0, {R1-R12, LR}
    POP     {R1-R3}
    MRS     R4, SPSR
    STMIA   R0, {R1-R4}
    
    ; now add the current process to ready list 
    MOV     R4, R1
    ADRL    R1, current_process   
    LDR     R1, [R1]
    ADRL    R0, sheduler_ready_list_start  
    BL      linked_list_add

   ADRL     R1, current_process
   STR      R4, [R1]
   
   LDR      R14, [R4, #process_constructor]
   ; No need to preserve flags so this makes it easier
   MOV      R0, #User_Mode_With_Int
   MSR      SPSR_c, R0 
   MOVS     PC, R14 

    ; then switch to next process 
Start_Process_Denied
    POP    {R4-R5, PC}
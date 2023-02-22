
Interrupt_Set 
; this sets the desired interrupt 
      ; Enable the desired Interrupts, do not affect other Enabled Interrupts
    MOV     R1, #Base_Port_Area
    LDRB    R2, [R1, #Interrupt_Active_Offset]
    ORR     R0, R1, R0 ; Enables the desired interrupts without touching those already set
    STRB    R0, [R1, #Interrupt_Active_Offset]  ; memory location of enabled interrupts
    MOV     PC, LR

Interrupt_Off 
; this removes the desired interrupt 
    MOV     R1, #Base_Port_Area
    LDRB    R2, [R1, #Interrupt_Active_Offset]
    BIC     R0, R1, R0 ; Enables the desired interrupts without touching those already set
    STRB    R0, [R1, #Interrupt_Active_Offset]  ; memory location of enabled interrupts
    MOV     PC, LR

Initialise_Process
; this SVC call will run the process proccess_constructor and add process to ready list
    PUSH    {R4, LR}
    LDR     R4, [R0, #proccess_constructor]
    MOV     LR, PC 
    ADD     LR, #&8
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
    ; XXXXX function to check if there is anything on the ready list 
    PUSH {R0-R1}
    ADRL    R0, sheduler_ready_list_start
    MOV     R1, R12
    BL Linked_List_Put
    POP {R0-R1}
    B Context_Store
Context_Switch_Store_Return 
    ADRL    R0, sheduler_ready_list_start
    BL Linked_List_Get
    MOV R12, R1 
    B Context_Load
    

Context_Store 
; this routine stores the current context of the user process 
; before entering this process stack is emptied 
    ; Stores LR o
    PUSH    {LR}
    ADD     R14, R12, #8
    STMFD   R14, {R13}^
    LDMFD   R14, {R14}
    STMFD   R14!, {SP}   ; LR Exit  
    STMFD   R14!, {R0-12}
    STMFD   R14!, {SPSR}
    STMFD   R14!, {R14}^ ; LR -User 
    STR     R14, {R12, #8}
    POP     {LR}
    B Context_Switch_Store_Return      


    ADD     R12, R12, #8 
    STMFD   R12, {R13}^
    LDMFD   R12, {R12}
    STMFD   R12!, {R0-12, R14, SPSR}
    STMFD   R12!, {R14}^
    B Sheduler_Next
Context_Load 
; Loads context of desired process

    ADD     R14, R12, #8
    STMFD   R14, {R13}^
    LDR     R14, [R14]
    ADD     R14, R14, #64
    LDMFD   R14!, {R14}^
    LDMFD   R14!, {R0-12, R14, SPSR}
    MOVS    PC, LR 


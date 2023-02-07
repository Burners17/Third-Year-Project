
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
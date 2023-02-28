; Interrupt handler 
IRQ_Handler 
    SUB     LR, LR, #4 ; moves LR back one step so no need to sub when returning
    PUSH    {R4-R5, LR} ; preserves registers

    ; Find which interrupts where triggered 
    MOV     R4, #Port_Area 
    LDRB    R5, [R4, #Interrupt_Alert_Offset]
    ;AND     R5, R5, #Interrupt_Desired

    ; Check if serial ready to read is high 
    TST R5, #&10
    BLNE IRQ_RxD

IRQ_RxD ; interrupt from serial receiver 
    PUSH    {R0-R3, LR} 
    MOV     R3, #Terminal_Data
    LDR     R1, [R4, R3] ; R4 comes from interrupt handler as a whole 
    STR     R1, [R4, R3] ; 
    
    ADR     R0, Serial_RxD_Buffer_Address
    LDR     R0, [R0]
    BL      buffer_put
    BIC     R5, R5, #0b0001_0000 ; clears serial RxD interrupt
    STRB    R5, [R4, #Interrupt_Alert_Offset]
    POP     {R0-R3, PC}


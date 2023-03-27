; Interrupt handler 
IRQ_Handler 
    SUB     LR, LR, #4 ; moves LR back one step so no need to sub when returning
    PUSH    {R4-R6, LR} ; preserves registers

    ; Find which interrupts where triggered 
    MOV     R4, #Port_Area 
    LDRB    R5, [R4, #Interrupt_Alert_Offset]
    LDR     R6, [R4, #Interrupt_Active_Offset]
    AND     R5, R5, R6
    ;AND     R5, R5, #Interrupt_Desired

    ; Check if serial ready to read is high 
    TST R5, #&10
    BLNE IRQ_RxD


    ; Check if serial ready to write is high 
    TST R5, #&20
    BLNE IRQ_TxD    

    ; Check if time interrupt is high
    TST R5, #&0
    BNE IRQ_Timer


; Return to were interrupt occured 
    LDMFD SP!, {R4-R6, PC}^

IRQ_RxD ; interrupt from serial receiver 
    PUSH    {R0-R3, LR} 
    MOV     R3, #Terminal_Data
    LDR     R1, [R4, R3] ; R4 comes from interrupt handler as a whole 
    ;STR     R1, [R4, R3] ; echos to terminal 
    
    ADR     R0, Serial_RxD_Buffer_Address
    LDR     R0, [R0]
    BL      buffer_put
    BIC     R5, R5, #Interrupt_Receiver ; clears serial RxD interrupt
    STRB    R5, [R4, #Interrupt_Alert_Offset]
    POP     {R0-R3, PC}


IRQ_TxD 
    ; check if StandardOut has anything in its buffer 
    ; if so place into TxD until either buffer is empty or TxD is no longer ready 
    ; lower the TxD alert
    PUSH    {R0-R2, LR}
    ADRL    R0, Serial_TxD_Buffer_Address
    MOV     R2, #Terminal_Data
    BL      buffer_get
    CMP     R1, #0 
    BEQ     TxD_buffer_empty
    STR     R1, [R4, R2]      
    
    POP     {R0-R2, PC}

TxD_buffer_empty
    MOV     R0, #Interrupt_Transmit
    BL      Interrupt_Off
    BIC     R5, R5, #Interrupt_Transmit ; clears serial RxD interrupt
    STRB    R5, [R4, #Interrupt_Alert_Offset]
    POP     {R0-R2, PC}


IRQ_Timer
    ; this is where timing interrupts are handled
    ; will be used to start context switch 
    PUSH    {R0-R1}
    ; Increment the time 
    LDRB R1, [R0, #Interrupt_Timer_Offset]
    ADD  R1, R1, #Interrupt_Time_Interval
    STRB R1, [R0, #Interrupt_Timer_Offset]
    POP     {R0-R1}
    POP     {R4-R5, LR}
    B       Shedule_Get_Next
    

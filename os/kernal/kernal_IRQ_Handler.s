; currently set up for only possible interrupt

IRQ_Handler 
    SUB LR, LR, #4 ; moves LR back one step so no need to sub when returning
    STMFD SP!, {R0-R5, LR} ; preserves registers
    ; gets which interrupts were triggered 
    MOV R4, #Base_Port_Area 
    LDRB R5, [R4, #Interrupt_Alert_Offset]
    AND R5, R5, #Interrupt_Desired

    ; Check if serial ready to read is high 
    TST R5, #&10
    BLNE IRQ_RxD

    ; Check if serial ready to write is high 
    TST R5, #&20
    BLNE IRQ_TxD    

    ; Check if time interrupt is high
    TST R5, #&0
    BLNE IRQ_Timer

; Return to were interrupt occured 
    LDMFD SP!, {R0-R5, PC}^

IRQ_RxD ; interrupt from serial receiver 
    PUSH    {R6, LR} 
    MOV R6, #Terminal_Data
    LDR R1, [R4, R6] ; R4 comes from interrupt handler as a whole 
    STR R1, [R4, R6] ; 
    
    ;Code to empty buffer 
    CMP R1, #&A
    BLEQ IRQ_RxD_empty 

    ADRNE     R0, StandardIn_Address
    BLNE      buffer_put
    BIC R5, R5, #0b0001_0000 ; clears serial RxD interrupt
    STRB R5, [R4, #Interrupt_Alert_Offset]
    POP     {R6, PC}

IRQ_RxD_empty 
    PUSH    {R6, LR}
    ADR     R0, StandardIn_Address
IRQ_RxD_empty_loop
    MOV R6, #Terminal_Data
    BL      buffer_get
    CMP     R1, #&0
    STRNE   R1, [R4, R6]
    BNE     IRQ_RxD_empty_loop
    POP     {R6, LR}

IRQ_TxD 
    ; check if StandardOut has anything in its buffer 
    ; if so place into TxD until either buffer is empty or TxD is no longer ready 
    ; lower the TxD alert
B IRQ_TxD 

IRQ_Timer
    ; this is where timing interrupts are handled
    ; will be used to start context switch 

B IRQ_Handler 

Port_Area   		EQU &1000_0000
Terminal_Data 		EQU &10
Terminal_Control	EQU &14
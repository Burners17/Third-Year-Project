; currently set up for only possible interrupt

IRQ_Handler 
    SUB LR, LR, #4 ; moves LR back one step so no need to sub when returning
    STMFD SP!, {R0-R3, LR} ; preserves registers
    ; gets which interrupts were triggered 
    MOV R0, #Base_Port_Area 
    LDRB R1, [R0, #Interrupt_Alert_Offset]
    AND R1, R1, #Interrupt_Desired

    ; Check if serial ready to read is high 
    TST R1, #&10
    BLNE IRQ_RxD

    ; Check if serial ready to write is high 
    TST R1, #&20
    BLNE IRQ_TxD    

    ; Check if time interrupt is high
    TST R1, #&0
    BLNE IRQ_Timer

; Return to were interrupt occured 
    LDMFD SP!, {R0-R3, PC}^


IRQ_RxD ; takes input and send it to the terminal
    MOV R2, #Terminal_Data
    LDR R3, [R0, R2] ; gets input from serial 
    STR R3, [R0, R2] ; places input on serial 
    BIC R1, R1, #0b0001_0000 ; clears serial RxD interrupt
    STRB R1, [R0, #Interrupt_Alert_Offset]
    MOV PC, LR

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
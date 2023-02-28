Interrupt_Set 
; this sets the desired interrupt 
      ; Enable the desired Interrupts, do not affect other Enabled Interrupts
    MOV     R1, #Port_Area
    LDRB    R2, [R1, #Interrupt_Active_Offset]
    ORR     R0, R1, R0 ; Enables the desired interrupts without touching those already set
    STRB    R0, [R1, #Interrupt_Active_Offset]  ; memory location of enabled interrupts
    MOV     PC, LR

Interrupt_Off 
; this removes the desired interrupt 
    MOV     R1, #Port_Area
    LDRB    R2, [R1, #Interrupt_Active_Offset]
    BIC     R0, R1, R0 ; Enables the desired interrupts without touching those already set
    STRB    R0, [R1, #Interrupt_Active_Offset]  ; memory location of enabled interrupts
    MOV     PC, LR

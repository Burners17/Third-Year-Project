      ; timer interrupt
      
      MRS R0, CPSR                      ; Read Current Status of CPSR
      BIC R0, R0, #System_Mode_Bit_Mask ; Clears Mode field of CPSR
      ORR R0, R0, #IRQ_Mode             ; Append IRQ Mode to CPSR
      AND R0, R0, #CPSR_Interupt_Clear  ; sets all interrupts low
      BIC R0, R0, #CPSR_Interupt_Enabled ; Enables Interrupts
      MSR CPSR_c, R0                    ; Updates the CPSR
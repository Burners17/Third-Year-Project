; this is for initialising the kernal
;   Set up supervisor mode 
;   set up standardIn
;   set up interrupts 
;   set up user mode, enable interrupts  
; set up standardIn buffer 
; get address of reserved memory 
; initalise buffer 
; store buffer address 
kernal_Initial
    ; Set up supervisor mode  
        ;supervisor stack pointer 
    ADRL    SP, Supervisor_Stack_End

    ; Set up for interrupt mode 
        ; Switch to Interrupt Mode
    MRS     R0, CPSR                      ; Read Current Status of CPSR
    BIC     R0, R0, #System_Mode_Bit_Mask ; Clears Mode field of CPSR
    ORR     R0, R0, #IRQ_Mode             ; Append IRQ Mode to CPSR
    MSR     CPSR_c, R0                    ; Updates the CPSR

        ; Set Interrupt Stack Pointer
    ADRL    SP, Interrupt_Stack_End      ; Sets up Interrupt Stack Pointer

    ; Set up initial proccesses 
        ; Switch back to supervisor mode
    MRS     R0, CPSR                      ; Read Current Status of CPSR
    BIC     R0, R0, #System_Mode_Bit_Mask ; Clears Mode field of CPSR
    ORR     R0, R0, #Super_Mode           ; Append IRQ Mode to CPSR
    MSR     CPSR_c, R0                    ; Updates the CPSR

        ; Terminal Handler 
            ; which will set up StandardOut handler as well 
    ADRL    R0, Terminal_Handler_Process
    BL      Initialise_Process

         ; Idle_process for when there is nothing to do 
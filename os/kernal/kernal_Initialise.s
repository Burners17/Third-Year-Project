; this is for initialising the kernal
;   Disable interrupts 
;   Set up supervisor mode 
;   set up standardIn
;   set up interrupts 
;   set up user mode, enable interrupts  
; set up standardIn buffer 
; get address of reserved memory 
; initalise buffer 
; store buffer address 
kernal_Initial
    ; disable interrupts 
    MRS     R0, CPSR                      ; Read Current Status of CPSR
    ORR     R0, R0, #CPSR_Interupt_Enabled ; disables interrupts 
    MSR     CPSR_c, R0                    ; Updates the CPSR

    ; Set up supervisor mode  
        ;supervisor stack pointer 
    ADRL SP, Supervisor_Stack_End

    ; Set which interrupts are desired
    MOV     R0, #Base_Port_Area
    MOV     R1, #0 
    STRB    R1, [R0, #Interrupt_Alert_Offset]  ; removes any existing alerts 
    MOV     R1, #Interrupt_Desired                ; Sets R2 to 0 so that all execpt rxD interrupts are inactive
    STRB    R1, [R0, #Interrupt_Active_Offset]  ; Disables all active Interrupts    

    ; Initialise StandardIn Buffer 
    BL      standardIn_initialise

    ; Set up for interrupt mode 
        ; Switch to Interrupt Mode
    MRS R0, CPSR                      ; Read Current Status of CPSR
    BIC R0, R0, #System_Mode_Bit_Mask ; Clears Mode field of CPSR
    ORR R0, R0, #IRQ_Mode             ; Append IRQ Mode to CPSR
    MSR CPSR_c, R0                    ; Updates the CPSR

        ; Set Interrupt Stack Pointer
    ADRL SP, Interrupt_Stack_End      ; Sets up Interrupt Stack Pointer

    ; Set up user mode
        ; Switch to usermode and enable interrupt
        MOV R14, #&50 ; CPSR for user mode with interrupts enabled
        MSR SPSR, R14                    ; Updates the CPSR
        LDR R14, =User_Code_start
        MOVS PC, R14

standardIn_initialise
    PUSH    {R4, LR}
    ADRL     R0, StandardIn_start
    ADRL     R4, StandardIn_Address
    ; Stores starting address of StandardIn input a fixed place variable
    STR     R0, [R4]
    ; might be able to avoid by making StandardIn_Address EQU StandardIn_start
    MOV R1, #&40
    BL      buffer_initialise
    POP     {R4, PC}

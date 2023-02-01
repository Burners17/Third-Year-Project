B Initialise_Program  ; This Reset Exception
Undefined_Instruction B Undefined_Instruction ; Undefined Instruction cause a branch to here
B SVC_Handler         ; SVC calls jump to here and then go to the SVC Handler
Prefetch_Abort        B Prefetch_Abort ; If there is a Prefect Abort the PC come here
Data_Abort            B Data_Abort     ; If there is a Data Abort the PC jump here
Not_Provided_Except   B Not_Provided_Except ; Do not know why PC might jump here
; ---------------------------------------------------------
; Needs to be done
B IRQ_Handler         ; If and Interupt occurs PC jumps here.
Fast_Interrupt_Request B Fast_Interrupt_Request ; If a Fast Interrupt occurs, PC jumps here


Initialise_Program 
; code for setting up supervisor mode 
    ADRL  SP, Supervisor_Stack_End ; Sets up the Stack Pointer for Supervisor Mode
    BL StanIn_Initialise
; code for setting up Interrupt mode 
; Switch to Interrupt Mode
    MRS R0, CPSR                      ; Read Current Status of CPSR
    BIC R0, R0, #System_Mode_Bit_Mask ; Clears Mode field of CPSR
    ORR R0, R0, #IRQ_Mode             ; Append IRQ Mode to CPSR
    MSR CPSR_c, R0                    ; Updates the CPSR

    ; Set Interrupt Stack Pointer
    ADRL SP, Interrupt_Stack_End      ; Sets up Interrupt Stack Pointer

; Deactivates all interrupt alerts execpt when input from serial - prevents problems later on.
    MOV     R0, #Base_Port_Area
    MOV R1, #0 
    STRB R1, [R0, #Interrupt_Alert_Offset]  ; removes any existing alerts 
    MOV     R1, #0b0001_0000                ; Sets R2 to 0 so that all execpt rxD interrupts are inactive
    STRB    R1, [R0, #Interrupt_Active_Offset]  ; Disables all active Interrupts

; code for setting up user mode 
    MOV R14, #&50 ; CPSR for user mode with interrupts enabled
    ;BIC R14, R14, #CPSR_Interupt_Enabled ; Enables Interrupts
    MSR SPSR, R14                    ; Updates the CPSR
    LDR R14, =User_Code_start
    MOVS PC, R14

; SVC call handeler code 
; get file 
GET kernal_SVC_Handler.s 


; Interrupt handler 
; get file 
GET kernal_IRQ_Handler.s 

; Kernal Constants 
GET kernal_constants.s

; kernal memory. 
GET kernal_memory.s 
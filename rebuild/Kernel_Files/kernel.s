; This file is the main for the kernal 

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
B kernal_Initialise

GET     kernel_SVC_Handler.s
GET     kernel_IRQ_Handler.s

; Loads the Kernal_Initialise code 
GET     kernel_Initialise.s

; Loads Kernal Constants 
GET     kernel_constants.s 

; Loads Kernal Variables 
GET     kernel_variables.s

; Loads kernal predefined memeory 
GET     kernel_memory.s

GET     Kernel_Subroutines/Subroutines_main.s 
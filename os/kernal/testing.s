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

; SVC call handeler code 
; get file 
GET kernal_SVC_Handler.s 

GET kernal_buffer.s
; Kernal Predefined memory 
GET kernal_memory.s 

GET kernal_subroutines.s

GET kernal_data_structures.s

GET kernal_IRQ_Handler.s 

; Kernal initialiser 
GET kernal_Initialise.s
; Kernal Constants 
GET kernal_constants.s

Terminal_Handler_Process
    pointer_next    DEFW 0 
    proccess_id     DEFW 1
    proccess_stack_pointer DEFW 0 
    proccess_constructor DEFW Terminal_Handler_Constructor
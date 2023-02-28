; This is the start of the whole OS and the master File 

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
b kernal_Initialise

; Load Kernal Initialiser here 
GET kernal_Initialise.s

; Loads the SVC Handler Here 
;GET kernal_SVC_Handler.s 

; Load the IRQ Handler Here 
;GET kernal_IRQ_Handler.s 

; Load Kernal Constants here 
GET     kernal_memory.s 

; Load Kernal Data Structurs 
GET     kernal_data_structures.s

Get     ./process/process.s

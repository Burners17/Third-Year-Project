; this the the program which will handel inputs from Serial Line 
;

; initialise 
    ; Set up process Stack
Terminal_Handler_Constructor
    ADRL    SP, Terminal_Handler_Stack_End
    PUSH    {R0}
    ; Set up StandardIn buffer 
        ; Get addresses of where standardIn 
    ADRL    R0, StandardIn_start
    ADRL    R1, StandardIn_Address
        ; Store address of StandardIn in memory location 
    STR     R0, [R1]
    MOV     R1, #&40
    SVC     Buffer_Initial_SVC

    ; Set up reciever interrupt 
    MOV     R0, #Interrupt_Receiver
    SVC     Interrupt_Set_SVC
    

    ; Set up StandardOut buffer 
        ; Get addresses of where standardIn 
    ADRL    R0, StandardOut_start
    ADRL    R1, StandardOut_Address
        ; Store address of StandardOut in memory location 
    STR     R0, [R1]
    MOV     R1, #&40
    SVC     Buffer_Initial_SVC

    ; Set up Standard Out Handler Process
    ADRL    R0, StandOut_Handler_Process
    SVC     Initialise_Process_SVC

    ; Set up transimitter interrupt 
    MOV     R0, #Interrupt_Transmitter
    SVC     Interrupt_Set_SVC

    ; Return from end of handler 
    POP     {R0}
    SVC     Initialise_Process_Return_SVC
; Set up interrupt for reciever 

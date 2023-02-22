; Any predefine memory used by the kernal will be here for easy access

; Varibles 
    ; stores address of StandardIn Buffer 
    Serial_Reciever_Buffer_Address DEFS &16
    StandardIn_Address DEFS &16
    StandardOut_Address DEFS &16
        Align 

; Blocks of memeory 
    ; Stacks 
        Supervisor_Stack_Size   EQU &256
        Interrupt_Stack_Size    EQU &256
        StandardIn_Buffer_Size  EQU &256
        StandardIn_Buffer_Size  EQU &256
        Serial_Reciever_Buffer_Size EQU &265
            Align     ; Just in case size is not in base 2

        ; Supervisor Stack
        Supervisor_Stack_Start  DEFS Supervisor_Stack_Size ; Supervisor Stack
        Supervisor_Stack_End
            Align

        ; Interrupt Stack 
        Interrupt_Stack_Start   DEFS Interrupt_Stack_Size ; Interrupt Stack
        Interrupt_Stack_End
             Align

    ; Buffers 
        StandardIn_start DEFS StandardIn_Buffer_Size
        StandardIn_End 
            Align 

        StandardOut_start DEFS StandardOut_Buffer_Size
        StandardOut_End 
            Align 

        Serial_Reciever_Buffer_Start DEFS Serial_Reciever_Buffer_Size
        Serial_Reciever_Buffer_End
            Align 
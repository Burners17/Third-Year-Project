
; variable for different stacks 
Terminal_Handler_Stack_Size EQU &200
    Align 
Idle_Stack_Size EQU &20
    Align 
StandardIn_Buffer_Size      EQU &64
    Align
        ; Terminal Handler Stack 
        
        Terminal_Handler_Stack_Start   DEFS Terminal_Handler_Stack_Size ; Terminal_Handler Stack
        Terminal_Handler_Stack_End
             Align

        StandardIn_start DEFS StandardIn_Buffer_Size
        StandardIn_End 
            Align 

        Idle_Stack_Start   DEFS Idle_Stack_Size 
        Idle_Stack_End
             Align
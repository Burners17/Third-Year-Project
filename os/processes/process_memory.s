
; variable for different stacks 
Terminal_Handler_Stack_Size EQU &200

        ; Interrupt Stack 
        Terminal_Handler_Stack_Start   DEFS Terminal_Handler_Stack_Size ; Terminal_Handler Stack
        Terminal_Handler_Stack_End
             Align
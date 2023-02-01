; Any predefine memory used by the kernal will be here for easy access

Supervisor_Stack_Size EQU &256
Interrupt_Stack_Size  EQU &256

                    Align     ; Just in case size is not in base 2
; Supervisor Stack
Supervisor_Stack_Start  DEFS Supervisor_Stack_Size ; Supervisor Stack
Supervisor_Stack_End

                    Align
; Interrupt Stack 
Interrupt_Stack_Start   DEFS Interrupt_Stack_Size ; Interrupt Stack
Interrupt_Stack_End
                    Align

; This file includes all predefined memory used by the kernal 

; Stacks 
    Supervisor_Stack_Size   EQU &250
    Interrupt_Stack_Size    EQU &250
        Align 
    ; Supervisor Stack
    Supervisor_Stack_Start  DEFS Supervisor_Stack_Size ; Supervisor Stack
    Supervisor_Stack_End
        Align
    ; Interrupt Stack 
    Interrupt_Stack_Start   DEFS Interrupt_Stack_Size ; Interrupt Stack
    Interrupt_Stack_End
        Align
; Buffers 
    Serial_RxD_Buffer_Size  EQU &250
        Align 
    Serial_TxD_Buffer_Size  EQU &250
        Align 

    Serial_RxD_Buffer_Start DEFS Serial_RxD_Buffer_Size
    Serial_RxD_Buffer_End
        Align 

    Serial_TxD_Buffer_Start DEFS Serial_TxD_Buffer_Size
    Serial_TxD_Buffer_End
        Align
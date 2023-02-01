; Any predefine memory used by the kernal will be here for easy access

Supervisor_Stack_Size EQU &256
Interrupt_Stack_Size  EQU &256
StandardIn_Buffer_Size  EQU &256

                    Align     ; Just in case size is not in base 2
; Supervisor Stack
Supervisor_Stack_Start  DEFS Supervisor_Stack_Size ; Supervisor Stack
Supervisor_Stack_End

                    Align
; Interrupt Stack 
Interrupt_Stack_Start   DEFS Interrupt_Stack_Size ; Interrupt Stack
Interrupt_Stack_End
                    Align

; Standardin buffer #

StandardIn_Buffer_Head_Pointer DEFS &32

ALIGN
StandardIn_Buffer_Tail_Pointer DEFS &32

ALIGN
StandardIn_Buffer_Start DEFS StandardIn_Buffer_Size
StandardIn_Buffer_End

ALIGN

; sets up standard in buffer for use 
StanIn_Initialise
    PUSH {R0-R1, LR}
    ADRL R0, StandardIn_Buffer_Head_Pointer
    ADRL R1, StandardIn_Buffer_Start
    STR  R1, [R0]
    ADRL R0, StandardIn_Buffer_Tail_Pointer
    STR  R1, [R0]
    POP {R0-R1, PC}


; Place into buffer 
; input value come from R0 
StandIn_Place 
    PUSH {R1-R5, LR}
    ; get head and tail pointer locations 
    ADRL R1, StandardIn_Buffer_Head_Pointer
    LDR  R4, [R1]
    ADRL R1, StandardIn_Buffer_Tail_Pointer
    LDR  R5, [R1]

    ; check to see if tail is on next location 
    ADRL R1, StandardIn_Buffer_End
    CMP R4, R1
    BEQ XXXXX
    ; Check to see if tail is in word below
    SUB R1, R5, #&4
    CMP R1, R4 
    ; if not equal it can place, otherwise place request fails 
    STRNE R0, [R4]
    ADDNE R4, R4, #&4
    MOVNE R0, #&1
    MOVEQ R0, #&0
    ADRL R1, StandardIn_Buffer_Head_Pointer
    STR  R4, [R1]
    POP {R1-R5, PC}

    XXXXX ; means that head of tail is at the bottom 
    ; Check if tail it at top 
    ADRL R1, StandardIn_Buffer_Start
    CMP R5, R1 
    STRNE R0, [R4]
    MOVNE R0, #&1
    MOVEQ R0, #&0
    ADRL R1, StandardIn_Buffer_Head_Pointer
    STR  R4, [R1]
    POP {R1-R5, PC}

StandIn_Get
    PUSH {R2-R6, LR}
    ; get head and tail pointer locations 
    ADRL R1, StandardIn_Buffer_Head_Pointer
    LDR  R4, [R1]
    ADRL R1, StandardIn_Buffer_Tail_Pointer
    LDR  R5, [R1]

    CMP R4, R5
    MOVEQ R1, #&0
    MOVNE R1, #&1
    LDRNE R0, [R5]
    ADDNE R5, R5, #&4
    ADRL R6, StandardIn_Buffer_Tail_Pointer
    STR  R5, [R6]
    POP{R2-R6, PC}



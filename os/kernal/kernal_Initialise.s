
; set up standardIn buffer 
; get address of reserved memory 
; initalise buffer 
; store buffer address 
kernal_Initial
    PUSH    {R4, LR}
    ADRL     R0, StandardIn_start
    ADRL     R4, StandardIn_Address
    ; Stores starting address of StandardIn input a fixed place variable
    STR     R0, [R4]
    ; might be able to avoid by making StandardIn_Address EQU StandardIn_start
    MOV R1, #&40
    BL      buffer_initialise
    POP     {R4, PC}
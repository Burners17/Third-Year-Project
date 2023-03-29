; this file contains the libary functions malloc and free 

; This function is used by a user process to reserve memory 
; Inputs 
;   R0 - pointer to list of free memory 
;   R1 - Amount of memeory requested in words 
malloc 
    PUSH    {R4-R8,LR} 
    ; Check if a list of free memeory was provided 
    MOV R4, #0 
    CMP R0, R4 
    ;BEQ 

    POP     {R4-R8, PC}

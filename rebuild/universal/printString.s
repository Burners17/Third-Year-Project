;this file contains the print string function 
; it take the following inputs 
; R1 is the string to be printed 
; and returns the following outputs 

; Working Registers 
; R4 is the pointer to the character to be printed 


printString 
    PUSH    {R4, LR}
    MOV     R4, R1

printStringLoop 
    LDRB    R0, [R4]!   ; Get next character to be printed 
    CMP     R0, #0 
    BEQ     print_String_Complete     ; Return to printString Call and restores Registers to before call
printCharLoop
    SVC     Print_String_SVC        ; needs to be implemented 
    CMP     R1, #0          ; loops incase LCD is not ready 
    BNE     printCharLoop  
    CMP     R2, #0          ; occurs when a print was unsucessful, perhase due to ownership issues
    BEQ     printFailed
    B       printStringLoop

printFailed
    B printFailed

print_String_Complete
    SVC     Release_LCD_SVC
    POP     {R4, PC}

; print char svc will check if the LCD is ready and if so print otherwise it will return 
; This file contains the function responsible for accessing the peripherals on the Lab board 

; variables 

LCD_Owner DEFW 0

SVC_printChar
    PUSH    {R4,R5, LR}
    MOV     R2, #0
    ; code to check if the LCD is reserved 
    ADRL    R4, LCD_Owner
    LDR     R4, [R4]
    CMP     R4, #0
    ; if not reserve it 
    BEQ     Reserve_LCD
    ; check if the proccess has reserved the LCD 
    ADRL    R5, current_process
    LDR     R5, [R5]
    CMP     R4, R5
    BNE     LCDInUse

    ; else return failure to print 
printChar_Status
    ; check if LCD is ready 
    ; Set LCD to get ready state of LCD 
    MOV     R4, #Port_Area
    LDRB    R5, [R4, #Port_B]
    BIC     R5, R5, #RS_Bit      ; Sets Port_A In/Out to control Register
    ORR     R5, R5, #RW_Bit      ; Sets to Read from LCD
    BIC     R5, R5, #LED_On
    STRB    R5, [R4, #Port_B]     ; Sends updated instructions to Port_B

    ; Set E High  
    LDRB    R5, [R4, #Port_B]     ; Gets value of Port_B and stores it in R4
    ORR     R5, R5, #E_En         ; Sets LCD Enable Bus high
    STRB    R5, [R4, #Port_B]     ; Sends updated instructions to Port_B

    ; Get status of LCD 
    LDRB    R5, [R4, #Port_A]     ; Get Status of LCD
    AND     R5, R5, #LCD_Ready_Status      

    ; set E Low 
    LDRB    R5, [R4, #Port_B]     ; Gets value of Port_B and stores it in R4
    BIC     R5, R5, #E_En         ; Sets LCD Enable Bus high
    AND     R5, R5, #LED_On
    STRB    R5, [R4, #Port_B]     ; Sends updated instructions to Port_B

    ; if not return waiting loop 
    CMP     R5, #0
    MOVNE   R1, #1
    LDMNEFD SP!, {R4-R5, PC}
    ; if ready 

    ; print char
printChar_s
    ; Save state of current LEDS 
    PUSH    {R6,R7} 
    LDRB    R6, [R4, #Port_A]


    ; get LCD ready to recieve char
    LDRB    R5, [R4, #Port_B]
    MOV     R7, R5              ; Saves state of interface before sending char
    ORR     R5, R5, #RS_Bit      ; Sets Port_A In/Out to control Register
    BIC     R5, R5, #LED_On
    BIC     R5, R5, #RW_Bit      ; Sets to Read from LCD
    STRB    R5, [R4, #Port_B]     ; Sends updated instructions to Port_B
    ; Sent Character to be sent 
    STRB    R0, [R4, #Port_A]     ; send character to LCD

    ; Pluse E_En
    ; Set E High  
    LDRB    R5, [R4, #Port_B]     ; Gets value of Port_B and stores it in R4
    ORR     R5, R5, #E_En         ; Sets LCD Enable Bus high
    STRB    R5, [R4, #Port_B]     ; Sends updated instructions to Port_B

    ; set E Low 
    LDRB    R5, [R4, #Port_B]     ; Gets value of Port_B and stores it in R4
    BIC     R5, R5, #E_En         ; Sets LCD Enable Bus LOW
    STRB    R5, [R4, #Port_B]     ; Sends updated instructions to Port_B
    ; Restore state of interface and LEDS if they had been set
    STRB    R6, [R4, #Port_A]
    STRB    R7, [R4, #Port_B]
    MOV     R1, #0
    MOV     R2, #0
    POP     {R4-R7,PC} 


Reserve_LCD
    ADRL    R4, LCD_Owner
    ADRL    R5, current_process
    LDR     R5, [R5]
    STR     R5, [R4]
    B printChar_Status


LCDInUse
    MOV     R2, #1 
    POP     {R4,R5, LR}

; Function 2 
; send something to a peripheral 

Release_LCD_Ownership 
    ; this function releases the ownership of the lcd 
    PUSH    {R4, R5, LR}
    ; first it checks that this process is the current owner of the LCD 
    ADRL    R4, LCD_Owner 
    LDR     R4, [R4]
    ADRL    R5, current_process
    LDR     R5, [R5]    
    CMP     R4, R5      ; make sure current process is the owner 
    MOVNE   R0, #1
    LDMNEFD SP!, {R4-R5, PC} 
    ADRL    R4, LCD_Owner
    MOV     R5, #0 
    STR     R5, [R4]
    POP     {R4, R5, PC}

Peripheral 


; this file contains the supervsior level function needed to drive the LEDS 

LED_Owner DEFW 0

Set_LED 
    ;Check owenership of LEDS 
    PUSH    {R4, R5, LR}
    ADRL    R4, LED_Owner
    LDR     R4, [R4]
    CMP     R4, #0
    ; if not reserve it 
    BEQ     Reserve_LED
    ; check if the proccess has reserved the LCD 
    ADRL    R5, current_process
    LDR     R5, [R5]
    CMP     R4, R5
    BNE     LEDInUse

Set_LED_Main
    PUSH    {R6}
    MOV     R4, #Port_Area
    LDR     R5, [R4, #Port_B]

    ; Enable LEDs 
    AND     R5, R5, #LED_On
    STR     R5, [R4, #Port_B]
    ; update LEDS 
    LDR     R6, [R4]
    AND     R6, R6, R0 
    EOR     R6, R6, R1
    STR     R6, [R4, #Port_A]
    POP     {R4, R5, R6, PC}

Reserve_LED
    ADRL    R4, LCD_Owner
    ADRL    R5, current_process
    LDR     R5, [R5]
    STR     R5, [R4]
    B       Set_LED_Main
LEDInUse  
    MOV     R2, #1
    POP     {R4, R5, PC}
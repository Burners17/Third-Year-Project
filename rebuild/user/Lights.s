; This file is for using the LEDS 
Lights_Handler_Constructor
; set up stack 
ADRL    SP, Lights_Stack_End

; set and LED 

    MOV     R0, #0 
    MOV     R1, #0b0010_0010
    SVC     LED_SVC

lights_loop B lights_loop

; loop in place 
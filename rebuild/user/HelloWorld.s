; This file is used to print the hello world statement to the LCD 

string      DEFB  'He12o Wor3d!',0
            align


HelloWorld_Handler_Constructor
; set up stack 
ADRL    SP, HelloWorld_Stack_End

; set and LCD 
ADRL    R1, string
BL      printString 

HelloWorld_Loop B HelloWorld_Loop


; loop in place 
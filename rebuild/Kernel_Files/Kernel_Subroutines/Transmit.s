; This SVC will send what is requested to Serial Transmitter 
; 

; load control to see if transmitter internal buffer is full 

Transmit_word 
    PUSH    {R1-R6, LR} 
    MOV     R5, #Port_Area
    MOV     R6, #Terminal_Control
    LDR     R1, [R5, R6] 
    TST     R1, #2
   ; if EQ then hardware buffer is full 
    BNE     Transmit_word_send
    MOV     R1, R0 
    ADRL    R0, Serial_TxD_Buffer_Address
    BL      buffer_put
    MOV     R0, #Interrupt_Transmit 
    BL      Interrupt_Set    
    POP     {R1-R6, PC} 

Transmit_word_send
    MOV     R6, #Terminal_Data
    STR     R0, [R5, R6]
    POP     {R1-R6, PC}     
; if full place on buffer 
; activate interrupt


 

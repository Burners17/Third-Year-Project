; Terminal Handler Process 
; This process handles intake from the terminal and determines how to respond

;   Register Index 
    ; R9  Holds last input character 
    ; R10 is used to tell the process if it an echo input or not 1 is echo 0 is not echo 
    ; R11 is used to store address of RxD buffer start  
    ; R12 is used to store address of buffer start 


Terminal_Handler_Constructor
; Constructor 
 ; Set up Stack pointer 
    ADRL    SP, Terminal_Handler_Stack_End

 ; Set up Buffer to store input from buffer 
    ADRL    R12, StandardIn_start
 ; Saves memeory address to process register 
    MOV     R0, R12
    MOV     R1, #StandardIn_Buffer_Size
    BL      buffer_initialise

;
; Main 
 ; Set up Constants 
  ADRL    R11, Serial_RxD_Buffer_Address 
  LDR     R11, [R11]
  MOV     R10, #1   ; Boolean for echo 
    ;MOV     R10, #Terminal_Control
    ;MOV     R9, #Terminal_Data

 ;
 ; Second it needs to handler what happens when it is called 
Terminal_Handler_Main_Loop
  ; Requests control of RxD and TxD 
  ; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  ; 
  ; Check if there is anything in the RxD Buffer 
    MOV     R0, R11 
    BL      buffer_get
    CMP     R0, #&0
    BEQ     Terminal_Handler_Main_Loop
    
    ; Check if the input is an Enter
    CMP     R0, #&A
    BEQ     Terminal_Handler_Commands
    MOVNE   R9, R0

  ; Check if in protected mode 
    CMP     R10, #1
    BLEQ     Transmit 
  ;

    ;   if it is an enter check if it is a known command 
	; Checks if it has recieved a input from the serie line 

    ; Checks to see what the input is and if it shoudl do anyting 
    ;   if it is enter it checks what it needs to do 
    ; Places input into StandardIn Buffer 
    ; Checks to see if it is in echo to terminal mode or not 
    ;   If it is it send it to TxD Buffer 
    MOV   R9, R0
  B Terminal_Handler_Main_Loop
Transmit 
;B     Terminal_Handler_Main_Loop
; This function is responsible for transmitting 
  SVC   Transmit_SVC
  B     Terminal_Handler_Main_Loop
Terminal_Handler_Commands
    ; This function will check input against commands 
    CMP   R9, #1 
    BEQ   printHello
    
    CMP   R9, #2
    BEQ   LED_Show

    MOV   R9, #0 
    B     Terminal_Handler_Main_Loop

printHello  
    ADRL  R0, HelloWorld_Handler_Process 
    SVC   Start_Process_SVC
    MOV   R9, #0 
    B     Terminal_Handler_Commands

LED_Show    
    ADRL  R0, Lights_Handler_Process
    SVC   Start_Process_SVC
    MOV   R9, #0 
    B     Terminal_Handler_Commands


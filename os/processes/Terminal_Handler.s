; Terminal Handler Process 

;   Register Index 
    ; R8 is used to tell the process if it an echo input or not 1 is echo 0 is not echo
    ; R9 is used to store #Terminal Data offset 
    ; R10 is used to store #Terminal control offset 
    ; R11 is used to store port area 
    ; R12 is used to store address of buffer start 

; First it needs a constructor 
    ; It requries 
        ; Buffer to place content of recievcer 
        ; buffer to store content of reciever 
        ; buffer to send things that should be sent to serial transmitter 
        ; It up stack pointer 



Terminal_Handler_Constructor
; Constructor 
 ; Set up Stack pointer 
    ADRL    SP, Terminal_Handler_Stack_End

 ; Set up Buffer to store input from buffer 
    ADRL    RO, StandardIn_start
    ADRL    R12, StandardIn_Address
 ; Store address of StandardIn in memory location 
    STR     R0, [R12]
    MOV     R1, #&40
    SVC     Buffer_Initial_SVC

 ; Request that Interrupt for when something is received in RxD 
    ; Set up reciever interrupt 
    MOV     R0, #Interrupt_Receiver
    SVC     Interrupt_Set_SVC

 ; Set up done, it returns to process set up 

;
; Main 
 ; Set up Constants 
    MOV     R11, #Port_Area   
    MOV     R10, #Terminal_Control
    MOV     R9, #Terminal_Data
    MOV     R8, #1
 ;
 ; Second it needs to handler what happens when it is called 
Terminal_Handler_Main_Loop
  ; Requests control of RxD and TxD 
  ; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  ; 
  ; Check if there is anything in the RxD Buffer 
    LDR     R0, [R11, R10]
    TST     R0, #1
    BEQ     Terminal_Handler_Main_Loop

  ;
  ; load from RxD 
    LDR     R0, [R11, R10]
  ;
  ; Check if in protected mode 
    CMP     R8, #1
    BLEQ     Transmit 
  ;
  ; Check if the input is an Enter
    CMP     R0, #&A
    BEQ     Terminal_Handler_Commands
    ;   if it is an enter check if it is a known command 
	; Checks if it has recieved a input from the serie line 

    ; Checks to see what the input is and if it shoudl do anyting 
    ;   if it is enter it checks what it needs to do 
    ; Places input into StandardIn Buffer 
    ; Checks to see if it is in echo to terminal mode or not 
    ;   If it is it send it to TxD Buffer 

Transmit 
; This function is responsible for transmitting 

Terminal_Handler_Commands
    ; This function will check input against commands 

Terminal_Handler_Commands_Table 
                                DEFW Command_Echo
Terminal_Handler_Commands_Table_End

Command_Echo DEFB "echo",0

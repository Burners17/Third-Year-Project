; This program will set up the Operating systems 
; It will 
;   Set up Supervisor mode
;       Set Stack pointer  
;   Set up Interrupt mode 
;       Set up anything required by the interrupts 
;       Set Stack pointer

kernal_Initialise

; Set up Supervisor 
 ; Set up Stack pointer 
  ADRL    SP, Supervisor_Stack_End

; Set up Interrupt Mode 
 ; Set up anything required or used by interrupts 
  ; RxD Interrupt 
   ; This interrupt requires a buffer to place things into 
    ; Get address of buffer and store it in a know variable 
    ADRL    R0, Serial_RxD_Buffer_Start
    ADRL    R1, Serial_RxD_Buffer_Address
    STR     R0, [R1]
    ; Initialise the buffer 
    MOV     R1, #&40
    BL      buffer_initialise
    MOV     R1, #5
    BL      buffer_put
    MOV     R1, #0 
    BL      buffer_get        
    
  ; TxD Interrupt 
   ; Buffer it uses
    ; Get address of buffer and store it in a know variable 
    ADRL    R0, Serial_TxD_Buffer_Start
    ADRL    R1, Serial_TxD_Buffer_Address
    STR     R0, [R1]
    ; Initialise the buffer 
    MOV       R1, #&40
    BL        buffer_initialise   
  ; 
  ; Timer Interrupt 
  ; NA 
; Switch Mode to Interupt mode 
    MRS     R0, CPSR                      ; Read Current Status of CPSR
    BIC     R0, R0, #System_Mode_Bit_Mask ; Clears Mode field of CPSR
    ORR     R0, R0, #IRQ_Mode             ; Append IRQ Mode to CPSR
    MSR     CPSR_c, R0                    ; Updates the CPSR
 ;
 ; Set up Interrupt Stack Pointer
    ADRL    SP, Interrupt_Stack_End      ; Sets up Interrupt Stack Pointer

; Most likely redundant
 ; Return to Supervisor Mode 
    MRS     R0, CPSR                      ; Read Current Status of CPSR
    BIC     R0, R0, #System_Mode_Bit_Mask ; Clears Mode field of CPSR
    ORR     R0, R0, #Super_Mode           ; Append Supervisor Mode to CPSR
    MSR     CPSR_c, R0                    ; Updates the CPSR
 ;
;
; Initialise first process which is always terminal handler 
   ADRL     R0, Terminal_Handler_Process
   LDR      R14, [R0, #process_constructor]
   MOV      R0, #&50
   MSR      SPSR, R0 
   MOVS     PC, R14 
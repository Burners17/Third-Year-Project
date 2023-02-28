; This is the Operating System Initialiser 
; It will do the following 
;   Set Up Supervisor Mode 
;   Set Up Interrupt Mode 
;   Initialise First Process 

kernal_Initialiser 

; Setting up Supervisor Mode 
    ADRL    SP, Supervisor_Stack_End
;
; Setting Up Interrupt Mode 
 ; Set up Data Structures used by Interrupts 
  ; RxD Interrupt 
   ; Buffer it uses
    ; Get address of buffer and store it in a know variable 
    ADRL    R0, Serial_RxD_Buffer_Start
    ADRL    R1, Serial_RxD_Buffer_Address
    STR     R0, [R1]
    ; Initialise the buffer 
    MOV       R1, #&40
    BL        Buffer_Initial_SVC   
   ;
  ; TxD Interrupt 
   ; Buffer it uses
    ; Get address of buffer and store it in a know variable 
    ADRL    R0, Serial_TxD_Buffer_Start
    ADRL    R1, Serial_TxD_Buffer_Address
    STR     R0, [R1]
    ; Initialise the buffer 
    MOV       R1, #&40
    BL        Buffer_Initial_SVC   
  ; 


;
 ; 
 ; Switch Mode to Interupt mode 
    MRS     R0, CPSR                      ; Read Current Status of CPSR
    BIC     R0, R0, #System_Mode_Bit_Mask ; Clears Mode field of CPSR
    ORR     R0, R0, #IRQ_Mode             ; Append IRQ Mode to CPSR
    MSR     CPSR_c, R0                    ; Updates the CPSR
 ;
 ; Set up Interrupt Stack Pointer
    ADRL    SP, Interrupt_Stack_End      ; Sets up Interrupt Stack Pointer
 ;
 ; Return to Supervisor Mode 
    MRS     R0, CPSR                      ; Read Current Status of CPSR
    BIC     R0, R0, #System_Mode_Bit_Mask ; Clears Mode field of CPSR
    ORR     R0, R0, #Super_Mode           ; Append Supervisor Mode to CPSR
    MSR     CPSR_c, R0                    ; Updates the CPSR
 ;
;

; Initialise first process which is always terminal handler 
   ADRL     R0, Terminal_Handler_Process
   LDR      R14, [R0, #proccess_constructor]
   MOV      R0, #&50
   MSR      SPSR, R0 
   MOVS     PC, R14 


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
    ADRL    R1, Serial_RxD_Buffer_Size
    LDR     R1, [R1]
    BL      buffer_initialise

  ; TxD Interrupt 
   ; Buffer it uses
    ; Get address of buffer and store it in a know variable 
    ADRL    R0, Serial_TxD_Buffer_Start
    ADRL    R1, Serial_TxD_Buffer_Address
    STR     R0, [R1]
    ; Initialise the buffer 
    ADRL    R1, Serial_TxD_Buffer_Size
    LDR     R1, [R1]
    BL      buffer_initialise   
  ; 
  ; Timer Interrupt 
  ; Get current timer time 
  ; Add 200 to it 
  ; 
   LDRB R1, [R0, #Interrupt_Timer_Offset]
   ADD  R1, R1, #Interrupt_Time_Interval
   STRB R1, [R0, #Interrupt_Timer_Offset]
; Switch Mode to Interupt mode 
    MRS     R0, CPSR                      ; Read Current Status of CPSR
    BIC     R0, R0, #System_Mode_Bit_Mask ; Clears Mode field of CPSR
    ORR     R0, R0, #IRQ_Mode             ; Append IRQ Mode to CPSR
    MSR     CPSR_c, R0                    ; Updates the CPSR
 ;
 ; Set up Interrupt Stack Pointer
    ADRL    SP, Interrupt_Stack_End      ; Sets up Interrupt Stack Pointer
   MOV      R0, #Interrupt_Desired
   BL       Interrupt_Set
; Most likely redundant
 ; Return to Supervisor Mode 
    MRS     R0, CPSR                      ; Read Current Status of CPSR
    BIC     R0, R0, #System_Mode_Bit_Mask ; Clears Mode field of CPSR
    ORR     R0, R0, #Super_Mode           ; Append Supervisor Mode to CPSR
    MSR     CPSR_c, R0                    ; Updates the CPSR
 ;
;
;  clear shedule list 
   ADRL     R0, sheduler_ready_list_start
   MOV      R1, #0
   STR      R1, [R0] 
; Initialise first user process which is always terminal handler 
   ADRL     R0, Terminal_Handler_Process
   ADRL     R1, current_process
   STR      R0, [R1]
   ;ADRL     R0, HelloWorld_Handler_Process 
   LDR      R14, [R0, #process_constructor]
   ; No need to preserve flags so this makes it easier
   MOV      R0, #User_Mode_With_Int
   MSR      SPSR_c, R0 
   MOVS     PC, R14 
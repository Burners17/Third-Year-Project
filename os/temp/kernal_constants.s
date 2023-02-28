; Constants used by the kernal are define here for easy access and maintance 

; SVC Names 
Buffer_Initial_SVC      EQU &0 
Buffer_GET_SVC          EQU &4
Buffer_Put_SVC          EQU &8
Interrupt_Set_SVC       EQU &C 
Interrupt_Off_SVC       EQU &10
Initialise_Process_SVC  EQU &14
Initialise_Process_Return_SVC EQU &18
;Sheduler_Add_SVC        EQU 
;Sheduler_Remove_SVC     EQU 
;Sheduler_Next_SVC       EQU 

; Constants used for initialse and changing user mode
    User_Mode   EQU &10         ; User Mode
    IRQ_Mode    EQU &12         ; Interrupt Mode
    Super_Mode  EQU &13
    System_Mode_Bit_Mask EQU &1F ; Used to clear the are that determines system mode
    CPSR_Interupt_Enabled EQU 0b1000_0000   ; Bit responsible for whether or not Interrupts are Enabled


    Base_Port_Area  EQU &10000000   ; Defines I/O Base port area

    Interrupt_Alert_Offset      EQU &18
    Interrupt_Active_Offset     EQU &1C
    Interrupt_Receiver          EQU 0b0001_0000
    Interrupt_Transmitter       EQU 0b0010_0000 
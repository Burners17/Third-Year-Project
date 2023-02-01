; Constants used by the kernal are define here for easy access and maintance 

; Constants used for initialse and changing user mode
    User_Mode   EQU &10         ; User Mode
    IRQ_Mode    EQU &12         ; Interrupt Mode
    System_Mode_Bit_Mask EQU &1F ; Used to clear the are that determines system mode
    CPSR_Interupt_Enabled EQU 0b1000_0000   ; Bit responsible for whether or not Interrupts are Enabled


    Base_Port_Area  EQU &10000000   ; Defines I/O Base port area

    Interrupt_Alert_Offset EQU &18
    Interrupt_Active_Offset EQU &1C
    Interrupt_Desired       EQU 0b0001_0000
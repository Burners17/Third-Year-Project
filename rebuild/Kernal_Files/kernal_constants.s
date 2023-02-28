; This file holds all of the constants used by the kernal
; Constants for diffe
IRQ_Mode                    EQU &12         ; Interrupt Mode
Super_Mode                  EQU &13         ; Supervisor Mode
System_Mode_Bit_Mask        EQU &1F ; Used to clear the are that determines system mode
Interrupt_Receiver          EQU 0b0001_0000
Interrupt_Transmit          EQU 0b0010_0000
Interrupt_Alert_Offset      EQU &18
Port_Area                   EQU &10000000
Interrupt_Active_Offset     EQU &1C
Interrupt_Receiver          EQU 0b0001_0000

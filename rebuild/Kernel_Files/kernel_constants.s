; This file holds all of the constants used by the kernal
; Constants for diffe
IRQ_Mode                    EQU &12         ; Interrupt Mode
Super_Mode                  EQU &13         ; Supervisor Mode
System_Mode_Bit_Mask        EQU &1F ; Used to clear the are that determines system mode
User_Mode_With_Int          EQU &50

Interrupt_Alert_Offset      EQU &18
Port_Area                   EQU &10000000


; Interrupt bits 
Interrupt_Receiver          EQU 0b0001_0000
Interrupt_Transmit          EQU 0b0010_0000
Interrupt_Active_Offset     EQU &1C
Interrupt_Timer_Offset      EQU &0C ; This location holds the value at which the Interrupt will trigger when the timer reaches

Interrupt_Time_Interval     EQU &64 ; time gap for interrupts to occur
; This file holds all of the constants used by the kernal
; Constants for diffe
IRQ_Mode                    EQU &12         ; Interrupt Mode
Super_Mode                  EQU &13         ; Supervisor Mode
System_Mode_Bit_Mask        EQU &1F ; Used to clear the are that determines system mode
User_Mode_With_Int          EQU &50

; SVC call Constants 
Print_String_SVC            EQU &0 
Release_LCD_SVC             EQU &4
LED_SVC                     EQU &8 
Transmit_SVC                EQU &C
Start_Process_SVC           EQU &10
;EQU &0 
;EQU &4
;EQU &8
;EQU &C 
;EQU &10
;EQU &14
Port_Area                   EQU &10000000
Port_A                      EQU &0 
Port_B                      EQU &4

; LCD constants 
RS_Bit                      EQU 0B0000_0010
RW_Bit                      EQU 0B0000_0100
E_En                        EQU 0B0000_0001
LCD_Ready_Status            EQU 0B1000_0000
LED_On                      EQU 0B0001_0000

; Interrupt bits 
Interrupt_Receiver          EQU 0b0001_0000
Interrupt_Transmit          EQU 0b0010_0000
Interrupt_Desired           EQU 0b0011_000
Interrupt_Active_Offset     EQU &1C
Interrupt_Alert_Offset      EQU &18
Interrupt_Timer_Offset      EQU &0C ; This location holds the value at which the Interrupt will trigger when the timer reaches

Interrupt_Time_Interval     EQU &64 ; time gap for interrupts to occur
; rewrote the controls to make them come back to the master routine and added clear screen 

; R0 -R3 Argument values passed to a subroutine and results returned from a subroutine
; R4 - R11 Local Variables
; R12 - unknown purpose
; R13 - Stack pointer
; R14 Link register
; R15 is program

; States
; state 1  - this is the waiting state that waits for the LCD to be ready so no
;            characters are skipped


; defined constants
Port_Area   EQU &10000000
Port_A      EQU &0
Port_B      EQU &4
Led_Dis     EQU 0B1110_1111 ; Use AND to apply this
E_En        EQU 0B0000_0001 ; Use OR to apply this
LCD_status  EQU 0B1000_0000 ; Use AND to isolate the LCD status Bye

; branch to avoid unknown instruction for cpu
            B main

; string
string      DEFB  'Hello World!',0
            align

main
            MOV R0, #Port_Area  ; defines port area to be used by the program
            ADR SP, stack_end   ; sets up the stack pointer to be used
            BL dis_LED          ; disables LEDs on the board

            BL clear_LCD        ; clears LCD
            ADR R1, string      ; loads the address of the string to be printed into R1
            BL printString      ; Print string at address loaded into R1
            B End               ; End point of program, send it into infinite loop

dis_LED     ; disable LEDs
            LDRB R4, [R0, #Port_B] ; disable LEDs
            AND R4, R4, #Led_Dis
            STRB R4, [R0, #Port_B]
            MOV PC, LR


clear_LCD   ; this is to clear the current from the screen
            ; Register bank
            ; R0  passes the port area into the sub routines of the print loop
            ; R2  passed the character to be printed from printLoop to sub-subroutine print
            ; R7 Temporarily used to hold the LR in printString while i get stack to work
            MOV R7, LR
            ; set ports to send to control registers
            LDRB R5, [R0, #Port_B]    ; loads current value of port B into R5
            AND R5, R5, #0B1111_1001  ; this sets R/W and RS low
            STRB R5, [R0, #Port_B]    ; send instruction to LCD
            MOV R2, #&01
            BL clear
            MOV PC, R7


printString ; this is the control logic for the printing characters
            ; Register bank
            ; R0  passes the port area into the sub routines of the print loop
            ; R1  passed the address of the string to be printed to the printString subroutine
            ; R2  passed the character to be printed from printLoop to sub-subroutine print

            ; R4  used as a pointer to character to be printed in string
            ; R7 Temporarily used to hold the LR in printString while i get stack to work

            ; saves Registers that could be changed
            ;PUSH {R14}
            MOV R7, LR ; quick and dirty way of saving the LR
            ; setting variables to be used by subroutine
            MOV R4, #0        ; sets string character pointer to 0

            ; execute code
printLoop   LDRB R2, [R1, R4] ; loads the next character into the string
            ADD R4, R4, #1    ; increments R4, character pointer by one
            CMP R2, #0        ; this check if the end of the string has been reached

            BEQ PS_finished
            ;LDMEQFD SP, {PC}  ; printing is finished and will now return to where it was called
            BL wait           ; call the wait sub-routine
            BL print          ; call the print sub-routine
            B printLoop       ; returns to the top of the execute code for PS

PS_finished
            ;POP {PC}
            MOVEQ PC, R7


wait ; the waiting state for the LCD to be ready for the next char
            ; Register bank
            ; R0  passes the port area into the sub routines of the print loop
            ; R5  used to LD value of Port_B and then manipulate it and ST it back
            ; R6  used to LD value of Port_A for use by routine

            ; step 1 set controls
            LDRB R5, [R0, #Port_B]    ; loads current value of port B into R5
            AND R5, R5, #0B1111_1101  ; this sets RS low
            ORR R5, R5, #0B0000_0100  ; this sets R/W high
            STRB R5, [R0, #Port_B]    ; this send the changed signals back to the LCD to change its behaviour

            ; step 2 enable bus
step2       LDRB R5, [R0, #Port_B]    ; loads current value of port B into R5
            ORR R5, R5, #E_En         ; sets E high therefore interface active
            STRB R5, [R0, #Port_B]    ; sends instruction to LCD Port B

            ; step 3 read LCD status
            LDRB R6, [R0, #Port_A]    ; loads value of Port A to R6
            AND R6, R6, #LCD_status   ; strips all but the LCD status byte

            ; step 4 disable bus
            LDRB R5, [R0, #Port_B]    ; loads current value of port B into R5
            BIC R5, R5, #E_En         ; sets E low therefore Interface inactive
            STRB R5, [R0, #Port_B]    ; sends instruction to LCD Port B

            ; step 5 check status of LCD and take appropriate action
            CMP R6, #0                ; checks if R6 is 0 and therefore LCD is idle
            MOVEQ PC, LR              ; return if LCD is idle to where it was called
            B step2                   ; else repeat from step 2 until LCD is idle

print       ; Write a character to the LCD
            ; Register bank
            ; R0  passes the port area into the sub routines of the print loop
            ; R2  character to be printed by routine passed by printString routine
            ; R5  used to LD value of Port_B and then manipulate it and ST it back

            ; step 6, set to write data
            LDRB R5, [R0, #Port_B]    ; loads current value of port B into R5
            AND R5, R5, #0B1111_1011  ; this sets R/W low
            ORR R5, R5, #0B0000_0010  ; this sets RS high
            STRB R5, [R0, #Port_B]    ; send instruction to LCD

clear       ; step 7 Output desired byte onto data bus, Port A

            STRB R2, [R0, #Port_A]    ; send character to LCD

            ; step 8 enable - copy of step 2
            LDRB R5, [R0, #Port_B]    ; loads current value of port B into R5
            ORR R5, R5, #E_En         ; sets E high therefore interface active
            STRB R5, [R0, #Port_B]    ; sends instruction to LCD Port B

            ; step 9 disable bus - copy  of step 4
            LDRB R5, [R0, #Port_B]    ; loads current value of port B into R5
            BIC R5, R5, #E_En         ; sets E low therefore Interface inactive
            STRB R5, [R0, #Port_B]    ; sends instruction to LCD Port B

            MOV PC, LR ; return to where print was called


End         B End ; infinite loop so the PC does not infinitely increment
            B End
; stack
stack       DEFS 100
stack_end
; change log

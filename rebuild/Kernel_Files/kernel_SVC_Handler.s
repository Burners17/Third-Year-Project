SVC_Handler PUSH  {R4-R5, LR}
            LDR   R4, [LR, #-4] ; Read the SVC Instruction from the LR
            BIC   R4, R4, #&FF000000 ; Masks off the Operation Code from SVC Call
            CMP   R4, #SVC_Jump_Table_Size ; Checks that the Operation Code is defined.
            BHI   SVC_Out_Of_Bounds   ; Jumps to this Location If the SVC Calls is out of bounds
            ADR   R5, SVC_Jump_Table  ; Loads SCV Jump Table Start Address into R5
            ADD   LR, PC, #&0         ; Loads LR with end of handler, which handles return to SVC Calls
            LDR   PC, [R5, R4]        ; Loads the PC with the address of the function being called
            POP   {R4-R5, LR}         ; Restores Registers and Loads Return Address into LR
            MOVS  PC, LR              ; Restores CSPR code and moves PC to call address

SVC_Jump_Table_Size EQU SVC_Jump_Table_End - SVC_Jump_Table
SVC_Jump_Table      DEFW SVC_printChar
                    DEFW Release_LCD_Ownership
                    DEFW Set_LED 
                    DEFW Transmit_word
                    DEFW Shedule_Add 
                    ;DEFW Initialise_Process
                    ;DEFW Initialise_Process_Return
SVC_Jump_Table_End

SVC_Jump_Table_place_holder

; SVC Call Out of Bounds
SVC_Out_Of_Bounds   B   SVC_Out_Of_Bounds ; SVC call out of bounds
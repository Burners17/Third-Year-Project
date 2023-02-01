; currently set up for only possible interrupt

IRQ_Handler 
    SUB LR, LR, #4 ; moves LR back on step 
    STMFD SP!, {R0-R7, LR}

    ; check if 
    MOV R4, #Port_Area
	MOV R5, #Terminal_Data
	MOV R6, #Terminal_Control
    MOV R3, #&4

	LDR R2, [R4, R5]
    STR R2, [R4, R5]

; Return to were interrupt occured 
    LDMFD SP!, {R0-R7, PC}^

B IRQ_Handler 


Port_Area   		EQU &1000_0000
Terminal_Data 		EQU &10
Terminal_Control	EQU &14
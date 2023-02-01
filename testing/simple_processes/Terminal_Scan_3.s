Port_Area   		EQU &1000_0000
Terminal_Data 		EQU &10
Terminal_Control	EQU &14
	ALIGN 

main 
	MOV R4, #Port_Area
	MOV R5, #Terminal_Data
	MOV R6, #Terminal_Control
	ADR R7, Buffer_Pointer_Write
	STR R0, [R7]
	ADR R7, Buffer_Pointer_Read
	STR R0, [R7]
	ADR SP, stack_end         ; Sets up the stack pointer


loop 
	BL Scan_Terminal 
	CMP R0, #&0
	BEQ loop 
	BL Write_Terminal 
	BL Store_Buffer
	CMP R2, #&A
	BNE loop
echo_loop	
	BL  Read_Buffer
	CMP R0, #&0
	BEQ next_echo
	MOV R2, R0
	BL Write_Terminal 
	B echo_loop

next_echo 
	MOV R0, #&0
	ADR R7, Buffer_Pointer_Write
	STR R0, [R7]
	ADR R7, Buffer_Pointer_Read
	STR R0, [R7]
	B loop

Scan_Terminal
	LDR R1, [R4, R6] 	; reads control from terminal
	; Checks if it has recieved a input from the serie line 
	TST R1, #1 	; checks 1st bit
	LDRNE R2, [R4, R5]
	MOVNE R0, #&1 ; successful read
	MOVEQ R0, #&0	
	MOV PC, LR

Write_Terminal ; does not include a wait if terminal is busy
	STR R2, [R4, R5]
	MOV PC, LR

Store_Buffer 
	PUSH {R4, R5, R6} 
	ADR  R4, Buffer_Pointer_Write
	LDR  R6, [R4] 
	ADR  R5, Buffer
	STR  R2, [R5, R6]
	ADD  R6, R6, #&4
	STR  R6, [R4]
	POP  {R4, R5, R6} 
	MOV PC, LR

Read_Buffer 
	PUSH	{R4, R5, R6, R7}
	ADR  	R4, Buffer_Pointer_Write
	LDR  	R5, [R4]
	ADR  	R4, Buffer_Pointer_Read
	LDR  	R6, [R4]
	CMP 	R5, R6
	MOVEQ 	R0, #&0 ; empty buffer 
	ADRNE 	R7, Buffer  
	LDRNE 	R0, [R7, R6]
	ADDNE 	R6, R6, #&4
	STRNE 	R6, [R4]
	POP		{R4, R5, R6, R7}
	MOV 	PC, LR


stack       DEFS 100
stack_end

Buffer_Pointer_Write 	DEFW &4
Buffer_Pointer_Read 	DEFW &4


Buffer  DEFW &20


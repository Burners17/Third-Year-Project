Port_Area   		EQU &1000_0000
Terminal_Data 		EQU &10
Terminal_Control	EQU &14
	ALIGN 

main 
	MOV R4, #Port_Area
	MOV R5, #Terminal_Data
	MOV R6, #Terminal_Control
	ADR R7, Buffer
	MOV R3, #&4
	MOV R8, #&4

loop
	LDR R1, [R4, R6]
	TST R1, #1
	BEQ loop
	LDR R2, [R4, R5]
	CMP R2, #&A
	BEQ write
	STR R2, [R7, R3]
	ADD R3, R3, #&4
	B loop 

write 
	CMP R8, R3
	BEQ End
	LDR R2, [R7, R8]
	ADD R8, R8, #&4
	STR R2, [R4, R5]	
	B write	
End B End

Buffer  DEFW &20

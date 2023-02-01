Port_Area   		EQU &1000_0000
Terminal_Data 		EQU &10
Terminal_Control	EQU &14
	ALIGN 

main 
	MOV R4, #Port_Area
	MOV R5, #Terminal_Data
	MOV R6, #Terminal_Control

 	MOV R1, #&61
	STR	R1, [R4, R5]

 	MOV R1, #&63
	STR	R1, [R4, R5]
		
End B End
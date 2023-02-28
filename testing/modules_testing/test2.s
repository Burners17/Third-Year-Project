Port_Area   		EQU &1000_0000
Terminal_Data 		EQU &10
Terminal_Control	EQU &14
	ALIGN 

main 
    MOV R10 , #0
	MOV R4, #Port_Area
	MOV R5, #Terminal_Data
	MOV R6, #Terminal_Control

loop
    MOV R1, #&30
loe     
	STR R1, [R4, R5] 
    ADD R1, R1, #&1
    CMP R1, #&3A
    MOVEQ R1, #&30
    ADDEQ R10, R10, #&1
    CMP     R10, #&A
    BEQ     End
    b loe
End B End
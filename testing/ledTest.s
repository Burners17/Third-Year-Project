Port_area   EQU &10000000
LED_port    EQU &0

Delay       EQU &20000


;R1 Holds the bit mask for the output
;R2 stores the delay
;R3 Hold the loop number for the master loop
;R8 holds the postion on the part

            MOV R3, #0
            MOV R8, #Port_area


;for longer delays then 1 unit the code will increase the delay appropriately so as to not
; increase the loop number

;master loop




;first signal
return0
            MOV R1, #&44
            MOV R2, #Delay
            STRB R1, [R8, #LED_port]
            b loop

return1
            MOV R1, #&46
            MOV R2, #Delay
            STRB R1, [R8, #LED_port]
            b loop

return2
            MOV R1, #&41
            MOV R2, #Delay
            ADD R2, R2, #Delay
            ADD R2, R2, #Delay
            STRB R1, [R8, #LED_port]
            b loop

return3
            MOV R1, #&42
            MOV R2, #Delay
            STRB R1, [R8, #LED_port]
            b loop

return4
            MOV R1, #&44
            MOV R2, #Delay
            STRB R1, [R8, #LED_port]
            b loop

return5
            MOV R1, #&64
            MOV R2, #Delay
            STRB R1, [R8, #LED_port]
            b loop

return6
            MOV R1, #&14
            MOV R2, #Delay
            ADD R2, R2, #Delay
            ADD R2, R2, #Delay
            STRB R1, [R8, #LED_port]
            b loop

return7
            MOV R1, #&24
            MOV R2, #Delay
            STRB R1, [R8, #LED_port]
            b loop

loop
            SUB R2, R2, #1
            CMP R2, #0
            BEQ control
            B loop

control     ADD R3, R3, #1
            CMP R3, #1
            BEQ return1
            CMP R3, #2
            BEQ return2
            CMP R3, #3
            BEQ return3
            CMP R3, #4
            BEQ return4
            CMP R3, #5
            BEQ return5
            CMP R3, #6
            BEQ return6
            CMP R3, #7
            BEQ return7
            MOV R3, #&0
            B return0

; this file will list all processes 


; list of programs 

    ; Terminal Handler 
Terminal_Handler_Process
    pointer_next    DEFW 0 
    proccess_id     DEFW 1
    proccess_stack_pointer DEFW 0 
    proccess_constructor DEFW Terminal_Handler_Constructor

StandOut_Handler_Process
    pointer_next    DEFW 0 
    proccess_id     DEFW 2
    proccess_stack_pointer DEFW 0 
    proccess_constructor DEFW 0

Idle_proccess
    pointer_next    DEFW 0 
    proccess_id     DEFW 3
    proccess_stack_pointer DEFW 0 
    proccess_constructor DEFW 0

; Terminal handler 
GET Terminal_Handler.s

; process memory 

GET process_memory.s
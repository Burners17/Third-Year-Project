; List of all Processes
Idle 
    DEFW 0 ; pointer next
    DEFW 0  ; process Id 
    DEFW 0 ; process Stack pointer 
    DEFW Idle_Constructor

Terminal_Handler_Process
    DEFW 0 
    DEFW 1
    DEFW 0 
    DEFW Terminal_Handler_Constructor


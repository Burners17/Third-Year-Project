; List of all Processes
Idle 
    DEFW 0 ; pointer next
    DEFW 0  ; process Id 
    DEFW Idle_Constructor
    DEFW 0 ; process Stack pointer 
    DEFS &80 
    Align

Terminal_Handler_Process
    DEFW 0 
    DEFW 1
    DEFW Terminal_Handler_Constructor
    DEFW 0 
    DEFS &C8 
    Align

Lights_Handler_Process 
    DEFW 0 
    DEFW 2
    DEFW Lights_Handler_Constructor 
    DEFW 0 
    DEFS &C8 
    Align

HelloWorld_Handler_Process 
    DEFW 0 
    DEFW 3
    DEFW HelloWorld_Handler_Constructor 
    DEFW 0 
    DEFS &C8 
    Align
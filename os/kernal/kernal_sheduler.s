; Sheduler file 
;   To Do 
;   Context switching 
;   choose next from list 
;       need function to get next from linked list
sheduler_ready_list_start defs &16
    align
sheduler_unactive_list_start defs &16
   align

initialise_sheduler 
    ; loop though items in list of proccess
    MOV     R10,#0
    ADRL    R4, processes_list_start
    ADRL    R5, processes_list_end
    ADRL    R6, sheduler_unactive_list_start
    ADRL    R7, process_linked_list_space
    MOV     R8, #&1    
    
    LDR     R9, [R4] ; gets address of process start 
    STR     R10, [R7,#pointer_next] ; sets process linked to null 
    STR     R7, [R6]
    STR     R8, [R7, #proccess_id]
    STR     R9, [R7,#context_pointer]
    ADD     R4, R4, #&4
    MOV     R6, R7
    ADD     R7, R7, #&C




; list of processes
processes_list_start 
process_one_address   defw proccess_one_main
process_one_address2   defw proccess_one_main
process_one_address3   defw proccess_one_main
process_one_address4   defw proccess_one_main
processes_list_end 


; memory space for proccess 
process_linked_list_space
defs (processes_list_end - processes_list_start) 

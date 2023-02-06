; Sheduler file 
;   To Do 
;   Context switching 
;   choose next from list 
;       need function to get next from linked list
b main


main
initialise_sheduler 
    ; loop though items in list of proccess
    MOV     R10,#0
    ADRL    R4, sheduler_ready_list_start
    STR     R10, [R4]
    proccess_one_main
    ADRL    R4, processes_list_start
    proccess_two_main
    ADRL    R5, processes_list_end
    proccess_three_main
    ADRL    R6, sheduler_unactive_list_start
    proccess_four_main
    ADRL    R7, process_linked_list_space
    MOV     R8, #&1    
initialise_process_list_loop   
    LDR     R9, [R4] ; gets address of process start 
    STR     R10, [R7,#pointer_next] ; sets process linked to null 
    STR     R7, [R6]
    STR     R8, [R7, #proccess_id]
    STR     R9, [R7,#context_pointer]
    ADD     R4, R4, #&4
    MOV     R6, R7
    ADD     R7, R7, #&C 
    ADD     R8, R8, #1
    CMP     R4, R5 
    BNE initialise_process_list_loop

end b end

sheduler_ready_list_start defs &4
    align
sheduler_unactive_list_start defs &4
   align

; list of processes
processes_list_start 
process_one_address     defw proccess_one_main
process_two_address     defw proccess_two_main
process_three_address   defw proccess_three_main
process_four_address    defw proccess_four_main
processes_list_end 


; memory space for proccess 
process_linked_list_space
defs (processes_list_end - processes_list_start) 



struct 
pointer_next    word 
proccess_id     word 
context_pointer word 
    struct_align
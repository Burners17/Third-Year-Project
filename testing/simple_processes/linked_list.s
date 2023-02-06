b main 



main 
; set up linked list with three values 
    ADRL SP, Supervisor_Stack_End
    MOV     R2, #0
    ADRl    R0, list_start
    STR     R2, [R0]

    ADRL    R0, item1 
    MOV     R1, #&1
    STR     R2, [R0, #pointer_next]
    STR     R1, [R0, #proccess_id]
    STR     R2, [R0, #context_pointer]

    ADRL    R0, item2 
    MOV     R1, #&2
    STR     R2, [R0, #pointer_next]
    STR     R1, [R0, #proccess_id]
    STR     R2, [R0, #context_pointer]

    ADRL    R0, item3 
    MOV     R1, #&3
    STR     R2, [R0, #pointer_next]
    STR     R1, [R0, #proccess_id]
    STR     R2, [R0, #context_pointer]

    ADRL    R0, item4 
    MOV     R1, #&4
    STR     R2, [R0, #pointer_next]
    STR     R1, [R0, #proccess_id]
    STR     R2, [R0, #context_pointer]

    ADRL    R0, item5 
    MOV     R1, #&5
    STR     R2, [R0, #pointer_next]
    STR     R1, [R0, #proccess_id]
    STR     R2, [R0, #context_pointer]

    ADRL    R1, item1
    BL      add_to_list
    
    ADRL    R1, item2
    BL      add_to_list

    ADRL    R1, item3
    BL      add_to_list   

    ADRL    R1, item4
    BL      add_to_list 

    ADRL    R1, item5
    BL      add_to_list 

    MOV R1, #&3
    BL      remove_item

    MOV R1, #&4
    BL      find_item

end 
    b end 

remove_item
    PUSH    {R4, LR}
    BL find_item
    LDR R4, [R0, #pointer_next]
    STR R4, [R1, #pointer_next]

    ; save next pointer in this pointer 
    MOV R4, #0 
    STR R4, [R0, #pointer_next]
    POP     {R4, PC}
    
    ; find item before it and item after it 

    ; update pointer from before to one after 




; function to add link 
; R1 is item pointer of item to add 
add_to_list 
    PUSH {R4-R5, LR}
    ; get adr for list start
    ADRL    R4, list_start

add_to_list_loop
    LDR     R5, [R4, #pointer_next] 
    ; see if it is null
    CMP R5, #&0 
    MOVNE R4, R5
    BNE add_to_list_loop
    STR     R1, [R4, #pointer_next]
    POP {R4-R5, PC}

; function to find specific item 
find_item 
    ; takes process id desired 
    ; return in R0, pointer to item, 
    ; return in R1, pointer to item pointing at desired item
    PUSH    {R4-R8, LR}
    ; get start of list 
    ; get adr for list start
    ADRL    R4, list_start
    ADRL     R5, list_start ; this register will hold pointer to last item 
find_item_search_loop       
    ; List is empty 
    LDR R6, [R4, #pointer_next]
    CMP R6, #0 ; check if you reached end of line 
    BEQ end_of_list
    LDR R7, [R4, #proccess_id]
    CMP R7, R1
    BEQ item_found
    MOV R5, R4
    MOV R4, R6
    ; check if item is desired item  
    B find_item_search_loop   
    POP     {R4-R8, PC}   


end_of_list
    b end_of_list

item_found
    MOV R0, R4
    MOV R1, R5
    POP     {R4-R8, PC}   
list_start defs &16
    align

struct 
pointer_next    word 
proccess_id     word 
context_pointer word 
    struct_align


item1   defs &C  
item2   defs &C  
item3   defs &C  
item4   defs &C  
item5   defs &C 


; Blocks of memeory 
    ; Stacks 
        Supervisor_Stack_Size EQU &256

        ; Supervisor Stack
        Supervisor_Stack_Start  DEFS Supervisor_Stack_Size ; Supervisor Stack
        Supervisor_Stack_End
            Align

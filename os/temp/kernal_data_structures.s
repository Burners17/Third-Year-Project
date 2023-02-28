; This file holds all the data structurs used by the OS 
struct
buffer_start    word 
buffer_end      word 
buffer_head     word
buffer_tail     word 
buffer_waiter   word
    struct_align  


struct 
pointer_next            word 
proccess_id             word 
proccess_stack_pointer  word 
proccess_constructor    word
    struct_align

; Linked list functions 
; Takes in pointer to start of linked list in R0 
    ; add item to list
    ; Inputs 
    ; R0 pointer to start of list
    ; R1 pointer to item you want to add 
    ; R4 is used to deterime is end of list has been reached 
Linked_List_Put
    PUSH {R4, LR}
    ; get adr for list start

Linked_List_Put_Loop
    LDR     R4, [R0, #pointer_next] 
    ; see if it is null
    CMP R4, #&0 
    MOVNE R0, R4
    BNE Linked_List_Put_Loop
    STR     R1, [R0, #pointer_next]
    POP {R4, PC}

Linked_List_Get
    ; Inputs 
    ; R0 pointer to start of list
    ; R1 Will hold pointer to desired item 
    ; R4 is used to pass pointer to next item to start of list 
    PUSH {R4, LR}
    LDR     R1, [R0, #pointer_next]
    LDR     R4, [R1, #pointer_next]
    STR     R4, [R0, #pointer_next]
    POP  {R4, PC}



; Linked List data Structure 

struct 
pointer_next    word 
data            word  
    struct_align

; Functions 
; Add Item to list 
linked_list_add
; Function for adding an item to the list
; Inputs 
;   R0 Address of start of list     
    PUSH    {R4, LR} 
    LDR     R4, [R0]
    CMP     R4, #0 
    STREQ   R1, [R0]
    BEQ     linked_list_add_end
linked_list_add_loop
    LDR     R4, [R0]
    ; See if its null 
    CMP     R4, #&0 
    MOVNE   R0, R4 
    BNE     linked_list_add_loop
    STR     R1, [R0]
linked_list_add_end
    POP     {R4, PC}

linked_list_get 
; Inputs
;   R0 pointer to linked list starting location   
; Outputs 
;   R1 pointer to first item ob list
    PUSH    {R4, R5, LR}    
    LDR     R1, [R0]
    CMP     R1, #&0 
    LDRNE   R4, [R1]
    STRNE   R4, [R0]
    MOVNE   R5, #0 
    STRNE   R5, [R1]
    ;MOVNE   R1, R4
    POP     {R4, R5, PC}

; Remove Item to List 
linked_list_remove 
; Input 
;   R1 value of data for item removed    
; Output 
;   R0 if 0 then it failed 
    PUSH    {R4, LR}
    BL      linked_list_find 
    ; check if item was found 
    CMP R0, #0 
    BEQ linked_list_remove_failed
    ; update pointer #
    LDR     R4, [R0, #pointer_next]
    STR     R4, [R1, #pointer_next]
    
    ; Blanks pointer next of desired item 
    MOV     R4, #0 
    STR     R4, [R0, #pointer_next]
linked_list_remove_failed
    POP     {R4, PC}


linked_list_find 
; Function find item by data 
; Input
; R0 Pointer to start of linked list  
; R1 Data of item function is looking for 
; Ouput
; R0 pointer to desired item 
; R1 Pointer to preseding Item 
    MOV     R4, R0
    MOV     R5, R0
linked_list_find_loop       
    ; List is empty 
    LDR     R6, [R4, #pointer_next]
    CMP     R6, #0 ; check if you reached end of line 
    BEQ     linked_list_find_end_of_list
    LDR     R7, [R4, #data]
    CMP     R7, R1
    BEQ     linked_list_find_item_found
    MOV     R5, R4
    MOV     R4, R6
    ; check if item is desired item  
    B       linked_list_find_loop   
    POP     {R4-R8, PC}   

linked_list_find_item_found
    MOV     R0, R4
    MOV     R1, R5
    POP     {R4-R8, PC} 

linked_list_find_end_of_list
    MOV R0, #0 
    POP     {R4-R8, PC} 
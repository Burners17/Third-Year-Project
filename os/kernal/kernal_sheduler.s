; Sheduler file 
;   To Do 
;   Context switching 
;   choose next from list 
;       need function to get next from linked list

sheduler_ready_list_start defs &16
    align

; add to ready list
; Takes as input 
; R1 pointer to item to add 
Sheduler_Add
PUSH    {R0, LR} 
ADRL    R0, sheduler_ready_list_start
BL      Linked_List_Put
POP     {R0, PC} 

; get next item on list 
; Output 
; R1 pointer to next item
Sheduler_Next 
PUSH    {R0, LR} 
ADRL    R0, sheduler_ready_list_start
BL      Linked_List_Get
POP     {R0, PC} 

; remove from list 
Sheduler_Remove B Sheduler_Remove


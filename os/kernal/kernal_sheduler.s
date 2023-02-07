; Sheduler file 
;   To Do 
;   Context switching 
;   choose next from list 
;       need function to get next from linked list

sheduler_ready_list_start defs &16
    align

; add to ready list 
Sheduler_Add B Sheduler_Add

; get next item on list 
Sheduler_Next B Sheduler_Next

; remove from list 
Sheduler_Remove B Sheduler_Remove


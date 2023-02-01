; This is the main program for the OS that brings together the kernal 
; and the moduls used to create the OS
; This is also where all example programs will be loaded to. 

GET kernal/kernal.s 

User_Code_start

MOV R0, #&0
MOV R1, #&1
MOV R2, #&2

End
B End
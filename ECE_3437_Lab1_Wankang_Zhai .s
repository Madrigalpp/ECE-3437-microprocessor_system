;****************** main.s ***************
; Program written by: Yuhan Wang and Wankang Zhai    ***Name of the students******
; Date Created: September 5th            ***              *************
; Last Modified: September 5th
; Brief description of the program:  Desigh a program to add, substract the number  ***DMU_Lab 1****
;
;****************TASK 0: EQU DIRECTIVES***********************
ADDVALUE EQU 0x1
SUBVALUE EQU 0x3
MULVALUE EQU 0x4
DIVVALUE EQU 0x2

  
	THUMB

; *********************************************************************
; *************************** CODE AREA IN ROM ************************
; *********************************************************************
; ROM addresses start at address 0x0000.0000, but your code starts a little after that
	AREA	|.text|, CODE, READONLY, ALIGN=2		; Flash EEPROM

; ****************************************************************************
; ****************************************************************************
; ******************************** MAIN PROGRAM ******************************
; ****************************************************************************
; ****************************************************************************

	EXPORT	Start

Start

;****************** Lab 1 Part I ****************************************************
;***TASK 1: LOAD VECTOR X INTO THE REGISTER BANK*****
    MOV R0, #0x2
	MOV R1, #0x1
	SUB R2, R1, R0
	MOV R2, #0x3
	

;***TASK 2: LOAD VECTOR y INTO THE REGISTER BANK*****
	MOV R3, #0x4
	MOV R4, #0x5
	MOV R5, #0x6



;***TASK 3: ADD SCALAR AND SUM VECTOR X***************
	ADD R10, R0, #ADDVALUE
	ADD R11, R1, #ADDVALUE
	ADD R12, R2, #ADDVALUE
	ADD R6, R10, R11
	ADD R6, R12, R6
	

;***TASK 4: SUBTRACT SCALAR AND SUM VECTOR Y**********
	SUB R7, R3, #SUBVALUE
	SUB R8, R4, #SUBVALUE
	SUB R9, R5, #SUBVALUE
	ADD R7, R7, R8
	ADD R7, R7, R9
	
  
  
  
;****************** Lab 1 Part II *******************************
	
;***TASK 5: MULTIPLY VECTOR X BY SCALAR AND SUM********	
	MOV R9, #MULVALUE
	MUL R10, R0, R9
	MUL R11, R1, R9
	MUL R12, R2, R9
	ADD R8, R10, R11
	ADD R8, R8, R12
	
	
;***TASK 6: DIVIDE VECTOR Y BY SCALAR AND SUM***********
	MOV R10, #DIVVALUE
	UDIV R9, R3, R10
	UDIV R11, R4, R10
	UDIV R10, R5, R10
	ADD R9, R9, R11
	ADD R9, R9, R10
	
	
;***TASK 7: DOT PRODUCT OF X & Y*************************
	MUL R10, R0, R3
	MUL R11, R1, R4
	MUL R12, R2, R5
	ADD R10, R10, R11
	ADD R10, R10, R12
	
	
	

;***TASK 8: TWO’S COMPLEMENT******************************
	NEG R11, R10
	
	
	NOP
    
    ALIGN      ; make sure the end of this section is aligned
    END        ; end of file


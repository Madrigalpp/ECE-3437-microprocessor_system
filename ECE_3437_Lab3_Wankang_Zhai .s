;****************** main.s ***************
; Program written by: Dr. D
; Date Created: 03/21/2023
; Last Modified:  10/10/2023
; Brief description of the program
; The objective of this program is to practice reading from
; and writing to memory.


 
 	THUMB     

		   
; *********************************************************************
; ************************* ROM CONSTANTS AREA ************************
; *********************************************************************
; EEPROM addresses start at 0x0000.0000
; Constants and code areas start at address 0x0000.0284
	AREA    MyConstants, DATA, READONLY, ALIGN=2		; Flash EEPROM
		 
RES0	DCB		2
RES1	DCB		6
RES2	DCB		8
RES3	DCB		1
RES4	DCB		3
ISRC1	DCB		16
ISRCT	DCB		8
P1  DCB 15
P2  DCW 150
P3  DCD 1500

	ALIGN

; *********************************************************************
; ************************* RAM VARIABLES AREA ************************
; *********************************************************************
; SRAM variables area starts at address 0x2000.0000
	AREA    MyVariables, DATA, READWRITE, ALIGN=2		; SRAM		  
		  
VSRC1	SPACE	2
VSRC2	SPACE	2
ISRC2	SPACE	2
IRES4	SPACE	2
RES5	SPACE	2
RES6	SPACE	2
RES7	SPACE	2

;P1  SPACE 1
;P2  SPACE 2
;P3  SPACE 4

	ALIGN

; *********************************************************************
; *************************** CODE AREA IN ROM ************************
; *********************************************************************
	AREA    |.text|, CODE, READONLY, ALIGN=2		; Flash ROM



	EXPORT  Start
		
Start
		
; ************************************************
; ******************** TASK 0 ********************
	MOV32 R4, #0XAABBCCEE
	MOV32 R5, #0XBBCCEEDD
	MOV32 R6, #0XECEECE55
	
	LDR R0, =P1
	LDRB R4, [R0]
;	STR R4, [R0]
	LDR R0, =P2
	LDRH R5, [R0]
;	STR R5, [R0]
	LDR R0, =P3
	LDR R6, [R0]
;	STR R6, [R0]
	
	LDR R0, =RES0
	LDRB R0, [R0]
	LDR R1, =RES1
	LDRB R1, [R1]
	LDR R2, =RES2
	LDRB R2, [R2]
	LDR R3, =RES3
	LDRB R3, [R3]
	LDR R4, =RES4
	LDRB R4, [R4]
	LDR R5, =ISRC1
	LDRB R5, [R5]


; ************************************************
; ******************** TASK 1 ********************
	LDR R6, =VSRC1
	MUL R7, R5, R0 ; VSRC1
	STR R7, [R6]
	ADD R8, R0, R1  ; R5
	LDR R9, =RES5
	STR R8, [R9]

	
; ************************************************
; ******************** TASK 2 ********************
	UDIV R12, R7, R8 ; ISRC2
	MUL R10, R8, R2
	ADD R11, R8, R2
	UDIV R11, R10, R11  ; R6
	LDR R8, =ISRC2
	STR R12, [R8]
	LDR R9, =RES6
	STRH R11, [R9] 
	


; ************************************************
; ******************** TASK 3 ********************
	MUL R10, R12, R11 ; VSRC2
	LDR R12, =VSRC2
	STR R10, [R12]
	ADD R7, R11, R3
	ADD R7, R7, R4
;	ADD R6, R4, R7 ; R7
	LDR R11, =RES7
	STR R6, [R11]
	


; ************************************************
; ******************** TASK 4 ********************
	UDIV R7, R10, R6
	LDR R10, =IRES4
	STR R7, [R10]


; ************************************************
; ******************** TASK 5 ********************
; Change ISRC1 to ISRCT (T for test) and verify 
; that your answers are still correct.


	NOP


	ALIGN        ; make sure the end of this section is aligned
	END          ; end of file
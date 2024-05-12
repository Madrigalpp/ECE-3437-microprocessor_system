;****************** main.s ***************
; Program written by: Dr. D
; Date Created: 02/20/2023
; Last Modified:  
; Brief description of the program: LED sequence display
; 	Spring 2023 Lab 2
; 		PF0	-->	SW2
;		PF1	-->	Red LED
;		PF2	-->	Blue LED
;		PF3	--> Green LED
;		PF4	--> SW1


	THUMB
		
; Base address for Port F Data Register = 0x4002.5000
GPIO_PORTF_DATA_R  EQU 0x400253FC	; GPIO Data Register (GPIODATA)


; Test 1
;redPattern		EQU		2_01010101010101010101010101010101
;bluePattern		EQU		2_01010101010101010101010101010101
;greenPattern	EQU		2_01010101010101010101010101010101
	
; Test 2
redPattern		EQU		2_00000101000000000101000000000101
bluePattern		EQU		2_00000101000001010000000001010000
greenPattern	EQU		2_00000101010100000000010100000000		

; Test 3
;redPattern		EQU		2_00010001000100010001000100010001
;bluePattern		EQU		2_00100010001000100010001000100010
;greenPattern	EQU		2_01000100010001000100010001000100			  
		  
; *********************************************************************
; *************************** CODE AREA IN ROM ************************
; *********************************************************************
	AREA    |.text|, CODE, READONLY, ALIGN=2		; Flash ROM
		  
		  		  

	EXPORT  Start

	IMPORT	portFconfig


; MAIN PROGRAM ****************************
;	Port F has 5 pins.
; 		PF0 (Bit0)	-->	SW2
;		PF1	(Bit1)	-->	Red LED
;		PF2	(Bit2)	-->	Blue LED
;		PF3	(Bit3)	--> Green LED
;		PF4	(Bit4)	--> SW1

Start

	BL	portFconfig
	LDR R2, =redPattern
	LDR R3, =bluePattern
	LDR R4, =greenPattern



loop
	RORS R2,R2,#1
	RRX R5,R5
  
	RORS R3,R3,#1
	RRX R5,R5
	
	RORS R4,R4,#1
	RRX R5,R5
	
	LSR R5,R5,#28
	MOV R0,R5
	BL setData
	BL wait500ms
 



	
	B	loop
	
	





; ****************************** SUBROUTINES ******************************
; *************************************************************************	
	

setData
; input parameters: R0 contains the bit values to output on Port F I/O pins
; return parameters: none
; destroys value in R1 register
	PUSH {R0, R1}
	LDR	R1, =GPIO_PORTF_DATA_R
	STR R0, [R1]
	POP {R0, R1}
	BX	LR

; ****************************************
; input parameters: none
; return parameters: none
wait500ms
	MOV32	R0, #2500000
wait_loop
	SUBS R0, #1
	BNE wait_loop
	BX LR


	
; *************************************************************************
; *************************************************************************


	NOP
      

      ALIGN        ; make sure the end of this section is aligned
      END          ; end of file
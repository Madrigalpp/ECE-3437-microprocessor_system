;****************** main.s ***************
; Program written by: Dr. D
; Date Created: 03/27/2023
; Last Modified:  
; Brief description of the program:
; 	Fall 2022 Lab 5
; 		PF0	-->	SW2
;		PF1	-->	Red LED
;		PF2	-->	Blue LED
;		PF3	--> Green LED
;		PF4	--> SW1


	THUMB
		
; Base address for Port F Data Register = 0x4002.5000

; 
; Complete this section EQU for the GPIO Data Register (GPIODATA)
GPIO_PORTF_DATA_R  EQU 0x400253FC



	
	
; *********************************************************************
; ************************* EQU DIRECTIVES ****************************
; *********************************************************************
	  
; *********************************************************************
; ************************* ROM CONSTANTS AREA ************************
; *********************************************************************
; Constants and code area starts at address 0x0000.0000
	AREA    MyConstants, DATA, READONLY, ALIGN=2		; Flash EEPROM
		 
; *********************************************************************
; ************************* RAM VARIABLES AREA ************************
; *********************************************************************
; SRAM variables area starts at address 0x2000.0000
	AREA    MyVariables, DATA, READWRITE, ALIGN=2		; SRAM
 
		  
; *********************************************************************
; *************************** CODE AREA IN ROM ************************
; *********************************************************************
	AREA    |.text|, CODE, READONLY, ALIGN=2		; Flash ROM


	EXPORT  Start
	IMPORT	portFconfig
	


; MAIN PROGRAM ****************************
;	Port F has 5 pins.
; 		PF0	-->	SW2
;		PF1	-->	Red LED
;		PF2	-->	Blue LED
;		PF3	--> Green LED
;		PF4	--> SW1

Start
	BL	portFconfig
	
;*********** Begin Coding Here **************
;; Check the buttons and turn on proper LED
loop
	MOV R0, #0x0
	PUSH {R0, R1}
	LDR R1, =GPIO_PORTF_DATA_R
	STR R0, [R1]
	LDR R7, [R1]
	POP {R0, R1}
	
	CMP R7, #0x11
	BEQ SETRED
	CMP R7, #0x1
	BEQ SETYELLOW
	CMP R7, #0x10
	BEQ SETYELLOW
	CMP R7, #0x0
	BEQ SETGREEN

SETGREEN
	MOV R0, #0x8
	PUSH {R0, R1}
	LDR R1, =GPIO_PORTF_DATA_R
	STR R0, [R1]
	POP {R0, R1}
	B loop
	
SETRED
	MOV R0, #0X2
	PUSH {R0, R1}
	LDR R1, =GPIO_PORTF_DATA_R
	STR R0, [R1]
	POP {R0, R1}
	B loop
	
wait500ms
	MOV R0, #0x0
	PUSH {R0, R1}
	LDR R1, =GPIO_PORTF_DATA_R
	STR R0, [R1]
	LDR R9, [R1]
	POP {R0, R1}
	CMP R9, #0x1B
	BEQ loop
	CMP R9, #0xA
	BEQ loop
	MOV32 R5, #2500000
wait_loop1
	SUBS R5, #1
	BNE wait_loop1

SETYELLOW
	MOV R0, #0xA
	PUSH {R0, R1}
	LDR R1, =GPIO_PORTF_DATA_R
	STR R0, [R1]
	LDR R9, [R1]
	POP {R0, R1}
	

wait500msblink
	CMP R9, #0x1B
	BEQ loop
	CMP R9, #0xA
	BEQ loop
	MOV32 R6, #2500000
wait_loop
	SUBS R6, #1
	BNE wait_loop
	

	BL wait500ms

      

	ALIGN        ; make sure the end of this section is aligned
    END          ; end of file
	

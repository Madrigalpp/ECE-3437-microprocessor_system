;****************** main.s ***************
; Program written by: Dr. D
; Date Created: ??
; Last Modified: 11/14/2022
; Brief description of the program: Demonstration of 16MHz & 80MHz
;		clocking on the uC	
  

 ; ********************************************************************
 ; ********************* EQU Label Definitions ************************
 ; ********************************************************************

; Port F Data registers
GPIO_PORTF_DATA_R  	EQU 0x400253FC	; to read all bits on Port F
GPIO_PORTF_DATA_SWS	EQU	0x40025044	; to read both switches on Port F
GPIO_PORTF_DATA_OUT	EQU	0x40025038	; Port F data bits 1-3


	THUMB
		
; *********************************************************************
; ************************* ROM CONSTANTS AREA ************************
; *********************************************************************
; Constants and code area starts at address 0x0000.0000
	AREA    MyConstants, DATA, READONLY, ALIGN=2		; Flash EEPROM

		 
	ALIGN
		 
		 
; *********************************************************************
; ************************* RAM VARIABLES AREA ************************
; *********************************************************************
; SRAM variables area starts at address 0x2000.0000
	AREA    MyVariables, DATA, READWRITE, ALIGN=2		; SRAM

	ALIGN		  
		  
		  
; *********************************************************************
; *************************** CODE AREA IN ROM ************************
; *********************************************************************
	AREA    |.text|, CODE, READONLY, ALIGN=2		; Flash ROM
		    
	ALIGN
		  
	EXPORT  Start
		  
Start


Prog_Init

; Configure 80 MHz Clock System
;	IMPORT	SysClock80MHz_Config
;	BL		SysClock80MHz_Config
;	NOP

; Configure Port F
	IMPORT	PortF_Config
	BL		PortF_Config
	NOP
	
	
; ******************************************************************
; ********************** MAIN PROGRAM ******************************
; ******************************************************************
;	f = 16MHz	-->	T = 62.5 ns
;	f = 80MHz	-->	T = 12.5 ns
	
	LDR	R1, =GPIO_PORTF_DATA_OUT

	MOV	R2, #2_00000
	MOV	R4, #2_01110
	
loop

	STR	R2, [R1]	; turn LEDs off --> LDRs & STRs require 2 cycles in the execute stage of the pipeline (4 total cycles)
	MOV32	R0, #800000
counter1

	SUBS R0, #1
	BNE counter1
	
	
	STR	R4, [R1]	; turn LEDs on
	MOV32	R0, #800000
counter2
	SUBS R0, #1
	BNE counter2
	
	
	B	loop		; branches require 3 cycles in the execute stage of the pipeline (5 total cycles)


;************************ SUBROUTINES *****************************
;******************************************************************


	
;*********************** END SUBROUTINES **************************
      
    ALIGN      ; make sure the end of this section is aligned
    END        ; end of file


;****************** main.s ***************
; Author 1:   Yuhan Wang     
; Author 2:   Wankang Zhai
; Date Created:  10/30/2023
; Last Modified:  10/30/2023
; Brief description of the program:
;	Use conditional instructions to test whether the string has "WALDO"

		  

	THUMB

; *********************************************************************
; ************************* ROM CONSTANTS AREA ************************
; *********************************************************************
MYTEST		EQU		1

 
; *********************************************************************
; ************************* ROM CONSTANTS AREA ************************
; *********************************************************************
; Constants and code area starts at address 0x0000.0284
	AREA    MyConstants, DATA, READONLY, ALIGN=2		; Flash EEPROM
		
;; HINTS: DEFINE TESTDATA HERE
TESTDATA1  DCB "AbWALDOcD", 0
TESTDATA2  DCB "WWW", 0
TESTDATA3  DCB "00W8AL0WALDOcF", 0
TESTDATA4  DCB "", 0



		 
	ALIGN
		 
		 
; *********************************************************************
; ************************* RAM VARIABLES AREA ************************
; *********************************************************************
; SRAM variables area starts at address 0x2000.0000
	AREA    MyVariables, DATA, READWRITE, ALIGN=2		; SRAM

;; HINTS: DEFINE VARIABLE HERE
LOCATION  SPACE  4

		 

	ALIGN		  
		  
		  
; *********************************************************************
; *************************** CODE AREA IN ROM ************************
; *********************************************************************
	AREA    |.text|, CODE, READONLY, ALIGN=2		; Flash ROM
		  
		  
	ALIGN
		  
	EXPORT  Start
		
	IMPORT	portFconfig
	IMPORT	setData
	IMPORT	findWaldo

		
Start
	BL	portFconfig
; ****************************************************************************
; ******************************** MAIN PROGRAM ******************************
; ****************************************************************************

;; HINTS: START MAIN PROGRAM HERE
;; CHECK TESTDATA ONE BY ONE
;; CALL findWaldo SUBROUTINE

	
	LDR R1, =MYTEST
	CMP R1, #1
	BLO OUTRANGE
	CMP R1, #5
	BHI OUTRANGE
	
	CMP R1, #1
	BEQ CHOOSING1
	CMP R1, #2
	BEQ CHOOSING2
	
	CMP R1, #3
	BEQ CHOOSING3
	CMP R1, #4
	BEQ CHOOSING4
	
;	BL findWaldo
;	LDR R5,=LOCATION
;	STR R0,[R5]
;	B ending

OUTRANGE
	MOV32 R0, #0x2
	BL setData	
	B ending
	
CHOOSING1
	LDR R0, =TESTDATA1
	BL findWaldo
	LDR R5,=LOCATION
	STR R0,[R5]
	B ending
	
CHOOSING2
	LDR R0, =TESTDATA2
	BL findWaldo
	LDR R5,=LOCATION
	STR R0,[R5]
	B ending
	
CHOOSING3
	LDR R0, =TESTDATA3
	BL findWaldo
	LDR R5,=LOCATION
	STR R0,[R5]
	B ending
	
CHOOSING4
	LDR R0, =TESTDATA4
	BL findWaldo
	LDR R5,=LOCATION
	STR R0,[R5]
	B ending
	

ending
	NOP
	
    ALIGN      ; make sure the end of this section is aligned
    END        ; end of file



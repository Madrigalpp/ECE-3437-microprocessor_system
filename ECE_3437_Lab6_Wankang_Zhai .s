;****************** main.s ***************
; Program written by:        ***Your Names**update this***
; Date Created: 11/28/2022
; Last Modified: 11/28/2022
; Brief description of the program
;	The purpose of the program is to...


	THUMB
			  
; PortF device registers
GPIO_PORTF_DATA_R  	EQU 0x400253FC	; to read all bits on Port F
GPIO_PORTF_DATA_SWS	EQU	0x40025044	; to read both switches on Port F
GPIO_PORTF_DATA_OUT	EQU	0x40025038	; to write to all LEDs on Port F

; SysTick Timer addresses
NVIC_ST_CTRL_R 		EQU 0xE000E010	; SysTick Control and Status Register (STCTRL)
NVIC_ST_RELOAD_R	EQU 0xE000E014	; SysTick Reload Value register (STRELOAD)
NVIC_ST_CURRENT_R	EQU 0xE000E018	; SysTick Current Value Register (STCURRENT)
DELAY				EQU 4000000		; 400,000 ticks = 5ms at 80MHz
DEBOUNCE			EQU 1000000



		   

 
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
		
		  

	EXPORT  Start
		  
		  
    IMPORT	SysClock80MHz_Config
	IMPORT	SysTick_Config
	IMPORT  PortF_Config

		   		  

; ******************** MAIN PROGRAM ****************************
; 	PF0	-->	SW2
;	PF1	-->	Red LED
;	PF2	-->	Blue LED
;	PF3	--> Green LED
;	PF4	--> SW1

Start
 
     BL	SysClock80MHz_Config 	; sets bus clock at 80 MHz
	 BL	SysTick_Config			; configures SysTick timer
	 BL	PortF_Config			; configures Port F
LOOP
	LDR R1, =GPIO_PORTF_DATA_R
	LDR R2, [R1]
	MOV R2, #0X0
	CMP R2, #0X0
	BEQ GREEN
	CMP R2, #0X11
	BEQ RED
	CMP R2, #0X01
	BEQ YELLOW
	CMP R2, #0X10
	BEQ YELLOW
	
GREEN
	MOV R3, #0X8
	STR R3, [R1]
	B LOOP
	
YELLOW
	MOV R4, #0XA
	STR R4, [R1]
	MOV R6, #10
	BL SysTick_Wait
	SUB R6, #1
	CMP R6, #0
	BEQ BLINK
	B YELLOW
	
BLINK
	MOV R7, #0X0
	STR R7, [R1]
	MOV R9, #10
	BL SysTick_Wait
	SUB R9, #1
	CMP R9, #0
	BEQ YELLOW
	B BLINK
RED
	MOV R5, #0X2
	STR R5, [R1]
	B LOOP
	
;	MOV R4, #0X2
;	BL SysTick_Wait10ms
;	MOV R7, #0
;loop
;	LDR R5, =GPIO_PORTF_DATA_SWS
;	LDR R6, [R5]
;	MOV R11, #2
;	MOV R10, #2
;	CMP R7, #0
;	BEQ MINVALUE
;	CMP R7, #0X7
;	BEQ MAXVALUE
;	CMP R6, #0X10
;	BEQ GEORGE2
;	CMP R6, #0X01
;	BEQ GEORGE1
;	B loop
;	

;PRESSSW2
;	LDR R8, =GPIO_PORTF_DATA_R
;	LSL R9, R7, #1
;	STR R9, [R8]

;	LDR R5, =GPIO_PORTF_DATA_SWS
;	LDR R6, [R5]
;	CMP R6, #0X11
;	BEQ COUNTDOWN
;	B PRESSSW2
;	
;PRESSSW1
;	LDR R8, =GPIO_PORTF_DATA_R
;	LSL R10, R7, #1
;	STR R10, [R8]
;	LDR R5, =GPIO_PORTF_DATA_SWS
;	LDR R6, [R5]
;	CMP R6, #0X11
;	BEQ COUNTUP
;	B PRESSSW1

;COUNTUP
;	ADD R7, #1
;	LSL R11, R7, #1
;	LDR R8, =GPIO_PORTF_DATA_R
;	STR R11, [R8]
;	CMP R7, #0X7
;	BEQ MAXVALUE
;	MOV R10, #10
;	LDR R5, =GPIO_PORTF_DATA_SWS
;	LDR R6, [R5]
;	CMP R6, #0X10
;	BEQ PRESSSW2
;	CMP R6, #0X01
;	BEQ PRESSSW1
;	BL COUNTUP_DELAY
;	B COUNTUP

;COUNTDOWN
;	SUB R7, #1
;	LSL R12, R7, #1
;	LDR R8, =GPIO_PORTF_DATA_R
;	STR R12, [R8]
;	CMP R7, #0
;	BEQ MINVALUE
;	MOV R11, #10
;	LDR R5, =GPIO_PORTF_DATA_SWS
;	LDR R6, [R5]
;	CMP R6, #0X10
;	BEQ PRESSSW2
;	CMP R6, #0X01
;	BEQ PRESSSW1
;	BL COUNTDOWN_DELAY
;	B COUNTDOWN
;	
;MINVALUE
;	LDR R8, =GPIO_PORTF_DATA_R
;	STR R7, [R8]
;	MOV R11, #2
;	MOV R10, #2
;	LDR R5, =GPIO_PORTF_DATA_SWS
;	LDR R6, [R5]
;	CMP R6, #0X01
;	BEQ GEORGE1
;	B MINVALUE
;	
;MAXVALUE
;	LDR R8, =GPIO_PORTF_DATA_R
;	LSL R4, R7, #1
;	STR R4, [R8]
;	MOV R11, #2
;	MOV R10, #2
;	LDR R5, =GPIO_PORTF_DATA_SWS
;	LDR R6, [R5]
;	CMP R6, #0X10
;	BEQ GEORGE2
;	B MAXVALUE

;COUNTUP_DELAY
;    LDR R0, =DELAY
;	SUB R10, #1
;    BL SysTick_Wait
;	CMP R10, #0
;    BEQ COUNTUP
;	B COUNTUP_DELAY

;COUNTDOWN_DELAY
;    LDR R0, =DELAY
;	SUB R11, #1
;    BL SysTick_Wait
;	CMP R11, #0
;    BEQ COUNTDOWN
;	B COUNTDOWN_DELAY
;GEORGE1
;	LDR R0, =DEBOUNCE
;	SUB R11, #1
;	BL SysTick_Wait
;	CMP R11, #0
;	BNE GEORGE1
;	CMP R6, #0X01
;	BEQ PRESSSW1
;	BL loop
;	
;;GEORGE1
;;	LDR R0, =DEBOUNCE
;;	SUB R11, #1
;;	BL SysTick_Wait
;;	CMP R6, #0X01
;;	BNE loop
;;	CMP R11, #0
;;	BNE GEORGE1
;;	CMP R6, #0X01
;;	BEQ PRESSSW1
;;	BL loop
;GEORGE2
;	LDR R0, =DEBOUNCE
;	SUB R10, #1
;	BL SysTick_Wait
;	CMP R10, #0
;	BNE GEORGE2
;	CMP R6, #0X10
;	BEQ PRESSSW2
;	BL loop


	
	
	

;************************ SUBROUTINES *****************************
;******************************************************************
	
SysTick_Wait
	; load counter with desired number of ticks
	LDR	R1,	=NVIC_ST_RELOAD_R	; R1 = &NVIC_ST_RELOAD_R
	SUB	R0,	#1					; (delay-1) = number of ticks to wait
	STR	R0,	[R1]
	; get address of register that has COUNT bit
	LDR	R1,	=NVIC_ST_CTRL_R		; R1 = & NVIC_ST_CTRL_R
SysTick_Wait_loop
	LDR	R3,	[R1]
	ANDS R3, R3, #0x00010000	; COUNT bit is bit 16
	BEQ	SysTick_Wait_loop	; if COUNT == 0, the counter has not hit zero, so keep waiting 
	BX	LR


; ******************** SysTick Wait 10ms ********************	
; Time delay using busy wait. This assumes 80MHz clock
; Input: R0 --> # of times to wait 10 ms before returning
; Output: none
; Modifies: R0

DELAY10MS EQU	3
	
SysTick_Wait10ms
	PUSH {R4, LR}				; save current value of R4 and LR
	MOVS R4, R0					; R4 = R0 = remainingWaits
	BEQ SysTick_Wait10ms_done	; R4 == 0, done
SysTick_Wait10ms_loop
	LDR R0, =DELAY10MS			; R0 = DELAY10MS
	BL SysTick_Wait				; wait 10ms
	SUBS R4, R4, #1				; R4 = R4 -1; remainingWaits--
	BHI SysTick_Wait10ms_loop	; if (R4 > 0), wait another 10ms
SysTick_Wait10ms_done			
	POP {R4, PC}
	BX LR
;*********************** END SUBROUTINES ****************************
      
	  
    ALIGN      ; make sure the end of this section is aligned
    END        ; end of file


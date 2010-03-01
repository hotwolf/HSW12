	CPU	XGATE
	
	ORG	$B000
	DS.W	2 	; reserve two words at cahnnel 0
	; channel 1
	DC.W	_START	; point to start address
	DC.W	V_PTR    ; point to initial variables

	ORG	$2000 ; with comment

V_PTR	EQU	123
SPI0    EQU     $D0
SPI_CR  EQU     5

        DC.W	BACK_
	DS.W	8
	DC.B	$56
	DS.B	11

	ALIGN	1

_START
	TFR	R2,CCR	 	; R2 = CCR
	TFR	CCR,R1          ; CCR = R1

;empty line
	LDB     R1,(R1,#SPI_CR)	; willi
	LDW     R1,(R1,#4)
	STB     R1,(R1,#4)	; willi
	STW     R1,(R1,#4)
	LDB	R1,(R1,R2)
	LDW	R1,(R1,R2)
	STB	R1,(R1,R2)
	STW	R1,(R1,R2)
	LDB	R1,(R1,R2+)
	LDW	R1,(R1,R2+)
	STB	R1,(R1,R2+)
	STW	R1,(R1,R2+)
	LDB	R1,(R1,-R2)
	LDW	R1,(R1,-R2)
	STB	R1,(R1,-R2)
	STW	R1,(R1,-R2)

BACK_	SEX	R3
	PAR	R4
	JAL	R7

	CSEM	#1	; semaphores
	CSEM    R1	; same as above + 1

	SSEM	#7      ; semaphores
	SSEM    R7	; same as above + 1

	BFFO	R4,R5
	ASR	R6,R7
	CSL	R2,R2
	CSR	R5,R3
	LSL	R2,R0
	LSR	R0,R3
	ROL	R4,R2
	ROR	R5,R6

	ASR	R6,#1
	CSL	R2,#2
	CSR	R5,#3
	LSL	R2,#4
	LSR	R0,#5
	ROL	R4,#6
	ROR	R5,#7

	AND	R0,R1,R2	; bit compare R1,R2
	OR	R1,R2,R3
	XNOR	R2,R0,R3	; invert R3
	COM     R2,R3		; as pseudo op with two operands (r2 = ~r3)
	COM     R3		; as pseudo op with single op    (r3 = ~r3)

	SUB	R0,R2,R3	; compare
	CMP	R2,R3	        ; compare as pseudo op
	SUB	R0,R2,R0	; compare
	NEG     R2,R3		; as pseudo op with two operands (r3 = 0-r2)
	NEG     R3		; as pseudo op with single op    (r3 = 0-r3)
	TST	R2              ; compare as pseudo op
	SBC	R4,R5,R6
	SBC	R0,R5,R6
	CPC	R5,R6		; compare as pseudo op
	ADD	R6,R7,R7	; R7*2
	ADC	R3,R2,R1

	BCC	*+2
	BCS	*+2
	BEQ	*
	BNE	FWD

FWD	BPL	BACK_
	BMI	BACK_
	BVC	*+2
	BVS	*+2
	BHI	*+2
	BLS	*+2
	BGE	*+2
	BGT	*+2
	BRA	BACK_

	BFEXT	R4,R5,R6
	BFINS	R4,R5,R6	; clear BitField
	BFINSI	R4,R0,R6	; set BF
	BFINSX	R4,R5,R6	; toggle

	ANDL	R3,#$FE
	ANDH	R3,#4+(5*3)	; 19dec = $13
	BITL	R3,#($FE+1-1)   ; $FE
	BITH	R3,#255
	ORL 	R3,#~$FE	; should be 1
	ORH 	R3,#~(~0)       ; should be 0
	XNORL 	R3,#$FE
	XNORH 	R3,#~$01	; toggle bit 0 = $FE

	SUBL	R3,#0
	SUBH	R4,#2
	CMPL	R3,#0
	CPCH	R4,#2
	ADDL	R3,#0
	ADDH	R4,#2
	LDL 	R3,#0
	LDH 	R4,#2

	SIF
	SIF	R7
	BRK
	NOP
	RTS






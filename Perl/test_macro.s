#MACRO MAC0 2       
		MAC1  \1	;don't substitute: \1 \2
LOOP\2   	CPD   0,\2	;don't substitute: \1 \2
		JSR   LOOP\2	;don't substitute: \1 \2
		LEA\2 0,\1	;don't substitute: \1 \2
#EMAC

#MACRO MAC1 1       
LOOP\1   	CPD   0,\1   	;don't substitute: \1 \2    
		JMP   LOOP\1	;don't substitute: \1 \2
		ST\1  0,\1	;don't substitute: \1 \2
#EMAC       


		CPU   S12	
		ORG   $1234
		MAC0  X, Y

#ifmac MAC0	
MAC0_DEFFINED	EQU	1	
#else
MAC0_UNDEFFINED	EQU	1	
#endif

#ifnmac MAC1	
MAC1_UNDEFFINED	EQU	1	
#else
MAC1_DEFFINED	EQU	1	
#endif

		NOP
		NOP

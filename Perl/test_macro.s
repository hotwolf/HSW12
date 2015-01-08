#MACRO MAC0 2       
		MAC1  \1
LOOP   		CPD   0,\2
		BEQ   LOOP
#EMAC

#MACRO MAC1 1       
LOOP   		CPD   0,\1       
		BNE   LOOP
#EMAC       


		CPU   S12	
		ORG   $0000
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

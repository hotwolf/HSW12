#MACRO MAC0 2       
       MAC1  \1
LOOP   CPD   0,\2
       BEQ   LOOP
#EMAC

#MACRO MAC1 1       
LOOP   CPD   0,\1       
       BNE   LOOP
#EMAC       

       CPU   S12	
       ORG   $0000
       MAC0  X, Y

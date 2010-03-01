; 1) The assembler likes code fields separated by the Tab character rather than
; by a space. Under certain circumstances, the assembler will flag a line as an
; error when the first character is a space rather than a tab, or when a space
; separate fields like label and instruction.  I haven't spent time noting the
; exact circumstances of the effect.  I just use tabs regardless now, and have
; not had a problem.

        ;; I'm a little bit puzzled about this problem. I can't reproduce it and
        ;; I can't find anything in the assembler's source code, that would
        ;; distinguish between the different kinds of whitespace.
        ;; The assembler uses a set of regular expressions for parsing code.
        ;; They all use Perl's symbol for whitespace "\s", which is supposed to
        ;; include spaces as well as tabs. Could the problem be related to the
        ;; Perl interpreter that you're using?
        ;; I'd be very interested to see an example, which shows this whitespace
        ;; problem.
        
; 2) Arithmetic expressions do not seem to have expected rules of precedence.
; You need to specify parentheses for everything to make sure expressions get
; evaluated correctly.  It may be that evaluation is done right to left instead
; of left to right.  I'm not sure. 

        ;; The rules of precedence I've meant to implement are:
        ;; -/~, &, |, ^, >>, <<, *, /, %, +, -
        ;; Again, arithmetic expressions are evaluated with the help of regular
        ;; expressions. I believe the way they're coded, expressions might
        ;; might evaluated right to left.
        ;; I would like to see some expressions that evaluate to unexpected
        ;; results. That would help me to improve my evaluation algorithm.
        
; 3) The 'bsr' instruction has issues resolving forward references.  If the
; label it jumps to has already been encountered in the code, then it works
; fine.  I usually end up changing the forward referencing 'bsr' stuff to 'jsr'
; instructions, and just be done with it.

        ;; Forward references are now working again. I had broken them when I
        ;; introduced the "JOB" and "JOBSR" instructions (pls. see below)
        ORG     $3000
        CPU     S12
        BSR     L3
L3      NOP

        ;; 

; 4) Comments after an instruction need to be prefixed by a semicolon, or they
; are considered part of the instruction.

        ;; That is something that is not correctly described in my
        ;; documentation. "*" actually only mark the beginning of a comment if
        ;; the "*" is the first non-whitespace character in the line. Otherwise
        ;; it could hardly be distinguished from a multiplication or the current
        ;; program counter.
        ;; I've updated the documentation.
        
; 5) Some duplicate instructions are not supported.  For example, the assembler
; will not recognize the 'lslw' instruction.  However this is the same as
; 'aslw', which the assembler does recognize.  So if the assembler complains
; about an instruction, see if it is a duplicate of something else.

        ;; That's funny, I've used the "Instruction Set Summary" (Table A-1) of
        ;; the CPU12/CPU12X Reference Manual to implement the assembler's
        ;; instruction table. The LSLW, LSLX, and LSLY instruction is missing in
        ;; there as well. These shift instructions have now been added to the
        ;; "S12X" opcode table.
        ORG     $5000
        CPU     S12X
        LSLW    $1234           ;extended address mode
        LSLW    $F,X            ;indexed address mode 5-bit offset
        LSLW    $FF,X           ;indexed address mode 9-bit offset
        LSLW    $FFF,X          ;indexed address mode 16-bit offset
        LSLW    [D,X]           ;index indirect address mode accu D offset
        LSLW    [1024,X]        ;index indirect address mode 16-bit offset
        LSLX
        LSLY

        ;; 

; 6) S2 records generated need to be checked carefully to make sure they are
; created to go into the correct place in memory.  Using the ORG instruction can
; be tricky, and will produce bad results if not done correctly.

        ;; The HSW12 assembler has two program counters to satisfy Gordon
        ;; Doughman's DBUG12 BDM pod. The DBUB12 requires a paged S-Record for
        ;; loading RAM content and a linear S-Record for programming the flash.
        ;; Therefore the HSW12 has a paged program counter which is is intended
        ;; to be used for the CPU's local address space (it is also used to
        ;; calculate relative branch addresses) and a linear program counter
        ;; which is intended to assign a physical address.
        ;; To avoid complicated translation tables, I've implemented an "ORG"
        ;; directive with two arguments.This makes it possible to assign each
        ;; opcode a logical address which corresponds to the CPU's program
        ;; counter and a physical address for loading the code into a memory.
        ;; To be able to compile old AS12 assembler code I've also implemented a
        ;; single argument "ORG". This one only requires a paged program counter
        ;; value and calculates the linear program counter according to the
        ;; translation table for the original S12 MCUs.
        ;; S12X MCUs and newer S12 MCUs (such as the S12P family) require a
        ;; different translation between paged and linear addresses. Software
        ;; written for these newer devices should not use the single argument
        ;; "ORG" directve.

; 7) The CALL instruction does not accept indirect indexing.  So something like
; "call [0,x]" will always result in an error generated.  The workaround is to
; manually put in the code with an FCB statement.

	;; This has been fixed. The CALL instruction can now with all address modes:
        CALL    $1234,$56       ;extended address mode
        CALL    $56_1234        ;extended address mode
        CALL    $F,X,$56        ;indexed address mode 5-bit offset
        CALL    $FF,X,$56       ;indexed address mode 9-bit offset
        CALL    $FFF,X,$56	;indexed address mode 16-bit offset
	CALL 	[D,x]		;indexed-indirect address mode accu D offset
	CALL 	[$FFF,x]	;indexed-indirect address mode 16-bit offset
	
; 8) The BRA instruction will change automatically to an LBRA instruction if the
; target address gets too far away.  This is generally a good thing, but it does
; add two extra bytes to the code.  So be aware of it if you end up needing to
; count bytes used by a routine.

        ;; There is a syntax to select direct or extended address mode:
        ;;      ">" selects extended mode
        ;;      "<" selects direct mode
        ;; I've now applied the same syntax to select 8 or 16 bit relative
        ;; address mode:                
        ;;      ">" selects 16 bit relative mode
        ;;      "<" selects  8 bit relative mode

        ORG     $8000
        CPU     S12
        BRA     *+5             ;BRA instruction
        BRA     *+500           ;LBRA instruction
        BRA     <(*+5)          ;force BRA instruction
        BRA     >(*+5)          ;force LBRA instruction
        ;BRA    <(*+500)        ;Error because the destination address is beyond
                                ;the 8 bit address range

        ;; Here is another convenience feature, which I prefer over the
        ;; automatic selection of BRA and LBRA:
        ;; A JMP instruction is shorter then a LBRA. So in my projects I want
        ;; the assembler to choose between a BRA and a JMP. For this purpose
        ;; I've made up a new mnemonic: "JOB" (jump or branch).  

        JOB     *+5             ;BRA instruction
        JOB     *+500           ;JMP instruction

        ;; Another mnemonic automatically chooses between BSR and JAR:
        ;; "JOBSR" (jump or branch subroutine)
        
        JOBSR   *+5             ;BSR instruction
        JOBSR   *+500           ;JSR instruction

        ;; 
        
; 9) By default, the assembler assumes direct page addressing for addresses
; starting in $00xx.  I do not know if this can be changed or not.

        ;; Actually I meant to implement a pseudo-opcode for selecting the
        ;; direct page along with the support for the S12X. I just somehow  
        ;; forgot to complete the implementation. It's in now.

        ORG     $9000
        CPU     S12X            ;This feature is only available for the S12X,
                                ;since the original S12 MCUs don't have a DIRECT 
                                ;page register
        SETDP   $12             ;set direct page to $12
        LDAA    $1234           ;direct address mode
        LDAA    >$1234          ;forced extended address mode
        LDAA    $5678           ;extended address mode
        SETDP   $56             ;set direct page to $56
        LDAA    $1234           ;extended address mode
        LDAA    $5678           ;direct address mode
        CPU     S12             ;the "SETDP" configuration is ignored S12
        LDAA    $5678           ;extended address mode
        LDAA    $0034           ;direct address mode
        CPU     S12X            ;switching back to the S12X restores the
                                ;previous direct page
        LDAA    $1234           ;extended address mode
        LDAA    $5678           ;direct address mode

        ;; 
        
; 10) MOV instructions do not take indirect addressing.  This fails:
; movw    2,y,[0,y]

        ;; This bug is fixed now: 

        ORG     $A000
        CPU     S12X            ;This address mode is only available
        MOVW    2,y,[0,y]       ; for the S12X

; New Feature: FCS - strings which are terminated by bit 7 in the last
; character:

        ORG	$B000
	FCC	"HELLO"
	FCS	"HELLO"

; New Feature: extended-indirect address mode "[ext]" which translates
; to PC relative indexed-indirect address mode:

  	ORG	$C000
       	CPU	S12X

	MOVW	#$12,     [IEXT1]
IEXT1	MOVW	#$1234,   [IEXT2]
IEXT2	MOVW	$1234,    [IEXT3]
IEXT3	MOVW	4,X+,     [IEXT4]
IEXT4	MOVW	$FF,X,    [IEXT5]
IEXT5	MOVW	$FFF,X,   [IEXT6]
IEXT6	MOVW	[D,X],    [IEXT7]
IEXT7	MOVW	[$FFF,X], [IEXT8]
IEXT8	MOVW	[IEXT9],  $1234
IEXT9	MOVW	[IEXT10], 4,X+
IEXT10	MOVW	[IEXT11], $FF,X
IEXT11	MOVW	[IEXT12], $FFF,X
IEXT12	MOVW	[IEXT13], [D,X]
IEXT13	MOVW	[IEXT14], [$FFF,X]
IEXT14	MOVW	[IEXT15], [IEXT15]
IEXT15

; Added string hack to allow semicolons inside strings

  	ORG	$D000

	FCS    /HELLO!/     ;any delimeter allowed if there is no semicolon in
	                    ; the string 
	FCS    ";HELLO!"    ;semicolon allowed inside " delimeters
	FCS    ';HELLO!'    ;semicolon allowed inside ' delimeters

*
*       HC11 test case
*
        CPU     HC11
        
char    equ     65
immed   equ     $72
dir     equ     $55
ext     equ     $1234
ind     equ     $37
small   equ     $e
mask    equ     %11001100
ROTATE000 EQU   $0188
ROTATE001 EQU   $8944
ROTATE002 EQU   $3333
ROTATE003 EQU   $4444
INDEX   EQU     3
*
*
*
        ORG             $1000
TEST1   EQU     1
TEST2   EQU     2
TEST3   EQU     3
TEST4   EQU     4
TEST5   EQU     5
TEST6   EQU     6
TEST7   EQU     7
TEST8   EQU     8
                                
#ifdef  TEST1
        ldaa    #TEST1
#ifdef  TEST2
        ldaa    #TEST2
#ifndef TEST3
        ldab    #TEST3
#ifdef  TEST4
        ldab    #TEST4
#endif
#ifdef  TEST5
        ldaa    #TEST5
*#ifdef TEST6
*       ldaa    #TEST6
*#ifdef TEST7
*       ldaa    #TEST7
*#ifdef TEST8
*       ldaa    #TEST8
*#endif
*#endif
*#endif
#else
        ldd     #3333
#ifdef  TEST7
        ldd     #7777
#else
        ldaa    #'N'
#endif                          
#endif
#else
        ldd     #3333
#ifdef  TEST17
        ldd     #7777
#else
        ldaa    #'N'
#endif                          
#endif
#endif
#endif  
*#endif         
        ORG             $4000
                                
#ifdef a4fn
#endif
#ifdef b32ff    
#endif
; funny ` test
; stinky `` test
;
happy`
        
        dw      2
        db      2
        dc.w    2
        dc.b    2
        fcb     2
        fdb     2222
        ds      34
        ds.b    34
        ds.w    34
        rmb     34
        rmw     34
bb equ 1
#ifdef aa
#endif
#ifdef aa
#endif
        
#ifdef aa
#endif
#ifdef bb
#endif
        bclr    dir,$55
        bclr    dir,#$55
        
        brset   dir,$55,*
        brset   dir,#$55,*
        
        bset    dir,$55
        bset    dir,#$55
        
        aba
        abx
        aby
        ALIGN   0
        adca    #immed
        adca    #immed
        adca    #immed
        adca    #immed
        adca    #immed
#ifndef dense
#else
#endif
        LOC 
        adca    ,x
        adca    ,y
reset
reset`
        adca    -1,x
*
* helwo warry bud
* hewe is you comment
*
        adca    -1,y
        jsr     *
        adca    -16,x
        adca    -16,y
        ALIGN   1
        adca    -17,x
        adca    -17,y
        ALIGN   3
        adca    -small,x
        ALIGN   7
        adca    -small,y
        adca    0,x
        adca    0,y
        adca    ext,x
        adca    ext,x
        adca    ext,x
        adca    ext,x
        adca    ext,x
        adca    1,x
        adca    1,y
        adca    125,x
        adca    125,y
        adca    15,x
        adca    15,y
        adca    16,x
        adca    16,y
        adca    dir
        adca    dir
        adca    ext
        adca    ext
        adca    ext,x
        adca    ext,y
        adca    small,x
        adca    small,y
        adcb    #immed
        adcb    dir
        adcb    ext
        adda    #immed
        adda    dir
        adda    ext
        adda    ext
        addb    #immed
        addb    dir
        addb    ext
        addd    #immed
        addd    dir
        addd    ext
        anda    #immed
        anda    dir
        anda    ext
        andb    #immed
        andb    dir
        andb    ext
        asl     dir
        asl     ext
        asla
        aslb
        asld
        asr     dir
        asr     ext
        asra
        asrb
        bcc     *
        bcs     *
        beq     *
        bge     *
        bgt     *
        bhi     *
        bita    #immed
        bita    dir
        bita    ext
        bitb    #immed
        bitb    dir
        bitb    ext
        ble     *
        bls     *
        blt     *
        bmi     *
        bne     *
        bpl     *
        bra     *
        brn     *
        bsr     *
        bvc     *
        bvs     *
        cba
        clc
        cli
        clr     dir
        clr     ext
        clra
        clrb
        clv
        cmpa    #immed
        cmpa    dir
        cmpa    ext
        cmpb    #immed
        cmpb    #immed
        cmpb    ,x
        cmpb    ,y
        cmpb    -1,x
        cmpb    -1,y
        cmpb    -16,x
        cmpb    -16,y
        cmpb    -17,x
        cmpb    -17,y
        cmpb    -small,x
        cmpb    -small,y
        cmpb    0,x
        cmpb    0,y
        cmpb    1,x
        cmpb    1,y
        cmpb    125,x
        cmpb    125,y
        cmpb    15,x
        cmpb    15,y
        cmpb    16,x
        cmpb    16,y
        cmpb    dir
        cmpb    dir
        cmpb    ext
        cmpb    ext
        cmpb    ext,x
        cmpb    ext,y
        cmpb    small,x
        cmpb    small,y
        com     ,x
        com     ,y
        com     -1,x
        com     -1,y
        com     -16,x
        com     -16,y
        com     -17,x
        com     -17,y
        com     -small,x
        com     -small,y
        com     0,x
        com     0,y
        com     1,x
        com     1,y
        com     125,x
        com     125,y
        com     15,x
        com     15,y
        com     16,x
        com     16,y
        com     dir
        com     ext
        com     ext
        com     ext,x
        com     ext,y
        com     small,x
        com     small,y
        coma
        comb
        cpd     #immed
        cpd     #immed
        cpd     ,x
        cpd     ,y
        cpd     -1,x
        cpd     -1,y
        cpd     -16,x
        cpd     -16,y
        cpd     -17,x
        cpd     -17,y
        cpd     -small,x
        cpd     -small,y
        cpd     0,x
        cpd     0,y
        cpd     1,x
        cpd     1,y
        cpd     125,x
        cpd     125,y
        cpd     15,x
        cpd     15,y
        cpd     16,x
        cpd     16,y
        cpd     dir
        cpd     dir
        cpd     ext
        cpd     ext
        cpd     ext,x
        cpd     ext,y
        cpd     small,x
        cpd     small,y
        cpx     #immed
        cpx     #immed
        cpx     ,x
        cpx     ,y
        cpx     -1,x
        cpx     -1,y
        cpx     -16,x
        cpx     -16,y
        cpx     -17,x
        cpx     -17,y
        cpx     -small,x
        cpx     -small,y
        cpx     0,x
        cpx     0,y
        cpx     1,x
        cpx     1,y
        cpx     125,x
        cpx     125,y
        cpx     15,x
        cpx     15,y
        cpx     16,x
        cpx     16,y
        cpx     dir
        cpx     dir
        cpx     ext
        cpx     ext
        cpx     ext,x
        cpx     ext,y
        cpx     small,x
        cpx     small,y
        cpy     #immed
        cpy     #immed
        cpy     ,x
        cpy     ,y
        cpy     -1,x
        cpy     -1,y
        cpy     -16,x
        cpy     -16,y
        cpy     -17,x
        cpy     -17,y
        cpy     -small,x
        cpy     -small,y
        cpy     0,x
        cpy     0,y
        cpy     1,x
        cpy     1,y
        cpy     125,x
        cpy     125,y
        cpy     15,x
        cpy     15,y
        cpy     16,x
        cpy     16,y
        cpy     dir
        cpy     dir
        cpy     ext
        cpy     ext
        cpy     ext,x
        cpy     ext,y
        cpy     small,x
        cpy     small,y
        daa
        dec     ,x
        dec     ,y
        dec     -1,x
        dec     -1,y
        dec     -16,x
        dec     -16,y
        dec     -17,x
        dec     -17,y
        dec     -small,x
        dec     -small,y
        dec     0,x
        dec     0,y
        dec     1,x
        dec     1,y
        dec     125,x
        dec     125,y
        dec     15,x
        dec     15,y
        dec     16,x
        dec     16,y
        dec     dir
        dec     ext
        dec     ext
        dec     ext,x
        dec     ext,y
        dec     small,x
        dec     small,y
        deca
        decb
        des
        dex
        dey
        eora    #immed
        eora    #immed
        eora    ,x
        eora    ,y
        eora    -1,x
        eora    -1,y
        eora    -16,x
        eora    -16,y
        eora    -17,x
        eora    -17,y
        eora    -small,x
        eora    -small,y
        eora    0,x
        eora    0,y
        eora    1,x
        eora    1,y
        eora    125,x
        eora    125,y
        eora    15,x
        eora    15,y
        eora    16,x
        eora    16,y
        eora    dir
        eora    dir
        eora    ext
        eora    ext
        eora    ext,x
        eora    ext,y
        eora    small,x
        eora    small,y
        eorb    #immed
        eorb    #immed
        eorb    ,x
        eorb    ,y
        eorb    -1,x
        eorb    -1,y
        eorb    -16,x
        eorb    -16,y
        eorb    -17,x
        eorb    -17,y
        eorb    -small,x
        eorb    -small,y
        eorb    0,x
        eorb    0,y
        eorb    1,x
        eorb    1,y
        eorb    125,x
        eorb    125,y
        eorb    15,x
        eorb    15,y
        eorb    16,x
        eorb    16,y
        eorb    dir
        eorb    dir
        eorb    ext
        eorb    ext
        eorb    ext,x
        eorb    ext,y
        eorb    small,x
        eorb    small,y
        fdiv
        idiv
        inc     ,x
        inc     ,y
        inc     -1,x
        inc     -1,y
        inc     -16,x
        inc     -16,y
        inc     -17,x
        inc     -17,y
        inc     -small,x
        inc     -small,y
        inc     0,x
        inc     0,y
        inc     1,x
        inc     1,y
        inc     125,x
        inc     125,y
        inc     15,x
        inc     15,y
        inc     16,x
        inc     16,y
        inc     dir
        inc     ext
        inc     ext
        inc     ext,x
        inc     ext,y
        inc     small,x
        inc     small,y
        inca
        incb
        ins
        inx
        iny
        jmp     ,x
        jmp     ,y
        jmp     -1,x
        jmp     -1,y
        jmp     -16,x
        jmp     -16,y
        jmp     -17,x
        jmp     -17,y
        jmp     -small,x
        jmp     -small,y
        jmp     0,x
        jmp     0,y
        jmp     1,x
        jmp     1,y
        jmp     125,x
        jmp     125,y
        jmp     15,x
        jmp     15,y
        jmp     16,x
        jmp     16,y
        jmp     dir
        jmp     ext
        jmp     ext
        jmp     ext,x
        jmp     ext,y
        jmp     small,x
        jmp     small,y
        jsr     ,x
        jsr     ,y
        jsr     -1,x
        jsr     -1,y
        jsr     -16,x
        jsr     -16,y
        jsr     -17,x
        jsr     -17,y
        jsr     -small,x
        jsr     -small,y
        jsr     0,x
        jsr     0,y
        jsr     1,x
        jsr     1,y
        jsr     125,x
        jsr     125,y
        jsr     15,x
        jsr     15,y
        jsr     16,x
        jsr     16,y
        jsr     dir
        jsr     dir
        jsr     ext
        jsr     ext
        jsr     ext
        jsr     ext,x
        jsr     ext,y
        jsr     small,x
        jsr     small,y
        ldaa    #immed
        ldaa    #immed
        ldaa    ,x
        ldaa    ,y
        ldaa    -1,x
        ldaa    -1,y
        ldaa    -16,x
        ldaa    -16,y
        ldaa    -17,x
        ldaa    -17,y
        ldaa    -small,x
        ldaa    -small,y
        ldaa    0,x
        ldaa    0,y
        ldaa    1,x
        ldaa    1,y
        ldaa    125,x
        ldaa    125,y
        ldaa    15,x
        ldaa    15,y
        ldaa    16,x
        ldaa    16,y
        ldaa    dir
        ldaa    dir
        ldaa    ext
        ldaa    ext
        ldaa    ext,x
        ldaa    ext,y
        ldaa    small,x
        ldaa    small,y
        ldab    #immed
        ldab    #immed
        ldab    ,x
        ldab    ,y
        ldab    -1,x
        ldab    -1,y
        ldab    -16,x
        ldab    -16,y
        ldab    -17,x
        ldab    -17,y
        ldab    -small,x
        ldab    -small,y
        ldab    0,x
        ldab    0,y
        ldab    1,x
        ldab    1,y
        ldab    125,x
        ldab    125,y
        ldab    15,x
        ldab    15,y
        ldab    16,x
        ldab    16,y
        ldab    dir
        ldab    dir
        ldab    ext
        ldab    ext
        ldab    ext,x
        ldab    ext,y
        ldab    small,x
        ldab    small,y
        ldd     #immed
        ldd     #immed
        ldd     ,x
        ldd     ,y
        ldd     -1,x
        ldd     -1,y
        ldd     -16,x
        ldd     -16,y
        ldd     -17,x
        ldd     -17,y
        ldd     -small,x
        ldd     -small,y
        ldd     0,x
        ldd     0,y
        ldd     1,x
        ldd     1,y
        ldd     125,x
        ldd     125,y
        ldd     15,x
        ldd     15,y
        ldd     16,x
        ldd     16,y
        ldd     dir
        ldd     dir
        ldd     ext
        ldd     ext
        ldd     ext,x
        ldd     ext,y
        ldd     small,x
        ldd     small,y
        lds     #immed
        lds     #immed
        lds     ,x
        lds     ,y
        lds     -1,x
        lds     -1,y
        lds     -16,x
        lds     -16,y
        lds     -17,x
        lds     -17,y
        lds     -small,x
        lds     -small,y
        lds     0,x
        lds     0,y
        lds     1,x
        lds     1,y
        lds     125,x
        lds     125,y
        lds     15,x
        lds     15,y
        lds     16,x
        lds     16,y
        lds     dir
        lds     ext
        lds     ext,x
        lds     ext,y
        lds     small,x
        lds     small,y
        ldx     #immed
        ldx     #immed
        ldx     ,x
        ldx     ,y
        ldx     -1,x
        ldx     -1,y
        ldx     -16,x
        ldx     -16,y
        ldx     -17,x
        ldx     -17,y
        ldx     -small,x
        ldx     -small,y
        ldx     0,x
        ldx     0,y
        ldx     1,x
        ldx     1,y
        ldx     125,x
        ldx     125,y
        ldx     15,x
        ldx     15,y
        ldx     16,x
        ldx     16,y
        ldx     dir
        ldx     dir
        ldx     ext
        ldx     ext
        ldx     ext,x
        ldx     ext,y
        ldx     small,x
        ldx     small,y
        ldy     #immed
        ldy     #immed
        ldy     ,x
        ldy     ,y
        ldy     -1,x
        ldy     -1,y
        ldy     -16,x
        ldy     -16,y
        ldy     -17,x
        ldy     -17,y
        ldy     -small,x
        ldy     -small,y
        ldy     0,x
        ldy     0,y
        ldy     1,x
        ldy     1,y
        ldy     125,x
        ldy     125,y
        ldy     15,x
        ldy     15,y
        ldy     16,x
        ldy     16,y
        ldy     dir
        ldy     dir
        ldy     ext
        ldy     ext
        ldy     ext,x
        ldy     ext,y
        ldy     small,x
        ldy     small,y
        lsl     ,x
        lsl     ,y
        lsl     -1,x
        lsl     -1,y
        lsl     -16,x
        lsl     -16,y
        lsl     -17,x
        lsl     -17,y
        lsl     -small,x
        lsl     -small,y
        lsl     0,x
        lsl     0,y
        lsl     1,x
        lsl     1,y
        lsl     125,x
        lsl     125,y
        lsl     15,x
        lsl     15,y
        lsl     16,x
        lsl     16,y
        lsl     dir
        lsl     ext
        lsl     ext
        lsl     ext,x
        lsl     ext,y
        lsl     small,x
        lsl     small,y
        lsla
        lslb
        lsld
        lsr     ,x
        lsr     ,y
        lsr     -1,x
        lsr     -1,y
        lsr     -16,x
        lsr     -16,y
        lsr     -17,x
        lsr     -17,y
        lsr     -small,x
        lsr     -small,y
        lsr     0,x
        lsr     0,y
        lsr     1,x
        lsr     1,y
        lsr     125,x
        lsr     125,y
        lsr     15,x
        lsr     15,y
        lsr     16,x
        lsr     16,y
        lsr     dir
        lsr     ext
        lsr     ext
        lsr     ext,x
        lsr     ext,y
        lsr     small,x
        lsr     small,y
        lsra
        lsrb
        lsrd
        lsrd
        mul
        neg     ,x
        neg     ,y
        neg     -1,x
        neg     -1,y
        neg     -16,x
        neg     -16,y
        neg     -17,x
        neg     -17,y
        neg     -small,x
        neg     -small,y
        neg     0,x
        neg     0,y
        neg     1,x
        neg     1,y
        neg     125,x
        neg     125,y
        neg     15,x
        neg     15,y
        neg     16,x
        neg     16,y
        neg     dir
        neg     ext
        neg     ext
        neg     ext,x
        neg     ext,y
        neg     small,x
        neg     small,y
        nega
        negb
        nop
        oraa    #immed
        oraa    #immed
        oraa    ,x
        oraa    ,y
        oraa    -1,x
        oraa    -1,y
        oraa    -16,x
        oraa    -16,y
        oraa    -17,x
        oraa    -17,y
        oraa    -small,x
        oraa    -small,y
        oraa    0,x
        oraa    0,y
        oraa    1,x
        oraa    1,y
        oraa    125,x
        oraa    125,y
        oraa    15,x
        oraa    15,y
        oraa    16,x
        oraa    16,y
        oraa    dir
        oraa    dir
        oraa    ext
        oraa    ext
        oraa    ext,x
        oraa    ext,y
        oraa    small,x
        oraa    small,y
        orab    #immed
        orab    #immed
        orab    ,x
        orab    ,y
        orab    -1,x
        orab    -1,y
        orab    -16,x
        orab    -16,y
        orab    -17,x
        orab    -17,y
        orab    -small,x
        orab    -small,y
        orab    0,x
        orab    0,y
        orab    1,x
        orab    1,y
        orab    125,x
        orab    125,y
        orab    15,x
        orab    15,y
        orab    16,x
        orab    16,y
        orab    dir
        orab    dir
        orab    ext
        orab    ext
        orab    ext,x
        orab    ext,y
        orab    small,x
        orab    small,y
        psha
        pshb
        pshx
        pshy
        pula
        pulb
        pulx
        puly
        rol     ,x
        rol     ,y
        rol     -1,x
        rol     -1,y
        rol     -16,x
        rol     -16,y
        rol     -17,x
        rol     -17,y
        rol     -small,x
        rol     -small,y
        rol     0,x
        rol     0,y
        rol     1,x
        rol     1,y
        rol     125,x
        rol     125,y
        rol     15,x
        rol     15,y
        rol     16,x
        rol     16,y
        rol     dir
        rol     ext
        rol     ext
        rol     ext,x
        rol     ext,y
        rol     small,x
        rol     small,y
        rola
        rolb
        ror     ,x
        ror     ,y
        ror     -1,x
        ror     -1,y
        ror     -16,x
        ror     -16,y
        ror     -17,x
        ror     -17,y
        ror     -small,x
        ror     -small,y
        ror     0,x
        ror     0,y
        ror     1,x
        ror     1,y
        ror     125,x
        ror     125,y
        ror     15,x
        ror     15,y
        ror     16,x
        ror     16,y
        ror     dir
        ror     ext
        ror     ext
        ror     ext,x
        ror     ext,y
        ror     small,x
        ror     small,y
        rora
        rorb
        rti
        rts
        sba
        sbca    #immed
        sbca    #immed
        sbca    ,x
        sbca    ,y
        sbca    -1,x
        sbca    -1,y
        sbca    -16,x
        sbca    -16,y
        sbca    -17,x
        sbca    -17,y
        sbca    -small,x
        sbca    -small,y
        sbca    0,x
        sbca    0,y
        sbca    1,x
        sbca    1,y
        sbca    125,x
        sbca    125,y
        sbca    15,x
        sbca    15,y
        sbca    16,x
        sbca    16,y
        sbca    dir
        sbca    dir
        sbca    ext
        sbca    ext
        sbca    ext,x
        sbca    ext,y
        sbca    small,x
        sbca    small,y
        sbcb    #immed
        sbcb    #immed
        sbcb    ,x
        sbcb    ,y
        sbcb    -1,x
        sbcb    -1,y
        sbcb    -16,x
        sbcb    -16,y
        sbcb    -17,x
        sbcb    -17,y
        sbcb    -small,x
        sbcb    -small,y
        sbcb    0,x
        sbcb    0,y
        sbcb    1,x
        sbcb    1,y
        sbcb    125,x
        sbcb    125,y
        sbcb    15,x
        sbcb    15,y
        sbcb    16,x
        sbcb    16,y
        sbcb    dir
        sbcb    dir
        sbcb    ext
        sbcb    ext
        sbcb    ext,x
        sbcb    ext,y
        sbcb    small,x
        sbcb    small,y
        sec
        sei
        sev
        staa    ,x
        staa    ,y
        staa    -1,x
        staa    -1,y
        staa    -16,x
        staa    -16,y
        staa    -17,x
        staa    -17,y
        staa    -small,x
        staa    -small,y
        staa    0,x
        staa    0,y
        staa    1,x
        staa    1,y
        staa    125,x
        staa    125,y
        staa    15,x
        staa    15,y
        staa    16,x
        staa    16,y
        staa    dir
        staa    dir
        staa    ext
        staa    ext
        staa    ext,x
        staa    ext,y
        staa    small,x
        staa    small,y
        stab    ,x
        stab    ,y
        stab    -1,x
        stab    -1,y
        stab    -16,x
        stab    -16,y
        stab    -17,x
        stab    -17,y
        stab    -small,x
        stab    -small,y
        stab    0,x
        stab    0,y
        stab    1,x
        stab    1,y
        stab    125,x
        stab    125,y
        stab    15,x
        stab    15,y
        stab    16,x
        stab    16,y
        stab    dir
        stab    dir
        stab    ext
        stab    ext
        stab    ext,x
        stab    ext,y
        stab    small,x
        stab    small,y
        std     ,x
        std     ,y
        std     -1,x
        std     -1,y
        std     -16,x
        std     -16,y
        std     -17,x
        std     -17,y
        std     -small,x
        std     -small,y
        std     0,x
        std     0,y
        std     1,x
        std     1,y
        std     125,x
        std     125,y
        std     15,x
        std     15,y
        std     16,x
        std     16,y
        std     dir
        std     dir
        std     ext
        std     ext
        std     ext,x
        std     ext,y
        std     small,x
        std     small,y
        stop
        sts     ,x
        sts     ,y
        sts     -1,x
        sts     -1,y
        sts     -16,x
        sts     -16,y
        sts     -17,x
        sts     -17,y
        sts     -small,x
        sts     -small,y
        sts     0,x
        sts     0,y
        sts     1,x
        sts     1,y
        sts     125,x
        sts     125,y
        sts     15,x
        sts     15,y
        sts     16,x
        sts     16,y
        sts     dir
        sts     ext
        sts     ext,x
        sts     ext,y
        sts     small,x
        sts     small,y
        stx     ,x
        stx     ,y
        stx     -1,x
        stx     -1,y
        stx     -16,x
        stx     -16,y
        stx     -17,x
        stx     -17,y
        stx     -small,x
        stx     -small,y
        stx     0,x
        stx     0,y
        stx     1,x
        stx     1,y
        stx     125,x
        stx     125,y
        stx     15,x
        stx     15,y
        stx     16,x
        stx     16,y
        stx     dir
        stx     dir
        stx     ext
        stx     ext
        stx     ext,x
        stx     ext,y
        stx     small,x
        stx     small,y
        sty     ,x
        sty     ,y
        sty     -1,x
        sty     -1,y
        sty     -16,x
        sty     -16,y
        sty     -17,x
        sty     -17,y
        sty     -small,x
        sty     -small,y
        sty     0,x
        sty     0,y
        sty     1,x
        sty     1,y
        sty     125,x
        sty     125,y
        sty     15,x
        sty     15,y
        sty     16,x
        sty     16,y
        sty     dir
        sty     dir
        sty     ext
        sty     ext
        sty     ext,x
        sty     ext,y
        sty     small,x
        sty     small,y
        suba    #immed
        suba    ,x
        suba    ,y
        suba    -1,x
        suba    -1,y
        suba    -16,x
        suba    -16,y
        suba    -17,x
        suba    -17,y
        suba    -small,x
        suba    -small,y
        suba    0,x
        suba    0,y
        suba    1,x
        suba    1,y
        suba    125,x
        suba    125,y
        suba    15,x
        suba    15,y
        suba    16,x
        suba    16,y
        suba    dir
        suba    ext
        suba    ext,x
        suba    ext,y
        suba    small,x
        suba    small,y
        subb    #immed
        subb    #immed
        subb    ,x
        subb    ,y
        subb    -1,x
        subb    -1,y
        subb    -16,x
        subb    -16,y
        subb    -17,x
        subb    -17,y
        subb    -small,x
        subb    -small,y
        subb    0,x
        subb    0,y
        subb    1,x
        subb    1,y
        subb    125,x
        subb    125,y
        subb    15,x
        subb    15,y
        subb    16,x
        subb    16,y
        subb    dir
        subb    dir
        subb    ext
        subb    ext
        subb    ext,x
        subb    ext,y
        subb    small,x
        subb    small,y
        subd    #immed
        subd    #immed
        subd    ,x
        subd    ,y
        subd    -1,x
        subd    -1,y
        subd    -16,x
        subd    -16,y
        subd    -17,x
        subd    -17,y
        subd    -small,x
        subd    -small,y
        subd    0,x
        subd    0,y
        subd    1,x
        subd    1,y
        subd    125,x
        subd    125,y
        subd    15,x
        subd    15,y
        subd    16,x
        subd    16,y
        subd    dir
        subd    dir
        subd    ext
        subd    ext
        subd    ext,x
        subd    ext,y
        subd    small,x
        subd    small,y
        swi
        tab
        tap
        tba
        tpa
        tst     ,x
        tst     ,y
        tst     -1,x
        tst     -1,y
        tst     -16,x
        tst     -16,y
        tst     -17,x
        tst     -17,y
        tst     -small,x
        tst     -small,y
        tst     0,x
        tst     0,y
        tst     1,x
        tst     1,y
        tst     125,x
        tst     125,y
        tst     15,x
        tst     15,y
        tst     16,x
        tst     16,y
        tst     dir
        tst     ext
        tst     ext
        tst     ext,x
        tst     ext,y
        tst     small,x
        tst     small,y
        tsta
        tstb
        tsx
        tsy
        txs
        tys
        wai
        xgdx
        xgdy

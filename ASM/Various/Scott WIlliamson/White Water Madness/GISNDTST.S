        DATA
REGDAT:
        DC.B    0,$B0
        DC.B    1,$2
        DC.B    2,$B1
        DC.B    3,$2
        DC.B    4,$B2
        DC.B    5,$2
        DC.B    6,$10
        DC.B    7,%11111000
        DC.B    8,$10
        DC.B    9,$10
        DC.B    10,$10
        DC.B    11,$00
        DC.B    12,$13
        DC.B    13,%0000
        DC.B    -1

        TEXT
REGSEL  =       $FF8800
REGW    =       $FF8802

        LEA     REGDAT,A0
LOADREGS:
        MOVE.B  (A0)+,D0
        CMP.B   #-1,D0
        BEQ     EXIT
        MOVE.B  D0,REGSEL
        MOVE.B  (A0)+,REGW
        BRA     LOADREGS
EXIT:
        JMP     EXIT


VBL:
        MOVE.B  #5,REGSEL
        MOVE.B  FREQC,REGW
        MOVE.B  #10,REGSEL
        MOVE.B  VOLC,REGW
        ADD.B   #2,VOLC
        CMP.B   #15,VOLC
        BLE     VOLCOK
        CLR.B   VOLC
VOLCOK



        END


 
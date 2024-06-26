; LIFE
; Version 0.22
; Haute r�solution.(160x100)
; Charge 1/16 d'image ou remplit al�atoirement l'�cran
; puis affiche les g�n�rations.
; "Delete": Recommencer.
; "Esc"   : Fin du programme.

 ILABEL GEM.BIB
 GEM_APP

 SCRN_GRES
 cmpi #2,D0
 bne FIN
 SCRN_GPBASE
 move.l D0,ECR_N
 PROG_SUPER #GETPALETTE
 bsr MSE_OFF
 SCRN_TEXT #AIDE,0,0
 SCRN_TEXT #AIDE2,0,0
 CONS_IN #2
choix_f: lea CHEMIN(PC),A3
 lea FICHIER(PC),A4
 clr.b (A4)
 bsr CLS
 bsr MSE_ON
 FILE_SELECT A3,A4,CHOIX
 bsr MSE_OFF
 bsr CLS
 tst CHOIX
 beq \1
 ;chargement
 bsr NOUV_CHEMIN
 tst D3
 bne \err
 FILE_OPEN #FICHIER,#0
 move D0,D3
 bmi \err
 move.l #32066,D4
 FILE_READ D3,D4,#IMG
 cmp.l D4,D0
 beq \2
 cmpi.l #32034,D0
 beq \2
\err clr CHOIX
 bra \1
\2 FILE_CLOSE D3
\1 lea palette(PC),A3
 tst CHOIX
 beq \3
 lea IMG+2(PC),A3
\3 SCRN_SPALETTE A3

 sf N_M
 ;initialiser ECR_M
 lea ECR_M+4+256,A0
 move.l A0,D0
 andi.l #$3FFF00,D0
 move.l D0,ECR_M

 ;init TAB_N
 tst CHOIX
 bne IMAGE

HAZARD: lea TAB_N+162+1,A3
 moveq #160/2-1,D3 ;col.
 moveq #100-1,D4   ;lign.
 move #$0F0F,D5    ;masque
\1 move #17,-(SP)
 trap #14
 addq #2,SP
 move D0,D1
 swap D0
 and D0,D1
 and D5,D1
 move D1,(A3)+
 dbra D3,\1
 moveq #160/2-1,D3
 addq #2,A3
 dbra D4,\1
 bra pres

IMAGE: ;IMG+34 ---> TAB_N
 lea IMG+34(PC),A0   ;A0=srce
 lea TAB_N+162+1,A1  ;A1=dest
 moveq #31,D0        ;D0=pix.
 moveq #160/32-1,D1  ;D1=col. de 32 pixels
 moveq #100-1,D2     ;D2=lign.
\nsp move.l (A0)+,D3 ;D3=bits
\2 btst D0,D3
 sne (A1)+
 dbra D0,\2
 moveq #31,D0
 dbra D1,\nsp
 moveq #160/32-1,D1
 adda #40,A0
 addq #2,A1
 dbra D2,\nsp

pres: bsr SPHERE
 bsr VOIR
 CONS_IN #2

LIFE:
 lea TAB_M+162+1,A0 ;A0=TAB srce
 lea TAB_N+162+1,A1 ;A1=TAB dest
 tst.b N_M
 beq \1
 lea TAB_N+162+1,A0
 lea TAB_M+162+1,A1
\1 move #160-1,D0   ;D0=col.
 move #100-1,D1     ;D1=lign.
 lea -162-1(A0),A2  ;A2=C-1|L-1
 lea     -1(A0),A3  ;A3=C-1
 lea  162-1(A0),A4  ;A4=C-1|L+1
 moveq #2,D3        ;D3=mort si <
 moveq #3,D4        ;D4=mort si >
\np clr D2          ;nbre de voisins
 tst.b (A2)+
 beq \2
 addq #1,D2
\2 tst.b (A2)
 beq \3
 addq #1,D2
\3 tst.b 1(A2)
 beq \4
 addq #1,D2
\4 tst.b (A3)+
 beq \5
 addq #1,D2
\5 tst.b 1(A3)
 beq \6
 addq #1,D2
\6 tst.b (A4)+
 beq \7
 addq #1,D2
\7 tst.b (A4)
 beq \8
 addq #1,D2
\8 tst.b 1(A4)
 beq \9
 addq #1,D2
\9 move.b (A0)+,D6
 cmp D3,D2
 blo \mort
 cmp D4,D2
 bhi \mort
 tst.b D6
 beq \10
\survie move.b D6,(A1)+
 bra \11

\10 cmp D4,D2
 bne \mort

\naissance st (A1)+
 bra \11

\mort sf (A1)+

\11 dbra D0,\np
 move #160-1,D0
 addq #2,A0
 addq #2,A1
 addq #2,A2
 addq #2,A3
 addq #2,A4
 dbra D1,\np

 bsr SPHERE
 bsr VOIR

attente: CONS_GINSTATE #2
 tst D0
 beq LIFE
 CONS_IN #2
 cmpi.b #27,D0
 seq D3
 beq EPILOGUE
 cmpi.b #127,D0
 beq EPILOGUE
 bra attente

EPILOGUE:
 bsr CLS
 SCRN_SET #-1,ECR_N,#-1
 SCRN_SPALETTE #palette_orig
 tst.b D3
 beq choix_f
 bsr MSE_ON
 bra FIN

SPHERE: ; report sph�rique
 lea TAB_N,A0
 tst.b N_M
 beq \1
 lea TAB_M,A0
\1 ;A0=TAB
 ;lign. -1 et 100
 lea 1(A0),A1
 move.l #100*162,D0
 moveq #160/4-1,D1
\L_1 move.l (A1,D0.L),(A1)+
 dbra D1,\L_1
 movea.l A0,A1
 adda.l #101*162+1,A1
 moveq #160/4-1,D1
 neg.l D0
\L100 move.l (A1,D0.L),(A1)+
 dbra D1,\L100
 ;col. -1 et 160
 lea 162(A0),A1
 move #100-1,D1
\C_1 move.b 160(A1),(A1)
 adda #162,A1
 dbra D1,\C_1
 lea 162+160+1(A0),A1
 move #100-1,D1
\C160 move.b -160(A1),(A1)
 adda #162,A1
 dbra D1,\C160
 rts

VOIR:
 lea TAB_N,A0
 movea.l ECR_N,A1
 tst.b N_M
 beq \1
 lea TAB_M,A0
 movea.l ECR_M,A1
\1 adda #162+1+4,A0  ;A0=srce
                     ;A1=dest
 movea.l A1,A3       ;A3=svg
 moveq #160/4-1,D0   ;D0=col. /4 car on traite 4 cellules
 moveq #100-1,D1     ;D1=lign.
\nsp move.b -(A0),D2 ;D2=1 cell.
 move.b -(A0),D3     ;D3=1 cell.
 move.b -(A0),D4     ;D4=1 cell.
 move.b -(A0),D5     ;D5=1 cell.
 lsr  #1,D2
 roxr #1,D6          ;D6=planbit
 asr  #1,D6
 asr  #1,D6
 asr  #1,D6
 lsr  #1,D3
 roxr #1,D6
 asr  #1,D6
 asr  #1,D6
 asr  #1,D6
 lsr  #1,D4
 roxr #1,D6
 asr  #1,D6
 asr  #1,D6
 asr  #1,D6
 lsr  #1,D5
 roxr #1,D6
 asr  #1,D6
 asr  #1,D6
 asr  #1,D6
 move D6,(A1)+ ;vidage
 addq #8,A0
 dbra D0,\nsp
 ;ligne � quadrupler
 moveq #3-1,D2
\4x lea -80(A1),A2
 moveq #80/16-1,D0
\2x move.l (A2)+,(A1)+
 move.l (A2)+,(A1)+
 move.l (A2)+,(A1)+
 move.l (A2)+,(A1)+
 dbra D0,\2x
 dbra D2,\4x

 addq #2,A0
 moveq #160/4-1,D0
 dbra D1,\nsp

 SCRN_SET #-1,A3,#-1
 not.b N_M
 rts

GETPALETTE: lea $FFFF8240,A0
 lea palette_orig(PC),A1
 moveq #15,D0
\1 move (A0)+,(A1)+
 dbra D0,\1
 rts

MSE_ON: GRAF_MOUSE #257,A0
 rts

MSE_OFF: GRAF_MOUSE #256,A0
 rts

CLS: CONS_OUT #2,#27
 CONS_OUT #2,#'E'
 rts

NOUV_CHEMIN: ;tenir compte du disque et du chemin
 ;E:A3=chemin  S:D3=erreur
 cmpi.b #'A',(A3)
 blo \1
 cmpi.b #'P',(A3)
 bhi \1
 clr D0
 move.b (A3),D0
 subi #'A',D0
 DISK_SET D0
 tst D0
 bmi \err
\1 ;chercher '\'
 movea.l A3,A0
 movea.l A0,A1 ;dernier'\'
 moveq #'\',D0
\3 moveq #12,D1
\4 cmp.b (A0)+,D0
 bne \2
 lea -1(A0),A1
 bra \3
\2 tst.b (A0)
 dbeq D1,\4
 lea PAD(PC),A2
 move.l A1,(A2)+
 move.b 1(A1),(A2)+
 clr.b 1(A1)
 DISK_SDIR A3
 lea PAD(PC),A2
 movea.l (A2)+,A0
 move.b (A2)+,1(A0)
 tst D0
 bmi \err
 clr D3
\f rts

\err neg D3
 bra \f

 _D
AIDE: DC.B 27,"H",10,10,10
 DC.B "         Charge 1/16 d'image ou  ",13,10
 DC.B "[Annuler]:Remplissage al�atoire. ",13,10,10
 DC.B " [Touche]:D�but.                 ",13,10,0
AIDE2 DC.B " [Delete]:Recommencer.           ",13,10
 DC.B "    [Esc]:Fin du programme.      ",0

CHEMIN: DC.B ".\*.PI1",0
 DS.B 64-8+1,0

palette DC.W $000,$200,$300,$400,$500,$600,$700,$732
        DC.W $742,$752,$652,$552,$770,$773,$775,$777
COUL DC.B 15

 _M
PAD DS.L 16
ECR_N DS.L 1
palette_orig DS.W 16
FICHIER DS.B 12+1
CHOIX DC.W 0
IMG DS.B 32066
DEG_NEO DS.B 1 ;drap.

N_M DS.B 1 ;indicateur Normal/Miroir
ECR_M DS.L 1
 DS.B 32000+256

 DS.B 1 ;"r�aligner" les TAB
TAB_N DS.B (160+2)*(100+2)
TAB_M DS.B (160+2)*(100+2)
 END
 
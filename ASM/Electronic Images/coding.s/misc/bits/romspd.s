	output	c:\auto\romspeed.prg

	movea.l	4(a7),a0
	movea.l	$C(a0),a1
	adda.l	$14(a0),a1
	adda.l	$1C(a0),a1
	lea	$100(a1),a1
	move.l	a1,l14A4EA
	pea	(a1)
	pea	(a0)
	clr.w	-(a7)
	move.w	#$4A,-(a7)
	trap	#1
	lea	$C(a7),a7
	clr.l	-(a7)
	move.w	#$20,-(a7)
	trap	#1
	addq.l	#6,a7
	move.l	d0,d4

	lea mytos,a0
	movea.l	a0,a1
	adda.l	#$7FFF8,a0
	move.l	-4(a0),d0
l14A16A	cmp.l	-(a0),d0
	beq.s	l14A16A
	addq.l	#4,a0
	suba.l	a1,a0
	pea	(a0)
	lea	$7FFF(a0),a0
	pea	(a0)
	move.w	#$48,-(a7)
	trap	#1
	addq.l	#6,a7
	movea.l	(a7)+,a0
l14A1A4	;tst.l	d0
	;beq	l14A242
	add.l	#$7FFF,d0
	and.w	#$8000,d0
	move.l	d0,l14A2F0
	exg	d0,a0
	lsr.l	#2,d0
	lea mytos,a1
l14A1D2	move.l	(a1)+,(a0)+
	subq.l	#1,d0
	bne.s	l14A1D2
	move.l	l14A2F0(pc),d0
	or.w	#5,d0
	;lea mytos,a0
	lea	$E00000,a0
l14A1F0	ptestr	#7,([8,a0]),#7,a0
	move.l	d0,(a0)
	pflusha
	move.l	d4,-(a7)
	move.w	#$20,-(a7)
	trap	#1
	addq.l	#6,a7
	move.w	#$FFFF,-(a7)
	move.w	#$4C,-(a7)
	trap	#1
l14A2EC	DC.B	$33,$2E,$31,$30
l14A2F0	DC.B	0,0,0,0
l14A2F4	DC.B	$D,$A,$1B,$70,$52,$4F,$4D,$53
	DC.B	$50,$45,$45,$44,$20,$56,$33,$2E
	DC.B	$31,$30,$20,$69,$6E,$73,$74,$61
	DC.B	$6C,$6C,$69,$65,$72,$74,$1B,$71
	DC.B	$D,$A,$BD,$20,$31,$39,$39,$33
	DC.B	$20,$62,$79,$20,$55,$77,$65,$20
	DC.B	$53,$65,$69,$6D,$65,$74,$D,$A
	DC.B	0
l14A32D	DC.B	$D,$A,$1B,$70,$52,$4F,$4D,$53
	DC.B	$50,$45,$45,$44,$20,$56,$33,$2E
	DC.B	$31,$30,$20,$69,$6E,$73,$74,$61
	DC.B	$6C,$6C,$65,$64,$1B,$71,$D,$A
	DC.B	$BD,$20,$31,$39,$39,$33,$20,$62
	DC.B	$79,$20,$55,$77,$65,$20,$53,$65
	DC.B	$69,$6D,$65,$74,$D,$A,0
l14A364	DC.B	$D,$A,$1B,$70,$52,$4F,$4D,$53
	DC.B	$50,$45,$45,$44,$20,$56,$33,$2E
	DC.B	$31,$30,$20,$69,$6E,$73,$74,$61
	DC.B	$6C,$6C,$82,$1B,$71,$D,$A,$BD
	DC.B	$20,$31,$39,$39,$33,$20,$70,$61
	DC.B	$72,$20,$55,$77,$65,$20,$53,$65
	DC.B	$69,$6D,$65,$74,$D,$A,0
l14A39B	DC.B	$D,$A,$52,$4F,$4D,$53,$50,$45
	DC.B	$45,$44,$20,$6E,$69,$63,$68,$74
	DC.B	$20,$69,$6E,$73,$74,$61,$6C,$6C
	DC.B	$69,$65,$72,$74,$21,$D,$A,0
l14A3BB	DC.B	$D,$A,$52,$4F,$4D,$53,$50,$45
	DC.B	$45,$44,$20,$6E,$6F,$74,$20,$69
	DC.B	$6E,$73,$74,$61,$6C,$6C,$65,$64
	DC.B	$21,$D,$A,0
l14A3D7	DC.B	$D,$A,$52,$4F,$4D,$53,$50,$45
	DC.B	$45,$44,$20,$70,$61,$73,$20,$69
	DC.B	$6E,$73,$74,$61,$6C,$6C,$82,$21
	DC.B	$D,$A,0
l14A3F2	DC.B	$D,$A,$52,$4F,$4D,$53,$50,$45
	DC.B	$45,$44,$20,$6C,$84,$75,$66,$74
	DC.B	$20,$6E,$75,$72,$20,$61,$75,$66
	DC.B	$20,$64,$65,$6D,$20,$41,$74,$61
	DC.B	$72,$69,$20,$54,$54,$20,$6F,$64
	DC.B	$65,$72,$20,$46,$61,$6C,$63,$6F
	DC.B	$6E,$30,$33,$30,$21,$D,$A,0
l14A42A	DC.B	$D,$A,$52,$4F,$4D,$53,$50,$45
	DC.B	$45,$44,$20,$72,$65,$71,$75,$69
	DC.B	$72,$65,$73,$20,$61,$6E,$20,$41
	DC.B	$74,$61,$72,$69,$20,$54,$54,$20
	DC.B	$6F,$72,$20,$46,$61,$6C,$63,$6F
	DC.B	$6E,$30,$33,$30,$21,$D,$A,0
l14A45A	DC.B	$D,$A,$52,$4F,$4D,$53,$50,$45
	DC.B	$45,$44,$20,$6E,$65,$20,$66,$6F
	DC.B	$6E,$63,$74,$69,$6F,$6E,$6E,$65
	DC.B	$20,$71,$75,$65,$20,$73,$75,$72
	DC.B	$20,$54,$54,$20,$6F,$75,$20,$46
	DC.B	$61,$6C,$63,$6F,$6E,$30,$33,$30
	DC.B	$21,$D,$A,0
l14A48E	DC.B	$D,$A,$45,$73,$20,$69,$73,$74
	DC.B	$20,$62,$65,$72,$65,$69,$74,$73
	DC.B	$20,$65,$69,$6E,$20,$4D,$4D,$55
	DC.B	$2D,$50,$72,$6F,$67,$72,$61,$6D
	DC.B	$6D,$20,$61,$6B,$74,$69,$76,$21
	DC.B	$D,$A,0
l14A4B9	DC.B	$D,$A,$4D,$4D,$55,$20,$61,$6C
	DC.B	$72,$65,$61,$64,$79,$20,$69,$6E
	DC.B	$20,$75,$73,$65,$21,$D,$A,0
l14A4D1	DC.B	$D,$A,$4D,$4D,$55,$20,$65,$73
	DC.B	$74,$20,$64,$82,$6A,$85,$20,$61
	DC.B	$63,$74,$69,$66,$21,$D,$A,0
	DC.B	$A
l14A4EA	DC.B	0,0,5,$EA
l14A4EE	DC.B	0,0
l14A4F0	DC.B	0,0,$E,$64,$E,$1C,$5E,$E
	DC.B	$3C,$E,$76,0,0,0,0,0
	EVEN
mytos	incbin tos162.dat

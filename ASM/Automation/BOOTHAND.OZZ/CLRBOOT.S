	PEA	NOTHING(PC)
	MOVE.W	#$9,-(A7)
	TRAP	#$01
	ADDQ.L	#6,A7
	RTS
	
;                    1234567890 < -            - > 0987654321
	
NOTHING	DC.B	"THIS IS A STANDARD CLEAR AUTOMATION BOOT",$D,$A
	DC.B	"  AS INCLUDED ON ALL AUTOMATION MENU'S",$D,$A
	DC.B	"        ISSUED FROM NUMBER 106!!",0 
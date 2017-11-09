IMPLEMENTATION MODULE Scsi;
(****************************************************************************
 *
 * SCSI-Zugriffe nach SCSI-2
 *
 * $Source: /dev/e/hm2/lib/se\RCS\SCSI.M,v $
 *
 * $Revision: 1.2 $
 *
 * $Author: Steffen_Engel $
 *
 * $Date: 1996/02/14 00:04:08 $
 *
 * $State: Exp $
 *
 *****************************************************************************
 * History:
 *
 * $Log: SCSI.M,v $
 * Revision 1.2  1996/02/14  00:04:08  Steffen_Engel
 * Korrektur bei Maskierung in SetCmd6: Maske 1F mu� Modulo 20 tragen.
 *
 * Revision 1.1  1996/02/03  19:33:48  S_Engel
 * Initial revision
 *
 *****************************************************************************
 * altes Modul: SCSI2.M
 *
 * Revision 1.5  1995/10/30  17:44:48  S_Engel
 * *** empty log message ***
 *
 * Revision 1.4  1995/04/13  13:46:56  S_Engel
 * Simple Senseauswertung mit GetError
 *
 * Revision 1.3  1995/02/10  12:38:10  S_Engel
 * Anpassungen an aktuellen SCSI-Driver
 *
 * Revision 1.2  1995/02/07  23:59:40  S_Engel
 * Umstellung auf handleorientierte SCSI-Routinen
 *
 * Revision 1.1  1995/01/01  19:14:46  S_Engel
 * Initial revision
 *
 *
 ****************************************************************************)


FROM SYSTEM   (* Type  *) IMPORT BYTE, ADDRESS,
              (* Proc  *) ADR, TSIZE;

IMPORT SYSTEM;

FROM Portab IMPORT UChar, Char;

IMPORT ScsiIO;

  FROM SYSTEM  IMPORT CODE;
  (* String f�r WHAT - leider ein bi�chen HM2-spezifisches *)
  CONST What = '@(#) Scsi2 '
               + CHR(SYSTEM.DATE DIV 1000000H DIV 10 + 48)
               + CHR(SYSTEM.DATE DIV 1000000H MOD 10 + 48) + '.'
               + CHR(SYSTEM.DATE DIV 10000H MOD 100H DIV 10 MOD 10 + 48)
               + CHR(SYSTEM.DATE DIV 10000H MOD 100H MOD 10 + 48) + '.'
               + CHR(SYSTEM.DATE MOD 10000H DIV 10 MOD 10 + 48)
               + CHR(SYSTEM.DATE MOD 10000H MOD 10 + 48)
               + '  (c) S. Engel';


(*------ Deklarationsteil *)

VAR
  Handle          : ScsiIO.tHandle; 
  SCmd            : ScsiIO.tSCSICmd;

(*------ Hilfsunterprogramme *)

PROCEDURE SetCmd6(Cmd :SHORTCARD;BlockAdr:LONGCARD;













PROCEDURE SetCmd10(Cmd :SHORTCARD;BlockAdr:LONGCARD;














PROCEDURE SetCmd12(Cmd : SHORTCARD; BlockAdr    : LONGCARD;













PROCEDURE SetCmd(VAR Cmd      : ARRAY OF SYSTEM.LOC;



















PROCEDURE TestUnitReady() : BOOLEAN;







PROCEDURE Inquiry(Buffer : ADDRESS; Vital : BOOLEAN; Page : SHORTCARD; TransLen : SHORTCARD) : BOOLEAN;


















PROCEDURE ModeSelect(SelectFlags  : tsSelectFlag;




















PROCEDURE ModeSense(PageCode       : SHORTCARD;




















PROCEDURE PreventMediaRemoval(Prevent:BOOLEAN) : BOOLEAN;











PROCEDURE GetError(reqbuff : ADDRESS) : ErrorType;















(*-------------------------------------------------------------------------*)
(*-                                                                       -*)
(*- Allgemeine Tools                                                      -*)
(*-                                                                       -*)
(*-------------------------------------------------------------------------*)

PROCEDURE Wait(Ticks : LONGCARD);








PROCEDURE SetBlockSize(NewLen : LONGCARD);






PROCEDURE GetBlockSize() : LONGCARD;






(*$E+*)
PROCEDURE MySetScsiUnit(handle : ScsiIO.tHandle; Lun: SHORTINT; MaxLen : LONGCARD);







(*$E=*)




BEGIN
  LogicalUnit:=0;
  SetBlockSize(ScsiIO.DmaBlockLen);
  SetScsiUnit := MySetScsiUnit;
  ScsiFlags := {};
END Scsi.
;******************************************************************************
;* Aufrufbibliothek f�r VMEM V1.1:                                            *
;*                                                                            *
;* Diese Bibliothek enth�lt s�mtliche Aufrufe, die f�r VMEM n�tig sind.       *
;* Die �bergabe der Parameter erfolgt hierbei haupts�chlich in Registern,     *
;* da VMEM zum gr��ten Teil in Turbo C geschrieben wurde.                     *
;*                                                                            *
;* Sollte jemand die Bibliothek z.B. f�r Pascal umschreiben wollen, so mu�    *
;* man folgendes beachten:                                                    *
;*                                                                            *
;* - die Funktion "cj_find" ermittelt den Cookiejar-Wert f�r den Cookie       *
;*   "VMEM". Hierzu wird das Register D0 mit dem Long "VMEM" und A0 mit       *
;*   der Adresse einer Long-Variablen initialisiert. Diese Long-Variable      *
;*   enth�lt nach erfolgreichem Aufruf die Adresse der VMEM-Service-Routine,  *
;*   die f�r jede Funktion aufgerufen werden mu�. Falls das Register D0 nach  *
;*   dem Aufruf einen Wert ungleich 0 enth�lt, so ist ein Fehler aufgetreten. *
;*                                                                            *
;* - der Aufruf einer Funktion ist �hnlich den Betriebssystemaufrufen, da     *
;*   der Inhalt der Register D0-D2 und A0-A1 danach ge�ndert sein kann !!     *
;*   Lieber vorher den Inhalt dieser Register retten.                         *
;*                                                                            *
;* - die ersten 4 Parameter, die keine Zeiger sind, werden in den Registern   *
;*   D0 - D3 �bergeben (int, long, V_ADR, usw.)                               *
;*                                                                            *
;* - ein Zeiger wird immer im Register A0 �bergeben                           *
;*                                                                            *
;* - die Funktionsnummer steht im Register D7 (32 Bit)                        *
;*                                                                            *
;* - ein Funktionsergebnis wird im Register D0 �bergeben, falls es sich um    *
;*   keinen Zeiger handelt. Ansonsten steht das Ergebnis im Register A0       *
;******************************************************************************

            EXPORT vm_config, vm_close, vm_info, vm_alloc
            EXPORT vm_free, vm_address, vm_fill, vm_copy
            EXPORT vm_load, vm_save, vm_write, vm_read, vm_clrcache

            IMPORT cj_find

COOKIE      equ "VMEM"

; Funktionsnummern:

VM_CONFIG   equ 0
VM_CLOSE    equ 1
VM_INFO     equ 2
VM_ALLOC    equ 3
VM_FREE     equ 4
VM_ADDRESS  equ 5
VM_FILL     equ 6
VM_COPY     equ 7   ; im Augenblick noch nicht verf�gbar !!!!
VM_LOAD     equ 8
VM_SAVE     equ 9
VM_WRITE    equ 10
VM_READ     equ 11
VM_CLRCACHE equ 12

;************************************
;* VM_CONFIG:                       *
;*                                  *
;* IN:   A0.l: Zeiger auf Parameter *
;* OUT:  D0.w: Returncode           *
;************************************
vm_config:
        move.l  d7,-(sp)

        pea     (a0)            ; A0 retten
        lea     adresse,a0      ; Platz f�r Cookie-Wert
        move.l  #COOKIE,d0      ; Cookie-Name
        jsr     cj_find         ; Cookie suchen
        move.l  (sp)+,a0        ; A0 restaurieren

        tst.w   d0              ; Cookie gefunden ??
        bne.b   error           ; nein => Fehler !!

        moveq   #VM_CONFIG,d7   ; Funktionsnummer
        move.l  adresse,a1      ; Adresse der Service-Routine
        jsr     (a1)            ; Routine aufrufen

error:  move.l  (sp)+,d7
        rts

error2: moveq   #-1,d0
        rts

;*************
;* VM_CLOSE: *
;*           *
;* IN:   --  *
;* OUT:  --  *
;*************
vm_close:
        move.l  d7,-(sp)
        moveq   #VM_CLOSE,d7    ; Funktionsnummer
        move.l  adresse,a1      ; Adresse der Service-Routine
        jsr     (a1)            ; Routine aufrufen
        move.l  (sp)+,d7
        rts

;*************************************
;* VM_INFO:                          *
;*                                   *
;* IN:   --                          *
;* OUT:  A0.l: Zeiger auf INFO-Daten *
;*************************************
vm_info:
        move.l  d7,-(sp)
        moveq   #VM_INFO,d7     ; Funktionsnummer
        move.l  adresse,a1      ; Adresse der Service-Routine
        jsr     (a1)            ; Routine aufrufen
        move.l  (sp)+,d7
        rts

;****************
;* VM_CLRCACHE: *
;*              *
;* IN:   --     *
;* OUT:  --     *
;****************
vm_clrcache:
        move.l  d7,-(sp)
        moveq   #VM_CLRCACHE,d7 ; Funktionsnummer
        move.l  adresse,a1      ; Adresse der Service-Routine
        jsr     (a1)            ; Routine aufrufen
        move.l  (sp)+,d7
        rts

;***********************
;* VM_ALLOC:           *
;*                     *
;* IN:   D0.l: Gr��e   *
;* OUT:  D0.l: Adresse *
;***********************
vm_alloc:
        move.l  d7,-(sp)
        moveq   #VM_ALLOC,d7    ; Funktionsnummer
        move.l  adresse,a1      ; Adresse der Service-Routine
        jsr     (a1)            ; Routine aufrufen
        move.l  (sp)+,d7
        rts

;**************************
;* VM_FREE:               *
;*                        *
;* IN:   D0.l: Adresse    *
;* OUT:  D0.w: Returncode *
;**************************
vm_free:
        move.l  d7,-(sp)
        moveq   #VM_FREE,d7     ; Funktionsnummer
        move.l  adresse,a1      ; Adresse der Service-Routine
        jsr     (a1)            ; Routine aufrufen
        move.l  (sp)+,d7
        rts

;***************************************
;* VM_ADDRESS:                         *
;*                                     *
;* IN:   D0.l: Adresse                 *
;*       A0.l: Zeiger auf Window-Gr��e *
;*       D1.w: Zugriffsmodus           *
;* OUT:  A0.l: Zeiger auf Window       *
;***************************************
vm_address:
        move.l  d7,-(sp)
        moveq   #VM_ADDRESS,d7  ; Funktionsnummer
        move.l  adresse,a1      ; Adresse der Service-Routine
        jsr     (a1)            ; Routine aufrufen
        move.l  (sp)+,d7
        rts

;***********************************
;* VM_FILL:                        *
;*                                 *
;* IN:   D0.l: Adresse             *
;*       D1.l: Anzahl der Bytes    *
;*       D2.w: F�llwert            *
;* OUT:  D0.l: tats�chliche Anzahl *
;***********************************
vm_fill:
        move.l  d7,-(sp)
        moveq   #VM_FILL,d7     ; Funktionsnummer
        move.l  adresse,a1      ; Adresse der Service-Routine
        jsr     (a1)            ; Routine aufrufen
        move.l  (sp)+,d7
        rts

;***********************************
;* VM_COPY:                        *
;*                                 *
;* IN:   D0.l: Quelladresse        *
;*       D1.l: Zieladresse         *
;*       D2.l: Anzahl der Bytes    *
;* OUT:  D0.l: tats�chliche Anzahl *
;***********************************
vm_copy:
        move.l  d7,-(sp)
        moveq   #VM_COPY,d7     ; Funktionsnummer
        move.l  adresse,a1      ; Adresse der Service-Routine
        jsr     (a1)            ; Routine aufrufen
        move.l  (sp)+,d7
        rts

;**************************************
;* VM_LOAD:                           *
;*                                    *
;* IN:   D0.l: Quelladresse           *
;*       A0.l: Zieladresse (Speicher) *
;*       D1.l: Anzahl der Bytes       *
;* OUT:  D0.l: tats�chliche Anzahl    *
;**************************************
vm_load:
        move.l  d7,-(sp)
        moveq   #VM_LOAD,d7     ; Funktionsnummer
        move.l  adresse,a1      ; Adresse der Service-Routine
        jsr     (a1)            ; Routine aufrufen
        move.l  (sp)+,d7
        rts

;***************************************
;* VM_SAVE:                            *
;*                                     *
;* IN:   A0.l: Quelladresse (Speicher) *
;*       D0.l: Zieladresse             *
;*       D1.l: Anzahl der Bytes        *
;* OUT:  D0.l: tats�chliche Anzahl     *
;***************************************
vm_save:
        move.l  d7,-(sp)
        moveq   #VM_SAVE,d7     ; Funktionsnummer
        move.l  adresse,a1      ; Adresse der Service-Routine
        jsr     (a1)            ; Routine aufrufen
        move.l  (sp)+,d7
        rts

;***********************************
;* VM_WRITE:                       *
;*                                 *
;* IN:   D0.w: Datei-Handle        *
;*       D1.l: Anzahl der Bytes    *
;*       D2.l: Quelladresse        *
;* OUT:  D0.l: tats�chliche Anzahl *
;***********************************
vm_write:
        move.l  d7,-(sp)
        moveq   #VM_WRITE,d7    ; Funktionsnummer
        move.l  adresse,a1      ; Adresse der Service-Routine
        jsr     (a1)            ; Routine aufrufen
        move.l  (sp)+,d7
        rts

;***********************************
;* VM_READ:                        *
;*                                 *
;* IN:   D0.w: Datei-Handle        *
;*       D1.l: Anzahl der Bytes    *
;*       D2.l: Zieladresse         *
;* OUT:  D0.l: tats�chliche Anzahl *
;***********************************
vm_read:
        move.l  d7,-(sp)
        moveq   #VM_READ,d7     ; Funktionsnummer
        move.l  adresse,a1      ; Adresse der Service-Routine
        jsr     (a1)            ; Routine aufrufen
        move.l  (sp)+,d7
        rts

        DATA

adresse:
        dc.l error2


DEBUG_TRACKLOAD=0

macro pushFDC,valeur
@ready
in a,(c)
jp p,@ready
ld a,{valeur}
inc c
out (c),a
dec c
mend

HISTORY=#1000

org #B800
run #B800

ld bc,#FB7E
ld hl,HISTORY-1
;*************************************************
                  FDC_read_id
;*************************************************
macro waitReady
@wait_ready0 in a,(c) : jp p,@wait_ready0
mend

ld e,9

.reloop
ld a,#4A : call push_fdc                  ; READ ID
.wait_ready0 in a,(c) : jp p,.wait_ready0
xor a : call push_fdc                     ; DRIVE
.wait_ready1 inc hl : in a,(c) : ld (hl),a : jp p,.wait_ready1 ; STATUS HISTORY
call GetResult
dec e
jr nz,.reloop

call Analyse_History

;*** calculs savants ***

ld hl,(Analyse_History.string_list): ld a,h : or l : jp z,.wrongFDC   ; must be many
ld a,h : or a : jr nz,.testnext
ld a,l : and %11100000 : jp z,.wrongFDC ; must be >32
.testnext
ld hl,(Analyse_History.string_list+4): ld a,h : or l : jp z,.wrongFDC ; must be many
ld a,h : cp 7 : jp c,.wrongFDC ; must be greater than 1800!

; cas hyper favorable
; 69x9+512x8=4654 => 13538 sur base 11us (#34E2)
; cas classique defavorable
; 6250-514=5736 => 16686 sur base 11us (#412E)
;
ld hl,(reallength) : ld a,h : cp #33 : jp c,.wrongFDC ; <#3300
cp #43 : jp nc,.wrongFDC ; >=#4300

ld bc,#A09
ld hl,(Analyse_History.string_list+8):  ld a,h : or a : jr nz,.wrongFDC : ld a,l : cp b : jr nc,.wrongFDC : ld e,a
ld hl,(Analyse_History.string_list+12): ld a,h : or a : jr nz,.wrongFDC : ld a,l : cp b : jr nc,.wrongFDC : add e : cp c : jr nz,.wrongFDC ; 9 sectors read
ld hl,(Analyse_History.string_list+16): ld a,h : or a : jr nz,.wrongFDC : ld a,l : cp b : jr nc,.wrongFDC : ld e,a
ld hl,(Analyse_History.string_list+20): ld a,h : or a : jr nz,.wrongFDC : ld a,l : cp b : jr nc,.wrongFDC : add e : ld e,a
ld hl,(Analyse_History.string_list+24): ld a,h : or a : jr nz,.wrongFDC : ld a,l : cp b : jr nc,.wrongFDC : add e : cp c : jr nz,.wrongFDC ; 9 sectors read
ld hl,(Analyse_History.string_list+28): ld a,h : or l : jr nz,.wrongFDC ; must be none!
ld hl,(Analyse_History.string_list+32): ld a,h : or l : jr nz,.wrongFDC ; must be none!

.goodFDC
ld a,3
jr .load
.wrongFDC
IF DEBUG_TRACKLOAD==1
ld b,9
ld hl,Analyse_History.string_list
.wrongloopinfo push bc,hl : call displayhexa16 : call displayCR : pop hl,bc : inc hl : inc hl: inc hl : inc hl : djnz .wrongloopinfo
jr $
ENDIF

ld a,7

.load
; all colors to dark blue
exx : ld bc,#7F01 : out (c),c : ld e,64+4 : out (c),e
inc c : out (c),c : out (c),e
inc c : out (c),c : out (c),e : exx

ld (track),a
ld hl,#C000
ld de,#DDDD ; one sector called #DD
ld bc,#FB7E
ld xh,4
.pic16k call read_sector : dec xh : jr nz,.pic16k

exx : ld a,#4B : ld c,#10 : out (c),c : out (c),a : ld c,3 : out (c),c : out (c),a : dec c
ld a,#47 : out (c),c : out (c),a : dec c
ld a,#4C : out (c),c : out (c),a : dec c
ld a,#54 : out (c),c : out (c),a : exx

;**************** load snapshot *****************
ld bc,#7FC0 : out (c),c
ld a,11 : ld (track),a
ld hl,#0000
ld de,#DDDD
ld bc,#FB7E
ld xh,5
.snaplow call read_sector : dec xh : jr nz,.snaplow

ld bc,#7FC5 : out (c),c : ld hl,#4000 : ld de,#DDDD : ld bc,#FB7E : ld xh,4
.snaphigh5 call read_sector : dec xh : jr nz,.snaphigh5

ld bc,#7FC6 : out (c),c : ld hl,#4000 : ld de,#DDDD : ld bc,#FB7E : ld xh,4
.snaphigh6 call read_sector : dec xh : jr nz,.snaphigh6

ld bc,#7FC7 : out (c),c : ld hl,#4000 : ld de,#DDDD : ld bc,#FB7E : ld xh,4
.snaphigh7 call read_sector : dec xh : jr nz,.snaphigh7

ld bc,#7FC0 : out (c),c
ld bc,#7F00+%10001101 : out (c),c

exx : ld hl,#C000 : exx
ld b,200
.razou
exx
ld de,hl : inc de : ld (hl),0 : ld bc,79 : ldir
ld de,-79+#800 : add hl,de
jr nc,.nexti
ld de,80-#4000
add hl,de
.nexti
ld b,0 : djnz $
exx
djnz .razou
ld bc,#FA7E : out (c),0
jp #100

;************ now load Music & GAME ****************************
ld a,11 : ld (track),a
exx : ld bc,#7FC4 : out (c),c : exx : ld hl,#4000
ld xh,4 : .loadC4 call read_sector : dec xh : jr nz,.loadC4
exx : ld bc,#7FC5 : out (c),c : exx : ld hl,#4000
ld xh,4 : .loadC5 call read_sector : dec xh : jr nz,.loadC5

exx : ld bc,#7FC7 : out (c),c : exx : ld hl,#4000
ld xh,4 : .loadC7 call read_sector : dec xh : jr nz,.loadC7

exx : ld bc,#7FC0 : out (c),c : exx : ld hl,#400 ; ??????????????????????????
ld xh,4 : .loadC0 call read_sector : dec xh : jr nz,.loadC0
jp #400

;************************************
;   Loading routines
;************************************
get_ET3
ld a,4 : call push_fdc
xor a : call push_fdc
call GetResult
ld a,(nbresult) : cp 1 : jr nz,get_ET3    ; result OK
ld a,(result+0) : and 32 : jr z,get_ET3   ; floppy inserted?
ld a,(result+0) : and 128 : jr nz,get_ET3 ; out of order?
ret

get_int_state
ld a,8 : call push_fdc
call GetResult
ret

calibrate
ld a,7 : call push_fdc
xor a : call push_fdc
.waitseek
call get_int_state
ld a,(nbresult) : cp 2 : jr nz,.waitseek ; tant qu'on n'a pas deux resultats
ld a,(result+0) : cp 32 : jr nz,.waitseek; et que ce n'est pas termine
; then seek_track again!
seek_track
ld a,15 : call push_fdc
xor a  : call push_fdc
ld a,(track) : call push_fdc
.waitseek
call get_int_state
ld a,(nbresult) : cp 2 : jr nz,.waitseek
ld a,(result+0) : cp 32 : jr nz,.waitseek
ld a,(track) : ld e,a
ld a,(result+1) : cp e : jr nz,calibrate ; violent mais bon...
ret

; HL=buffer dest
;---------------
; HL=byte next after buffer
read_sector
ld a,(track) : call seek_track
ld a,#46     : call push_fdc ; command
xor a        : call push_fdc ; drive
ld a,(track) : call push_fdc ; track
   inc a : ld (track),a
xor a        : call push_fdc ; head
ld a,#DD     : call push_fdc ; start sector
ld a,5       : call push_fdc ; sector size
ld a,#DD     : call push_fdc ; end sector
ld a,#4F     : call push_fdc ; GAP
ld a,5       : call push_fdc ; sector size again...
jr read_data.waitready

read_data
.store
inc c : ini : inc b : dec c
.waitready in a,(c) : jp p,.Waitready
and 32 : jr nz,.store

call GetResult

; check des erreurs
ld a,(nbresult) : cp 7 : jr nz,GURUDISPLAY
ld a,(result+0) ; ET0
and 128+64+16+8 ; => ERROR
cp #40
jr nz,GURUDISPLAY
ld a,(result+1) ; ET1
and 32+16+4+1 ; => ERROR
jr nz,GURUDISPLAY
ld a,(result+2) ; ET2
and 32+16 ; => ERROR
jr nz,GURUDISPLAY

; check returned track is track => @@TODO

ret

; A=valeur a envoyer
push_fdc
push af
.ready
in a,(c)
jp p,.ready
pop af
inc c
out (c),a
dec c
ret

GURUDISPLAY ld bc,#7F10 : out (c),c : ld a,64+12 : out (c),a : jr $


;*********************************************************************************
; tested on Nec-a2 & Zilog
; typical GETID #10,#10,...,#10,#10,[#30],#70,#70,#70,...,#70,#70,[#10],[#50],#D0
;*********************************************************************************
Analyse_History
ld de,HISTORY
sbc hl,de ; HL=log length for a revolution, should be max 6250x32/12 bytes or 16666 bytes
ld (reallength),hl
ld a,l : or a : jr z,.noadjust
inc h
.noadjust
ld (.loglength+1),hl
ld ix,.string_list

.loop_strings
ld a,(ix+0) : or a : ret z
ld iy,HISTORY
.loglength ld bc,#1234
exx : ld de,0 : exx
; push values to code
ld a,(ix+0) : inc ix : ld (.cmp1+1),a
ld a,(ix+0) : inc ix : ld (.cmp2+1),a
ld a,(ix+0) : inc ix : ld (.cmp3+1),a
ld a,(ix+0) : inc ix : ld (.cmp4+1),a
; init values
ld l,(iy+0)
ld h,(iy+1)
ld e,(iy+2)
ld d,(iy+3)
.compare
ld a,l : .cmp1 cp #20 : jr nz,.next
ld a,h : .cmp2 cp #20 : jr nz,.next
ld a,e : .cmp3 cp #20 : jr nz,.next
ld a,d : .cmp4 cp #20 : jr nz,.next
exx : inc de : exx ; count match!
.next
ld l,h : ld h,e : ld e,d : ld d,(iy+4) : inc iy
dec c
jr nz,.compare
djnz .compare
exx
ld (ix-4),e
ld (ix-3),d
exx
jr .loop_strings
;***************************
.string_list
defb #10,#10,#10,#10 ; many and >128 pour 9 secteurs
defb #70,#70,#70,#70 ; many and > 1800 dans le meilleur des cas
defb #10,#10,#70,#70 ; max 9
defb #10,#30,#70,#70 ; max 9
defb #70,#10,#10,#D0 ; max 9
defb #70,#10,#50,#D0 ; max 9
defb #70,#70,#10,#D0 ; max 9
defb #50,#50,#50,#50 ; none!
defb #30,#30,#30,#30 ; none!
defb 0
;***************************

; compact version for GetResult
GetResult
push de,hl
ld d,7 ; nombre MAX de valeurs a recuperer
ld hl,result
.wait_ready in a,(c) : jp p,.wait_ready ; attente du READY
and 64 : jr z,.done                ; doit-on recuperer quelque chose?
inc c : in a,(c) : dec c
ld (hl),a : inc hl ; store!
dec d
jr nz,.wait_ready
.done
ld a,7
sub d
ld (nbresult),a
pop hl,de
ret

IF DEBUG_TRACKLOAD==1
include 'displaychar.asm'
ENDIF

save"trackload.raw",#B800,2048

result     defs 7
nbresult   defb 0
track      defb 0
reallength defw 0

assert $<#C000




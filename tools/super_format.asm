; roudoudou / Resistance 2021

org #4000
run #4000

ld hl,str_motor : call print_string

;**************************************************
; wait for system to shut down floppy drive
;**************************************************
ld b,0 : halt : djnz $-1
         halt : djnz $-1
ld hl,str_motoron : call print_string
;**************************************************
; then start it! + delay
;**************************************************
ld bc,#FA7E : ld a,1 : out (c),c
ld b,0 : halt : djnz $-1

ld bc,#FB7E ; FDC I/O port

;**************************************************
; reinit values for multiple run
;**************************************************
xor a : ld (track),a : call calibrate
ld hl,TRACK_DEFINITION
ld (current_definition+1),hl

push bc : ld hl,str_is_calibrated : call print_string : pop bc


;**************************************************
;**************************************************
;**************************************************
;**************************************************
                  super_format
;**************************************************
;**************************************************
;**************************************************
;**************************************************
push bc,de,hl : ld hl,str_check : call print_string : pop hl,de,bc

;**************************************************
; check ET3 | floppy inserted and not protected
;**************************************************
ld a,4 : call push_fdc ; command
xor a  : call push_fdc ; drive
call GetResult
ld hl,msgerr4 : ld a,(nbresult) : cp 1 : jp nz,exit_ko
ld hl,msgerr5
ld a,(result) ; ET3
and #C0
jp nz,exit_ko

;**************************************************
; read definition for the track
;**************************************************
current_definition ld hl,#1234
ld e,(hl) : inc hl ; sector size
ld d,(hl) : inc hl ; nbsector
ld a,e : or d : jp z,exit_ok

;**************************************************
; seek track (may calibrate if not succeed)
;**************************************************
push bc,de,hl : ld hl,str_seek : call print_string : pop hl,de,bc
push bc : ld bc,#7F10 : out (c),c : ld c,64+19 : out (c),c : pop bc ; VERT VIF
push de,hl : call seek_track : pop hl,de ; seek on (track)
push bc,de,hl : ld hl,str_format : call print_string : pop hl,de,bc

di

push bc : ld bc,#7F10 : out (c),c : ld c,64+14 : out (c),c : pop bc ; ORANGE

;**************************************************
; format command
;**************************************************
ld a,#4D : call push_fdc          ; FORMAT command
ld a,0   : call push_fdc          ; drive
ld a,e   : call push_fdc          ; sector size
ld a,d   : call push_fdc          ; nbsector
ld a,(hl): call push_fdc : inc hl ; GAP

push bc : ld bc,#7F10 : out (c),c : ld c,64+12 : out (c),c : pop bc ; ROUGE

ld a,(hl): call push_fdc : inc hl ; filler

;**************************************************
; format sector execution
;**************************************************
.loopsector
ld a,(track) : call push_fdc          ; track
ld a,0       : call push_fdc          ; head
ld a,(hl)    : call push_fdc : inc hl ; ID
ld a,(hl)    : call push_fdc : inc hl ; sector size (used to read/write)
dec d
jr nz,.loopsector

push bc : ld bc,#7F10 : out (c),c : ld c,64+22 : out (c),c : pop bc ; VERT

ld (current_definition+1),hl

;**************************************************
; format result
;**************************************************
call GetResult
; check des erreurs
ld hl,msgerr1 : ld a,(nbresult) : cp 7 : jr nz,exit_ko
ld hl,msgerr2 : ld a,(result+0) ; ET0
and 128+64+16+8 ; => ERROR (no disk, calib faile, head unavailable)
jr nz,exit_ko
ld a,(result+0) ; ET0
and 32 ; terminated
jr nz,exit_ko
ld hl,msgerr3
ld a,(result+1) ; ET1
and 16+2 ; => ERROR (overrun or protected) => DO NOT CHECK END OF TRACK because we want to deformat some ;)
jr nz,exit_ko

push bc : ld bc,#7F10 : out (c),c : ld c,64+18 : out (c),c : pop bc ; VERT VIF

ld a,(track) : inc a : ld (track),a
ei
jp super_format


;**************************************************
;**************************************************
;**************************************************
exit_ok
ld hl,str_ok
call print_string
jr motoff

exit_ko
;ld hl,str_ko
call print_string

ld a,(nbresult) : ld d,a : call printA : inc d
dec d : jr z,motoff
ld a,(result) : call printA
dec d : jr z,motoff
ld a,(result+1) : call printA
dec d : jr z,motoff
ld a,(result+2) : call printA
dec d : jr z,motoff
ld a,(result+3) : call printA
dec d : jr z,motoff
ld a,(result+4) : call printA
dec d : jr z,motoff
ld a,(result+5) : call printA
dec d : jr z,motoff
ld a,(result+6) : call printA

motoff
ei
ld bc,#FA7E : out (c),0
ret

printA
push af
rrca : rrca : rrca : rrca : and #F : call printF
pop af
and #F
call printF
ld a,' '
jp #BB5A
printF
cp 10 : jr c,.digit
add 'A'-10
jp #BB5A
.digit
add '0'
jp #BB5A

print_string ld a,(hl) : or a : ret z
call #bb5A : inc hl : jr print_string

msgerr1 defb 13,10,'there was error during format: need 7 result bytes',13,10,0
msgerr2 defb 13,10,'there was error during format: ET0 is wrong',13,10,0
msgerr3 defb 13,10,'there was error during format: ET1 is wrong',13,10,0
msgerr4 defb 13,10,'there was error during format: GetET3 need 1 byte result',13,10,0
msgerr5 defb 13,10,'there was error during format: ET3 is wrong',13,10,0

str_ok defb 13,10,'everything went OK',13,10,0
str_motor defb 'waiting before motor ON',13,10,0
str_is_calibrated defb 'Calibration OK',13,10,0
str_motoron defb 'motor ON',13,10,0
str_format defb 'FRMT/',0
str_seek defb 'SK/',0
str_check defb 'CHK/',0

;************************************
;   FDC routines
;************************************
get_int_state
ld a,8 : call push_fdc
call GetResult
ret

calibrate
ld a,7 : call push_fdc
xor a : call push_fdc
.waitseek
call get_int_state
ld a,(nbresult) : cp 2 : jr nz,.waitseek ; a successful calibration returns 2 results
ld a,(result+0) : cp 32 : jr nz,.waitseek; ET0 must tell us it's over
; then seek_track again!

seek_track
ld a,15 : call push_fdc
xor a  : call push_fdc
ld a,(track) : call push_fdc
.waitseek
call get_int_state
ld a,(nbresult) : cp 2 : jr nz,.waitseek ; same as calibration
ld a,(result+0) : cp 32 : jr nz,.waitseek
ld a,(track) : ld e,a
ld a,(result+1) : cp e : jr nz,calibrate ; if we get a wrong track ID then calibrate!
ret

; A=value to push
push_fdc
push af
.ready
in a,(c)
jp p,.ready
and 64 : jr nz,GURUDISPLAY ; if FDC does not want our value then we are in a wrong state
pop af
inc c
out (c),a
dec c
ret

GURUDISPLAY ld bc,#7F10 : out (c),c : ld a,64+5 : out (c),a : jr $

; compact version for GetResult
GetResult
push de,hl
ld d,7 ; Max results to get
ld hl,result
.wait_ready in a,(c) : jp p,.wait_ready
and 64 : jr z,.done                ; is it a result?
inc c : in a,(c) : dec c
ld (hl),a : inc hl ; store it!
dec d
jr nz,.wait_ready
.done
ld a,7
sub d
ld (nbresult),a ; also store nbresult
pop hl,de
ret

result     defs 7
nbresult   defb 0
track      defb 0
reallength defw 0


TRACK_DEFINITION
; track-info => sector size / nbsector / GAP / filler
; then for each sector => sectorID,sectorsize
; end list by 0,0
; 
; size 0=>128 bytes 1=>256 2=>512 3=>1024 4=>2048 5=>4096 6=>will deformat track

;*************** TRACK 0 *************************************
defb 2,9,#52,#E5 ; sector size / nbsector / GAP / filler
defb #41,2,#42,2,#43,2,#44,2,#45,2,#46,2,#47,2,#48,2,#49,2 ; sectorID,sectorsize / sectorID,sectorsize / ...
;*************** TRACK 1 *************************************
defb 6,1,#50,#50
defb #66,6
;*************** TRACK 2 *************************************
defb 2,4,#52,#E5
defb #41,2,#42,2,#43,2,#44,2 ; track 2 | AMSDOS catalog
;*************** TRACK 3+ ************************************
repeat 38
defb 5,1,#50,#50
defb #50,5
rend
;*************************************************************
defb 0,0

;save'SUPERF.BIN',#4000,$-#4000,AMSDOS
;save'SUPERF.BIN',#4000,$-#4000,DSK,"super_format.dsk"




;*******************************************************************
; minimal CPM bootstrap
;
; 512 bytes maximum located in sector #41, side 0, track 0
;*******************************************************************

result=#100
org #100

bootstrap
;**********************************
      Motor_ON
;**********************************
ld a,1 : ld bc,(26<<8)+26
call #BC32 ; INK 1,26,26
ld hl,(12<<8)+12
call #BB75 ; LOCATE
ld hl,bootinfo
call print_string
;ld b,0 : halt : djnz $-1
;ld bc,#FA7E
;ld a,1
;out (c),a
;ld b,25 : halt : djnz $-1
di

ld sp,#B800
ld bc,#FB7E
;**********************************
      read_sector_command
;**********************************
ld hl,read_command
ld e,(hl) : inc hl
.loop
.waitready in a,(c) : jp p,.waitready
bit 6,a
jr nz,GURUDISPLAY
inc c
inc b
outi
dec c
dec e
jr nz,.loop

;**********************************
     read_sector_execution
;**********************************
ld hl,#B800
jr .waitready

.store
inc c : ini : inc b : dec c
.waitready in a,(c) : jp p,.waitready
and 32 : jr nz,.store

;******************************
         get_result
;******************************
ld d,7
ld hl,result
.waitready in a,(c) : jp p,.waitready
and 64 : jr z,.razremaining
inc c : in a,(c) : dec c
ld (hl),a : inc hl
dec d
jr nz,.waitready
ld a,7
jr .done
.razremaining
ld a,7 : sub d
.razloop ld (hl),0 : dec d : jr nz,.razloop
.done
; A=NBRESULT
; we ensure we got 7 results and no error
; check for overrun, wrong CRC, ID or hardware failure

cp 7 : jp nz,GURUDISPLAY
ld a,(result+0) ; ET0
and 128+64+16+8 ; => ERROR
cp #40 ; 01 => RW ended
jp nz,GURUDISPLAY
ld a,(result+1) ; ET1
and 32+16+4+1 ; => ERROR
jp nz,GURUDISPLAY
ld a,(result+2) ; ET2
and 32+16 ; => ERROR
jp nz,GURUDISPLAY
jp #B800

GURUDISPLAY
ld bc,#7F10 : out (c),c : ld a,64+12 : out (c),a
out (c),0 : ld e,64+28
.rasta out (c),a : out (c),e
jr .rasta


defb ' watch and learn pussy! '

read_command defb 9,#46,0,0,0,#42,2,#45,#4F,#FF ; 2K => #B800-#C000

bootinfo defb '= CP/M BOOTBLOCK =',13,10,0

print_string ld a,(hl) : or a : ret z : call #BB5A : inc hl : jr print_string

assert $<#300

save"bootsector.raw",#100,#200


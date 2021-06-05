buffer_adr=#8000

;****************************************
; contient les infos sur les tours
;****************************************
airmap   equ buffer_adr : buffer_adr+=256
posmap   equ buffer_adr : buffer_adr+=256
dirtmap1 equ buffer_adr : buffer_adr+=256
zeback   equ buffer_adr : buffer_adr+=256
dirtmap3 equ buffer_adr : buffer_adr+=256

;****************************************
; contient les infranchissables
;****************************************
zemap equ buffer_adr : buffer_adr+=256

;****************************************
; contient les deplacements possibles
;****************************************
depmap equ buffer_adr : buffer_adr+=256

;****************************************
; tampon pour fusion des deplacements
;****************************************
deptmp   equ buffer_adr : buffer_adr+=256
scantmp1 equ deptmp
scantmp2 equ buffer_adr : buffer_adr+=256
damage   equ buffer_adr : buffer_adr+=256
explomap equ buffer_adr : buffer_adr+=256
frostmap equ buffer_adr : buffer_adr+=256
airdamage equ buffer_adr : buffer_adr+=256
tower_struct equ buffer_adr : buffer_adr+=512

print "donnees de 8000 a ",{hex4}buffer_adr

SIZE_ENNEMY equ 9
myennemy equ buffer_adr : buffer_adr+=SIZE_ENNEMY*256

print "ennemy jusqu'a    ",{hex4}buffer_adr

jp restart
include 'printchar.asm'

fake_init ret

;******************************************************
                     restart
;******************************************************
ld bc,#BC00+12 : out (c),c : inc b : ld a,#10 : out (c),a
ld bc,#7FC0 : ld a,c : ld (currentbank),a : out (c),c
jp sheet ; => menu


;******************************************************
                     engine
;******************************************************
ld hl,#4000 : ld de,#4001 : ld bc,#6FFF : ld (hl),l : ldir
ld hl,#C000 : ld de,#C001 : ld bc,16383 : ld (hl),l : ldir

ld de,tower_struct
ld hl,#4000 : ld bc,64
.preca ex hl,de : ld (hl),e : inc h : ld (hl),d : dec h : inc l : jr z,.preca_end
ex hl,de : add hl,bc : jr .preca
.preca_end

ld de,#C000
ld a,2
.copyhudscreen
ld hl,hud
ld xl,2
.copyhudblock
ld xh,8
.copyhudline
ld bc,64 : ldir
ex hl,de : ld bc,#800-64 : add hl,bc : ex hl,de
dec xh
jr nz,.copyhudline
ex hl,de : ld bc,64-#4000 : add hl,bc : ex hl,de
dec xl
jr nz,.copyhudblock
ld de,#4000
dec a
jr nz,.copyhudscreen


call pageflip
; initialise background buffer

; A=tour (0=efface,1=tour, ...)
; B=X
; C=Y
;***********************************************
prepare_background
ld hl,zeback : ld (hl),l : ld de,zeback+1 : ld bc,255 : ldir : ld a,1 : ld (zeback+8*16),a : ld (zeback+8*16+15),a

ld a,1
ld hl,dirtmap1+16
ld de,dirtmap3+16
.loopdirt ld (hl),a : ld (de),a : inc l : inc e : jr nz,.loopdirt

ld a,241  : ld (wave_management.interwait+1),a
ld a,50   : ld (wave_management.wait+1),a : ld (refwait),a
ld a,1    : ld (wave_management.repet+1),a
which_wave=$+1 : ld hl,wave : ld (wave_management.current+1),hl
ld hl,MYENNEMY : ld (ennemy.plist),hl
xor a : ld (ennemy.pcpt),a

ld hl,0
ld (wave_number),hl

init_vector=$+1
call fake_init
call findpath

ld bc,#7F01 : out (c),c : ld c,#4C : out (c),c

;**************************************************************************************
;**************************************************************************************
;**************************************************************************************
;**************************************************************************************
                                      mainloop
;**************************************************************************************
;**************************************************************************************
;**************************************************************************************
;**************************************************************************************

call ennemy.manage
call manage_touret
call explosion

di
ld (.spback+1),sp
ld sp,posmap+256 : ld hl,0 : ld b,8
.raztable01 repeat 15 : push hl : rend : djnz .raztable01
ld sp,airmap+256 : ei : ld b,8 : di
.raztable02 repeat 15 : push hl : rend : djnz .raztable02
.spback ld sp,#1234 : ei



include 'control.asm'
include 'cursor.asm'

refresh_digit ld a,1 : or a : jr z,.nodigit
xor a : ld (refresh_digit+1),a

.which_HUD1 call #CDCD
call pageflip
.which_HUD2 call #CDCD

jr .skipflip

.nodigit
call pageflip
.skipflip



;*******************************************************************************
                             wave_management
;*******************************************************************************

.enable jp mainloop

.wait ld a,1 : dec a : ld (.wait+1),a : jp nz,mainloop
ld a,(refwait) : ld (.wait+1),a ; copy du backup poru les repetitions
.repet ld a,1 : dec a : ld (.repet+1),a : jr nz,.push_ennemy
; lecture de la table des vagues

.current ld hl,0 : ld a,(hl) : inc hl : or a : jp z,upgrade_ennemy ; compteur d'attente / 0=> upgrade
ld (refwait),a : .interwait ld a,241 : ld (.wait+1),a ; temps d'attente entre chaque vague
ld a,(hl) : ld (.repet+1),a : inc hl ; repetition des ennemis, lu depuis la table des vagues
ld e,(hl) : inc hl : ld d,(hl) : inc hl : ld (.current+1),hl : ld (.push_ennemy+1),de ; ennemy a pusher, lu de la table des vagues
ld hl,(wave_number) : inc hl : ld (wave_number),hl
.max_wave ld de,101 : xor a : sbc hl,de : jr z,winzegame
.back_on_track
ld a,l : and 15 : jp nz,mainloop
ld hl,reward
.inc_reward inc (hl) ; toutes les 16 vagues augmenter la recompense
jp mainloop

.push_ennemy call #1234
jp mainloop



;**************************************************************************************
				winzegame
;**************************************************************************************
call .msg : call pageflip : call .msg
ld h,50 : .titepause call waitfullvbl : dec h : jr nz,.titepause
.waitkey
call scanfullkeyboard
ld a,(KEY_ESC_BYTE) : and KEY_ESC : jp nz,restart
call anykey : jr z,.waitkey
call pageflip

ld hl,dirtmap1+16
ld de,dirtmap3+16
ld a,2
.clean ld (hl),a : ld (de),a : inc l : inc e : jr nz,.clean
jp wave_management.back_on_track
.msg
locate 23,6 : ld hl,str_congratulations : call printstring
locate 20,7 : victory_msg ld hl,str_wineasy : call printstring
locate 13,8 : ld hl,str_continue : call printstring
ret

;**************************************************************************************
;**************************************************************************************
;**************************************************************************************
;**************************************************************************************

upgrade_ennemy
ld (wave_management.current+1),hl : ld a,(hl) : or a : jp z,wave_loop
ld hl,(ennemy.lifeminiflyer+1) : .up1 ld bc,4  : add hl,bc : call c,.zemax : ld (ennemy.lifeminiflyer+1),hl
ld hl,(ennemy.lifefast+1)      : .up2 ld bc,5  : add hl,bc : call c,.zemax : ld (ennemy.lifefast+1),hl
ld hl,(ennemy.lifemini+1)      : .up3 ld bc,6  : add hl,bc : call c,.zemax : ld (ennemy.lifemini+1),hl
ld hl,(ennemy.lifeblob+1)      : .up4 ld bc,10 : add hl,bc : call c,.zemax : ld (ennemy.lifeblob+1),hl
ld hl,(ennemy.lifeflyer+1)     : .up5 ld bc,15 : add hl,bc : call c,.zemax : ld (ennemy.lifeflyer+1),hl
ld hl,(ennemy.lifeboss+1)      : .up6 ld bc,25 : add hl,bc : call c,.zemax : ld (ennemy.lifeboss+1),hl
ld a,(wave_management.interwait+1) : .dw1 sub 20 : jr c,.leaveone : ld (wave_management.interwait+1),a
.leaveone
ld a,1 : ld (wave_management.wait+1),a : ld (wave_management.repet+1),a; new refwait
ld hl,.up1+1 : call .upbc
ld hl,.up2+1 : call .upbc
ld hl,.up3+1 : call .upbc
ld hl,.up4+1 : call .upbc
ld hl,.up5+1 : call .upbc
ld hl,.up6+1 : call .upbc
jp wave_management.wait
.zemax : ld hl,#FFFF : ret
.upbc : ld c,(hl) : inc hl : ld b,(hl) : inc bc : ld (hl),b : dec hl : ld (hl),c : ret

endofgame
locate 19,7 : ld hl,str_youlose : call printstring
call pageflip
.waitkey call scanfullkeyboard
call anykey : jr z,.waitkey
.waitrelease call scanfullkeyboard
call anykey : jr nz,.waitrelease
jp restart

wave_loop
ld a,1   : ld (wave_management.wait+1),a
ld a,1   : ld (wave_management.repet+1),a
ld hl,wave : ld (wave_management.current+1),hl
jp mainloop



;*******************************************************************************
;                             page flipping
;*******************************************************************************

pageflip
; #7FC1 is 0,1,2,7 / display #C000 / dirtmap1
; #7FC3 is 0,3,2,7 / display #4000 / dirtmap3
ld b,#7F
.gaval ld a,#C3 : xor 2 : ld (.gaval+1),a : ld (currentbank),a ; tik tok between #C1 & #C3
out (c),a : ld d,a : xor 2
add a : add a : add a : add a : ld e,a
.waitint ld a,(cptmus) : cp 2 : jr c,.waitint : xor a : ld (cptmus),a
ld b,#F5 : .vbl : in a,(c) : rra : jr nc,.vbl
ld bc,#BC00+12 : out (c),c : inc b : out (c),e
ld a,d : and 2 : add hi(dirtmap1) : ld (current_dirtmap),a
call restore_background
ret

life defb 0

credit defw 0

confine 21
refund defb 0,0,5,12,25,45,25,50,75,100,50,100,150,200,25,50,100,150,200,50,125,250,255

confine 21
may_upgrade defb 0,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,1,0

confine 21
touret_upgrade_cost defb 0,0,15,25,40,0,50,50,100,0,100,200,250,0,50,100,150,0,150,200,250,0

confine 10
touret_list defw add_touret,add_frost,add_frost,add_touret,add_touret ; bash==frost missile==touret


cursor
.x defb 5
.y defb 1

include 'menu.asm'
include 'digit.asm'
include 'ennemy.asm'
include 'keyboard.asm'
include 'findpath.asm'
include 'background.asm'
include 'defense.asm'
include 'explosion.asm'

current_dirtmap defw 0
wave_number defw 0

wave
defb 30  : defb 11 : defw ennemy.add_mini
defb 30  : defb 21 : defw ennemy.add_mini
defb 30  : defb 11 : defw ennemy.add_blob
defb 30  : defb 21 : defw ennemy.add_blob
defb 20  : defb 11 : defw ennemy.add_fast
defb 20  : defb 11 : defw ennemy.add_miniflyer
defb 30  : defb 21 : defw ennemy.add_blob
defb 0

defb 25  : defb 31 : defw ennemy.add_mini
defb 30  : defb 21 : defw ennemy.add_blob
defb 20  : defb 21 : defw ennemy.add_fast
defb 30  : defb 41 : defw ennemy.add_mini
defb 20  : defb  2 : defw ennemy.add_flyer
defb 10  : defb  2 : defw ennemy.add_boss
defb 0

defb 20  : defb 11 : defw ennemy.add_mini
defb 10  : defb 21 : defw ennemy.add_fast
defb 20  : defb 11 : defw ennemy.add_miniflyer
defb 15  : defb 21 : defw ennemy.add_blob
defb 20  : defb  3 : defw ennemy.add_flyer
defb 10  : defb  3 : defw ennemy.add_boss
defb 0,0

refwait defb 30 ; duplicata pour les repetitions



strong_wave

defb 5  : defb 31 : defw ennemy.add_boss
defb 5  : defb 31 : defw ennemy.add_boss
defb 5  : defb 31 : defw ennemy.add_boss
defb 20 : defb 10 : defw ennemy.add_flyer
defb 5  : defb 31 : defw ennemy.add_boss
defb 5  : defb 31 : defw ennemy.add_boss
defb 20 : defb 10 : defw ennemy.add_flyer
defb 5  : defb 31 : defw ennemy.add_boss
defb 20 : defb 10 : defw ennemy.add_flyer
; very very very dirty
defb 2 : defb 2 : defw ennemy.null
defb 0,0






grouik


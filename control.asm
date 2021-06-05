;**************************************************************************************
                                interactivite
;**************************************************************************************
call scankeyboard

ld a,#12 : extended_keyz=$-1
or a
jp z,.noxkey


and KEY_T
jr z,.nox
;************************************************************
;                     select pellet
;************************************************************
xor a : ld (build.current_tower+1),a
ld hl,build+1 : inc (hl)
.nox

ld a,(extended_keyz)
and KEY_F
jr z,.noc
;************************************************************
;                     select frost
;************************************************************
ld a,4 : ld (build.current_tower+1),a
ld hl,build+1 : inc (hl)
.noc

ld a,(extended_keyz)
and KEY_B
jr z,.nob
;************************************************************
;                     select bash
;************************************************************
ld a,8 : ld (build.current_tower+1),a
ld hl,build+1 : inc (hl)
.nob

ld a,(extended_keyz)
and KEY_S
jr z,.nos
;************************************************************
;                     select swarm
;************************************************************
ld a,12 : ld (build.current_tower+1),a
ld hl,build+1 : inc (hl)
.nos

ld a,(extended_keyz)
and KEY_H
jr z,.noh
;************************************************************
;                     select hurricane
;************************************************************
ld a,16 : ld (build.current_tower+1),a
ld hl,build+1 : inc (hl)
.noh



ld a,(extended_keyz)
and KEY_U
jr z,.no_upgrade
;************************************************************
;                         upgrade
;************************************************************
ld hl,(cursor) : ld a,h : add a : add a : add a : add a : or l : ld l,a
ld h,hi(zeback) : ld a,(hl) : ld c,a : exa
ld b,hi(may_upgrade) : ld a,lo(may_upgrade) : add c : ld c,a : ld a,(bc) : or a : jr z,.no_upgrade
ld a,(hl)
exx
ld hl,touret_upgrade_cost : add l : ld l,a : ld e,(hl) : ld d,0 : ld hl,(credit) : xor a : sbc hl,de : jr nc,$+4 : jr .no_upgrade : ld (credit),hl

; on vient d'upgrader on met a jour le cost_upgrade
exx : ld a,(hl) : exx
ld hl,touret_upgrade_cost : add l : ld l,a :
ld a,(hl) : ld (cost_upgrade),a
 
exx
exa
inc (hl)
; A=case en cours toujours positif
ld (refresh_digit+1),a
;
dec a
ld b,a
 srl a : srl a : add a ; 0:tower 1:frost 2:bash 3:missile ...
 ld hl,touret_list : add l : ld l,a : ld e,(hl) : inc l : ld d,(hl)
 ld hl,.addend : push hl
ld a,b
ld hl,(cursor) : ld c,h : ld b,l
and 3
ex hl,de
jp (hl)
.addend


; wait for key release
.release call scankeyboard
ld a,(extended_keyz) : and KEY_U : jr nz,.release
.no_upgrade

;************************************************************
;                         delete
;************************************************************
ld a,(extended_keyz)
.allow_delete and KEY_D
jr z,.no_delete

ld (extended_display.refresh_xtended+1),a
ld hl,(cursor) : ld a,h : add a : add a : add a : add a : or l : ld l,a
ld h,hi(zeback) : ld a,(hl)
or a  : jr z,.no_delete
dec a : jr z,.no_delete
cp 21 : jr z,.no_delete
;
; => renflouer le pognon @TODO
;
ld a,(hl)
push hl
ld hl,refund : add l : ld l,a : ld a,(hl) : ld hl,(credit) : add l : ld l,a : ld a,h : adc 0 : ld h,a : ld (credit),hl
ld a,1 : ld (refresh_digit+1),a
pop hl
xor a
ld (hl),a
call findpath ; Always OK for delete!
.no_delete
 

.noxkey

;************************************************************
;                         cursor
;************************************************************
move_cursor
ld hl,cursor.x
ld e,#12 : keyboardbuffer=$-1

ld a,(hl)
or a
jr z,.noleft
ld a,e
and KEY_LEFT
jr z,.noleft
ld (extended_display.refresh_xtended+1),a
dec (hl)
.noleft

ld a,(hl)
cp 15
jr z,.noright
ld a,e
and KEY_RIGHT
jr z,.noright
ld (extended_display.refresh_xtended+1),a
inc (hl)
.noright

inc hl
ld a,(hl)
cp 1
jr z,.noup
ld a,e
and KEY_UP
jr z,.noup
ld (extended_display.refresh_xtended+1),a
dec (hl)
.noup

ld a,(hl)
cp 15
jr z,.nodown
ld a,e
and KEY_DOWN
jr z,.nodown
ld (extended_display.refresh_xtended+1),a
inc (hl)
.nodown


;*******************************************************************************
                                    space
;*******************************************************************************
;
; fire must be released before unleashing new ennemies
;
;
ld a,e
and KEY_FIRE
jp z,.skipdelay

.delay_release ld a,0 : or a : jr nz,.delayexit
inc a : ld (.delay_release+1),a
ld a,1 : ld (wave_management.wait+1),a
; enable waves!!! (if not already)
ld hl,wave_management.wait ; ENABLE WAVE
ld (wave_management.enable+1),hl
jr .delayexit
.skipdelay
xor a : ld (.delay_release+1),a
.delayexit

;*******************************************************************************
                                    esc
;*******************************************************************************
ld a,(extended_keyz)
and KEY_ESC_INGAME
jp nz,restart

;*******************************************************************************
                                   BUILD 
;*******************************************************************************
ld a,0 : or a : jp z,.nospace
xor a : ld (build+1),a

; SPACE!!! => MARCHE POOOOOOOOOOOO
ld hl,(cursor) : ld c,h : ld b,l
ld a,(current_dirtmap) : ld h,a
ld a,c : add a : add a : add a : add a : or b : ld l,a
ld a,(hl) : or a : jp nz,.nospace
ld h,hi(zeback) : ld a,(hl) : or a : jp nz,.nospace

;********* ajouter une tour ***************

; quelle est la selection courante
.current_tower ld a,0 ; 0->3
ld hl,.addlist : add l : ld l,a : ld a,(hl) : inc l : exx

; on met le cout demande au cas ou ca passe pas
ld (cost_upgrade),a 

ld hl,(credit) : ld (.back_credit+1),hl : ld d,0 : ld e,a : xor a : sbc hl,de : jr nc,.new_tower_ok : jr .notenough ; si on n'a pas l'argent, on ne fait rien
.new_tower_ok
ld (credit),hl
exx

ld de,(cursor) : ld c,d : ld b,e : xor a ; toujours commencer par l'indice ZERO
ld e,(hl) : inc l : ld d,(hl) : inc l : push hl
ld hl,.apply : push hl
ex hl,de
jp (hl)
.apply
pop hl
ld e,(hl) ; 2,6,10,14...

;********* apply tower **************
ld hl,cursor+1
ld a,(hl) : add a : add a : add a : add a : dec hl : or (hl) : ld l,a : ld h,hi(zeback) : ld (hl),e : push hl ; e=indice de tour

ld a,e : ld hl,touret_upgrade_cost : add l : ld l,a :
ld a,(hl) : ld (cost_upgrade),a

call findpath ; Z flag is KO / NZ is OK
pop hl
jr nz,.settour
ld bc,#7F10 : out (c),c : ld a,#4C : out (c),a
ld (hl),0
.back_credit : ld hl,#1234 : ld (credit),hl ; on remet l'argent
call findpath
jr z,$ ;=> ARG!!!!
ld bc,#7F54 : out (c),c
jr .nospace

confine 20
.addlist
defb 10  : defw add_touret : defb 2
defb 50  : defw add_frost  : defb 6
defb 100 : defw add_frost  : defb 10
defb 50  : defw add_air    : defb 14
defb 150 : defw add_air    : defb 18

.notenough
ld bc,#7F10 : out (c),c : ld a,64+28 : out (c),a
call scankeyboard : ld a,(keyboardbuffer) : or a : jr nz,.notenough : ld a,(extended_keyz) : or a : jr nz,.notenough
ld bc,#7F00+64+20 : out (c),c

.settour
ld a,1 : ld (refresh_digit+1),a
.nospace





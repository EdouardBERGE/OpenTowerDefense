

; scan du tableau et execution

; pool des listes en bank 4 => on peut avoir 64 points par tour => NB, p1,p2,p3,p4,p5



; a partir du XY on se positionne dans le cache de hwikaa
macro compute_cache_location
ld a,c : add a : add a : add a : add a : or b : ld d,a : ld e,0 : srl de : srl de : set 6,d ; XY x 64 => DE
mend




;******** bash is same as frost for range *******************
; B=X
; C=Y
; A=0,1,2 ; level ou type tour?
add_frost
exa
push bc : ld bc,#7FC4 : ld a,c : ld (currentbank),a : out (c),c : pop bc
compute_cache_location (void) ; XYx64 => DE
inc e

exa : add a : ld hl,.frost_list : add l : ld l,a : ld a,(hl) : ld lx,a : inc l : ld a,(hl) : ld hx,a

ld a,(ix+0) : inc ix
ld yl,a : ld yh,e
.loop_on_position
ld a,b : add (ix+0) : and #F0 : jr nz,.clipping ; 0=>15
ld a,c : add (ix+1) : ld l,a : and #F0 : jr nz,.clipping : or l : jr z,.clipping ; 1=>15
push bc
ld a,c : add (ix+1) : add a : add a : add a : add a : ld c,a : ld a,b : add (ix+0) : or c ; X+dep Y+dep => A
pop bc
ld (de),a : inc e ; manque une verif de dispo (ou on s'en fout...)
.clipping
inc ix : inc ix
dec yl
jr nz,.loop_on_position
ld a,e : sub yh
ld e,yh : dec e
ld (de),a ; poke du compteur (0 ou plus)

;
; update des tours adjacentes @TODO
;
ld b,#7F : ld a,(pageflip.gaval+1) : ld (currentbank),a : out (c),a
ret

confine 8
.frost_list defw frost_level12,frost_level12,frost_level34,frost_level34



;******** missile is same as touret for range *******************
; B=X
; C=Y
; A=0,1,2,3 ; level ou type tour?
add_air
ld hl,add_touret_generic.air_list
jr add_touret_generic

add_touret ; indice 2,3 et 4
ld hl,add_touret_generic.touret_list
add_touret_generic
exa
push bc : ld bc,#7FC4 : ld a,c : ld (currentbank),a : out (c),c : pop bc
compute_cache_location (void) ; XYx64 => DE
inc e

exa : add a : /* ld hl,.touret_list */ : add l : ld l,a : ld a,(hl) : ld lx,a : inc l : ld a,(hl) : ld hx,a

ld a,(ix+0) : inc ix
ld yl,a : ld yh,e
.loop_on_position
ld a,b : add (ix+0) : and #F0 : jr nz,.clipping ; 0=>15
ld a,c : add (ix+1) : ld l,a : and #F0 : jr nz,.clipping : or l : jr z,.clipping ; 1=>15
push bc
ld a,c : add (ix+1) : add a : add a : add a : add a : ld c,a : ld a,b : add (ix+0) : or c ; X+dep Y+dep => A
pop bc
ld (de),a : inc e ; manque une verif de dispo (ou on s'en fout...)
.clipping
inc ix : inc ix
dec yl
jr nz,.loop_on_position
ld a,e : sub yh
ld e,yh : dec e
ld (de),a ; poke du compteur (0 ou plus)

;
; update des tours adjacentes @TODO
;
ld b,#7F : ld a,(pageflip.gaval+1) : ld (currentbank),a : out (c),a
ret

confine 8
.touret_list defw touret_level1,touret_level23,touret_level23,touret_level4
confine 2
.air_list defw touret_level23 ;,touret_level23,touret_level23,touret_level4 ; AIR touret begin with cool area

frost_level12
touret_level1
defb 8 ; 8
defb 1,1, 1,0, 1,-1, 0,-1, -1,-1, -1,0, -1,1, 0,1

frost_level34
touret_level23
defb 8+12 ; 20
defb 2,0,0,2,0,-2,-2,0
defb 2,1,2,-1,1,2,1,-2,-1,2,-1,-2,-2,1,-2,-1
defb 1,1, 1,0, 1,-1, 0,-1, -1,-1, -1,0, -1,1, 0,1

touret_level4
defb 8+12+16 ; 36
defb 3,0,-3,0,0,3,0,-3
defb 3,1,3,-1,-3,1,-3,-1,1,3,1,-3,-1,3,-1,-3
defb 2,2,2,-2,-2,2,-2,-2
defb 2,0,0,2,0,-2,-2,0
defb 2,1,2,-1,1,2,1,-2,-1,2,-1,-2,-2,1,-2,-1
defb 1,1, 1,0, 1,-1, 0,-1, -1,-1, -1,0, -1,1, 0,1

manage_touret

di
ld (.spback+1),sp
ld sp,damage+256 : ld hl,0 : ld b,8
.raztable01 repeat 15 : push hl : rend : djnz .raztable01
ld sp,airdamage+256 : ei : ld b,8 : di
.raztable02 repeat 15 : push hl : rend : djnz .raztable02
.spback ld sp,#1234 : ei

ld bc,#7FC4 : ld a,c : ld (currentbank),a : out (c),c

;.phase ld a,0 : add #10 : and #F0 : jr nz,.inca : add #10
;.inca ld (.phase+1),a ; #10=>#F0 en #10

.curlist ld ix,.list1

ld d,hi(zeback)
ld h,hi(.jump)
ld c,3
.loopline
ld e,(ix+0) : inc lx
ld b,16
.reloop
ld a,(de) : add a : add lo(.jump) : ld l,a : ld a,(hl) : inc l : ld h,(hl) : ld l,a : jp (hl)
.beforenext
exx
ld h,hi(explomap) : ld l,e : ld (hl),6+8 ; gonflement de la tour
.next
ld h,hi(.jump)
inc e
djnz .reloop
dec c
jr nz,.loopline
ld a,(ix+0) : ld (.curlist+2),a

ld b,#7F : ld a,(pageflip.gaval+1) : ld (currentbank),a : out (c),a

;*******************************
;       update frost
;*******************************
ld de,(.curlist+2)
ld h,hi(frostmap)
ld c,3
.loopline2
ld a,(de) : inc e : ld l,a
repeat 16,cpt
ld a,(hl) : or a : jr .next_{cpt} : dec (hl) : .next_{cpt} : if cpt<16 : inc l : endif
rend
dec c
jr nz,.loopline2

ret

confine 20
.list1 defb 16, 96,176,lo(.list2)
.list2 defb 48,128,208,lo(.list3)
.list3 defb 80,160,240,lo(.list4)
.list4 defb 32,112,192,lo(.list5)
.list5 defb 64,144,224,lo(.list1)


confine 46
.jump
defw .next
defw .next
defw manage_touret1 ;1
defw manage_touret1 ;2
defw manage_touret2 ;3 +2 degats
defw manage_touret2 ;4 +2 degats

defw manage_frost1
defw manage_frost2
defw manage_frost2
defw manage_frost3

defw manage_bash1
defw manage_bash2
defw manage_bash2
defw manage_bash3

defw manage_swarm1
defw manage_swarm2
defw manage_swarm3
defw manage_swarm4

defw manage_hurricane1
defw manage_hurricane2
defw manage_hurricane3
defw manage_hurricane3
defw .next

macro init_tower
ld h,hi(explomap) : ld l,e : ld a,(hl) : or a : jp nz,manage_touret.next
ld a,e : exx
; DEPRECATED ld h,a : ld l,0 : srl hl : srl hl : set 6,h ; XY x 64 => HL in 13 nops
ld h,hi(tower_struct) : ld l,a : ld a,(hl) : inc h : ld h,(hl) : ld l,a ; 9 nops
ld b,(hl) : inc l
mend

macro make_frost,intensity
init_tower (void)
ld d,hi(posmap)
.searchtarget ld e,(hl) : ld a,(de) : dec a : jr z,.found : inc l : djnz .searchtarget : exx : jp manage_touret.next
.found
; deux choses à faire ; infliger des degats ; lancer une animation d'explosion
ex hl,de : ld h,hi(frostmap) : ld (hl),{intensity}
jp manage_touret.beforenext
mend

manage_frost1 make_frost 2
manage_frost2 make_frost 4
manage_frost3 make_frost 7

macro make_touret,intensity
init_tower (void)
ld d,hi(posmap)
.searchtarget ld e,(hl) : ld a,(de) : dec a : jr z,.found : inc l : djnz .searchtarget : exx : jp manage_touret.next
.found
; deux choses à faire ; infliger des degats ; lancer une animation d'explosion
ex hl,de : ld h,hi(explomap) : ld (hl),8 : dec h
if {intensity}==1
inc (hl)
jp nz,manage_touret.beforenext
else
ld a,(hl)
add {intensity}
ld (hl),a
jp nc,manage_touret.beforenext
endif
ld (hl),255
jp manage_touret.beforenext
mend

manage_touret1 make_touret 1
manage_touret2 make_touret 2


macro make_bash,intensity
init_tower (void)
ld d,hi(posmap)
.searchtarget ld e,(hl) : ld a,(de) : dec a : jr z,.found : inc l : djnz .searchtarget : exx : jp manage_touret.next
.researchtarget ld e,(hl) : ld a,(de) : dec a : jr z,.found : inc l : djnz .researchtarget : jp manage_touret.beforenext
.found
; deux choses à faire ; infliger des degats ; lancer une animation d'explosion
ex hl,de : ld h,hi(explomap) : ld (hl),8 : dec h : ld a,(hl) : add {intensity} : jr c,.ovf : ld (hl),a : ex hl,de : ld d,hi(posmap) : inc l : djnz .researchtarget : jp manage_touret.beforenext
.ovf
ld (hl),255
ex hl,de : ld d,hi(posmap)
inc l
djnz .researchtarget
jp manage_touret.beforenext
mend

manage_bash1 make_bash 2
manage_bash2 make_bash 3
manage_bash3 make_bash 4


macro make_swarm,intensity
init_tower (void)
ld d,hi(airmap)
.searchtarget ld e,(hl) : ld a,(de) : dec a : jr z,.found : inc l : djnz .searchtarget : exx : jp manage_touret.next
.found
; deux choses à faire ; infliger des degats ; lancer une animation d'explosion
ex hl,de : ld h,hi(explomap) : ld (hl),8 : ld h,hi(airdamage) : ld a,(hl) : add {intensity} : ld (hl),a : jp nc,manage_touret.beforenext
ld (hl),255
jp manage_touret.beforenext
mend

manage_swarm1 make_swarm 3
manage_swarm2 make_swarm 6
manage_swarm3 make_swarm 9
manage_swarm4 make_swarm 12


macro make_hurricane,intensity
init_tower (void)
ld d,hi(airmap)
.searchtarget ld e,(hl) : ld a,(de) : dec a : jr z,.found : inc l : djnz .searchtarget : exx : jp manage_touret.next
.researchtarget ld e,(hl) : ld a,(de) : dec a : jr z,.found : inc l : djnz .researchtarget : jp manage_touret.beforenext
.found
; deux choses à faire ; infliger des degats ; lancer une animation d'explosion
ex hl,de : ld h,hi(explomap) : ld (hl),8 : ld h,hi(airdamage) : ld a,(hl) : add {intensity} : jr c,.ovf : ld (hl),a : ex hl,de : ld d,hi(posmap) : inc l : djnz .researchtarget : jp manage_touret.beforenext
.ovf
ld (hl),255
ex hl,de : ld d,hi(posmap)
inc l
djnz .researchtarget
jp manage_touret.beforenext
mend

manage_hurricane1 make_hurricane 4
manage_hurricane2 make_hurricane 8
manage_hurricane3 make_hurricane 12


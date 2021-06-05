
ennemy

; fake ennemy looking for last real ennemy
.null
ld a,2
ld (wave_management.repet+1),a ; infinite loop
ld a,(.pcpt) : or a : ret nz
; WINZEGAME
pop hl ; because we are here with a CALL
jp winzegame


MAXLIFE=0
INFINITE_LIFE=0

; DE=sprite_reference
; BC=PV
; I=vitesse
; XL=ypos (if not zero)
.add_miniflyer
ld de,spr_miniflyer
.lifeminiflyer ld bc,1+MAXLIFE
jr .flyer_generic

.add_flyer
ld de,spr_flyer
.lifeflyer ld bc,3+MAXLIFE

.flyer_generic
ld a,r
and 3
.is5
add a : add a : add a : add a : add #6C ; Y

ld hl,.pcpt : inc (hl) : jr nz,.addnext_flyer : ld (hl),255 : ret
.addnext_flyer
ld hl,(.plist)
ld (hl),4   : inc hl  ; X=0
ld (hl),a : inc hl ; Y=1 => defaut 132 pour posy=8
ld (hl),ADROITE   : inc hl ; ADROITE
ld a,255
ld (hl),a  : inc hl ; compteur=3
ld (hl),e : inc hl ; 4
ld (hl),d : inc hl; 5

ld (hl),c : inc hl ; PV=6
ld (hl),b : inc hl ; PV=7
; generic speed
ld (hl),1  : inc hl ; vitesse=8

ld (.plist),hl
ret


.add_fast
ld de,spr_fast
.lifefast ld bc,2+MAXLIFE
ld a,2 : ld i,a
ld xl,132
jr .add

.add_boss
ld de,spr_boss
.lifeboss ld bc,20+MAXLIFE
xor a : ld i,a
ld xl,132
jr .add

.add_blob
ld de,spr_blob
.lifeblob ld bc,4+MAXLIFE
ld a,1 : ld i,a
ld xl,132
jr .add

.add_mini
ld de,spr_mini
.lifemini ld bc,2+MAXLIFE
ld a,1 : ld i,a
ld xl,132
jr .add

.add
ld hl,.pcpt : inc (hl) : jr nz,.addnext : ld (hl),255 : ret
.addnext
ld hl,(.plist)
ld (hl),4   : inc hl  ; X=0
ld (hl),132 : inc hl ; Y=1 => defaut 132 pour posy=8
ld a,(depmap+8*16)
ld (hl),a   : inc hl ; direction=2
ld a,i
exx
ld bc,.compteurtab : add c : ld c,a : ld a,(bc)
exx
ld (hl),a  : inc hl ; compteur=3
ld (hl),e : inc hl ; 4
ld (hl),d : inc hl; 5

ld (hl),c : inc hl ; PV=6
ld (hl),b : inc hl
ld a,i
ld (hl),a  : inc hl ; vitesse=8

ld (.plist),hl
ret

.getmap
ld a,(ix+0) : and #F0 : or 4 : ld (ix+0),a
rrca : rrca : rrca : rrca : and #F : ld c,a
ld a,(ix+1) : and #F0 : or 4 : ld (ix+1),a
and #F0 : or c : ld c,a : ld b,hi(depmap) : ld a,(bc) ; qu'est-ce qu'on fait?
; speed => table => counter
.setdep
ld (ix+2),a
ld bc,.compteurtab : ld a,(ix+8) : add c : ld c,a
ld a,(bc)
ld (ix+3),a
ret

confine 3
.compteurtab defb 32,16,8

;****************************************************************************
;****************************************************************************
;****************************************************************************
;****************************************************************************
;****************************************************************************
;****************************************************************************
.manage
ld ix,MYENNEMY
ld a,(.frost+1) : inc a : jr z,.frostok : ld a,#FF
.frostok ld (.frost+1),a ; tic/toc

ld a,(.pcpt) : or a : ret z : ld yl,a
;****************************************************************************
.mananext
;****************************************************************************
; avant toute chose, perdre des points de vie?
ld a,(ix+5) : cp hi(spr_flyer) : ld e,hi(damage) : jr nz,.regular_damage
ld e,hi(airdamage)
.regular_damage
ld a,(ix+0) : rrca : rrca : rrca : rrca : and #F : ld c,a : ld a,(ix+1) : and #F0 : or c : ld c,a : ld b,e : ld a,(bc) : or a : jr z,.nodamage
; perte de points de vie => A=perte
ld h,0 : ld l,a : ld de,(ix+6) : sbc hl,de : jr c,.alive
; DEAD
sub e : ld (bc),a ; update des dommages

; => moar credits!
ld hl,(credit) : ld de,1 : reward EQU $-2 : add hl,de : jr c,.max_de_flouze
ld a,(ix+5) : cp hi(spr_boss) ; est-ce un boss?
jr z,.boss
cp hi(spr_flyer)
jr nz,.noboss
ld a,(ix+4)
cp lo(spr_flyer)
jr nz,.noboss
.boss
ld a,29 : add l : ld l,a : ld a,h : adc 0 : ld h,a : jr c,.max_de_flouze
.noboss
ld (credit),hl
ld a,1 : ld (refresh_digit+1),a
jr .remove_ennemy

.max_de_flouze
ld hl,#FFFF : ld (credit),hl
jr .remove_ennemy

.alive
ld l,a
xor a : ld (bc),a
ex hl,de : ld d,a : sbc hl,de : ex hl,de : ld (ix+6),de
.nodamage

ld a,(ix+8) : or a : jr nz,.checkfrost
; les boss sont plus lents, on fait un tic/toc si (ix+8) vaut zero...
dec (ix+3) : call z,.getmap

ld a,(.frost+1) : neg : inc a : and 1 : ld h,a ; 0 ou 1
jr .boss_move

.checkfrost
; ensuite, gerer le frost APRES les boss
ld b,hi(frostmap)
ld a,(bc) : .frost : and #FF : jp nz,.display

.domove
; DEC du compteur + recherge infos de deplacement
dec (ix+3) : call z,.getmap

.ennemy_move
ld h,(ix+8)
.boss_move
ld a,(ix+2)
dec a : jr z,.adroite
dec a : jr z,.agauche
dec a : jr z,.enbas
;dec a : jr z,.enhaut
.enhaut  ld a,(ix+1) : sub h : ld (ix+1),a : jr .display
.enbas   ld a,(ix+1) : add h : ld (ix+1),a : jr .display
.agauche ld a,(ix+0) : sub h : ld (ix+0),a : jr .display
.adroite ld a,(ix+0) : add h : ld (ix+0),a : jr nc,.display

;*** sortie de l'ecran a droite obligatoirement en #8F  perte de PV, ... ******
.outofscreen
ld a,(life)
IF INFINITE_LIFE
inc a
ENDIF
dec a : ld (life),a : jp z,endofgame : ld (refresh_digit+1),a
.remove_ennemy
ld hl,SIZE_ENNEMY-1 : ld de,ix : add hl,de : ex hl,de ; DE=IX+SIZE_ENNEMY-1
ld hl,(.plist) : dec hl
repeat SIZE_ENNEMY-1 : ldd : rend : ld a,(hl): ld (de),a
ld (.plist),hl
ld hl,.pcpt : dec (hl)
dec yl : ret z
jp .mananext


.display
ld a,(ix+0) : cp #F8
jp nc,.display2clip

/*ld a,(ix+0) :*/  ld b,a : add 12 : rrca : rrca : rrca : rrca : and #F : ld e,a
ld a,(ix+1) : ld c,a : add 7 : and #F0 : or e : ld e,a ; E=reference down/right

ld a,b : rrca : rrca : rrca : rrca : and #F : ld l,a
ld a,c : and #F0 : or l : ld l,a
;**** ici on est sur de trouver l'ennemi
ld h,hi(posmap)
ld a,(ix+5) : cp hi(spr_flyer) : jr nz,.onzeground : dec h ; posmap => airmap
.onzeground
ld (hl),1
ld a,(current_dirtmap) : ld h,a
ld (hl),1

ld a,l : xor e : jr z,.noquad
ld b,a ; B=XOR des deux
and #F : jr z,.onlydiffy ; X different?
inc l : ld (hl),1
ld a,b : and #F0 : jr z,.noquad : dec l
ld a,#10 : add l : ld l,a : ld (hl),1
inc l : ld (hl),1
jr .noquad
.onlydiffy
ld a,#10 : add l : ld l,a : ld (hl),1
.noquad

ld a,(ix+0) : ld d,0 : ld e,a : srl e : srl e : and 3 : ld c,a ; X+modX
ld l,(ix+1) : ld h,hi(scradr) : ld a,(hl) : inc h : ld h,(hl) : ld l,a : add hl,de

; B=indice de "suivance" pour les sprites decales
ex hl,de
ld hl,(ix+4) ; sprite is not according to direction
ld b,0 : ld a,(bc) : ld c,a ; 0,24,48,72
add hl,bc
ld a,(ix+2) : add 3 : ld c,a : ld a,(bc) ; 0/48/96/144 to add twice
ld c,a : add hl,bc : add hl,bc

ex hl,de
.unclipped
; plus qu'a envoyer de DE vers HL
ld yh,8 : ld bc,#800-2 : jr .novf
.copyblob
add hl,bc : bit 7,h : jr z,.novf : ld bc,64-#4000 : add hl,bc : ld bc,#800-2
.novf
ld a,(de) : or (hl) : ld (hl),a : inc l : inc e
ld a,(de) : or (hl) : ld (hl),a : inc l : inc e
ld a,(de) : or (hl) : ld (hl),a : inc e
dec yh
jr nz,.copyblob

; Next ennemy
dec yl
ret z
ld bc,SIZE_ENNEMY
add ix,bc
jp .mananext


;*************************************************
;     affichage clippe pour la sortie ecran
;*************************************************
.display2clip
ld a,(ix+1) : ld c,a : add 7 : and #F0 : or #0F : ld e,a ; E=reference basse tient compte uniquement du Y

ld a,c : and #F0 : or #0F : ld l,a
;**** ici on est sur de trouver l'ennemi
ld h,hi(posmap)
ld a,(ix+5) : cp hi(spr_flyer) : jr nz,$+3 : dec h ; posmap => airmap
ld (hl),1
ld a,(current_dirtmap) : ld h,a
ld (hl),1

ld a,l : xor e : jr z,.nodual
ld a,#10 : add l : ld l,a
ld (hl),1
.nodual

;************* block copy from no clipped version **********************************
ld a,(ix+0) : ld d,0 : ld e,a : srl e : srl e : and 3 : ld c,a ; X+modX
ld l,(ix+1) : ld h,hi(scradr) : ld a,(hl) : inc h : ld h,(hl) : ld l,a : add hl,de
; B=indice de "suivance" pour les sprites decales
ex hl,de

ld hl,(ix+4) ; sprite is not according to direction
ld b,0 : ld a,(bc) : ld c,a ; 0,24,48,72
add hl,bc
ld a,(ix+2) : add 3 : ld c,a : ld a,(bc) ; 0/48/96/144 to add twice
ld c,a : ld a,l : add c : add c : ld l,a : ld a,h : adc 0 : ld h,a

ex hl,de
; plus qu'a envoyer de DE vers HL

ld a,(ix+0) : and #F : cp 8 : jp c,.unclipped
sub 8 : srl a : srl a : jr z,.clip2

.clip1
ld yh,8 : ld bc,#800 : jr .novf1
.copyblob1
add hl,bc : bit 7,h : jr z,.novf1 : ld bc,64-#4000 : add hl,bc : ld bc,#800
.novf1
ld a,(de) : or (hl) : ld (hl),a : inc e : inc e : inc e
dec yh
jr nz,.copyblob1

; Next ennemy
dec yl
ret z
ld bc,SIZE_ENNEMY
add ix,bc
jp .mananext


.clip2
ld yh,8 : ld bc,#800-1 : jr .novf2
.copyblob2
add hl,bc : bit 7,h : jr z,.novf2 : ld bc,64-#4000 : add hl,bc : ld bc,#800-1
.novf2
ld a,(de) : or (hl) : ld (hl),a : inc l : inc e
ld a,(de) : or (hl) : ld (hl),a : inc e : inc e
dec yh
jr nz,.copyblob2

; Next ennemy
dec yl
ret z
ld bc,SIZE_ENNEMY
add ix,bc
jp .mananext






.plist defw MYENNEMY ; Y/X/vect?
.pcpt  defb 0

align 256
spr_blob incbin './gfx/ttd_blob.bin'
spr_fast incbin './gfx/ttd_fast.bin'
spr_boss incbin './gfx/ttd_boss.bin'
spr_mini incbin './gfx/ttd_mini.bin'

confine 64
touret_display defs 64

align 256
spr_explosion
incbin './gfx/ttd_explosion.bin' ; 224 bytes

align 256
spr_miniflyer
incbin './gfx/ttd_flyer.bin',0,96
spr_flyer
incbin './gfx/ttd_flyer.bin',192+96,96

hud incbin './gfx/ttd_hud.bin'




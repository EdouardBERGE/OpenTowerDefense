
;**************************************************************************
;   build a simple distance map with a recursive search
;**************************************************************************
conflit xor a : ret

findpath
ld hl,depmap+16 : xor a
.razdep
ld (hl),a : inc l : ld (hl),a : inc l
ld (hl),a : inc l : ld (hl),a : inc l
ld (hl),a : inc l : ld (hl),a : inc l
ld (hl),a : inc l : ld (hl),a : inc l
jr nz,.razdep

ld hl,zeback+8*16
ld a,(hl)
and #FE
jr nz,conflit ; pas de tour au point de depart, merci!
ld (hl),0
ld hl,zeback+8*16+15
ld a,(hl)
and #FE
jr nz,conflit ; pas de tour au point d'arrivee, merci!
ld (hl),0

ld hl,zeback

ld de,zeback+16
ld hl,zemap+16
ld bc,#FF00
.tomap
ld a,(de) : inc e : or a : jr z,.mapreset : ld (hl),b : inc l : ld a,(de) : inc e : or a : jr z,.mapreset2 : ld (hl),b : inc l : jr nz,.tomap
jr .build_path
.mapreset
ld (hl),c : inc l : ld a,(de) : inc e : or a : jr z,.mapreset2 : ld (hl),b : inc l : jr nz,.tomap
jr .build_path
.mapreset2
ld (hl),c : inc l : jr nz,.tomap

; parcours de la map comme une onde
.build_path
ld ix,scantmp1
ld (ix+0),0
ld (ix+1),8
ld (ix+3),0 ; never 0
ld a,1
ld (zemap+8*16),a
inc a
ld yl,a

.loopscan
ld ix,scantmp1
ld hl,scantmp2
call .scanmap : inc yl : inc l : ld (hl),a : dec l
ld a,l : or a : jp z,path_optimal
ld ix,scantmp2
ld hl,scantmp1
call .scanmap : inc yl : inc l : ld (hl),a : dec l ; scanmap returns with A=0
ld a,l : or a : jr nz,.loopscan
jp path_optimal

;de=map
;ix=table input
;hl=table output
;yl=life
.scanmap
ld a,(ix+1) : or a : ret z : ld c,a : ld b,(ix+0) : inc lx : inc lx
; construire le DE
ld a,b : and #F : ld e,a : ld a,c : rrca : rrca : rrca : rrca : and #F0 : or e : ld e,a : ld d,hi(zemap)

ld a,b : cp 15 : jr z,.buteegauche
inc e : ld a,(de) : dec e
or a : jr nz,.buteegauche
inc e : ld a,yl : ld (de),a : dec e
inc b : ld (hl),b : dec b : inc l : ld (hl),c : inc l
.buteegauche

ld a,b : or a : jr z,.buteedroite
dec e : ld a,(de) : inc e
or a : jr nz,.buteedroite
dec e : ld a,yl : ld (de),a : inc e
dec b : ld (hl),b : inc b : inc l : ld (hl),c : inc l
.buteedroite

ld a,c : cp 15 : jr z,.buteebasse
ld a,e : exa : ld a,e : add 16 : ld e,a : ld a,(de) : exa : ld e,a : exa
or a : jr nz,.buteebasse
ld a,e : exa : ld a,e : add 16 : ld e,a : ld a,yl : ld (de),a : exa : ld e,a
ld (hl),b : inc l : inc c : ld (hl),c : dec c : inc l
.buteebasse

ld a,c : cp 1 : jr z,.scanmap
ld a,e : sub 16 : ld e,a : ld a,(de)
or a : jr nz,.scanmap
ld a,yl : ld (de),a
ld (hl),b : inc l : dec c : ld (hl),c : inc l
jp .scanmap


;****************************************************************
;   create directions for optimal path
;****************************************************************
path_optimal
ld hl,zemap+8*16+15
ld a,(hl)
or a
ret z
inc a
ret z

ld b,15
ld c,8
ld hl,zemap+15+8*16
ld e,(hl) ; valeur de sortie

ADROITE=1
AGAUCHE=2
ENBAS  =3
ENHAUT =4

inc h : ld (hl),ADROITE
dec h

.reloop
dec e
jp z,path_escape
.retry ld a,r : add e : xor e : and #1F : add a : exx : ld hl,.jumporder : add l : ld l,a : ld a,(hl) : inc hl : ld h,(hl) : ld l,a : jp (hl)

.testdroite ld a,b : or a : ret z
dec l : ld a,(hl) : inc l : cp e : ret nz
dec b : dec l : inc h : ld (hl),ADROITE : dec h : pop af : jr .reloop

.testbas ld a,c : cp 1 : ret z
ld d,l : ld a,-16 : add l : ld l,a : ld a,(hl) : ld l,d : cp e : ret nz
ld a,-16 : add l : ld l,a : dec c : inc h : ld (hl),ENBAS : dec h : pop af : jr .reloop

.testhaut ld a,c : cp 15 : ret z
ld d,l : ld a,16 : add l : ld l,a : ld a,(hl) : ld l,d : cp e : ret nz
ld a,16 : add l : ld l,a : inc c : inc h : ld (hl),ENHAUT : dec h : pop af : jr .reloop

.testgauche ld a,b : cp 15 : ret z
inc l : ld a,(hl) : dec l : cp e : ret nz
inc b : inc l : inc h : ld (hl),AGAUCHE : dec h : pop af : jr .reloop

confine 64
.jumporder
repeat 32,cbn
defw .combi{cbn-1}
rend

.combi24 : .combi25 : .combi26 : .combi27 : .combi28 : .combi29 : .combi30 : .combi31 :  exx : jp .retry

;*******************************************************************************
; reverse search for optimal path use some randomness to be less predictable
;*******************************************************************************

cbn=0

.combi{cbn}
cbn+=1
exx : call .testdroite : call .testgauche : call .testbas    : call .testhaut
.combi{cbn}
cbn+=1
exx : call .testdroite : call .testgauche : call .testhaut   : call .testbas

.combi{cbn}
cbn+=1
exx : call .testdroite : call .testhaut   : call .testbas    : call .testgauche
.combi{cbn}
cbn+=1
exx : call .testdroite : call .testhaut   : call .testgauche : call .testbas

.combi{cbn}
cbn+=1
exx : call .testdroite : call .testbas    : call .testgauche : call .testhaut
.combi{cbn}
cbn+=1
exx : call .testdroite : call .testbas    : call .testhaut   : call .testgauche

.combi{cbn}
cbn+=1
exx : call .testbas : call .testdroite : call .testgauche    : call .testhaut
.combi{cbn}
cbn+=1
exx : call .testbas : call .testdroite : call .testhaut   : call .testgauche

.combi{cbn}
cbn+=1
exx : call .testbas : call .testhaut   : call .testgauche    : call .testdroite
.combi{cbn}
cbn+=1
exx : call .testbas : call .testhaut   : call .testdroite : call .testgauche

.combi{cbn}
cbn+=1
exx : call .testbas : call .testgauche    : call .testdroite : call .testhaut
.combi{cbn}
cbn+=1
exx : call .testbas : call .testgauche    : call .testhaut   : call .testdroite

.combi{cbn}
cbn+=1
exx : call .testgauche : call .testdroite : call .testbas    : call .testhaut
.combi{cbn}
cbn+=1
exx : call .testgauche : call .testdroite : call .testhaut   : call .testbas

.combi{cbn}
cbn+=1
exx : call .testgauche : call .testhaut   : call .testbas    : call .testdroite
.combi{cbn}
cbn+=1
exx : call .testgauche : call .testhaut   : call .testdroite : call .testbas

.combi{cbn}
cbn+=1
exx : call .testgauche : call .testbas    : call .testdroite : call .testhaut
.combi{cbn}
cbn+=1
exx : call .testgauche : call .testbas    : call .testhaut   : call .testdroite

.combi{cbn}
cbn+=1
exx : call .testhaut : call .testdroite : call .testbas    : call .testgauche
.combi{cbn}
cbn+=1
exx : call .testhaut : call .testdroite : call .testgauche   : call .testbas

.combi{cbn}
cbn+=1
exx : call .testhaut : call .testgauche   : call .testbas    : call .testdroite
.combi{cbn}
cbn+=1
exx : call .testhaut : call .testgauche   : call .testdroite : call .testbas

.combi{cbn}
cbn+=1
exx : call .testhaut : call .testbas    : call .testdroite : call .testgauche
.combi{cbn}
cbn+=1
exx : call .testhaut : call .testbas    : call .testgauche   : call .testdroite






;****************************************************************
;    create all escape path
;****************************************************************
path_escape
ld hl,zemap+16
ld c,15 : ld e,l ; E=16
; ligne du haut
ld b,e
.loopx_haut
ld h,hi(deptmp) : ld (hl),0
ld h,hi(zemap) : ld a,(hl) : inc a : jr z,.loopnext_haut : inc h /* depmap */ : ld a,(hl) : or a : call z,.escape_generic
.loopnext_haut
inc l
djnz .loopx_haut

dec c
.loopy
ld b,e
ld h,hi(deptmp) : ld (hl),0
ld h,hi(zemap) : ld a,(hl) : inc a : jr z,.loopxprep : inc h /* depmap */ : ld a,(hl) : or a : call z,.escape_generic
.loopxprep
inc l : dec b
.loopx
  ld h,hi(deptmp) : ld (hl),0
  ld h,hi(zemap) : ld a,(hl) : inc a : jr z,.loopnext : inc h /* depmap */ : ld a,(hl) : or a : call z,.escape_notest
  .loopnext
  inc l
  dec b
  ld a,1
  cp b
  jr nz,.loopx
ld h,hi(deptmp) : ld (hl),0
ld h,hi(zemap) : ld a,(hl) : inc a : jr z,.loopxprep2 : inc h /* depmap */ : ld a,(hl) : or a : call z,.escape_generic
.loopxprep2
inc l
dec c
ld a,1
cp c
jr nz,.loopy

; ligne du bas
ld b,e ; Xloop=16 C=1
.loopx_bas
ld h,hi(deptmp) : ld (hl),0
ld h,hi(zemap) : ld a,(hl) : inc a : jr z,.loopnext_bas : inc h /* depmap */ : ld a,(hl) : or a : call z,.escape_generic
.loopnext_bas
inc l
djnz .loopx_bas

jp .one_pass_done



.escape_generic
ld a,c : dec a : jr z,.noyb
ld d,l : ld a,e : add l : ld l,a : ld a,(hl) :ld l,d : or a : jr z,.noyb
inc h : ld (hl),ENBAS : ret
.noyb

ld a,c : cp 15 : jr z,.noyh
ld d,l : ld a,l : sub e : ld l,a : ld a,(hl) :ld l,d : or a : jr z,.noyh
inc h : ld (hl),ENHAUT : ret
.noyh

ld a,b : dec a : jr z,.noxd
inc l : ld a,(hl) : dec l : or a : jr z,.noxd
inc h : ld (hl),ADROITE : ret
.noxd

ld a,b : cp e : ret z
dec l : ld a,(hl) : inc l : or a : ret z
inc h : ld (hl),AGAUCHE
ret

.escape_notest
ld d,l : ld a,l : add e : ld l,a : ld a,(hl) :ld l,d : or a : jr z,.shortnoyb
inc h : ld (hl),ENBAS : ret
.shortnoyb

ld d,l : ld a,l : sub e : ld l,a : ld a,(hl) :ld l,d : or a : jr z,.shortnoyh
inc h : ld (hl),ENHAUT : ret
.shortnoyh

inc l : ld a,(hl) : dec l : or a : jr z,.shortnoxd
inc h : ld (hl),ADROITE : ret
.shortnoxd

dec l : ld a,(hl) : inc l : or a : ret z
inc h : ld (hl),AGAUCHE
ret

.one_pass_done
;************************
; blend new dep with dep
;************************
ld hl,deptmp+16
ld d,hi(depmap)
ld b,1

xor a
.reloop
cp (hl) : call nz,.blend : inc l : cp (hl) : call nz,.blend : inc l
cp (hl) : call nz,.blend : inc l : cp (hl) : call nz,.blend : inc l
jr nz,.reloop
;
dec b
jp nz,path_escape ; need another iteration!

ld hl,zeback+8*16
ld (hl),1
ld hl,zeback+8*16+15
ld (hl),1


;*************************************************
;          check for prisonners BUT flyers
;*************************************************
ld ix,MYENNEMY
ld a,(ennemy.pcpt) : or a : jr z,.path_ok : ld yl,a
ld bc,SIZE_ENNEMY
ld de,#FF0
ld h,hi(depmap)

.check_prisonners
ld a,(ix+5) : cp hi(spr_flyer) : jr z,.nonono
ld a,(ix+0) : rrca : rrca : rrca : rrca : and d : ld l,a : ld a,(ix+1) : and e : or l : ld l,a
ld a,(hl) : or a : ret z ; findpath KO !
.nonono
add ix,bc
dec yl
jr nz,.check_prisonners

;*****************************************
;          force unused borders
;*****************************************
; ligne 1 et colonne 15 superieure
ld l,#10
ld b,15
.enforce_exit
ld a,(hl) : or a : jr nz,.enforce_next
ld (hl),AGAUCHE
.enforce_next
inc l
djnz .enforce_exit
ld bc,#710
.enforce_exit2
ld a,(hl) : or a : jr nz,.enforce_next2
ld (hl),ENBAS
.enforce_next2
ld a,l : add c : ld l,a
djnz .enforce_exit2



.path_ok
ld a,1 : or a
ret

.blend ld e,l : ld a,(hl) : ld (de),a : xor a : ld b,a : ret









;save"find.bin",#8000,$-#8000,DSK,"findpath.dsk"



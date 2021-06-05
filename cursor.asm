;*******************************************************************************
                           display_cursor
;*******************************************************************************

ld a,(cursor.y) : ld h,a : ld l,0 : srl h : rr l
ld a,(cursor.x) : add a : add a : ld d,#40 : ld e,a
add hl,de
ld c,#F0 : ld (hl),c : inc l : ld (hl),c : inc l : ld (hl),c : inc l : ld (hl),c
ld de,7*#800+64 : add hl,de : ld (hl),c : dec l : ld (hl),c : dec l : ld (hl),c : dec l : ld (hl),c : sbc hl,de
;
ld de,%0111011110000000
ld bc,%1110111000010000
ld xh,7
.cadre
ld a,64 : add l : ld l,a
ld a,(hl) : and d : or e : ld (hl),a : inc l: inc l: inc l: ld a,(hl): and b : or c : ld (hl),a
ld a,-64 : add l : ld l,a : ld a,8 : add h : ld h,a
ld a,(hl) : and b : or c : ld (hl),a : dec l: dec l: dec l: ld a,(hl): and d : or e : ld (hl),a
dec xh : jr nz,.cadre

ld hl,(cursor) : ld c,h : ld b,l
; DIRT_TAG
ld a,(current_dirtmap) : ld h,a
ld a,c : add a : add a : add a : add a : or b : ld l,a
ld (hl),2

;*******************************************************************************
                           extended_display
;*******************************************************************************
; on refresh si on change de tour ou qu'on quitte une tour ET qu'il faut le faire
push hl
.refresh_xtended ld a,0 : or a : jr z,.draw_or_not
xor a
ld (.refresh_xtended+1),a

;********* on active le refresh des tiles "souillees par le curseur quand on quitte la zone"
; on applique la map de refresh sur les dirtmap
ld hl,touret_display
ld a,(hl) : or a : jr z,.draw_or_not
ld b,a : ld (hl),0 ; reset de la liste apres affichage
exx
ld c,1
ld h,hi(dirtmap1)
ld d,hi(dirtmap3)
exx
.loopdirt
inc l
ld a,(hl)
exx
ld l,a : ld (hl),c
ld e,a : /* ld a,c : ld (de),e */ ld (de),a
exx
djnz .loopdirt

.draw_or_not
pop hl
ld h,hi(zeback)

push hl
ld a,(hl) : ld hl,touret_upgrade_cost : add l : ld l,a :
ld a,(hl) : ld (cost_upgrade),a
dec a : ld (refresh_digit+1),a
pop hl

ld a,(hl) : and #FE
jp z,.no_extended_display ; tout sauf 0/1 et... 22 !
cp 22 : jp z,.no_extended_display

; a partir de la tile en cours, on trouve la liste
ld h,l : ld l,0 : srl hl : srl hl : set 6,h ; XY x 64 => HL
ld bc,#7FC4 : ld a,c : ld (currentbank),a : out (c),c

exx
ld bc,#F00F
ld de,%1110111000010000
exx
ld c,(hl) : ld a,c : exa
inc c
ld de,touret_display
ld b,0
ldi
ldir
ld b,#7F : ld a,(pageflip.gaval+1) : ld (currentbank),a : out (c),a

exa
ld b,a
;ld a,(current_dirtmap) : ld h,a
ld de,touret_display
.loop_area
inc e
ld a,(de)
;ld l,a : ld (hl),2
exx
ld h,a : and b : ld l,a : ld a,h : and c
ld h,#0F : add hl,hl : or l : ld l,a : add hl,hl : add hl,hl ; quasi la bonne adresse ecran
inc l
ld a,(hl) : and d : or e : ld (hl),a : ld a,l : add #40 : ld l,a : ld a,h : adc #C8 : ld h,a
ld (hl),%00110000 : inc l : ld (hl),%10000000 : dec l : ld a,h : add 8 : ld h,a
ld a,(hl) : and d : or e : ld (hl),a
exx
djnz .loop_area

.no_extended_display



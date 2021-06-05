


explosion
ld de,explomap+16
.loop
ld a,(de)
or a
jr nz,.explosion
.next
inc e : ret z : ld a,(de) : or a : jr nz,.explosion
inc e : ret z : ld a,(de) : or a : jr nz,.explosion
inc e : ret z : ld a,(de) : or a : jr nz,.explosion
inc e : ret z : ld a,(de) : or a : jr nz,.explosion
inc e
jr nz,.loop
ret

; A donne le sprite (ou pas)
; affiche sprite + dirt

.tozero : xor a : ld (de),a : jr .next

.explosion
dec a : ld (de),a : cp 8 : jr z,.tozero

; avec le E on peut mettre a jour la dirt map


add a : add a : add a : add a : exa

ld a,(current_dirtmap) : ld h,a : ld l,e : ld (hl),1

ld a,e : and #F0 : ld l,a
ld h,#08 : add hl,hl : ld a,e : and #F : or l : ld l,a : add hl,hl : add hl,hl ; quasi la bonne adresse ecran
push de
exa
ld e,a
ld d,hi(spr_explosion)
ld bc,#2001 : add hl,bc : ld bc,#800-1
ld a,(de) : inc e : or (hl) : ld (hl),a : inc l : ld a,(de) : inc e : or (hl) : ld (hl),a : add hl,bc 
ld a,(de) : inc e : or (hl) : ld (hl),a : inc l : ld a,(de) : inc e : or (hl) : ld (hl),a : add hl,bc 
ld a,(de) : inc e : or (hl) : ld (hl),a : inc l : ld a,(de) : inc e : or (hl) : ld (hl),a : add hl,bc 
ld a,(de) : inc e : or (hl) : ld (hl),a : inc l : ld a,(de) : inc e : or (hl) : ld (hl),a : ld bc,64-1-#3800 : add hl,bc : ld bc,#800-1
ld a,(de) : inc e : or (hl) : ld (hl),a : inc l : ld a,(de) : inc e : or (hl) : ld (hl),a : add hl,bc 
ld a,(de) : inc e : or (hl) : ld (hl),a : inc l : ld a,(de) : inc e : or (hl) : ld (hl),a : add hl,bc 
ld a,(de) : inc e : or (hl) : ld (hl),a : inc l : ld a,(de) : inc e : or (hl) : ld (hl),a : add hl,bc 
ld a,(de) : inc e : or (hl) : ld (hl),a : inc l : ld a,(de) : or (hl) : ld (hl),a 
pop de
jp .next





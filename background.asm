
;***********************************************
;    restore background according to dirt map
;***********************************************
restore_background
ld a,(current_dirtmap)
ld h,a : ld l,16 : ld de,#F000
jp .loop

.restore_tile
ld (hl),e : ld a,l : exx
ld h,hi(bufadr) : ld l,a : ld e,(hl) : inc h : ld d,(hl) ; DE=destination
ld h,hi(zeback) : ld a,(hl) ; tower
add a : ld hl,compiled_tiles : add l : ld l,a : ld a,(hl) : inc l : ld h,(hl) : ld l,a : jp (hl)



.loopback
exx
inc l : ret z
.loop
ld a,(hl) : or a : jr nz,.restore_tile : inc l : ret z
ld a,(hl) : or a : jr nz,.restore_tile : inc l : ret z
ld a,(hl) : or a : jr nz,.restore_tile : inc l : ret z
ld a,(hl) : or a : jr nz,.restore_tile : inc l : ret z
ld a,(hl) : or a : jr nz,.restore_tile : inc l : ret z
ld a,(hl) : or a : jr nz,.restore_tile : inc l : ret z
ld a,(hl) : or a : jr nz,.restore_tile : inc l : ret z
ld a,(hl) : or a : jr nz,.restore_tile : inc l : ret z
ld a,(hl) : or a : jr nz,.restore_tile : inc l : ret z
ld a,(hl) : or a : jr nz,.restore_tile : inc l : ret z
ld a,(hl) : or a : jr nz,.restore_tile : inc l : ret z
ld a,(hl) : or a : jr nz,.restore_tile : inc l : jr nz,.loop
ret 


align 256
bufadr
repeat 16,py
repeat 16,px
adr=#4000+(px-1)*4+(py-1)*128
defb adr&255
rend
rend

repeat 16,py
repeat 16,px
adr=#4000+(px-1)*4+(py-1)*128
defb hi(adr)
rend
rend

scradr
adr=#4000
repeat 32
repeat 8
defb adr & 255
adr=adr+#800
rend
adr=adr-#4000+64
rend

adr=#4000
repeat 32
repeat 8
defb hi(adr)
adr=adr+#800
rend
adr=adr-#4000+64
rend

confine 46
compiled_tiles
repeat 23,x
tile_idx=x-1
defw compiled_tile_{tile_idx}
rend

;include 'compiled_tiles.asm'
;print "compiled tiles size =",$-compiled_tile_0



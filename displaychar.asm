
; before any string to declare!!! => charset '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+-:.! =/\\[]_^<>@()',0

SCREEN_WIDTH equ 80
DISPLAY_REFERENCE equ #C000

displaylineadr defw DISPLAY_REFERENCE
displaycharadr defw DISPLAY_REFERENCE

macro locate posx,posy

ld hl,DISPLAY_REFERENCE+{posy}*SCREEN_WIDTH
ld (displaylineadr),hl
ld hl,DISPLAY_REFERENCE+{posx}+{posy}*SCREEN_WIDTH
ld (displaycharadr),hl

mend


; A=char to display
displaychar
ld h,0
add a
ld l,a
add hl,hl
add hl,hl
ld de,minifonte
add hl,de
ex hl,de ; sprite char ADR
ld hl,(displaycharadr)
ld bc,#808
displaycharline
ld a,(de) ; donnee du caractere
inc e
ld (hl),a
ld a,h
add c
ld h,a
djnz displaycharline

ld hl,(displaycharadr)
inc hl
ld (displaycharadr),hl
ret

; a=hex value
displayhexa
push af
rrca : rrca : rrca : rrca : and 15
call displaychar
pop af
and 15
call displaychar
ret

; hl=hex16 adr
displayhexa16
ld a,(hl)
ex af,af'
inc hl
ld a,(hl)
call displayhexa
ex af,af'
call displayhexa
ret

; hl=string adr
; 255 -> EOS
; 254 -> CR
displaystring
ld a,(hl)
cp 255
ret z
cp 254
jr z,displayCR
push hl
call displaychar
pop hl
inc hl
jr displaystring

displayCR
ld hl,(displaylineadr)
ld de,SCREEN_WIDTH
add hl,de
ld (displaylineadr),hl
ld (displaycharadr),hl
ret

displayReinit
ld hl,DISPLAY_REFERENCE
ld (displaylineadr),hl
ld (displaycharadr),hl
ret

align 8
minifonte
incbin 'minifonte.bin'


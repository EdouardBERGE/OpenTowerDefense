
challenge_HUD
ld a,4 : ld (printdigit.cursor+1),a
ld a,(life) : cp 20 : jr z,.print20
cp 10 : jr c,.print0x
.print1x
sub 10 : exa : ld a,1 : call printdigit : exa : call printdigit : jr .print_wave
.print0x
exa : xor a : call printdigit : exa : call printdigit : jr .print_wave
.print20
ld a,2 : call printdigit : xor a : call printdigit
.print_wave
ld hl,(wave_number)
ld a,33 : ld (printdigit.cursor+1),a
jp printHL


level_HUD
ld a,4 : ld (printdigit.cursor+1),a
ld a,(life) : cp 20 : jr z,.print20
cp 10 : jr c,.print0x
.print1x
sub 10 : exa : ld a,1 : call printdigit : exa : call printdigit : jr .cost_upgrade
.print0x
exa : xor a : call printdigit : exa : call printdigit : jr .cost_upgrade
.print20
ld a,2 : call printdigit : xor a : call printdigit

.cost_upgrade
ld a,23 : ld (printdigit.cursor+1),a : ld b,0
ld h,b : ld a,0 : cost_upgrade=$-1 : ld l,a
call printL

.print_wave
ld hl,(wave_number)
ld a,33 : ld (printdigit.cursor+1),a
call printHL
jr printcredit

skipdigit exx : ld hl,(printdigit.cursor+1) : ld bc,#800 : xor a
ld (hl),a : add hl,bc
ld (hl),a : add hl,bc
ld (hl),a : add hl,bc
ld (hl),a : add hl,bc
ld (hl),a
ld hl,printdigit.cursor+1 : inc (hl) : exx : ret
; HL=credit
printcredit
ld hl,(credit)
ld a,13 : ld (printdigit.cursor+1),a
printHL
ld b,0
ld de,-10000
call printL.num1
ld de,-1000
call printL.num1
printL
ld de,-100
call .num1
ld e,-10
call .num1
ld e,-1 : ld b,16 ; pour le zero tout court
.num1
ld a,-1
.num2
inc a
add hl,de
jr c,.num2
sbc hl,de
or b
jr z,skipdigit
and 15
ld b,16

; A=digit
printdigit
exx
ld e,a
add a ; x2
add a ; x4
add e ; x5
ld de,spr_digit
add e
ld e,a

.cursor ld hl,#5000
ld bc,#800

ld a,(de) : inc e : ld (hl),a : add hl,bc
ld a,(de) : inc e : ld (hl),a : add hl,bc
ld a,(de) : inc e : ld (hl),a : add hl,bc
ld a,(de) : inc e : ld (hl),a : add hl,bc
ld a,(de) : inc e : ld (hl),a

ld hl,.cursor+1 : inc (hl)
exx
ret

confine 50
spr_digit incbin './gfx/ttd_digit.bin' ; sprites 10x4x5


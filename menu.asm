

challenge
ld hl,wave : ld (which_wave),hl
ld hl,fake_init : ld (init_vector),hl
ld hl,level_HUD
ld (refresh_digit.which_HUD1+1),hl
ld (refresh_digit.which_HUD2+1),hl

ld hl,mainloop
ld (wave_management.enable+1),hl

ld hl,str_winchallenge : ld (victory_msg+1),hl
; hard as default for challenges
ld a,6 :  ld (upgrade_ennemy.up1+1),a : inc a
          ld (upgrade_ennemy.up2+1),a : add 2
          ld (upgrade_ennemy.up3+1),a : add 4
          ld (upgrade_ennemy.up4+1),a : add 5
          ld (upgrade_ennemy.up5+1),a : add 10
          ld (upgrade_ennemy.up6+1),a
ld a,20 : ld (upgrade_ennemy.dw1+1),a

ld a,10
ld (life),a
ld hl,10
ld (credit),hl
ld hl,51 : ld (wave_management.max_wave+1),hl ; challenges on 50 waves

call clearscreen
locate 25,2  : ld hl,str_challengetitle    : call printstring
locate 22,4  : ld hl,str_challenge_1       : call printstring ; no delete
locate 22,5  : ld hl,str_challenge_2       : call printstring ; 10000 credits
locate 22,6  : ld hl,str_challenge_3       : call printstring ; one strong wave
locate 22,7  : ld hl,str_challenge_4       : call printstring ; 20 towers
locate 22,8  : ld hl,str_challenge_5       : call printstring ; checker

ld hl,1000 : ld (.wait+1),hl
.wait ld hl,0 : dec hl : ld (.wait+1),hl : ld a,h : or l : jp z,menu
call waitfullvbl ; music?

call scanfullkeyboard
ld a,(KEY_ESC_BYTE) : and KEY_ESC : jp nz,menu
ld a,(KEY_M_BYTE) : and KEY_M : jp nz,menu
ld a,(KEY_1_BYTE) : and KEY_1 : jp nz,challenge_1
ld a,(KEY_2_BYTE) : and KEY_2 : jp nz,challenge_2
ld a,(KEY_3_BYTE) : and KEY_3 : jp nz,challenge_3
ld a,(KEY_4_BYTE) : and KEY_4 : jp nz,challenge_4
ld a,(KEY_5_BYTE) : and KEY_5 : jp nz,challenge_5

jr .wait

challenge_1
xor a : ld (interactivite.allow_delete+1),a
jp engine

challenge_2
ld hl,10000
ld (credit),hl
ld hl,0 : ld (reward),hl
xor a : ld (wave_management.inc_reward),a
jp engine


challenge_3
ld hl,10000
ld (credit),hl
ld hl,11 : ld (wave_management.max_wave+1),hl ; challenges on 10 waves
ld hl,strong_wave : ld (which_wave),hl
jp engine

challenge_4
ld hl,33333
ld (credit),hl
ld hl,init_diag : ld (init_vector),hl
jp engine

init_diag
ld hl,zeback+12+3*16
ld de,15
ld b,11
ld a,22
.diag ld (hl),a : add hl,de : djnz .diag
ret

challenge_5
ld hl,init_checker : ld (init_vector),hl
jp engine

init_checker

ld b,8 : ld a,22
ld hl,zeback+7*16+4
ld d,h : ld e,9*16+4
.line1 ld (hl),a : ld (de),a : inc l : inc e : djnz .line1
ld b,15
ld l,7+16
ld de,16
.line2 ld (hl),a : add hl,de : djnz .line2
xor a
ld (zeback+7+8*16),a
ret






menu
ld hl,wave : ld (which_wave),hl
ld hl,101 : ld (wave_management.max_wave+1),hl
ld hl,1 : ld (reward),hl
ld a,0x34 : ld (wave_management.inc_reward),a ; INC (HL)
ld hl,fake_init : ld (init_vector),hl

ld hl,wave_management.wait
ld (wave_management.enable+1),hl

ld hl,level_HUD
ld (refresh_digit.which_HUD1+1),hl
ld (refresh_digit.which_HUD2+1),hl
ld a,KEY_D : ld (interactivite.allow_delete+1),a

; reset Ennemy PV
ld hl,1 : ld (ennemy.lifeminiflyer+1),hl
ld hl,4 : ld (ennemy.lifeflyer+1),hl
ld hl,2 : ld (ennemy.lifefast+1),hl
ld hl,2 : ld (ennemy.lifemini+1),hl
ld hl,4 : ld (ennemy.lifeblob+1),hl
ld hl,20 : ld (ennemy.lifeboss+1),hl

call clearscreen
locate 25,5  : ld hl,str_gamechoice    : call printstring
locate 22,7  : ld hl,str_gameeasy      : call printstring
locate 22,8  : ld hl,str_gamemedium    : call printstring
locate 22,9  : ld hl,str_gamehard      : call printstring
locate 22,10 : ld hl,str_gamextreme    : call printstring
locate 22,11 : ld hl,str_gamesound     : call printstring
locate 22,12 : ld hl,str_gamechallenge : call printstring
locate 22,13 : ld hl,str_gamemanual: call printstring

xor a : ld (.wait+1),a
.wait ld a,0 : dec a : ld (.wait+1),a : or a : jp z,sheet
call waitfullvbl ; music?

call scanfullkeyboard
ld a,(KEY_E_BYTE) : and KEY_E : jp nz,.easy
ld a,(KEY_M_BYTE) : and KEY_M : jp nz,.medium
ld a,(KEY_H_BYTE) : and KEY_H : jp nz,.hard
ld a,(KEY_X_BYTE) : and KEY_X : jp nz,.xtreme
ld a,(KEY_S_BYTE) : and KEY_S_MENU : call nz,.toggle
ld a,(KEY_C_BYTE) : and KEY_C : jp nz,challenge
ld a,(KEY_I_BYTE) : and KEY_I : jp nz,instructions
jr .wait

.toggle
; cut channels
ld e,7  : ld a,%111 : call .send
ld e,8  : xor a : call .send
ld e,9  : xor a : call .send
ld e,10 : xor a : call .send

di
ld bc,#7FC6 : ld e,#C7
out (c),c ; amorce
ld ix,#4000
ld hl,#4000
.swap
ld a,(hl) : out (c),e : ld d,(hl) : ld (hl),a : out (c),c : ld (hl),d : inc hl
dec xl : jr nz,.swap
dec xh : jr nz,.swap
; init
ld c,#C1 : out (c),c
call #C000
ld a,(currentbank) : ld b,#7F : out (c),a
ei
.waitkey call anykey : jr z,.waitkey
ret


; E=register A=value
.send
ld bc,#F984 : out (c),e
dec b : out (c),a
ld bc,#F988 : out (c),e
dec b : out (c),a
;sendpsg
ld hl,#F4F6
ld b,h :          : out (c),e ; register
ld b,l : ld c,#C0 : out (c),c : out (c),0
ld b,h :          : out (c),a ; value
ld b,l : ld c,#80 : out (c),c : out (c),0
ret


.easy
ld hl,str_wineasy : ld (victory_msg+1),hl
ld a,4 :  ld (upgrade_ennemy.up1+1),a : inc a
          ld (upgrade_ennemy.up2+1),a
          ld (upgrade_ennemy.up3+1),a : add 2
          ld (upgrade_ennemy.up4+1),a : add 2
          ld (upgrade_ennemy.up5+1),a : add 5
          ld (upgrade_ennemy.up6+1),a
ld a,5  : ld (upgrade_ennemy.dw1+1),a

ld a,20
ld (life),a
ld hl,100
ld (credit),hl
jp engine

.medium
ld hl,str_winmedium : ld (victory_msg+1),hl
ld a,4 :  ld (upgrade_ennemy.up1+1),a : inc a
          ld (upgrade_ennemy.up2+1),a : inc a
          ld (upgrade_ennemy.up3+1),a : add 3
          ld (upgrade_ennemy.up4+1),a : add 5
          ld (upgrade_ennemy.up5+1),a : add 10
          ld (upgrade_ennemy.up6+1),a
ld a,10 : ld (upgrade_ennemy.dw1+1),a

ld a,20
ld (life),a
ld hl,30
ld (credit),hl
jp engine

.hard
ld hl,str_winhard : ld (victory_msg+1),hl
ld a,6 :  ld (upgrade_ennemy.up1+1),a : inc a
          ld (upgrade_ennemy.up2+1),a : add 2
          ld (upgrade_ennemy.up3+1),a : add 4
          ld (upgrade_ennemy.up4+1),a : add 5
          ld (upgrade_ennemy.up5+1),a : add 10
          ld (upgrade_ennemy.up6+1),a
ld a,20 : ld (upgrade_ennemy.dw1+1),a

ld a,10
ld (life),a
ld hl,10
ld (credit),hl
jp engine

.xtreme
ld hl,str_winxtreme : ld (victory_msg+1),hl
ld a,8 :  ld (upgrade_ennemy.up1+1),a : inc a
          ld (upgrade_ennemy.up2+1),a : inc a
          ld (upgrade_ennemy.up3+1),a : add 4
          ld (upgrade_ennemy.up4+1),a : add 5
          ld (upgrade_ennemy.up5+1),a : add 20
          ld (upgrade_ennemy.up6+1),a
ld a,40 : ld (upgrade_ennemy.dw1+1),a

ld a,5
ld (life),a
ld hl,10
ld (credit),hl
jp engine

instructions
call clearscreen
locate 25,2 : ld hl,str_instructions : call printstring
locate 25,4 : ld hl,str_manual : call printstring
locate 15,5 : ld hl,str_manual2 : call printstring
locate 20,6 : ld hl,str_tower01 : call printstring
locate 20,7 : ld hl,str_tower02 : call printstring
locate 20,8 : ld hl,str_tower03 : call printstring
locate 20,9 : ld hl,str_tower04 : call printstring
locate 20,10: ld hl,str_tower05 : call printstring
locate  5,11: ld hl,str_upgrade : call printstring
locate 27,13: ld hl,str_goodluck : call printstring
ld h,50 : .rewait call waitfullvbl : dec h : jr nz,.rewait
jr sheet.waitinit





sheet
call waitfullvbl
ld bc,#7F01 : ld a,#54
out (c),c : out (c),a : inc c
out (c),c : out (c),a : inc c
out (c),c : out (c),a
ld bc,#7FC5 : ld a,c : ld (currentbank),a : out (c),c
ld hl,#4000
ld de,#C000
ld bc,16384
ldir
ld bc,#7FC0 : ld a,c : ld (currentbank),a : out (c),c
ld hl,#C000
ld de,#4000
ld bc,16384
ldir
call waitfullvbl

ld bc,#7F01 : ld a,#5C : out (c),c : out (c),a
inc c : ld a,#40 : out (c),c : out (c),a
inc c : ld a,#4B : out (c),c : out (c),a

.waitinit
xor a : ld (.wait+1),a
.wait ld a,0 : dec a : ld (.wait+1),a : or a : jp z,krou
call waitfullvbl ; music?

; wait any key + release
call scanfullkeyboard
call anykey : jr z,.wait
jp menu



krou
call clearscreen
locate 21,5  : ld hl,str_title  : call printstring
locate 21,7  : ld hl,str_crew01 : call printstring 
locate 23,8  : ld hl,str_crew02 : call printstring 
locate 19,9  : ld hl,str_crew03 : call printstring 
locate 16,10 : ld hl,str_crew04 : call printstring 
locate 19,11 : ld hl,str_crew05 : call printstring 

locate 0,15 : ld hl,str_beta : call printstring 

.waitinit
xor a : ld (.wait+1),a
.wait ld a,0 : dec a : ld (.wait+1),a : or a : jp z,menu
call waitfullvbl ; music?

; wait any key + release
call scanfullkeyboard
call anykey : jr z,.wait
jp menu

clearscreen
call waitfullvbl
ld bc,#7F01 : ld a,#54
out (c),c : out (c),a : inc c
out (c),c : out (c),a : inc c
out (c),c : out (c),a
ld hl,#4000 : ld de,#4001 : ld (hl),l : ld bc,16383 : ldir ; => then release any key!
ld bc,#7F01 : ld a,#4C : out (c),c : out (c),a
inc c : ld a,#40 : out (c),c : out (c),a
inc c : ld a,#4B : out (c),c : out (c),a
release_anykey
.release
call scanfullkeyboard
call anykey : jr nz,.release
ret


waitfullvbl ld b,#F5
.novbl in a,(c) : rra : jr c,.novbl
.vbl   in a,(c) : rra : jr nc,.vbl
ret



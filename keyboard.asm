OPTIMISATION_CLAVIER=0 ; you may enable this for Amstrad PLUS only productions

KEY_UP    equ 1
KEY_DOWN  equ 2
KEY_RIGHT equ 8
KEY_LEFT  equ 4
KEY_FIRE  equ #F0

KEY_ESC_INGAME equ 128
KEY_B	equ 64
KEY_F   equ 32
KEY_H   equ 16
KEY_T   equ 8
KEY_U   equ 4
KEY_D   equ 2
KEY_S   equ 1

;*************************************************************
;   ingame keyboard scan optimises keyz in two bytes array
;*************************************************************
scankeyboard
di
ld bc,#F40E ; PPI register 14
out (c),c
if !OPTIMISATION_CLAVIER
  ld bc,#F6C0 ; we want to select a register
  out (c),c
  out (c),0   ; validation
  ld bc,#F792 ; PPI configuration input A, output C
  out (c),c
  dec b : ld c,b
else
  ld bc,#F6F6
endif
ld de,#40F4 ; keyboard line 0 / e=#F4 read port

; L=extended keyz
; H=cursor
out (c),d : ld b,e : in a,(c) : cpl : add a : and %1110 : ld h,a
inc d
ld b,c : out (c),d : ld b,e : in a,(c) : cpl : and 1 : or h : ld hl,keyboard_conversion_curseur : add l : ld l,a : ld h,(hl)
ld d,#49
ld b,c : out (c),d : ld b,e : in a,(c) : cpl : and #7F : or h : ld h,a
;
ld d,#45
ld b,c : out (c),d : ld b,e : in a,(c) : cpl : ld l,a : and #80 : or h : ld (keyboardbuffer),a : ld a,l : and #14 : ld l,a ; HU & SPACE
ld d,#46
ld b,c : out (c),d : ld b,e : in a,(c) : cpl : and %1101000 : or l : ld l,a : ; B F T U
ld d,#47
ld b,c : out (c),d : ld b,e : in a,(c) : cpl : rrca : rrca : rrca : rrca : and %11 : or l : ld l,a
ld d,#48
ld b,c : out (c),d : ld b,e : in a,(c) : cpl : rrca : rrca : rrca : and #80 : or l : ld (extended_keyz),a ; <esc>BFHTUDS
;
if !OPTIMISATION_CLAVIER
  ld bc,#F782 ; PPI output A, output C
  out (c),c
  dec b
  out (c),0
endif
ei
ret

;***************************************************
; bubble quest remainder for cursor/joystick fusion
;***************************************************
confine 16
keyboard_conversion_curseur
repeat 16,idx
 bas=(idx-1)&8
 droite=(idx-1)&4
 haut=(idx-1)&2
 gauche=(idx-1)&1
 touche=0
 if bas>0
  touche|=2
 endif
 if droite>0
  touche|=8
 endif
 if haut>0
  touche|=1
 endif
 if gauche>0
  touche|=4
 endif
 defb touche
rend




;**************************************************************
;                    menu uses full scan
;**************************************************************
scanfullkeyboard
di
ld bc,#F40E ; PPI register 14
out (c),c
if !OPTIMISATION_CLAVIER
  ld bc,#F6C0 ; we want to select a register
  out (c),c
  out (c),0   ; validation
  ld bc,#F792 ; PPI configuration input A, output C
  out (c),c
  dec b : ld c,b
else
  ld c,#F6
endif
ld hl,keyboard_lines
ld de,#3FF4 ; keyboard line 0 / e=#F4 read port
.readline inc d : ld b,c : out (c),d : ld b,e : in a,(c) : cpl : ld (hl),a : inc l : ld a,#49 : cp d : jr nz,.readline
;
if !OPTIMISATION_CLAVIER
  ld bc,#F782 ; PPI output A, output C
  out (c),c
  dec b
  out (c),0
endif
ei
ret

confine 10
keyboard_lines defs 10

anykey
ld hl,keyboard_lines : ld b,9 : ld a,(hl)
.loop inc l : or (hl) : djnz .loop : or a : ret


KEY_SPACE_BYTE equ keyboard_lines+5 : KEY_SPACE equ 128
KEY_ESC_BYTE   equ keyboard_lines+8 : KEY_ESC   equ 4
KEY_E_BYTE     equ keyboard_lines+7 : KEY_E     equ 4
KEY_M_BYTE     equ keyboard_lines+4 : KEY_M     equ 64 ; qwerty
KEY_H_BYTE     equ keyboard_lines+5 ; KEY_H     equ 16
KEY_C_BYTE     equ keyboard_lines+7 : KEY_C     equ 64
KEY_I_BYTE     equ keyboard_lines+4 : KEY_I     equ 8
KEY_X_BYTE     equ keyboard_lines+7 : KEY_X     equ 128
KEY_S_BYTE     equ keyboard_lines+7 : KEY_S_MENU equ 16

KEY_1_BYTE     equ keyboard_lines+8 : KEY_1      equ 1
KEY_2_BYTE     equ keyboard_lines+8 : KEY_2      equ 2
KEY_3_BYTE     equ keyboard_lines+7 : KEY_3      equ 2
KEY_4_BYTE     equ keyboard_lines+7 : KEY_4      equ 1
KEY_5_BYTE     equ keyboard_lines+6 : KEY_5      equ 2
KEY_6_BYTE     equ keyboard_lines+6 : KEY_6      equ 1
KEY_7_BYTE     equ keyboard_lines+5 : KEY_7      equ 2
KEY_8_BYTE     equ keyboard_lines+5 : KEY_8      equ 1
KEY_9_BYTE     equ keyboard_lines+4 : KEY_9      equ 2
KEY_0_BYTE     equ keyboard_lines+4 : KEY_0      equ 1



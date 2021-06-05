
; minimal character output

macro locate posx,posy
ld hl,#4000+{posx}+{posy}*128 : ld (printchar.cursor+1),hl
mend

; A=char 0=>37
printchar
.cursor ld de,0
ld hl,spr_char : add a : add a : add a : ld c,a : ld a,0 : adc a : ld b,a : add hl,bc
ex hl,de
ld bc,#800
ld a,(de) : inc e : ld (hl),a : inc l : ld (.cursor+1),hl : dec l : add hl,bc
ld lx,7
.loopy ld a,(de) : inc e : ld (hl),a : add hl,bc : dec lx : jr nz,.loopy
ret

; HL=string terminated with last char OR bit7==1
printstring
ld a,(hl) : and #7F : exx : call printchar : exx
ld a,(hl) : and #80 : ret nz : inc hl : jr printstring

align 8
spr_char
incbin './gfx/ttd_font.bin'
defs 8

charset '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ[]-:/. ',0

str_title           str 'OPEN TOWER DEFENSE'
str_crew01          str 'CODE BY ROUDOUDOU'
str_crew02          str 'GFX BY HWIKAA'
str_crew03          str '6-CH MUSIC BY E-DREDON'
str_crew04          str '3-CH MUSIC BY TOM AND JERRY'
str_crew05          str 'FONT BY DADAKO STUDIO'

str_beta            defb 'BUILD ' : TIMESTAMP 'YYMMDDhhmm' : str ' ENGINE UP TO 768 SIMULTANEOUS SPRITES'

str_gamechoice      str 'GAME CHOICE'
str_gameeasy        str '[E]ASY'
str_gamemedium      str '[M]EDIUM'
str_gamehard        str '[H]ARD'
str_gamextreme      str '[X]TREME'
str_gamesound       str '[S]OUND PSG/PLAYCITY'
str_gamechallenge   str '[C]HALLENGES'
str_gamemanual      str '[I]NSTRUCTIONS'

str_challengetitle  str 'CHALLENGES'
str_challenge_1     str '[1] NO DELETE'
str_challenge_2     str '[2] 10000 CREDITS'
str_challenge_3     str '[3] ONE STRONG WAVE'
str_challenge_4     str '[4] 20 TOWERS'
str_challenge_5     str '[5] CHECKER'

str_congratulations str 'CONGRATULATIONS'
str_wineasy         str 'YOU WIN IN EASY MODE'
str_winmedium       str 'YOU WIN IN MEDIUM MODE'
str_winhard         str 'YOU WIN IN HARD MODE'
str_winxtreme       str 'YOU WIN IN EXTREME MODE'
str_winchallenge    str 'YOU WIN THE CHALLENGE'
str_continue        str 'ESC FOR MENU OR SPACE TO CONTINUE'
str_youlose         str ' YOU LOSE BOUUUUUUUUUU '

str_instructions    str 'INSTRUCTIONS'
str_manual          str 'USE KEYBOARD'
str_manual2         str 'SURVIVE 100 WAVES OR CHALLENGE GOAL'
str_tower01         str 'TOWER COSTS  10 CREDITS'
str_tower02         str 'FROST COSTS  50 CREDITS'
str_tower03         str 'BASH  COSTS 100 CREDITS'
str_tower04         str 'SWARN COSTS  50 CREDITS'
str_tower05         str 'HURRICANE   150 CREDITS'
str_upgrade         str 'UPDATE COST IS DISPLAYED WHEN CURSOR IS SET ON A TOWER'
str_goodluck        str 'GOOD LUCK'

charset


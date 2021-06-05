
RELEASE_SNAP   = 0
RELEASE_DSK    = 0
RELEASE_TAPE   = 0
RELEASE_AMSDOS = 1
RELEASE_BINARY = 0

if RELEASE_SNAP
buildsna
bankset 0
endif

org #100
run #100
di
ld bc,#F782 ; PPI output A, output C
out (c),c

ld sp,#38 ;;;;;maxstack+1 ; => #38 ???
ld bc,#7F00+%10001101 : out (c),c ; MODE 1 !!!
ld hl,int38
ld de,#38
ld bc,int38end-int38
ldir
ld bc,#FA7E : out (c),0 ; Floppy MOTOR OFF
ld bc,#7FC3 : out (c),c : maxstack=$ : call #C000 ; Init AKY player
ld bc,#7FC0 : currentbank=$-2
ei

out (c),c
ld bc,#BC00+13 : out (c),c : inc b : out (c),0
jr init

;******************************************************
;                    music handler
;******************************************************
int38
org #38,$
push af
push hl
ld hl,int_cpt
ld a,(hl)
add #10
ld (hl),a
jr c,int_muzik
pop hl
pop af
ei
ret

int_cpt defb #AA
cptmus defb 0

int_muzik
rld
push bc,de : exa : exx : push af,bc,de,hl,ix,iy
ld hl,cptmus : inc (hl)
ld bc,#7FC3 : out (c),c
call #C006 ; PLAY one frame
ld a,(currentbank) : ld b,#7F : out (c),a
pop iy,ix,hl,de,bc,af : exx : exa : pop de,bc,hl,af
ei
ret



;assert $<init
org $
int38end

;****************************************************
;         CRTC initialisation, colors, PPI
;****************************************************
crtc_data defb 63,32,42,#8E,38,0,32,34,0,7,0,0,#30,00

;***************************
           init
;***************************
; some stuff for computations
ld a,0  : ld (0),a
ld a,24 : ld (1),a
ld a,48 : ld (2),a
ld a,72 : ld (3),a
; 0/48/96/144
ld a,0  : ld (4),a
ld a,48 : ld (5),a
ld a,96 : ld (6),a
ld a,144: ld (7),a
; 0/96/192/288

xor a
ld d,a
ld e,a
ld b,#bc
ld hl,crtc_data

; loop is useless when we have memory and a good cruncher
ld d,14
.loop14
out (c),a : inc b : inc b : outi : inc a : dec b
dec d : jr nz,.loop14

ld bc,#7F00 : out (c),c : ld a,#54 : out (c),a : inc c
              out (c),c : ld a,#4C : out (c),a : inc c ; rouge
              out (c),c : ld a,#40 : out (c),a : inc c ; gris
              out (c),c : ld a,#4B : out (c),a : ld c,#10 ; blanc
              out (c),c : ld a,#54 : out (c),a
ld hl,stcomptiles
ld de,#B000
ld bc,ecomptiles-#B000
ldir

include 'engine.asm'

print "engine ends in ",{hex}$

stcomptiles
org #B000,$
include 'compiled_tiles.asm'
ecomptiles
print "compiled tiles size =",$-compiled_tile_0
assert $<=#C000
org $

IF RELEASE_DSK
save"otd.bin",#100,$-#100,DSK,"otd_basic.dsk"
ENDIF

IF RELEASE_BINARY
save"OpenTowerDefense_rawOrg100.bin",#100,$-#100
print 'FICHIER BINAIRE SANS ENTETE AMSDOS'
ENDIF

print "Full executable size=",{hex}$-#100


align 32
defb 'Big up to all emulator authors'
align 32
defb 'Marco, Bernd, Ulrich, Cesar,    Megachur, Thomas'
align 32
defb 'This production was made        with RASM'
align 32
defb 'new tools were designed in orderto make a proper trackload'
align 32
repeat 64 : defb 'rasm ' : rend

IF RELEASE_SNAP
bankset 1
ELSE
bank
ENDIF

org #4000
incbin './gfx/cover003.bin'

IF RELEASE_SNAP
ELSE
bank
ENDIF

org #C000
incbin './zik/music3CH.bin'

IF RELEASE_SNAP
ELSE
bank
ENDIF

org #8000
org #C000,$
ld hl,zezik
include './zik/PlayerAkyMultiPsg.asm'
zezik include './zik/muzik_aky.asm'
org $
IF RELEASE_BINARY
save"./zik/music6CH.bin",#8000,$-#8000
ENDIF

IF RELEASE_DSK
;save"otd-play.muz",#C000,$-#C000,DSK,"otd_basic.dsk"

ENDIF



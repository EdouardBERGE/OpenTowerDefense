;*******************************************************
                   compiled_tile_0
;*******************************************************
ex hl,de

; register init
xor a
ld bc,#0903
ld de,#0D0E
ld (hl),a   : inc l : ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : set 3,h
ld (hl),b   : dec l : ld (hl),b   : dec l : ld (hl),c   : dec l : ld (hl),b   : set 4,h
ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),c   : inc l : ld (hl),e   : res 3,h
ld (hl),d   : dec l : ld (hl),c   : dec l : ld (hl),b   : dec l : ld (hl),d   : set 5,h
ld (hl),c   : inc l : ld (hl),e   : inc l : ld (hl),c   : inc l : ld (hl),a   : set 3,h
ld (hl),c   : dec l : ld (hl),c   : dec l : ld (hl),e   : dec l : ld (hl),c   : res 4,h
ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),d   : dec l : ld (hl),b   : dec l : ld (hl),b   : dec l : ld (hl),b   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),b   : inc l : ld (hl),d   : inc l : ld (hl),a   : inc l : ld (hl),c   : set 3,h
ld (hl),b   : dec l : ld (hl),e   : dec l : ld (hl),a   : dec l : ld (hl),a   : set 4,h
ld (hl),c   : inc l : ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),e   : res 3,h
ld (hl),e   : dec l : ld (hl),e   : dec l : ld (hl),b   : dec l : ld (hl),c   : set 5,h
ld (hl),e   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : set 3,h
ld (hl),d   : dec l : ld (hl),c   : dec l : ld (hl),c   : dec l : ld (hl),e   : res 4,h
ld (hl),a   : inc l : ld (hl),b   : inc l : ld (hl),b   : inc l : ld (hl),a   : res 3,h
ld (hl),b   : dec l : ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),b   : 
jp restore_background.loopback


;*******************************************************
                   compiled_tile_1
;*******************************************************
ex hl,de

; register init
xor a
ld bc,#0309
ld de,#0D0E
ld (hl),a   : inc l : ld (hl),b   : inc l : ld (hl),a   : inc l : ld (hl),a   : set 3,h
ld (hl),c   : dec l : ld (hl),c   : dec l : ld (hl),b   : dec l : ld (hl),c   : set 4,h
ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : inc l : ld (hl),e   : res 3,h
ld (hl),d   : dec l : ld (hl),b   : dec l : ld (hl),c   : dec l : ld (hl),d   : set 5,h
ld (hl),b   : inc l : ld (hl),#3F : inc l : ld (hl),b   : inc l : ld (hl),a   : set 3,h
ld (hl),b   : dec l : ld (hl),#8B : dec l : ld (hl),#3F : dec l : ld (hl),b   : res 4,h
ld (hl),d   : inc l : ld (hl),#2F : inc l : ld (hl),a   : inc l : ld (hl),c   : res 3,h
ld (hl),d   : dec l : ld (hl),c   : dec l : ld (hl),c   : dec l : ld (hl),c   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),c   : inc l : ld (hl),#3F : inc l : ld (hl),#CC : inc l : ld (hl),b   : set 3,h
ld (hl),c   : dec l : ld (hl),#8E : dec l : ld (hl),#33 : dec l : ld (hl),a   : set 4,h
ld (hl),b   : inc l : ld (hl),#2F : inc l : ld (hl),d   : inc l : ld (hl),e   : res 3,h
ld (hl),e   : dec l : ld (hl),e   : dec l : ld (hl),#3B : dec l : ld (hl),b   : set 5,h
ld (hl),e   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),c   : set 3,h
ld (hl),d   : dec l : ld (hl),b   : dec l : ld (hl),b   : dec l : ld (hl),e   : res 4,h
ld (hl),a   : inc l : ld (hl),c   : inc l : ld (hl),c   : inc l : ld (hl),a   : res 3,h
ld (hl),c   : dec l : ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),c   : 
jp restore_background.loopback


;*******************************************************
                   compiled_tile_2
;*******************************************************
ex hl,de

; register init
xor a
ld bc,#1188
ld d,#FF
ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : set 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),#AA : set 5,h
ld (hl),c   : inc l : ld (hl),#01 : inc l : ld (hl),#08 : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),#8C : dec l : ld (hl),#03 : dec l : ld (hl),c   : res 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),#40 : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),c   : inc l : ld (hl),#03 : inc l : ld (hl),#0C : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),#08 : dec l : ld (hl),#01 : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 5,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : set 3,h
ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : res 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : 
jp restore_background.loopback


;*******************************************************
                   compiled_tile_3
;*******************************************************
ex hl,de

; register init
xor a
ld bc,#1188
ld d,#FF
ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : set 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),c   : dec l : ld (hl),#AA : set 5,h
ld (hl),c   : inc l : ld (hl),#01 : inc l : ld (hl),#08 : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),#8C : dec l : ld (hl),#03 : dec l : ld (hl),c   : res 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),#40 : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),c   : inc l : ld (hl),#03 : inc l : ld (hl),#0C : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),#08 : dec l : ld (hl),#01 : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 5,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : set 3,h
ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : res 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : 
jp restore_background.loopback


;*******************************************************
                   compiled_tile_4
;*******************************************************
ex hl,de

; register init
xor a
ld bc,#1188
ld d,#FF
ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : set 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),#AA : dec l : ld (hl),#AA : set 5,h
ld (hl),c   : inc l : ld (hl),#01 : inc l : ld (hl),#08 : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),#8C : dec l : ld (hl),#03 : dec l : ld (hl),c   : res 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),#40 : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),c   : inc l : ld (hl),#03 : inc l : ld (hl),#0C : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),#08 : dec l : ld (hl),#01 : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 5,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : set 3,h
ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : res 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : 
jp restore_background.loopback


;*******************************************************
                   compiled_tile_5
;*******************************************************
ex hl,de

; register init
xor a
ld bc,#1188
ld d,#FF
ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : set 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),c   : dec l : ld (hl),#AA : dec l : ld (hl),#AA : set 5,h
ld (hl),c   : inc l : ld (hl),#01 : inc l : ld (hl),#08 : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),#8C : dec l : ld (hl),#03 : dec l : ld (hl),c   : res 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),#40 : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),c   : inc l : ld (hl),#03 : inc l : ld (hl),#0C : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),#08 : dec l : ld (hl),#01 : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 5,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : set 3,h
ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : res 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : 
jp restore_background.loopback


;*******************************************************
                   compiled_tile_6
;*******************************************************
ex hl,de

; register init
xor a
ld bc,#1188
ld de,#FF66
ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : set 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),#AA : set 5,h
ld (hl),c   : inc l : ld (hl),e   : inc l : ld (hl),e   : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),c   : dec l : ld (hl),b   : dec l : ld (hl),c   : res 4,h
ld (hl),c   : inc l : ld (hl),#22 : inc l : ld (hl),#44 : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),c   : inc l : ld (hl),b   : inc l : ld (hl),c   : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),e   : dec l : ld (hl),e   : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),#44 : dec l : ld (hl),#22 : dec l : ld (hl),c   : set 5,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : set 3,h
ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : res 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : 
jp restore_background.loopback


;*******************************************************
                   compiled_tile_7
;*******************************************************
ex hl,de

; register init
xor a
ld bc,#8811
ld de,#FF22
ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : set 3,h
ld (hl),c   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),b   : set 4,h
ld (hl),b   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),c   : res 3,h
ld (hl),c   : dec l : ld (hl),a   : dec l : ld (hl),b   : dec l : ld (hl),#AA : set 5,h
ld (hl),b   : inc l : ld (hl),e   : inc l : ld (hl),#44 : inc l : ld (hl),c   : set 3,h
ld (hl),c   : dec l : ld (hl),b   : dec l : ld (hl),#55 : dec l : ld (hl),b   : res 4,h
ld (hl),b   : inc l : ld (hl),#CC : inc l : ld (hl),#BB : inc l : ld (hl),c   : res 3,h
ld (hl),c   : dec l : ld (hl),e   : dec l : ld (hl),#44 : dec l : ld (hl),b   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),b   : inc l : ld (hl),c   : inc l : ld (hl),#AA : inc l : ld (hl),c   : set 3,h
ld (hl),c   : dec l : ld (hl),#44 : dec l : ld (hl),e   : dec l : ld (hl),b   : set 4,h
ld (hl),b   : inc l : ld (hl),#44 : inc l : ld (hl),e   : inc l : ld (hl),c   : res 3,h
ld (hl),c   : dec l : ld (hl),#33 : dec l : ld (hl),#DD : dec l : ld (hl),b   : set 5,h
ld (hl),b   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),c   : set 3,h
ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : res 4,h
ld (hl),b   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),c   : res 3,h
ld (hl),c   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),b   : 
jp restore_background.loopback


;*******************************************************
                   compiled_tile_8
;*******************************************************
ex hl,de

; register init
xor a
ld bc,#8811
ld de,#5599
ld (hl),#37 : inc l : ld (hl),#FF : inc l : ld (hl),#FF : inc l : ld (hl),#CE : set 3,h
ld (hl),#23 : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),#4C : set 4,h
ld (hl),b   : inc l : ld (hl),b   : inc l : ld (hl),c   : inc l : ld (hl),c   : res 3,h
ld (hl),c   : dec l : ld (hl),a   : dec l : ld (hl),d   : dec l : ld (hl),e   : set 5,h
ld (hl),b   : inc l : ld (hl),#AA : inc l : ld (hl),d   : inc l : ld (hl),c   : set 3,h
ld (hl),c   : dec l : ld (hl),b   : dec l : ld (hl),c   : dec l : ld (hl),b   : res 4,h
ld (hl),b   : inc l : ld (hl),#44 : inc l : ld (hl),#22 : inc l : ld (hl),c   : res 3,h
ld (hl),e   : dec l : ld (hl),d   : dec l : ld (hl),#AA : dec l : ld (hl),e   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),b   : inc l : ld (hl),c   : inc l : ld (hl),b   : inc l : ld (hl),c   : set 3,h
ld (hl),c   : dec l : ld (hl),d   : dec l : ld (hl),#AA : dec l : ld (hl),b   : set 4,h
ld (hl),e   : inc l : ld (hl),#AA : inc l : ld (hl),d   : inc l : ld (hl),e   : res 3,h
ld (hl),c   : dec l : ld (hl),#22 : dec l : ld (hl),#44 : dec l : ld (hl),b   : set 5,h
ld (hl),#4C : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),#23 : set 3,h
ld (hl),#CE : dec l : ld (hl),#FF : dec l : ld (hl),#FF : dec l : ld (hl),#37 : res 4,h
ld (hl),b   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),c   : res 3,h
ld (hl),c   : dec l : ld (hl),c   : dec l : ld (hl),b   : dec l : ld (hl),b   : 
jp restore_background.loopback


;*******************************************************
                   compiled_tile_9
;*******************************************************
ex hl,de

; register init
xor a
ld bc,#8899
ld de,#1144
ld (hl),#37 : inc l : ld (hl),#FF : inc l : ld (hl),#FF : inc l : ld (hl),#CE : set 3,h
ld (hl),#23 : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),#4C : set 4,h
ld (hl),#BB : inc l : ld (hl),#22 : inc l : ld (hl),e   : inc l : ld (hl),#DD : res 3,h
ld (hl),c   : dec l : ld (hl),e   : dec l : ld (hl),#55 : dec l : ld (hl),c   : set 5,h
ld (hl),c   : inc l : ld (hl),#AA : inc l : ld (hl),#55 : inc l : ld (hl),c   : set 3,h
ld (hl),d   : dec l : ld (hl),b   : dec l : ld (hl),d   : dec l : ld (hl),b   : res 4,h
ld (hl),b   : inc l : ld (hl),e   : inc l : ld (hl),#22 : inc l : ld (hl),d   : res 3,h
ld (hl),d   : dec l : ld (hl),#55 : dec l : ld (hl),#AA : dec l : ld (hl),b   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),b   : inc l : ld (hl),d   : inc l : ld (hl),b   : inc l : ld (hl),d   : set 3,h
ld (hl),c   : dec l : ld (hl),#55 : dec l : ld (hl),#AA : dec l : ld (hl),c   : set 4,h
ld (hl),b   : inc l : ld (hl),#AA : inc l : ld (hl),#55 : inc l : ld (hl),d   : res 3,h
ld (hl),d   : dec l : ld (hl),#22 : dec l : ld (hl),e   : dec l : ld (hl),b   : set 5,h
ld (hl),#4C : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),#23 : set 3,h
ld (hl),#CE : dec l : ld (hl),#FF : dec l : ld (hl),#FF : dec l : ld (hl),#37 : res 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),c   : res 3,h
ld (hl),#DD : dec l : ld (hl),e   : dec l : ld (hl),#22 : dec l : ld (hl),#BB : 
jp restore_background.loopback


;*******************************************************
                   compiled_tile_10
;*******************************************************
ex hl,de

; register init
xor a
ld bc,#1188
ld de,#FF01
ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : set 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),#AA : set 5,h
ld (hl),c   : inc l : ld (hl),#03 : inc l : ld (hl),#8C : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),#0C : dec l : ld (hl),#03 : dec l : ld (hl),c   : res 4,h
ld (hl),c   : inc l : ld (hl),e   : inc l : ld (hl),#08 : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),#40 : dec l : ld (hl),a   : dec l : ld (hl),c   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),c   : inc l : ld (hl),e   : inc l : ld (hl),#08 : inc l : ld (hl),b   : set 3,h
ld (hl),#51 : dec l : ld (hl),a   : dec l : ld (hl),#40 : dec l : ld (hl),c   : set 4,h
ld (hl),#8B : inc l : ld (hl),#8C : inc l : ld (hl),#03 : inc l : ld (hl),#9D : res 3,h
ld (hl),#19 : dec l : ld (hl),e   : dec l : ld (hl),#08 : dec l : ld (hl),#89 : set 5,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : set 3,h
ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : res 4,h
ld (hl),#89 : inc l : ld (hl),#08 : inc l : ld (hl),e   : inc l : ld (hl),#19 : res 3,h
ld (hl),#1D : dec l : ld (hl),#03 : dec l : ld (hl),#0C : dec l : ld (hl),#8B : 
jp restore_background.loopback


;*******************************************************
                   compiled_tile_11
;*******************************************************
ex hl,de

; register init
xor a
ld bc,#8811
ld de,#FF01
ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : set 3,h
ld (hl),c   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),b   : set 4,h
ld (hl),b   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),c   : res 3,h
ld (hl),c   : dec l : ld (hl),a   : dec l : ld (hl),b   : dec l : ld (hl),#AA : set 5,h
ld (hl),b   : inc l : ld (hl),#03 : inc l : ld (hl),#8C : inc l : ld (hl),c   : set 3,h
ld (hl),c   : dec l : ld (hl),#0C : dec l : ld (hl),#03 : dec l : ld (hl),b   : res 4,h
ld (hl),b   : inc l : ld (hl),e   : inc l : ld (hl),#08 : inc l : ld (hl),c   : res 3,h
ld (hl),c   : dec l : ld (hl),#40 : dec l : ld (hl),a   : dec l : ld (hl),b   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),b   : inc l : ld (hl),e   : inc l : ld (hl),#08 : inc l : ld (hl),c   : set 3,h
ld (hl),#51 : dec l : ld (hl),a   : dec l : ld (hl),#40 : dec l : ld (hl),b   : set 4,h
ld (hl),#8B : inc l : ld (hl),#8C : inc l : ld (hl),#03 : inc l : ld (hl),#9D : res 3,h
ld (hl),#19 : dec l : ld (hl),e   : dec l : ld (hl),#08 : dec l : ld (hl),#89 : set 5,h
ld (hl),b   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),c   : set 3,h
ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : res 4,h
ld (hl),#89 : inc l : ld (hl),#08 : inc l : ld (hl),e   : inc l : ld (hl),#19 : res 3,h
ld (hl),#1D : dec l : ld (hl),#03 : dec l : ld (hl),#0C : dec l : ld (hl),#8B : 
jp restore_background.loopback


;*******************************************************
                   compiled_tile_12
;*******************************************************
ex hl,de

; register init
xor a
ld bc,#1188
ld de,#FF01
ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : set 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),#AA : dec l : ld (hl),#AA : set 5,h
ld (hl),c   : inc l : ld (hl),#03 : inc l : ld (hl),#8C : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),#0C : dec l : ld (hl),#03 : dec l : ld (hl),c   : res 4,h
ld (hl),c   : inc l : ld (hl),e   : inc l : ld (hl),#08 : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),#40 : dec l : ld (hl),a   : dec l : ld (hl),c   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),c   : inc l : ld (hl),e   : inc l : ld (hl),#08 : inc l : ld (hl),b   : set 3,h
ld (hl),#51 : dec l : ld (hl),a   : dec l : ld (hl),#40 : dec l : ld (hl),c   : set 4,h
ld (hl),#8B : inc l : ld (hl),#8C : inc l : ld (hl),#03 : inc l : ld (hl),#9D : res 3,h
ld (hl),#19 : dec l : ld (hl),e   : dec l : ld (hl),#08 : dec l : ld (hl),#89 : set 5,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : set 3,h
ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : res 4,h
ld (hl),#89 : inc l : ld (hl),#08 : inc l : ld (hl),e   : inc l : ld (hl),#19 : res 3,h
ld (hl),#1D : dec l : ld (hl),#03 : dec l : ld (hl),#0C : dec l : ld (hl),#8B : 
jp restore_background.loopback


;*******************************************************
                   compiled_tile_13
;*******************************************************
ex hl,de

; register init
xor a
ld bc,#1188
ld de,#FF01
ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : set 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),c   : dec l : ld (hl),#AA : dec l : ld (hl),#AA : set 5,h
ld (hl),c   : inc l : ld (hl),#03 : inc l : ld (hl),#8C : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),#0C : dec l : ld (hl),#03 : dec l : ld (hl),c   : res 4,h
ld (hl),c   : inc l : ld (hl),e   : inc l : ld (hl),#08 : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),#40 : dec l : ld (hl),a   : dec l : ld (hl),c   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),c   : inc l : ld (hl),e   : inc l : ld (hl),#08 : inc l : ld (hl),b   : set 3,h
ld (hl),#51 : dec l : ld (hl),a   : dec l : ld (hl),#40 : dec l : ld (hl),c   : set 4,h
ld (hl),#8B : inc l : ld (hl),#8C : inc l : ld (hl),#03 : inc l : ld (hl),#9D : res 3,h
ld (hl),#19 : dec l : ld (hl),e   : dec l : ld (hl),#08 : dec l : ld (hl),#89 : set 5,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : set 3,h
ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : res 4,h
ld (hl),#89 : inc l : ld (hl),#08 : inc l : ld (hl),e   : inc l : ld (hl),#19 : res 3,h
ld (hl),#1D : dec l : ld (hl),#03 : dec l : ld (hl),#0C : dec l : ld (hl),#8B : 
jp restore_background.loopback


;*******************************************************
                   compiled_tile_14
;*******************************************************
ex hl,de

; register init
xor a
ld bc,#1188
ld d,#FF
ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : set 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),#AA : set 5,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),#6F : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),#EE : dec l : ld (hl),#01 : dec l : ld (hl),c   : res 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),#03 : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),c   : inc l : ld (hl),#13 : inc l : ld (hl),#CE : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),#8C : dec l : ld (hl),d   : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),#51 : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),#08 : dec l : ld (hl),#33 : dec l : ld (hl),c   : set 5,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : set 3,h
ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : res 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),#91 : dec l : ld (hl),c   : 
jp restore_background.loopback


;*******************************************************
                   compiled_tile_15
;*******************************************************
ex hl,de

; register init
xor a
ld bc,#1188
ld d,#FF
ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : set 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),c   : dec l : ld (hl),#AA : set 5,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),#6F : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),#EE : dec l : ld (hl),#01 : dec l : ld (hl),c   : res 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),#03 : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),c   : inc l : ld (hl),#13 : inc l : ld (hl),#CE : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),#8C : dec l : ld (hl),d   : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),#51 : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),#08 : dec l : ld (hl),#33 : dec l : ld (hl),c   : set 5,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : set 3,h
ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : res 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),#91 : dec l : ld (hl),c   : 
jp restore_background.loopback


;*******************************************************
                   compiled_tile_16
;*******************************************************
ex hl,de

; register init
xor a
ld bc,#1188
ld d,#FF
ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : set 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),#AA : dec l : ld (hl),#AA : set 5,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),#6F : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),#EE : dec l : ld (hl),#01 : dec l : ld (hl),c   : res 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),#03 : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),c   : inc l : ld (hl),#13 : inc l : ld (hl),#CE : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),#8C : dec l : ld (hl),d   : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),#51 : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),#08 : dec l : ld (hl),#33 : dec l : ld (hl),c   : set 5,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : set 3,h
ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : res 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),#91 : dec l : ld (hl),c   : 
jp restore_background.loopback


;*******************************************************
                   compiled_tile_17
;*******************************************************
ex hl,de

; register init
xor a
ld bc,#1188
ld d,#FF
ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : set 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),c   : dec l : ld (hl),#AA : dec l : ld (hl),#AA : set 5,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),#6F : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),#EE : dec l : ld (hl),#01 : dec l : ld (hl),c   : res 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),#03 : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),c   : inc l : ld (hl),#13 : inc l : ld (hl),#CE : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),#8C : dec l : ld (hl),d   : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),#51 : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),#08 : dec l : ld (hl),#33 : dec l : ld (hl),c   : set 5,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : set 3,h
ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : res 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),#91 : dec l : ld (hl),c   : 
jp restore_background.loopback


;*******************************************************
                   compiled_tile_18
;*******************************************************
ex hl,de

; register init
xor a
ld bc,#1188
ld d,#FF
ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : set 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),#02 : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),#AA : set 5,h
ld (hl),c   : inc l : ld (hl),#33 : inc l : ld (hl),#08 : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),#31 : dec l : ld (hl),c   : res 4,h
ld (hl),c   : inc l : ld (hl),#01 : inc l : ld (hl),#8C : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),#4C : dec l : ld (hl),a   : dec l : ld (hl),c   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : set 3,h
ld (hl),#15 : dec l : ld (hl),a   : dec l : ld (hl),#02 : dec l : ld (hl),c   : set 4,h
ld (hl),#89 : inc l : ld (hl),#8C : inc l : ld (hl),#13 : inc l : ld (hl),#19 : res 3,h
ld (hl),#99 : dec l : ld (hl),#01 : dec l : ld (hl),#4C : dec l : ld (hl),c   : set 5,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : set 3,h
ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : res 4,h
ld (hl),#B9 : inc l : ld (hl),a   : inc l : ld (hl),#62 : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),#67 : dec l : ld (hl),#08 : dec l : ld (hl),#BB : 
jp restore_background.loopback


;*******************************************************
                   compiled_tile_19
;*******************************************************
ex hl,de

; register init
xor a
ld bc,#1188
ld d,#FF
ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : set 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),#02 : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),c   : dec l : ld (hl),#AA : set 5,h
ld (hl),c   : inc l : ld (hl),#33 : inc l : ld (hl),#08 : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),#31 : dec l : ld (hl),c   : res 4,h
ld (hl),c   : inc l : ld (hl),#01 : inc l : ld (hl),#8C : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),#4C : dec l : ld (hl),a   : dec l : ld (hl),c   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : set 3,h
ld (hl),#15 : dec l : ld (hl),a   : dec l : ld (hl),#02 : dec l : ld (hl),c   : set 4,h
ld (hl),#89 : inc l : ld (hl),#8C : inc l : ld (hl),#13 : inc l : ld (hl),#19 : res 3,h
ld (hl),#99 : dec l : ld (hl),#01 : dec l : ld (hl),#4C : dec l : ld (hl),c   : set 5,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : set 3,h
ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : res 4,h
ld (hl),#B9 : inc l : ld (hl),a   : inc l : ld (hl),#62 : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),#67 : dec l : ld (hl),#08 : dec l : ld (hl),#BB : 
jp restore_background.loopback


;*******************************************************
                   compiled_tile_20
;*******************************************************
ex hl,de

; register init
xor a
ld bc,#1188
ld d,#FF
ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : set 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),c   : set 4,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),#02 : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),#AA : dec l : ld (hl),#AA : set 5,h
ld (hl),c   : inc l : ld (hl),#33 : inc l : ld (hl),#08 : inc l : ld (hl),b   : set 3,h
ld (hl),b   : dec l : ld (hl),a   : dec l : ld (hl),#31 : dec l : ld (hl),c   : res 4,h
ld (hl),c   : inc l : ld (hl),#01 : inc l : ld (hl),#8C : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),#4C : dec l : ld (hl),a   : dec l : ld (hl),c   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : set 3,h
ld (hl),#15 : dec l : ld (hl),a   : dec l : ld (hl),#02 : dec l : ld (hl),c   : set 4,h
ld (hl),#89 : inc l : ld (hl),#8C : inc l : ld (hl),#13 : inc l : ld (hl),#19 : res 3,h
ld (hl),#99 : dec l : ld (hl),#01 : dec l : ld (hl),#4C : dec l : ld (hl),c   : set 5,h
ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),b   : set 3,h
ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : res 4,h
ld (hl),#B9 : inc l : ld (hl),a   : inc l : ld (hl),#62 : inc l : ld (hl),b   : res 3,h
ld (hl),b   : dec l : ld (hl),#67 : dec l : ld (hl),#08 : dec l : ld (hl),#BB : 
jp restore_background.loopback


;*******************************************************
                   compiled_tile_21
;*******************************************************
ex hl,de

; register init
xor a
ld bc,#8811
ld de,#FF01
ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : inc l : ld (hl),d   : set 3,h
ld (hl),c   : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),b   : set 4,h
ld (hl),b   : inc l : ld (hl),a   : inc l : ld (hl),#02 : inc l : ld (hl),c   : res 3,h
ld (hl),c   : dec l : ld (hl),b   : dec l : ld (hl),#AA : dec l : ld (hl),#AA : set 5,h
ld (hl),b   : inc l : ld (hl),#33 : inc l : ld (hl),#08 : inc l : ld (hl),c   : set 3,h
ld (hl),c   : dec l : ld (hl),a   : dec l : ld (hl),#31 : dec l : ld (hl),b   : res 4,h
ld (hl),b   : inc l : ld (hl),e   : inc l : ld (hl),#8C : inc l : ld (hl),c   : res 3,h
ld (hl),c   : dec l : ld (hl),#4C : dec l : ld (hl),a   : dec l : ld (hl),b   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),b   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),e   : set 3,h
ld (hl),#15 : dec l : ld (hl),a   : dec l : ld (hl),#02 : dec l : ld (hl),b   : set 4,h
ld (hl),#89 : inc l : ld (hl),#8C : inc l : ld (hl),#13 : inc l : ld (hl),#19 : res 3,h
ld (hl),#99 : dec l : ld (hl),e   : dec l : ld (hl),#4C : dec l : ld (hl),b   : set 5,h
ld (hl),b   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),c   : set 3,h
ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : dec l : ld (hl),d   : res 4,h
ld (hl),#B9 : inc l : ld (hl),a   : inc l : ld (hl),#62 : inc l : ld (hl),c   : res 3,h
ld (hl),c   : dec l : ld (hl),#67 : dec l : ld (hl),#08 : dec l : ld (hl),#BB : 
jp restore_background.loopback


;*******************************************************
                   compiled_tile_22
;*******************************************************
ex hl,de

; register init
ld a,#0F
ld bc,#078F
ld de,#0E3F
ld (hl),#01 : inc l : ld (hl),b   : inc l : ld (hl),#7F : inc l : ld (hl),#0C : set 3,h
ld (hl),d   : dec l : ld (hl),c   : dec l : ld (hl),a   : dec l : ld (hl),b   : set 4,h
ld (hl),b   : inc l : ld (hl),e   : inc l : ld (hl),#9F : inc l : ld (hl),d   : res 3,h
ld (hl),a   : dec l : ld (hl),#9F : dec l : ld (hl),e   : dec l : ld (hl),#03 : set 5,h
ld (hl),#1F : inc l : ld (hl),#1F : inc l : ld (hl),#CF : inc l : ld (hl),c   : set 3,h
ld (hl),c   : dec l : ld (hl),a   : dec l : ld (hl),c   : dec l : ld (hl),#17 : res 4,h
ld (hl),#17 : inc l : ld (hl),e   : inc l : ld (hl),#CF : inc l : ld (hl),a   : res 3,h
ld (hl),a   : dec l : ld (hl),#CF : dec l : ld (hl),e   : dec l : ld (hl),a   : set 6,l : res 5,h ; HL+64-#2000
ld (hl),a   : inc l : ld (hl),c   : inc l : ld (hl),a   : inc l : ld (hl),a   : set 3,h
ld (hl),a   : dec l : ld (hl),#EF : dec l : ld (hl),#1F : dec l : ld (hl),b   : set 4,h
ld (hl),b   : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),#0D : res 3,h
ld (hl),d   : dec l : ld (hl),a   : dec l : ld (hl),#2F : dec l : ld (hl),#0B : set 5,h
ld (hl),#02 : inc l : ld (hl),#0B : inc l : ld (hl),d   : inc l : ld (hl),#0A : set 3,h
ld (hl),#04 : dec l : ld (hl),#05 : dec l : ld (hl),#05 : dec l : ld (hl),#01 : res 4,h
ld (hl),#05 : inc l : ld (hl),a   : inc l : ld (hl),a   : inc l : ld (hl),#04 : res 3,h
ld (hl),#0A : dec l : ld (hl),a   : dec l : ld (hl),a   : dec l : ld (hl),#0B : 
jp restore_background.loopback



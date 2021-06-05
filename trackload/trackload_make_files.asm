bank
incbin'catalog.raw'
save 'catart.raw',0,2048,DSK,'create_otd.dsk'

bank
incbin 'bootsector.raw'
save 'boot.raw',0,512,DSK,'create_otd.dsk'


bank
incbin 'trackload.raw'
save 'track.raw',0,2048,DSK,'create_otd.dsk'


bank
incbin 'snapshot.low.raw'
save 'low0.raw',0,16384,DSK,'create_otd.dsk'
save 'low1.raw',16384,4096,DSK,'create_otd.dsk'

bank
incbin 'snapshot.high.raw'
save 'high0.raw',0,16384,DSK,'create_otd.dsk'
save 'high1.raw',16384,16384,DSK,'create_otd.dsk'
save 'high2.raw',32768,16384,DSK,'create_otd.dsk'

bank
incbin 'gfx/emulator_detected.bin'
save 'track3.raw',0,16384,DSK,'create_otd.dsk'

bank
incbin 'gfx/emulator_not_detected.bin'
save 'track7.raw',0,16384,DSK,'create_otd.dsk'


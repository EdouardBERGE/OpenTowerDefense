
../edsktool.exe masterw.dsk -putfile 0:0:1 trackload.raw PHYSICAL -o masterw.dsk 

../edsktool.exe masterw.dsk -putfile 0:11:0 snapshot.low.raw PHYSICAL -o masterw.dsk

../edsktool.exe masterw.dsk -putfile 0:16:0 snapshot.high.raw PHYSICAL -o masterw.dsk


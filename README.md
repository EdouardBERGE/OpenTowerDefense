
Open Tower Defense is a game inspired from departed flash game Desktop Tower Defense by Paul Preece

Staff:
- roudoudou (Edouard BERGE) for code
- hwikaa for GFX cover and more
- e-dredon for 6 channels music
- Tom&Jerry for 3 channels music
- Ast for mass-storage version of the game

As the font is copyrighted material from Dadako studio, i remove it from the GitHub package (binaries are legal since i'm in order with them)

The game is coded in pure assembly language, and is compiled with RASM

Soundtrack on 3 channels for regular CPC and 6 channels for Playcity owners

The game performs a FDC compatibility test on startup based on GETID command. As far as i know, at the time of the game's release, no emulator succeed this simple test, rhaaaaaaaaaa!

About the engine:
- up to 768 simultaneous sprites
- fast path finding for every ennemies
- air/ground damages
- huge hit range for every towers
- dynamic range display for every towers
- versatile & highly configurable engine

![screenshot](https://github.com/EdouardBERGE/OpenTowerDefense/blob/main/screenshot.png)

The game comes with old tools and new tools :)

convgeneric => PNG conversion to CPC binaries
snapexplode => RAM extraction from a CPC emulator snapshot
edsktool    => Import/Export/Creation/modification tool for EDSK

compiletile => Used to create assembly code from sprites
superformat => Native CPC tool to create special floppy format

Thanks to Tom&Jerry for CATaclysme 1.2a tool (CAT'Art creation)
Thanks to Targhan/Arkos for AT2 music designer and players


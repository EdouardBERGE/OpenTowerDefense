/*************************************************************************
 *
 * very simple tile compiler => NO STATISTICS in this one
 *
*************************************************************************/

#include<string.h>
#include<stdlib.h>
#include<malloc.h>
#include<stdio.h>

void main(int argc, char **argv) {
	unsigned char *data;
	unsigned char spr[64];
	int filesize;
	FILE *f;
	int occur[256];
	int g,i,j,imax;
	int v[5],zev;
	int x,y,spri;

	/* minimal arg checking */
	if (argc<2) exit(-1);

	f=fopen(argv[1],"rb");
	fseek(f,0,SEEK_END);
	filesize=ftell(f);
	fseek(f,0,SEEK_SET);
	data=malloc(filesize);
	fread(data,1,filesize,f);
	fclose(f);

	for (g=0;g<filesize;g+=64) {
		for (i=0;i<256;i++) occur[i]=0;

		for (i=0;i<64;i++) {
			occur[data[g+i]]++;
		}

		/* we have 5 registers free => A,B,C,D,E */
		for (j=0;j<5;j++) {
			for (i=imax=0;i<256;i++) {
				if (occur[i]>occur[imax]) imax=i;
			}
			if (occur[imax]<3) {
				while (j<5) {
					v[j]=0x1234; // no more opt
					j++;
				}
			} else {
				v[j]=imax;
			}
			occur[imax]=0;
		}

		/* for black to register A */
		for (j=1;j<5;j++) {
			if (v[j]==0) {
				v[j]=v[0];
				v[0]=0;
			}
		}

		printf(";*******************************************************\n");
		printf("                   compiled_tile_%d\n",g>>6);
		printf(";*******************************************************\n");
		printf("ex hl,de\n");
		printf("\n; register init\n");
		if (!v[0]) {
			printf("xor a\n");
		} else {
			if (v[0]!=0x1234) printf("ld a,#%02X\n",v[0]);
		}

		if (v[1]!=0x1234 && v[2]!=0x1234) {
			printf("ld bc,#%04X\n",(v[1]<<8)|v[2]);
		} else {
			if (v[1]!=0x1234) printf("ld b,#%02X\n",v[1]);
			if (v[2]!=0x1234) printf("ld c,#%02X\n",v[2]);
		}
		
		if (v[3]!=0x1234 && v[4]!=0x1234) {
			printf("ld de,#%04X\n",(v[3]<<8)|v[4]);
		} else {
			if (v[3]!=0x1234) printf("ld d,#%02X\n",v[3]);
			if (v[4]!=0x1234) printf("ld e,#%02X\n",v[4]);
		}

		/* kind of grey coding for data + zigzag */

		spri=0;
		y=0;for (x=0;x<4;x++)  spr[spri++]=data[g+x+y*4];
		y=1;for (x=3;x>=0;x--) spr[spri++]=data[g+x+y*4];
		y=3;for (x=0;x<4;x++)  spr[spri++]=data[g+x+y*4];
		y=2;for (x=3;x>=0;x--) spr[spri++]=data[g+x+y*4];
		y=6;for (x=0;x<4;x++)  spr[spri++]=data[g+x+y*4];
		y=7;for (x=3;x>=0;x--) spr[spri++]=data[g+x+y*4];
		y=5;for (x=0;x<4;x++)  spr[spri++]=data[g+x+y*4];
		y=4;for (x=3;x>=0;x--) spr[spri++]=data[g+x+y*4];
		y=8+0;for (x=0;x<4;x++)  spr[spri++]=data[g+x+y*4];
		y=8+1;for (x=3;x>=0;x--) spr[spri++]=data[g+x+y*4];
		y=8+3;for (x=0;x<4;x++)  spr[spri++]=data[g+x+y*4];
		y=8+2;for (x=3;x>=0;x--) spr[spri++]=data[g+x+y*4];
		y=8+6;for (x=0;x<4;x++)  spr[spri++]=data[g+x+y*4];
		y=8+7;for (x=3;x>=0;x--) spr[spri++]=data[g+x+y*4];
		y=8+5;for (x=0;x<4;x++)  spr[spri++]=data[g+x+y*4];
		y=8+4;for (x=3;x>=0;x--) spr[spri++]=data[g+x+y*4];
		if (spri!=64) {
			printf("assert spri==64\n");
			exit(-1);
		}

		for (i=j=0;i<64;i++) {
			zev=spr[i];

			if (zev==v[0]) printf("ld (hl),a   : "); else
			if (zev==v[1]) printf("ld (hl),b   : "); else
			if (zev==v[2]) printf("ld (hl),c   : "); else
			if (zev==v[3]) printf("ld (hl),d   : "); else
			if (zev==v[4]) printf("ld (hl),e   : "); else
			               printf("ld (hl),#%02X : ",zev);
			j++;
			if (j==4) {
				switch (i>>2) {
					case  8:case 0:printf("set 3,h\n");break;
					case  9:case 1:printf("set 4,h\n");break;
					case 10:case 2:printf("res 3,h\n");break;
					case 11:case 3:printf("set 5,h\n");break;
					case 12:case 4:printf("set 3,h\n");break;
					case 13:case 5:printf("res 4,h\n");break;
					case 14:case 6:printf("res 3,h\n");break;
					case 7:printf("set 6,l : res 5,h ; HL+64-#2000\n");break;
					case 15:printf("\n");break;
					default:printf("warning remover\n");
				}
				j=0;
			} else {
				switch ((i>>2)&1) {
					case 0:printf("inc l : ");break;
					case 1:printf("dec l : ");break;
					default:printf("warning remover\n");break;
				}
			}
		}
		printf("jp restore_background.loopback\n");
		printf("\n\n");

	}
}


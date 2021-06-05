#include<stdlib.h>
#include<stdio.h>
#include<unistd.h>
#include<string.h>

void WriteMem(unsigned char *data, int slot, char *reffilename) {
	FILE *f;
	char *filename,*sep;

	if (slot<0 || slot>7) return;

	filename=strdup(reffilename);
	if ((sep=strstr(filename,".SNA"))!=NULL || (sep=strstr(filename,".sna"))!=NULL) {
		sprintf(sep,".BI%d",slot);
		unlink(filename);
		f=fopen(filename,"wb");
		if (!f) {
			printf("Impossible d'ouvrir [%s] en ecriture\n",filename);
			exit(1);
		}
		printf("Write 64K [%s]\n",filename);
		fwrite(data,1,65536,f);
		fclose(f);
	}
	free(filename);
}

void main(int argc, char **argv) {

	unsigned char *snapdata;
	unsigned char data[65536];
	int src,idx,rep,i,srcmax;
	int chunksize;
	int version,size;
	int snapsize;
	int slot;

	if (argc==2) {
		FILE *f;
		f=fopen(argv[1],"rb");
		if (!f) {
			printf("file [%s] not found\n",argv[1]);
			exit(-1);
		}
		fseek(f,0,SEEK_END);
		snapsize=ftell(f);
		fseek(f,0,SEEK_SET);
		snapdata=malloc(snapsize);
		if (!snapdata) {
			printf("cannot malloc %d bytes\n",snapsize);
			exit(-1);
		}
		fread(snapdata,1,snapsize,f);
		fclose(f);
	} else {
		printf("ziva file un snap!\n");
		exit(0);
	}

	if (snapdata[0]!='M' || snapdata[1]!='V' || snapdata[2]!=' ' || snapdata[3]!='-' || snapdata[4]!=' ' || snapdata[5]!='S' || snapdata[6]!='N' || snapdata[7]!='A') {
		printf("invalid snapshot header!\n");
		exit(-1);
	}

	if (snapsize<0x100) {
		printf("Invalid snapshot\n");
		exit(-1);
	}

	size=snapdata[0x6B]*1024;
	src=0x100;

	switch (snapdata[0x6B]) {
		default:
		case 0:
			if (snapdata[16]<3) {
				printf("snapshot v2 is empty => this is abnormal\n");
				exit(-1);
			} else {
				printf("skip raw dump\n");
			}
			break;
		case 64:
			if (snapsize==size+0x100) {
				WriteMem(snapdata+0x100,0,argv[1]);
			} else {
				printf("Invalid snapshot v2 consistency\n");
				exit(-1);
			}
			break;
		case 128:
			if (snapsize==size+0x100) {
				WriteMem(snapdata+0x100,0,argv[1]);
				WriteMem(snapdata+0x100+65536,1,argv[1]);
			} else {
				printf("Invalid snapshot v2 consistency\n");
				exit(-1);
			}
			break;
	}

	while (src+8<snapsize) {
		chunksize=snapdata[src+4]+snapdata[src+5]*256+snapdata[src+6]*65536+snapdata[src+7]*65536*256;
		if (snapdata[src+0]=='M' && snapdata[src+1]=='E' && snapdata[src+2]=='M') {
			// v3 snapshot has chunk MEM%d ou MX%02X en RLE + chunksize + data
			slot=snapdata[src+3]-'0';
			printf("decrunching slot %d\n",slot);
			idx=0;
			src+=8;
			srcmax=src+chunksize;
			if (srcmax>snapsize) {
				printf("invalid chunk in snapshot (overrun)\n");
				exit(-1);
			}
			while (idx<65536 && src<srcmax) {
				if (snapdata[src]==0xE5) {
					src++;
					for (i=0;i<snapdata[src] && idx<65536;i++) {
						data[idx++]=snapdata[src+1];
					}
					src+=2;
				} else {
					data[idx++]=snapdata[src++];
				}
			}
			if (src!=srcmax) {
				printf("invalid chunk in snapshot (overrun2)\n");
				exit(-1);
			}
			WriteMem(data,slot,argv[1]);
		} else {
			printf("skip non memory chunk of %d bytes\n",chunksize);
			src+=8+chunksize;
		}
	}
}


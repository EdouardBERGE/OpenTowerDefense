#define PROD 1

#ifdef PROD
#include "rasmlib.h"
#include "minilib.h"
#else
#include "../tools/library.h"
#include "../tools/libgfx.h"
#endif

#define __FILENAME__ "convgeneric.c"

#include<float.h>

#ifndef OS_WIN
/* gris */
#define KNORMAL  "\x1B[0m"
/* rouge foncé */
#define KERROR   "\x1B[31m"
/* vert */
#define KAYGREEN "\x1B[32m"
/* orange */
#define KWARNING "\x1B[33m"
/* bleu foncé */
#define KBLUE    "\x1B[34m"
/* bleu ciel */
#define KVERBOSE "\x1B[36m"
/* blanc */
#define KIO      "\x1B[97m"
#else
#define KNORMAL  ""
#define KERROR   ""
#define KAYGREEN ""
#define KWARNING ""
#define KBLUE    ""
#define KVERBOSE ""
#define KIO      ""
#endif


enum e_packed_format {
E_PACKED_CPC_MODE0=0,
E_PACKED_CPC_MODE1,
E_PACKED_CPC_MODE2,
E_PACKED_HSP_RAW,
E_PACKED_HSP_2PIX_LOGICAL,
E_PACKED_HSP_2PIX_REVERSE,
E_PACKED_HSP_4PIX_REVERSE,
E_PACKED_END
};

struct s_parameter {
	/* file */
	char *filename;
	char *outputfilename;
	char *sheetfilename;
	/* lara option */
	int lara;
	/* general options */
	int mode;
	int width;
	int split;
	int grad;
	int asmdump;
	char *exportpalettefilename;
	char *importpalettefilename;
	/* screen options */
	int single;
	int sx,sy;
	int ox,oy;
	int mask;
	int scrmode,oldmode;
	int lineperblock;
	int nblinescreen;
	int splitraster;
	/* hardware sprite options */
	int hsp;
	int scan;
	int maxextract;
	int black;
	int packed; /* 0, 4, 2 */
	int forceextraction;
	int keep_empty;
	int metax,metay;
};

struct s_sprite_info {
	int x,y;
	int adr,size;
};

#define MAXSPLIT 6

struct s_rastblock {
int col[16];
int nbcol;
int newcol;
};

struct s_rastline {
struct s_rastblock block[48];
int col[27];
int cptcol;
int nbblock;
int freenop;
int mode;
int reg[MAXSPLIT];
};

struct s_rastecran {
struct s_rastline line[280];
int nbline;
};

struct s_score {
int score;
int ga;
};


void color_error(int r, int v, int b) {
	static char rvb[4096]={0};
	int idx;

	idx=(r>>4)+((v>>4)<<4)+((b>>4)<<8);

	if (!rvb[idx]) {
		printf(KERROR"rvb color #%02X%02X%02X not found\n"KNORMAL,r,v,b);
		rvb[idx]=1;
	}
}

int GetIDXFromPixel(unsigned char *palette, unsigned char *pixel)
{
	#undef FUNC
	#define FUNC "GetIDXFromPalette"

	int imin=0,vmin,va;
	int i;

	if (!pixel[3]) return 0; /* transparency is zero */

	for (i=0;i<16;i++) {
		if (palette[i*3+0]==pixel[0] && palette[i*3+1]==pixel[1] && palette[i*3+2]==pixel[2]) return i;
	}
	color_error(pixel[0],pixel[1],pixel[2]);
	return -1;
}
int GetIDXFromPalette(unsigned char *palette, int r, int v, int b)
{
	#undef FUNC
	#define FUNC "GetIDXFromPalette"

	int imin=0,vmin,va;
	int i;


	for (i=0;i<16;i++) {
//printf("palette[%d]=%d/%d/%d\n",i,palette[i*3+0],palette[i*3+1],palette[i*3+2]);
		if (palette[i*3+0]==r && palette[i*3+1]==v && palette[i*3+2]==b) return i;
	}

//printf("pixel = R:%X G:%X B:%X ",r,v,b);
	if (r==0x70) r=0x80;
	if (v==0x70) v=0x80;
	if (b==0x70) b=0x80;
	for (i=0;i<16;i++) {
		if (palette[i*3+0]==r && palette[i*3+1]==v && palette[i*3+2]==b) return i;
	}

	color_error(r,v,b);
	return -1;
}

int GetGAFromRGB(int r, int v, int b) {
	#undef FUNC
	#define FUNC "GetGAFromRGB"

	int ga=64,rgb;

	if (r<85) r=0; else if (r>170) r=255; else r=128;
	if (v<85) v=0; else if (v>170) v=255; else v=128;
	if (b<85) b=0; else if (b>170) b=255; else b=128;

	rgb=r*65536+v*256+b;

	switch (rgb) {
		case 0x000000:ga=64+20;break;
		case 0x000080:ga=64+4;break;
		case 0x0000FF:ga=64+21;break;
		case 0x800000:ga=64+28;break;
		case 0x800080:ga=64+24;break;
		case 0x8000FF:ga=64+29;break;
		case 0xFF0000:ga=64+12;break;
		case 0xFF0080:ga=64+5;break;
		case 0xFF00FF:ga=64+13;break;
		case 0x008000:ga=64+22;break;
		case 0x008080:ga=64+6;break;
		case 0x0080FF:ga=64+23;break;
		case 0x808000:ga=64+30;break;
		case 0x808080:ga=64+0;break;
		case 0x8080FF:ga=64+31;break;
		case 0xFF8000:ga=64+14;break;
		case 0xFF8080:ga=64+7;break;
		case 0xFF80FF:ga=64+15;break;
		case 0x00FF00:ga=64+18;break;
		case 0x00FF80:ga=64+2;break;
		case 0x00FFFF:ga=64+19;break;
		case 0x80FF00:ga=64+26;break;
		case 0x80FF80:ga=64+25;break;
		case 0x80FFFF:ga=64+27;break;
		case 0xFFFF00:ga=64+10;break;
		case 0xFFFF80:ga=64+3;break;
		case 0xFFFFFF:ga=64+11;break;
		default:printf(KERROR"unknown color for CPC\n"KNORMAL);exit(-1);
	}
	return ga;
}
int GetBASICFromRGB(int r, int v, int b, int zeline) {
	#undef FUNC
	#define FUNC "GetBASICFromRGB"

	int ga=64,rgb;

	if (r<85) r=0; else if (r>170) r=255; else r=128;
	if (v<85) v=0; else if (v>170) v=255; else v=128;
	if (b<85) b=0; else if (b>170) b=255; else b=128;

	rgb=r*65536+v*256+b;

	switch (rgb) {
		case 0x000000:ga=0;break;
		case 0x000080:ga=1;break;
		case 0x0000FF:ga=2;break;
		case 0x800000:ga=3;break;
		case 0x800080:ga=4;break;
		case 0x8000FF:ga=5;break;
		case 0xFF0000:ga=6;break;
		case 0xFF0080:ga=7;break;
		case 0xFF00FF:ga=8;break;
		case 0x008000:ga=9;break;
		case 0x008080:ga=10;break;
		case 0x0080FF:ga=11;break;
		case 0x808000:ga=12;break;
		case 0x808080:ga=13;break;
		case 0x8080FF:ga=14;break;
		case 0xFF8000:ga=15;break;
		case 0xFF8080:ga=16;break;
		case 0xFF80FF:ga=17;break;
		case 0x00FF00:ga=18;break;
		case 0x00FF80:ga=19;break;
		case 0x00FFFF:ga=20;break;
		case 0x80FF00:ga=21;break;
		case 0x80FF80:ga=22;break;
		case 0x80FFFF:ga=23;break;
		case 0xFFFF00:ga=24;break;
		case 0xFFFF80:ga=25;break;
		case 0xFFFFFF:ga=26;break;
		default:printf("unknown color for CPC line %d\n",zeline);exit(-1);
	}
	return ga;
}
char *GetStringFromGA(int ga) {
	#undef FUNC
	#define FUNC "GetStringFromGA"

	switch (ga) {
		case 64+20:return "black";break;
		case 64+4:return "deep blue";break;
		case 64+21:return "blue";break;
		case 64+28:return "brown";break;
		case 64+24:return "magenta";break;
		case 64+29:return "mauve";break;
		case 64+12:return "red";break;
		case 64+5:return "purple";break;
		case 64+13:return "bright magenta";break;
		case 64+22:return "green";break;
		case 64+6:return "cyan";break;
		case 64+23:return "sky blue";break;
		case 64+30:return "kaki";break;
		case 64+0:return "grey";break;
		case 64+31:return "pastel blue";break;
		case 64+14:return "orange";break;
		case 64+7:return "pink";break;
		case 64+15:return "pastel magenta";break;
		case 64+18:return "bright green";break;
		case 64+2:return "sea green";break;
		case 64+19:return "bright cyan";break;
		case 64+26:return "lime";break;
		case 64+25:return "pastel green";break;
		case 64+27:return "pastel cyan";break;
		case 64+10:return "yellow";break;
		case 64+3:return "bright yellow";break;
		case 64+11:return "white";break;
		default:break;
	}
	return "unknown color";
}
void GetRGBFromGA(int ga, unsigned char *r, unsigned char *v, unsigned char *b, int line) {
	#undef FUNC
	#define FUNC "GetRGBFromGA"

	switch (ga) {
		case 64+20:*r=0;*v=0;*b=0;break;
		case 64+4:*r=0;*v=0;*b=128;break;
		case 64+21:*r=0;*v=0;*b=255;break;
		case 64+28:*r=128;*v=0;*b=0;break;
		case 64+24:*r=128;*v=0;*b=128;break;
		case 64+29:*r=128;*v=0;*b=255;break;
		case 64+12:*r=255;*v=0;*b=0;break;
		case 64+5:*r=255;*v=0;*b=128;break;
		case 64+13:*r=255;*v=0;*b=255;break;
		case 64+22:*r=0;*v=128;*b=0;break;
		case 64+6:*r=0;*v=128;*b=128;break;
		case 64+23:*r=0;*v=128;*b=255;break;
		case 64+30:*r=128;*v=128;*b=0;break;
		case 64+0:*r=128;*v=128;*b=128;break;
		case 64+31:*r=128;*v=128;*b=255;break;
		case 64+14:*r=255;*v=128;*b=0;break;
		case 64+7:*r=255;*v=128;*b=128;break;
		case 64+15:*r=255;*v=128;*b=255;break;
		case 64+18:*r=0;*v=255;*b=0;break;
		case 64+2:*r=0;*v=255;*b=128;break;
		case 64+19:*r=0;*v=255;*b=255;break;
		case 64+26:*r=128;*v=255;*b=0;break;
		case 64+25:*r=128;*v=255;*b=128;break;
		case 64+27:*r=128;*v=255;*b=255;break;
		case 64+10:*r=255;*v=255;*b=0;break;
		case 64+3:*r=255;*v=255;*b=128;break;
		case 64+11:*r=255;*v=255;*b=255;break;
		default:printf("unknown gate array value\n");exit(-1);
	}
}
void GetRGBFromBASIC(int ba, unsigned char *r, unsigned char *v, unsigned char *b) {
	#undef FUNC
	#define FUNC "GetRGBFromBASIC"

	switch (ba) {
		case 0:*r=0;*v=0;*b=0;break;
		case 1:*r=0;*v=0;*b=128;break;
		case 2:*r=0;*v=0;*b=255;break;
		case 3:*r=128;*v=0;*b=0;break;
		case 4:*r=128;*v=0;*b=128;break;
		case 5:*r=128;*v=0;*b=255;break;
		case 6:*r=255;*v=0;*b=0;break;
		case 7:*r=255;*v=0;*b=128;break;
		case 8:*r=255;*v=0;*b=255;break;
		case 9:*r=0;*v=128;*b=0;break;
		case 10:*r=0;*v=128;*b=128;break;
		case 11:*r=0;*v=128;*b=255;break;
		case 12:*r=128;*v=128;*b=0;break;
		case 13:*r=128;*v=128;*b=128;break;
		case 14:*r=128;*v=128;*b=255;break;
		case 15:*r=255;*v=128;*b=0;break;
		case 16:*r=255;*v=128;*b=128;break;
		case 17:*r=255;*v=128;*b=255;break;
		case 18:*r=0;*v=255;*b=0;break;
		case 19:*r=0;*v=255;*b=128;break;
		case 20:*r=0;*v=255;*b=255;break;
		case 21:*r=128;*v=255;*b=0;break;
		case 22:*r=128;*v=255;*b=128;break;
		case 23:*r=128;*v=255;*b=255;break;
		case 24:*r=255;*v=255;*b=0;break;
		case 25:*r=255;*v=255;*b=128;break;
		case 26:*r=255;*v=255;*b=255;break;
		default:printf("unknown basic color value\n");exit(-1);
	}
}

void SortPalette(unsigned char *palette, int maxcoul)
{
	#undef FUNC
	#define FUNC "SortPalette"

	unsigned r,v,b;
	int i,j,imin;
	float vmin,vcur;

	for (i=0;i<maxcoul;i++) {
		vmin=palette[i*3+0]*palette[i*3+0]+palette[i*3+1]*palette[i*3+1]+palette[i*3+2]*palette[i*3+2];
		imin=i;
		for (j=i+1;j<maxcoul;j++) {
			vcur=palette[j*3+0]*palette[j*3+0]+palette[j*3+1]*palette[j*3+1]+palette[j*3+2]*palette[j*3+2];
			if (vcur<vmin) {
				vmin=vcur;
				imin=j;
			}
		}
		if (imin!=i) {
			r=palette[i*3+0];
			v=palette[i*3+1];
			b=palette[i*3+2];
			palette[i*3+0]=palette[imin*3+0];
			palette[i*3+1]=palette[imin*3+1];
			palette[i*3+2]=palette[imin*3+2];
			palette[imin*3+0]=r;
			palette[imin*3+1]=v;
			palette[imin*3+2]=b;
		}
	}

}

void AutoScanHSP(struct s_parameter *parameter, struct s_png_info *photo, unsigned char *palette, int *i, int *j)
{
	#undef FUNC
	#define FUNC "AutoScanHSP"

	static int match=0;
	static int xs=0,ys=0,xe=0,ye=0;
	int idx,tic=0;

	printf("autoscan HSP: i=%d j=%d ox=%d oy=%d w=%d h=%d\n",*i,*j,parameter->ox,parameter->oy,photo->width,photo->height);
	if (!match) {
		/* first run, is there an area? */
		while (GetIDXFromPixel(palette,&photo->data[((*i)+(*j)*photo->width)*4+0])==-1) {
			(*i)++;
			if (*i>=photo->width) {
				*i=parameter->ox;
				/* after a reinit AND a carriage return, we must go down the previous global boxes */
				if (ye && !tic) {
					*j=ye;
					tic=1;
				} else {
					(*j)++;
				}
				if (*j>=photo->height) break;
			}
		}
		match=1;
		xs=*i;ys=*j;
	} else {
		/* are they another sprite in the area? */
		match=0;
		//*i=(*i)+16; déjà fait par la capture du sprite...
printf("check right (%d/%d) =%d | ",*i,*j,GetIDXFromPixel(palette,&photo->data[((*i)+(*j)*photo->width)*4+0]));
		if (*i<photo->width && GetIDXFromPixel(palette,&photo->data[((*i)+(*j)*photo->width)*4+0])!=-1) {
printf("to the right | ");
			match=1;
			if (xe<*i) xe=*i; /* update global box */
		} else {
			/* rollback on i */
			*i=xs;
printf("return to xstart and check down below the whole sprite | ");
			if (*j<photo->height-16) {
				*j=(*j)+15;
printf("may be down %d/%d | ",*i,(*j)+1);
				for (idx=xs;GetIDXFromPixel(palette,&photo->data[((*i)+idx+(*j)*photo->width)*4+0])!=-1;idx++) {
					if (GetIDXFromPixel(palette,&photo->data[((*i)+idx+((*j)+1)*photo->width)*4+0])!=-1) {
						match=1;
						*j=(*j)+1;
						break;
					}
				}
				if (match) {
					ye=*j+16; /* update global box */
					while (GetIDXFromPixel(palette,&photo->data[((*i)-1+(*j)*photo->width)*4+0])!=-1) {
						(*i)--;
					}
printf("match xmin=%d! | ",*i);
					if (*i<xs) {
						xs=*i;
printf("update xs to %d | ",xs);
					}
				} else {
					/* reinit from the top right of the area */
					*i=xe+16;
					*j=ys;
printf("reinit in %d/%d | ",*i,*j);
					AutoScanHSP(parameter,photo,palette,i,j);
					return;
				}
			} else {
				*i=photo->width-1;
				*j=photo->height-1;
				printf("no moar to scan\n");
			}
		}
	}
#if 0
	/* get area size, which supposed to be squared */
	if (*i<photo->width && *j<photo->height) {
		/* looking for top right corner */
		parameter->sx=1;
		while (GetIDXFromPixel(palette,&photo->data[(parameter->sx+(*i)+(*j)*photo->width)*4+0])!=-1) parameter->sx++;
		/* looking for bottom right corner */
		parameter->sy=1;
		while (GetIDXFromPixel(palette,&photo->data[(parameter->sx+(*i)+((*j)+parameter->sy)*photo->width)*4+0])!=-1) parameter->sy++;
	}
#endif
printf("\n");
}

void AutoScan(struct s_parameter *parameter, struct s_png_info *photo, unsigned char *palette, int *i, int *j)
{
	#undef FUNC
	#define FUNC "AutoScan"

	if (parameter->scan) {
		if (parameter->hsp) {
			AutoScanHSP(parameter,photo,palette,i,j);
		} else {
			/* is there an area? */
			while (GetIDXFromPalette(palette, photo->data[(*i+*j*photo->width)*4+0],photo->data[(*i+*j*photo->width)*4+1],photo->data[(*i+*j*photo->width)*4+2])==-1) {
				(*i)++;
				if (*i>=photo->width) {
					*i=parameter->ox;
					(*j)++;
					if (*j>=photo->height) break;
				}
			}
			/* get area size, which supposed to be squared */
			if (*i<photo->width && *j<photo->height) {
				/* looking for top right corner */
				parameter->sx=1;
				while (GetIDXFromPalette(palette, photo->data[(parameter->sx+*i+*j*photo->width)*4+0],photo->data[(parameter->sx+*i+*j*photo->width)*4+1],photo->data[(parameter->sx+*i+*j*photo->width)*4+2])!=-1) parameter->sx++;
				/* looking for bottom right corner */
				parameter->sy=1;
				while (GetIDXFromPalette(palette, photo->data[(parameter->sx+*i+(*j+parameter->sy)*photo->width)*4+0],photo->data[(parameter->sx+*i+(*j+parameter->sy)*photo->width)*4+1],photo->data[(parameter->sx+*i+(*j+parameter->sy)*photo->width)*4+2])!=-1) parameter->sy++;
			}
		}
	}
}

int cmpscore(const void *a, const void *b) {
	struct s_score ia,ib;

	ia=*(struct s_score *)a;
	ib=*(struct s_score *)b;
	/* tri inverse! */
	return ib.score-ia.score;
}
int cmpcol(const void *a, const void *b) {
	int ia,ib;

	ia=*(int*)a;
	ib=*(int*)b;
	return ia-ib;
}

void DisplayPalette(int hsp, int max, unsigned char *palette)
{
	int i;

	for (i=hsp;i<max+hsp;i++) {
		printf("%s#%04X",i-hsp?",":"",(palette[i*3+0]&0xF0)|((palette[i*3+1]>>4)<<8)|(palette[i*3+2]>>4));
	}
printf("\n");

}

//#define CHECK_IDATA {if ((idata>photo->width*photo->height && !parameter->scrmode) || idata>=32768) {printf("internal error: too much data idata=%d width=%d height=%d\n",idata,photo->width,photo->height);exit(-1);}}
#define CHECK_IDATA ;

void Build(struct s_parameter *parameter)
{
	#undef FUNC
	#define FUNC "Build"

	/************************************************
                c o n v e r t e r    l e g a c y
        ************************************************/
	char newname[2048];

	struct s_png_info *photo=NULL;

	int j,k,l,m,n,zepix,maxcoul;
	unsigned char r,v,b;
	unsigned char r2,v2,b2;
	int *cptpalette;
	int width,height;
	float vmin,vmax,vpal,totpal;
	int imin,imax,icol,ipal,idark1,idark2;
	float vdark;
	int ligne[192],adr,adrcode,numligne=0;

	int iref;

	unsigned char spriteline[16]={0};
	int inthechar=0;

	int ticpack=0;
	int xs,ys;

	/****************************************
                c o n v e r t e r    v 2
        ****************************************/
	unsigned char *cpcdata=NULL;        /* dynamic workspace */
	int idata=0;                        /* current output */
	int pixrequested;                   /* how many pix do we need for a byte? */
	int limitcolors=16;                 /* max number of colors regarding the options */
	int hasblack;                       /* index of black color if any, else -1 */
	struct s_sprite_info *spinfo=NULL;  /* info about extracted sprites */
	struct s_sprite_info curspi={0};
	int ispi=0,mspi=0;                  /* fast counters for sprite info struct */
	int *scradr,maxscradr;             	/* CRTC line adresse decoding */
	int crtcadr,crtcb,curline;          /* CRTC mimic values */
	unsigned char palette[4096*3]={0};  /* palette for 16 colors + border for scanning */
	int cptcolor[4096];                 /* pour compter les couleurs par ligne */
	int bgr,bgv,bgb,scancolor;          /* border color for scanning */
	int i,istep;
	int pix1,pix2,pix3,pix4;            /* mode 0 & mode 1 pixels */
	int maxdata=0,byteleft;               /* byte count for file output */
	int filenumber=2;                   /* file naming */
	int png_has_transparency=0;         /* png data contains transparent pixels */
	/* split-rasters */
	int scrmode[280];                   /* required mode */
	int accmode,cptcol,oldmode;
	struct s_rastecran scr={0};
	int ib,maxblockcol,col,clash=0;
	int maxlinecol;
	int garemove[27],bareplace;
	int gacompare1[256],gacompare2[256];
	int cptchange,changeback;
	int curga,noptrou;
	int colorstat[128][128];
	int colorscore[128];
	struct s_score tabscore[27];
	int lastbackgroundcolor[256]; // 16 to check...
	int splitcolor[128];
	int primarybackgroundcolor[15];    /* couleurs de background à init hors-zone */
	int iprim=0;                       /* index max des couleurs primaires de background */
	int blockhascolor;
	int colormaysplit;
	int backgroundcolor[16];
	int lindex,found;
	int reg[MAXSPLIT]; /* register A,C,D,E,H,L */
	int woffset;
	int token[312*64];
	/***************************************************
	  L A R A   e x p o r t
	***************************************************/
	int decal,csx,theight;

	/*****************************
	 * export de la transparence
	 ****************************/
	unsigned char *transdata=NULL;
	int itrans=0;

	switch (parameter->mode) {
		default:break;
		case 1:limitcolors=4;break;
		case 2:limitcolors=2;break;
	}
	limitcolors+=parameter->scan; /* border color for scan raise the max */
	if (parameter->splitraster) limitcolors=27; /* no limit with rasters */

        photo=PNGRead32(parameter->filename);
        if (!photo) exit(-2);

	if (parameter->importpalettefilename) {
		/* load palette from a text file */
		char separator,*curchar,*txtpalette;
		int palsize,curcoul;
        printf(KIO"Image %dx%d\n",photo->width,photo->height);
		printf("import de palette RGB [%s]\n",parameter->importpalettefilename);
		palsize=FileGetSize(parameter->importpalettefilename);
		txtpalette=MemMalloc(palsize);
		FileReadBinary(parameter->importpalettefilename,txtpalette,palsize);
		FileReadBinaryClose(parameter->importpalettefilename);

		if (strchr(txtpalette,'$')) separator='$'; else
		if (strchr(txtpalette,'#')) separator='#'; else
		if (strstr(txtpalette,"0x")) separator='x'; else
		{
			printf(KERROR"\nERROR: invalid palette!\n"KNORMAL);
			exit(-4);
		}
		/* parse text */
		maxcoul=0;
		while ((curchar=strchr(txtpalette,separator))!=NULL) {
			if (maxcoul==17) {
			}
			*curchar=' ';
			curchar++;
			curcoul=strtol(curchar,NULL,16);
			palette[maxcoul*3+0]=curcoul&0xF0;
			palette[maxcoul*3+1]=(curcoul&0xF00)>>4;
			palette[maxcoul*3+2]=(curcoul&0xF)<<4;
			maxcoul++;
		}
		printf("%d couleur%s importée%s\n",maxcoul,maxcoul>1?"s":"",maxcoul>1?"s":"");

		for (i=0;i<photo->height*photo->width*4;i++) {
			photo->data[i]&=0xF0;
		}

		png_has_transparency=0;
		for (i=0;i<photo->height*photo->width;i++) {
			if (photo->data[i*4+3]>0) {
			} else {
				png_has_transparency=1;
			}
		}

		MemFree(txtpalette);
	} else {
		/* as the bitmap is RGBA we must scan to find all colors */

		/* but first reduce colorset to fit 4096k */
		for (i=0;i<photo->height*photo->width*4;i+=4) {
			photo->data[i+0]&=0xF0;
			photo->data[i+1]&=0xF0;
			photo->data[i+2]&=0xF0;
			/* pas de AND sur le canal ALPHA!!! */
		}

		maxcoul=0;
		png_has_transparency=0;
		for (i=0;i<photo->height*photo->width;i++) {
			if (photo->data[i*4+3]>0) {
				/* we scan only visible colors */
				r=photo->data[i*4+0];
				v=photo->data[i*4+1];
				b=photo->data[i*4+2];
				for (j=0;j<maxcoul;j++) {
					if (palette[j*3+0]==r && palette[j*3+1]==v && palette[j*3+2]==b) break;
				}

				if (j==maxcoul) {
					if (j>=limitcolors) {
						printf(KERROR"\nERROR: too much colors! moar than %d colors\n"KNORMAL,limitcolors);
						exit(-3);
					} else {
						palette[j*3+0]=r;
						palette[j*3+1]=v;
						palette[j*3+2]=b;
						maxcoul++;
					}
				}
			} else {
				png_has_transparency=1;
			}
		}
        printf(KIO"Image %dx%d with %d colors\n"KNORMAL,photo->width,photo->height,maxcoul);
	}

	for (i=0;i<maxcoul;i++) {
		printf("#%02X%02X%02X ",palette[i*3],palette[i*3+1],palette[i*3+2]);
	}
	printf("\n");

	/* il ne devrait pas y avoir plus de pixels que sur l'image d'origine */
	transdata=malloc(photo->width*photo->height*2);
	memset(transdata,0,photo->width*photo->height*2);

	if (parameter->scan) {
		bgr=palette[0];
		bgv=palette[1];
		bgb=palette[2];
	}
	if (parameter->grad) {
		SortPalette(palette,maxcoul);
	}
	if (parameter->scan) {
		/* reorg palette without border color */
		scancolor=GetIDXFromPalette(palette,bgr,bgv,bgb);
		if (scancolor!=maxcoul-1) {
			for (i=scancolor*3;i<16*3;i++) palette[i]=palette[i+3];
		}
		maxcoul--;
	}

	/* options check & management */
	if (!parameter->sx || !parameter->sy) {
		parameter->sx=photo->width;
		parameter->sy=photo->height;
	}
	if (parameter->sx>photo->width) {
		printf(KERROR"ERROR: sprite width cannot exceed image dimension\n");
		exit(-5);
	}
	if (parameter->sy>photo->height) {
		printf(KERROR"ERROR: sprite height cannot exceed image dimension\n");
		exit(-5);
	}
	if (parameter->ox>=photo->width) {
		printf(KERROR"ERROR: X offset cannot exceed image dimension\n");
		exit(-5);
	}
	if (parameter->oy>=photo->height) {
		printf(KERROR"ERROR: Y offset cannot exceed image dimension\n");
		exit(-5);
	}
	if (!parameter->nblinescreen) {
		parameter->nblinescreen=photo->height;
	} else if (parameter->nblinescreen>photo->height) {
		printf(KERROR"ERROR: split-screen line cannot exceed image dimension\n");
		exit(-5);
	}

	printf(KVERBOSE"Extraction: ");
	if (parameter->scrmode) printf("screen");
	else if (parameter->hsp) printf("hardware sprite");
	else printf("sprite");
	if (parameter->oldmode) printf("overscan bit");

	if (!parameter->hsp) {
		int checkwidth=1;
		printf(" in mode %d\n"KNORMAL,parameter->mode);
		switch (parameter->mode) {
			case 0:if (photo->width&1 && !parameter->lara) printf(KWARNING"ERROR: Mode 0 image must have width multiple of 2\n");break;
			case 1:if (photo->width&3) printf(KWARNING"ERROR: Mode 1 image must have width multiple of 1\n");break;
			case 2:if (photo->width&7) printf(KWARNING"ERROR: Mode 2 image must have width multiple of 8\n");break;
		}
	} else {
		printf("\n");
	}


	if (parameter->lara) {
		int cpt1=1,cpt2=0,color1=0,color2=-1,colortmp,barjack=0;
		printf(KVERBOSE"*** LARA MODE *** ");
		color1=*(int *)(&photo->data[(photo->height-1)*photo->width*4]);
		for (i=1;i<photo->width;i++) {
			colortmp=*(int *)(&photo->data[(photo->height-1)*photo->width*4+i*4]);
			if (colortmp==color1) {
				cpt1++; 
			} else {
				cpt2++;
				if (color2==-1) {
					color2=colortmp;
					barjack=i;
				} else if (color2!=colortmp) {
					printf(KERROR"INTERNAL ERROR -> lara mode -> too much colors on last line! X1=%d X2=%d\n",barjack,i);
					exit(1);
				}
			}
		}
		if (cpt1+cpt2!=photo->width) {
			printf(KERROR"INTERNAL ERROR -> lara mode -> count marks\n");
			exit(1);
		}
		if (cpt2<cpt1) {
			color1=color2;
			cpt1=cpt2;
		}
		/* on a le marqueur, on contrôle la cohérence */
		decal=i=0;
		color2=*(int *)(&photo->data[(photo->height-1)*photo->width*4]+i*4);
		while (color2!=color1) {
			decal++;
			i++;
			if (i>=photo->width) {
				printf(KERROR"INTERNAL ERROR -> lara mode -> test shift pixel\n");
				exit(1);
			}
			color2=*(int *)(&photo->data[(photo->height-1)*photo->width*4]+i*4);
		}
		printf("decal=%d -> %d byte ",decal,decal>>1);
		if (decal&1) {
			printf(KERROR"INTERNAL ERROR -> lara mode -> odd shift value\n");
			exit(1);
		}
		decal>>=1;
		csx=photo->width/cpt1;
		if (photo->width % cpt1) {
			printf(KERROR"INTERNAL ERROR -> lara mode -> cannot compute atomic width %d %% %d = %d\n",photo->width,cpt1,photo->width % cpt1);
			exit(1);
		}
		theight=0;
		i=photo->height-1;
		while (i>0) {
			theight++;
			i-=8;
		}
		/********** override parameter ****************/
		if (cpt1==25) parameter->maxextract=24; else parameter->maxextract=cpt1;
		parameter->sx=csx;
		parameter->sy=photo->height-1;
		printf(" -> sx=%d\n"KNORMAL,csx);
	}




	if (parameter->hsp) {
		if (parameter->sx>16 || parameter->sy>16) {
			printf(KERROR"ERROR: hardware sprite size cannot exceed 16x16!\n");exit(-1);
		}

		if (parameter->forceextraction) {
			int oldheight;
			oldheight=photo->height;
			photo->height=photo->height+16;
printf(KBLUE"expand image to %d\n"KNORMAL,photo->height);
			photo->data=realloc(photo->data,photo->height*photo->width*4);
			/* init all new pixels to zero */
			memset(photo->data+oldheight*4*photo->width,0,(photo->height-oldheight)*4*photo->width);
		}


		/* hardware sprite are limited to 15 different colors */
		hasblack=GetIDXFromPalette(palette,0,0,0);
		if (hasblack>=0) {
			printf("Image has black color (%d)\n",hasblack);
		} else {
			printf(KWARNING"Image has no black color => disabling -b option\n"KNORMAL);
			parameter->black=0;
		}
		if (maxcoul>15) {
			if (hasblack>=0 && parameter->black) {
				printf("-> black color is transparency\n");
			} else {
				printf(KERROR"ERROR: 15 colors maximum for hardware sprites\n"KNORMAL);
				DisplayPalette(0, maxcoul, palette);
				exit(-5);
			}
		}
		if (png_has_transparency) {
			if (!parameter->black) {
				printf(KVERBOSE"shift palette colors to set transparency at zero index\n"KNORMAL);
				memmove(palette+3,palette,3*15);
				palette[0]=1;
				palette[1]=2;
				palette[2]=3;
			}
		}
		if (parameter->black && hasblack!=0) {
			printf(KVERBOSE"Note: 'black is transparency' forces palette sorting (-grad option)\n"KNORMAL);
			SortPalette(palette,maxcoul);
		}
	} else {
		/* conventionnal export may require screen byte width */
		if (!parameter->width) {
			parameter->width=photo->width/2;
			switch (parameter->mode) {
				default:
				case 0:break;
				case 2:parameter->width/=2; /* no break */
				case 1:parameter->width/=2;
			}
		}
	}
	/* mimic hardware screen to put GFX data where it's supposed to be */
	if (parameter->oldmode) {
		int reste;

		crtcadr=crtcb=0;
		parameter->nblinescreen=2048/parameter->width*parameter->lineperblock;

		/* est-ce qu'on a des lignes partielles ensuite? */
		if (2048/parameter->width != 2048.0/(float)parameter->width) {
			reste=parameter->width-(16384-parameter->nblinescreen*parameter->width)/parameter->lineperblock;
			printf(KWARNING"Warning! Nouvelle bank suit première bank à partir de la ligne %d\n"KNORMAL,parameter->nblinescreen);
			parameter->nblinescreen+=parameter->lineperblock;
			
		} else {
			reste=0;
		}
		printf("Nouvelle bank en début de ligne à partir de la ligne %d\n",parameter->nblinescreen);

		maxscradr=32768/parameter->width;
		scradr=malloc(sizeof(int)*maxscradr);

		for (i=0;i<maxscradr;i++) {
			if (i==parameter->nblinescreen) {
				crtcadr=0x4000+reste;
				crtcb=0;
			}
			scradr[i]=crtcadr;
			crtcadr+=0x800;
			crtcb++;
			if (crtcb>=parameter->lineperblock) {
				crtcadr=crtcadr-0x4000+parameter->width;
				crtcb=0;
			}
		}
	} else if (parameter->scrmode) {
		scradr=malloc(sizeof(int)*280);
		maxscradr=32768;
		crtcadr=crtcb=0;
		for (i=0;i<280;i++) {
			if (i==parameter->nblinescreen) {
				crtcadr=0x4000;
				crtcb=0;
			}
			scradr[i]=crtcadr;
			crtcadr+=0x800;
			crtcb++;
			if (crtcb>=parameter->lineperblock) {
				crtcadr=crtcadr-0x4000+parameter->width;
				crtcb=0;
			}
		}
	}
	

	if (!parameter->splitraster) {
		if (parameter->black) {
			if (palette[0]!=0 || palette[1]!=0 || palette[2]!=0) {
				printf(KERROR"FATAL: there is an error with first color which is not black as expected\n"KNORMAL);
				exit(0);
			}
		}


		printf("paletteplus: defw ");
		for (i=parameter->hsp;i<maxcoul+parameter->hsp-parameter->black;i++) {
			printf("%s#%04X",i-parameter->hsp?",":"",(palette[i*3+0]&0xF0)|((palette[i*3+1]>>4)<<8)|(palette[i*3+2]>>4));
		}
		printf("\n");

		if (!parameter->hsp) {
			printf("paletteGA:   defb ");
			for (i=parameter->hsp;i<maxcoul+parameter->hsp;i++) {
				printf("%s#%02X",i-parameter->hsp?",":"",GetGAFromRGB(palette[i*3+0],palette[i*3+1],palette[i*3+2]));
			}
			printf("\n");
		}

		if (parameter->exportpalettefilename) {
			/* sortie en VRB */
			char exporttmpcolor[32];
			
			FileRemoveIfExists(parameter->exportpalettefilename);
			for (i=parameter->hsp;i<maxcoul+parameter->hsp-parameter->black;i++) {
				sprintf(exporttmpcolor,"%s#%04X",i>parameter->hsp?",":"",(palette[i*3+0]&0xF0)|((palette[i*3+1]>>4)<<8)|(palette[i*3+2]>>4));
				FileWriteBinary(parameter->exportpalettefilename,exporttmpcolor,strlen(exporttmpcolor));
			}
			strcpy(exporttmpcolor,"\n");
			FileWriteBinary(parameter->exportpalettefilename,exporttmpcolor,strlen(exporttmpcolor));
			FileWriteBinaryClose(parameter->exportpalettefilename);
		}

	}
	
	cpcdata=MemMalloc(32768+photo->width*photo->height+32);

	idata=0;
	curline=0;

	/*************************************************
	         h a r d w a r e    s p r i t e s
	*************************************************/
	if (parameter->hsp) {
		int metax,metay;

		for (j=parameter->oy;j<photo->height && ispi<parameter->maxextract;j+=parameter->metay) {
			for (i=parameter->ox;i<photo->width && ispi<parameter->maxextract;i+=parameter->metax) {
				/* sprites automatic search */
				//AutoScan(parameter,photo,palette,&i,&j);

				// meta management
				for (metay=0;metay<parameter->metay;metay+=16)
				for (metax=0;metax<parameter->metax;metax+=16)
				if (j+parameter->sy+metay<=photo->height && i+parameter->sx+metax<=photo->width) {
					/* prepare sprite info */
					curspi.adr=idata;
					for (ys=metay;ys<16+metay;ys++) {
						ticpack=0; /* reset pixel counter */
						for (xs=metax;xs<16+metax;xs++) {
							/* transparency */
							if (photo->data[(i+xs+(j+ys)*photo->width)*4+3]>0) {
								zepix=GetIDXFromPixel(palette,&photo->data[(i+xs+(j+ys)*photo->width)*4+0]);
								// RIEN A FAIRE!!! if (!parameter->black) zepix++;
							} else {
								zepix=0;
							}
							/* output format */
							switch (parameter->packed) {
								case 0:
									cpcdata[idata++]=zepix;
									break;
								case 2:
									/* packed reversed */
									switch (ticpack) {
										case 0: cpcdata[idata]=zepix; ticpack=1; break;
										case 1: cpcdata[idata++]|=zepix*16; ticpack=0; break;
										default: printf("warning remover\n"); break;
									}
									break;
								case 4:
									/* packed reversed */
									switch (ticpack) {
										case 0: cpcdata[idata]=zepix*64; ticpack=1; break;
										case 1: cpcdata[idata]|=zepix*16; ticpack=2; break;
										case 2: cpcdata[idata]|=zepix*4; ticpack=3; break;
										case 3: cpcdata[idata++]|=zepix; ticpack=0; break;
										default: printf("warning remover\n"); break;
									}
									break;
								default:printf("warning remover\n");break;
							}
							CHECK_IDATA
						}
						/* fill smaller sprites with blank */
						while (xs<16) {
							switch (parameter->packed) {
								case 0: cpcdata[idata++]=0; break;
								case 2: /* packed reversed */
									switch (ticpack) {
										case 0: cpcdata[idata]=0; ticpack=1; break;
										case 1: idata++; ticpack=0; break;
										default: printf("warning remover\n"); break;
									}
									break;
								case 4: /* packed reversed */
									switch (ticpack) {
										case 0: cpcdata[idata]=0; ticpack=1; break;
										case 1: ticpack=2; break;
										case 2: ticpack=3; break;
										case 3: idata++; ticpack=0; break;
										default: printf("warning remover\n"); break;
									}
									break;
								default:printf("warning remover\n");break;
							}
							xs++;
						}
					}
					while (ys<16) {
						switch (parameter->packed) {
							case 0: for (xs=0;xs<16;xs++) cpcdata[idata++]=0; break;
							case 2: /* packed reversed */ for (xs=0;xs<8;xs++) cpcdata[idata++]=0; break;
							case 4: /* packed reversed */ for (xs=0;xs<4;xs++) cpcdata[idata++]=0; break;
							default:printf("warning remover\n");break;
						}
						ys++;
					}
					/* check for empty sprite... */
					for (ys=curspi.adr;ys<idata;ys++) {
						if (cpcdata[ys]) break;
					}
					if (parameter->keep_empty || ys!=idata) {
						/* update sprite info */
						curspi.size=idata-curspi.adr;
						curspi.x=parameter->sx;
						curspi.y=parameter->sy;
						ObjectArrayAddDynamicValueConcat((void **)&spinfo,&ispi,&mspi,&curspi,sizeof(struct s_sprite_info));
//printf("sprite in %d/%d\n",i,j);
						/* raz area with border in case of scanning */
/*
						if (parameter->scan) {
							for (ys=0;ys<parameter->sy;ys++) {
								for (xs=0;xs<parameter->sx;xs++) {
									photo->data[(i+xs+(j+ys)*photo->width)*4+0]=bgr;
									photo->data[(i+xs+(j+ys)*photo->width)*4+1]=bgv;
									photo->data[(i+xs+(j+ys)*photo->width)*4+2]=bgb;
								}
							}
						}
*/
					} else {
						/* rollback */
						idata=curspi.adr;
					}
				}
			}
		}
	} else if (parameter->splitraster) {
	/*************************************************
	      s p l i t - r a s t e r       m o d e
	*************************************************/
		memset(reg,0,sizeof(reg));
		/*
			l'analyse pour split-raster se fait en mode 2 (pour traiter tous les cas d'un coup)
			si le mode est 1 ou 0 alors on suréchantillonne
		*/
		switch (parameter->mode) {
			case 0:
				printf("upsampling in mode 2\n");
				photo->data=MemRealloc(photo->data,photo->width*4*photo->height*4);
				for (i=photo->width*photo->height*4-4;i>=0;i-=4) {
					for (j=0;j<4;j++) {
						photo->data[i*4+j]=photo->data[i+j];
						photo->data[i*4+4+j]=photo->data[i+j];
						photo->data[i*4+8+j]=photo->data[i+j];
						photo->data[i*4+12+j]=photo->data[i+j];
					}
				}
				photo->width*=4;
				break;
			case 1:
				printf("upsampling in mode 2\n");
				photo->data=MemRealloc(photo->data,photo->width*2*photo->height*4);
				for (i=photo->width*photo->height*4-4;i>=0;i-=4) {
					for (j=0;j<4;j++) {
						photo->data[i*2+j]=photo->data[i+j];
						photo->data[i*2+4+j]=photo->data[i+j];
					}
				}
				photo->width*=2;
				break;
			case 2:break;
			default:printf("warning remover\n");break;
		}
		if (photo->width>768 || photo->height>280) {
			printf("maximum image size for splitraster is 768x280 (%d/%d)\n",photo->width,photo->height);
			exit(-1);
		}
		/* analyse du mode requis pour la ligne */
		scr.nbline=photo->height;
		oldmode=-1;
		for (i=0;i<photo->height;i++) {
			accmode=0;
			for (j=0;j<photo->width;j+=8) {
				if (memcmp(&photo->data[i*photo->width*4+j*4],&photo->data[i*photo->width*4+j*4+4],4)) accmode|=2;
				if (memcmp(&photo->data[i*photo->width*4+j*4+8],&photo->data[i*photo->width*4+j*4+12],4)) accmode|=2;
				if (memcmp(&photo->data[i*photo->width*4+j*4+16],&photo->data[i*photo->width*4+j*4+20],4)) accmode|=2;
				if (memcmp(&photo->data[i*photo->width*4+j*4+24],&photo->data[i*photo->width*4+j*4+28],4)) accmode|=2;

				if (memcmp(&photo->data[i*photo->width*4+j*4],&photo->data[i*photo->width*4+j*4+8],8)) accmode|=1;
				if (memcmp(&photo->data[i*photo->width*4+j*4+16],&photo->data[i*photo->width*4+j*4+24],8)) accmode|=1;
			}
			/* combien de couleurs sur la ligne? */
			memset(cptcolor,0,sizeof(cptcolor));
			cptcol=0;
			for (j=0;j<photo->width;j++) {
				cptcolor[GetIDXFromPalette(palette, photo->data[i*photo->width*4+j*4], photo->data[i*photo->width*4+j*4+1], photo->data[i*photo->width*4+j*4+2])]=1;
			}
			for (j=0;j<4096;j++) {
				if (cptcolor[j]) {
					scr.line[i].col[cptcol++]=GetGAFromRGB(palette[j*3+0],palette[j*3+1],palette[j*3+2]);
				}
			}

			if (accmode<oldmode && accmode==0 && cptcol<5) accmode=1;
			if (accmode<oldmode && accmode==1 && cptcol<3) accmode=2;
			scr.line[i].mode=accmode;
			scr.line[i].cptcol=cptcol;
			oldmode=accmode;
		}
		/* analyse inverse pour éviter du mode 0 sur des aplats de mode 1 ou 2 en début d'écran */
		oldmode=-1;
		for (i=photo->height-1;i>=0;i--) {
			accmode=scr.line[i].mode;
			cptcol=scr.line[i].cptcol;
			if (accmode<oldmode && accmode==0 && cptcol<5) accmode=1;
			if (accmode<oldmode && accmode==1 && cptcol<3) accmode=2;
			scr.line[i].mode=accmode;
			//printf("line %3d -> mode %d in %d color%s\n",i,accmode>=2?2:accmode,cptcol,cptcol>1?"s":"");
			oldmode=accmode;
		}
		/* contrôle des clashs si plus de 7 couleurs en mode 2, 9 couleurs en mode 1 ou 21 couleurs en mode 0 */
		for (i=0;i<photo->height;i++) {
			switch (scr.line[i].mode) {
				case 0:maxlinecol=21;break;
				case 1:maxlinecol=9;break;
				case 2:maxlinecol=7;break;
				default:printf("warning remover\n");break;
			}
			if (scr.line[i].cptcol>maxlinecol) {
				clash++;
				for (j=0;j<photo->width;j++) {
					garemove[GetBASICFromRGB(photo->data[i*photo->width*4+j*4],photo->data[i*photo->width*4+j*4+1],photo->data[i*photo->width*4+j*4+2],__LINE__)]=1;
				}
				/* supprimer arbitrairement les premières couleurs rencontrées */
				while (scr.line[i].cptcol>maxlinecol) {
					bareplace=-1;
					for (j=0;j<27;j++) {
						if (garemove[j] && bareplace!=-1) {
							bareplace=j;
						} else {
							break;
						}
					}
					garemove[j]=0;
					/* on supprime la couleur Basic d'index 'j' avec celle d'index 'bareplace' */
					for (j=0;j<photo->width;j++) {
						if (GetBASICFromRGB(photo->data[i*photo->width*4+j*4],photo->data[i*photo->width*4+j*4+1],photo->data[i*photo->width*4+j*4+2],__LINE__)==j) {
							GetRGBFromBASIC(bareplace,&photo->data[i*photo->width*4+j*4],&photo->data[i*photo->width*4+j*4+1],&photo->data[i*photo->width*4+j*4+2]);
						}
					}
					scr.line[i].cptcol--;
				}
			}
		}
		/* construction des blocs */
		for (i=0;i<photo->height;i++) {
			ib=0;
			for (j=0;j<photo->width;j+=16) {
				for (k=j;k<16;k++) {
					col=GetGAFromRGB(photo->data[i*photo->width*4+(j+k)*4],photo->data[i*photo->width*4+(j+k)*4+1],photo->data[i*photo->width*4+(j+k)*4+2]);
					l=0;
					/* brutal */
					do {
						if (scr.line[i].block[ib].col[l]==col) break;
						l++;
						if (l<scr.line[i].block[ib].nbcol) continue;
						scr.line[i].block[ib].col[scr.line[i].block[ib].nbcol++]=col;
					} while (0);
				}
				/* premier contrôle sur le nombre de couleurs maxi par bloc et "correction" du bloc */
				switch (scr.line[i].mode) {
					case 0:maxblockcol=16;break; /* useless test */
					case 1:maxblockcol=4;break;
					case 2:maxblockcol=2;break;
					default:printf("warning remover\n");break;
				}
				while (scr.line[i].block[ib].nbcol>maxblockcol) {
					scr.line[i].block[ib].nbcol--;
					clash++;
					/* use first color for replacement */
					for (k=j;k<j+16;k++) {
						col=GetGAFromRGB(photo->data[i*photo->width*4+(j+k)*4],photo->data[i*photo->width*4+(j+k)*4+1],photo->data[i*photo->width*4+(j+k)*4+2]);
						if (col==scr.line[i].block[ib].col[scr.line[i].block[ib].nbcol]) {
							GetRGBFromGA(scr.line[i].block[ib].col[0],&photo->data[i*photo->width*4+(j+k)*4],&photo->data[i*photo->width*4+(j+k)*4+1],&photo->data[i*photo->width*4+(j+k)*4+2],__LINE__);
						}
					}
				}
				/* on trie par commodité */
				qsort(scr.line[i].block[ib].col,scr.line[i].block[ib].nbcol,sizeof(int),cmpcol);
				/* bloc suivant */
				ib++;
			}

		}
		/* clash probable si plus d'une encre change entre deux blocs  */
		/* clash si changement successifs se font en moins de 4 nops */
		/* scoring pour la couleur de background
		+1	couleur présente sans trou de plus de 3 nops (hors début et fin)
		+nb	couleur ayant le plus de voisines différentes
		-nb	couleur ayant le moins de couleurs non voisines
		+1	couleur était déjà un background la ligne précédente
		*/
		for (i=0;i<16;i++) lastbackgroundcolor[i]=0;
		for (i=0;i<photo->height;i++) {
			/* il faut aussi calculer le groupe des couleurs à split */


			/* scoring pour les couleurs de background */
			memset(colorscore,0,sizeof(colorscore));
			memset(colorstat,0,sizeof(colorstat));
			/* on connait les couleurs utilisées sur chaque ligne */
			for (l=0;l<scr.line[i].cptcol;l++) {
				noptrou=0;
				colormaysplit=0;
				curga=scr.line[i].col[l];
				for (j=0;j<ib;j++) {
					/* est-ce que le bloc contient la couleur? */
					for (m=blockhascolor=0;m<scr.line[i].block[j].nbcol;m++) {
						if (curga==scr.line[i].block[j].col[m]) {
							blockhascolor=1;
							break;
						}
					}
					if (blockhascolor) {
						/* oui -> réinitialiser noptrou */
						noptrou=0;
						/* oui -> ajouter les voisines */
						for (m=blockhascolor=0;m<scr.line[i].block[j].nbcol;m++) {
							if (curga!=scr.line[i].block[j].col[m]) {
								colorstat[curga][scr.line[i].block[j].col[m]]=1;
							}
						}
					} else {
						/* non -> incrémenter noptrou */
						noptrou++;
						if (noptrou>3) {
							colormaysplit=1;
						}
					}


				}
				/* premiers résultats du scoring, si on ne splite pas alors c'est fort probablement du background! */
				colorscore[curga]=(1-colormaysplit)*5;
			}



			/* calcul des meilleures voisines */
			for (l=0;l<scr.line[i].cptcol;l++) {
				curga=scr.line[i].col[l];
				for (j=m=0;j<128;j++) {
					colorscore[curga]+=colorstat[curga][j];
				}
			}

			for (l=0;l<scr.line[i].cptcol;l++) {
				curga=scr.line[i].col[l];
				for (j=0;j<ib;j++) {
					/* est-ce que le bloc contient la couleur? */
					for (m=blockhascolor=0;m<scr.line[i].block[j].nbcol;m++) {
						if (curga==scr.line[i].block[j].col[m]) {
							blockhascolor=1;
							break;
						}
					}
					if (!blockhascolor) {
						for (m=blockhascolor=0;m<scr.line[i].block[j].nbcol;m++) {
							/* une couleur non voisine ne se retrouve jamais avec la couleur en cours */
							if (curga!=scr.line[i].block[j].col[m] && colorstat[curga][scr.line[i].block[j].col[m]]==0) {
								colorstat[curga][scr.line[i].block[j].col[m]]=2;
							}
						}
					}
				}
			}
			/* score des non voisines */
			memset(splitcolor,0,sizeof(splitcolor));
			for (l=n=0;l<scr.line[i].cptcol;l++) {
				curga=scr.line[i].col[l];
				for (j=m=0;j<128;j++) {
					if (colorstat[curga][j]==2) {
						colorscore[curga]--;
						if (splitcolor[n]!=curga) {
							splitcolor[curga]++;
						}
					}
				}
			}


			/* bonus si la couleur était un background la ligne d'avant */
			switch (scr.line[i].mode) {
				case 0:maxlinecol=15;break;
				case 1:maxlinecol=3;break;
				case 2:maxlinecol=1;break;
				default:printf("warning remover\n");break;
			}
			for (l=0;l<scr.line[i].cptcol;l++) {
				curga=scr.line[i].col[l];
				for (m=0;m<maxlinecol;m++) 
				if (lastbackgroundcolor[m]==curga) colorscore[curga]++;
			}
			/* on trie les scores pour avoir nos backgrounds */
			memset(tabscore,0,sizeof(tabscore));
			for (l=0;l<scr.line[i].cptcol;l++) {
				curga=scr.line[i].col[l];
				tabscore[l].score=colorscore[curga];
				tabscore[l].ga=curga;
			}
			qsort(tabscore,scr.line[i].cptcol,sizeof(struct s_score),cmpscore);

			/* un seul background peut changer sinon ben on fera ce qu'on pourra */
			if (!i) {
				/* attribution des backgrounds */
				printf("Première(s) couleur(s) de background:");
				for (l=0;l<maxlinecol;l++) {
					if (!tabscore[l].ga) break;
					lastbackgroundcolor[l]=tabscore[l].ga;
					primarybackgroundcolor[iprim++]=tabscore[l].ga;
					printf(" %02X",tabscore[l].ga);
				}
				printf("\n");
			} else {
				changeback=0;
				for (l=0;l<maxlinecol;l++) {
					if (!tabscore[l].ga) break;
					for (m=0;m<maxlinecol;m++) {
						/* on essaie de retrouver la couleur de background dans le "last" */
						if (lastbackgroundcolor[m]==tabscore[l].ga)
							break;
					}
					if (m==maxlinecol) {
						/* background n'était pas dans la liste précédente */
printf("ligne [%03d] background %02X pas dans la liste des background précédents [",i,tabscore[l].ga);
			for (m=0;m<maxlinecol;m++) {
				printf("%02X ",lastbackgroundcolor[m]);
			}
printf("]\n");
						changeback++;
						for (m=0;m<maxlinecol;m++) {
							if (lastbackgroundcolor[m]==0) {
								/* mais il y a un slot libre */
								printf("on ajoute aux PRIMARY background la couleur %02X et à la liste en cours\n",tabscore[l].ga);
								lastbackgroundcolor[m]=tabscore[l].ga;
								printf("iprim=%d maxlinecol=%d\n",iprim,maxlinecol);
								if (iprim<maxlinecol) {
									primarybackgroundcolor[iprim++]=tabscore[l].ga;
									/* prévoir un reboot de ligne? */
									changeback--;
								}
								break;
							}
						}
						if (changeback) {
							for (m=0;m<maxlinecol;m++) {
								for (n=0;n<l;n++) {
									if (lastbackgroundcolor[m]==tabscore[n].ga)
										break;
								}
								if (n==l) {
printf("le lastbackground %02X est remplacé par %02X\n",lastbackgroundcolor[m],tabscore[l].ga);
									lastbackgroundcolor[m]=tabscore[l].ga;
								}
							}
						}
					} else {
						/* background déjà sélectionné, on ne touche à rien */
					}
					/* enlever le background qu'on vient de choisir des stats dans tous les cas */
					for (m=0;m<128;m++) {
						colorstat[tabscore[l].ga][m]=0;
						colorstat[m][tabscore[l].ga]=0;
						colorstat[m][m]=0; /* on évite les effets de bords */
					}
					/* regarder si les couleurs restantes pourraient spliter ou non (aucune voisine par couleur restante) */
					if (l>=maxlinecol-2) {
						/* on ne teste que si il reste plus d'une couleur! */
						for (m=0;m<128;m++) for (n=0;n<128;n++) {
							if (colorstat[tabscore[n].ga][m]==1) {
								break;
							}
						}
						if (m!=128 || n!=128) {
							/* il reste des couleurs qui doivent etre distinctes en blocs! */
						} else {
							/* quitter la boucle des backgrounds: */
printf("sortie anticipée du traitement des backgrounds\n");
							lindex=l+1;
							break;
						}
					}
				}
				if (changeback) {
					printf("Couleurs de background:");
					for (l=0;l<maxlinecol;l++) {
						if (!tabscore[l].ga) break;
						printf(" %02X",tabscore[l].ga);
					}
					printf(" changeback=%d primary=",changeback);
					for (l=0;l<iprim;l++) {
						printf(" %02X",primarybackgroundcolor[l]);
					}
					printf("\n");
				}
				if (changeback>1) {
					clash++;
					printf("background clash\n");
					/* faire la resolution de la couleur */
				} else if (changeback) {
					/* trouver celle qui dégage  et attribuer + modif structure ligne pour insérer l'ordre de changement de background */
					printf("background change TODO\n");
				}
			}
			/* attribution des couleurs restantes dans les registres de split (pas d'optim d'attribution) */
			m=0;
			for (l=lindex;l<maxlinecol;l++) {
				if (!tabscore[l].ga) break;
				if (m<MAXSPLIT) {
					reg[m++]=tabscore[l].ga;
				} else {
					clash++;
					break;
				}
			}
			while (m<MAXSPLIT) reg[m++]=-1;
			/* registres pour la ligne */
			memcpy(scr.line[i].reg,reg,sizeof(reg));

			
			/* reinit? */
		}
		/* stats & infos */
		printf("primary background colors=");
		for (l=0;l<iprim;l++) {
			printf(" %s",GetStringFromGA(primarybackgroundcolor[l]));
		}
		printf("\n");

		
		/*************************************************
			A s s e m b l y      g e n e r a t i o n
		*************************************************/
			/* parcours des lignes de bloc en bloc, prémices du code sous forme de tokens */
/*
struct s_rastblock block[48];
int col[27];
int cptcol;
int nbblock;
int freenop;
int mode;
int reg[MAXSPLIT];
*/
			/* on initialise pas mal de choses pour la première ligne */

			/*
				exx : ld bc,#7F01 : out (c),0 : ld de,#0203 : ld hl,#8C8D : exx
				pushregisters(reg);
			*/
			/*
			inittoken(token);
			pushtoken(token,line,TOKEN_EXX);
			pushtokenstrict(token,line,TOKEN_EXX,timecode);
			cleantoken(token);
*/
			for (i=1;i<photo->height;i++) {
				/* on reutilise au mieux les registres d'un set de couleurs à l'autre */
				int newreg[MAXSPLIT]={0};
				m=0;
				for (j=0;scr.line[i-1].reg[j]>=0x40;j++) {
					/* chercher si la couleur est réutilisée */
					for (k=0;scr.line[i].reg[k]>=0x40;k++) {
						if (scr.line[i-1].reg[j]==scr.line[i].reg[k]) {
							/* trouve */
							newreg[j]=scr.line[i-1].reg[j];
							break;
						}
					}
				}
				for (k=0;scr.line[i].reg[k]>=0x40;k++) {
					for (j=0;j<MAXSPLIT;j++) {
						if (newreg[j]==scr.line[i].reg[k]) {
							break;
						}
					}
					if (j==MAXSPLIT) {
						/* pas trouve */
						for (j=0;j<MAXSPLIT;j++) {
							if (newreg[j]<0x40) {
								newreg[j]=scr.line[i].reg[k];
								break;
							}
						}
					}
				}
				/*** quels sont les registres qui ont changé du coup? ***/
				if (newreg[0]!=scr.line[i-1].reg[0]) {
					printf("LD A,#%02X\n",newreg[0]);
				}
				if (newreg[1]!=scr.line[i-1].reg[1]) {
					printf("LD C,#%02X\n",newreg[1]);
				}
				/* on essaie de packer DE */
				if (newreg[2]!=scr.line[i-1].reg[2] && newreg[3]!=scr.line[i-1].reg[3]) {
					printf("LD DE,#%04X\n",newreg[2]<<8+newreg[3]);
				} else if (newreg[2]!=scr.line[i-1].reg[2]) {
					printf("LD D,#%02X\n",newreg[2]);
				} else if (newreg[3]!=scr.line[i-1].reg[3]) {
					printf("LD E,#%02X\n",newreg[3]);
				}
				/* et HL */
				if (newreg[4]!=scr.line[i-1].reg[4] && newreg[5]!=scr.line[i-1].reg[5]) {
					printf("LD DE,#%04X\n",newreg[4]<<8+newreg[5]);
				} else if (newreg[4]!=scr.line[i-1].reg[4]) {
					printf("LD D,#%02X\n",newreg[4]);
				} else if (newreg[5]!=scr.line[i-1].reg[5]) {
					printf("LD E,#%02X\n",newreg[5]);
				}
			}
			
			/* tokenlist
				TOKEN_FILLER,TOKEN_NOP,TOKEN_EXX,TOKEN_OUT_0
				TOKEN_OUT_A,TOKEN_OUT_C,TOKEN_OUT_D,TOKEN_OUT_E,TOKEN_OUT_H,TOKEN_OUT_L
				TOKEN_LD_A,TOKEN_LD_C,TOKEN_LD_D,TOKEN_LD_E,TOKEN_LD_H,TOKEN_LD_L,TOKEN_LD_DE,TOKEN_LD_HL
				
			*/
			
			/* relecture des tokens pour créer le code */

			/* tempo generique pour n nops avec n>7
			
			   exx         1
			   ld b,cpt    2
			   djnz $      4*(cpt-1)+3
			   exx         1
			
			*/
		
		
		if (clash) {
			printf("***********************************************\n");
			printf(" t h e r e   i s   c o l o r   c l a s h i n g\n");
			printf("***********************************************\n");
		}
	} else {
	/*************************************************
	    s c r e e n   &   s p r i t e     m o d e
	*************************************************/
		/* step */
		if (parameter->single) {
			istep=1;
			printf("mode single: one pixel per byte output\n");
		} else {
			switch (parameter->mode) {
				case 0:istep=2;printf("mode 0: pixels grouped by 2\n");break;
				case 1:istep=4;printf("mode 1: pixels grouped by 4\n");break;
				case 2:istep=8;printf("mode 2: pixels grouped by 8\n");break;
				default:printf("warning remover\n");break;
			}
		}
		printf("extraction from %d/%d to %d/%d step %d/%d istep %d\n",parameter->ox,parameter->oy,photo->width,photo->height,parameter->sx,parameter->sy,istep);
		for (j=parameter->oy;j<photo->height;j+=parameter->sy) {
			for (i=parameter->ox;i<photo->width;i+=parameter->sx) {
				/* sprites automatic search */
				AutoScan(parameter,photo,palette,&i,&j);

				if (j+parameter->sy<=photo->height && i+parameter->sx<=photo->width) {
					/* prepare sprite info */
					curspi.adr=idata;
					for (ys=0;ys<parameter->sy;ys++) {
						/* sreen mode means adressing memory like CRTC does */
						if (parameter->scrmode) {
							idata=scradr[curline++];
							if (curline>=maxscradr) {
								printf(KERROR"trop de lignes parcourues (%d) pour faire une extraction encodée en entrelacé!\n",curline);
								exit(5);
							}
						}
						for (xs=0;xs<parameter->sx;xs+=istep) {
							adr=((j+ys)*photo->width+i+xs)*4;
							zepix=0;
							// ALPHA CHANNEL if (photo->data[(i+xs+(j+ys)*photo->width)*4+3]>0) {
							if (parameter->single) {
								/* one pixel per byte to the right / same calculations for every modes */
								pix2=GetIDXFromPalette(palette,photo->data[adr+0],photo->data[adr+1],photo->data[adr+2]);
								if (pix2&1) zepix+=64;if (pix2&2) zepix+=4;if (pix2&4) zepix+=16;if (pix2&8) zepix+=1;
							} else {
								switch (parameter->mode) {
									case 0:
										/* classical mode 0 */
										if (photo->data[adr+3]) pix1=GetIDXFromPalette(palette,photo->data[adr+0],photo->data[adr+1],photo->data[adr+2]); else pix1=0;
										transdata[itrans++]=photo->data[adr+3]>0?1:0;
										if (xs+1<parameter->sx) {
											if (photo->data[adr+7]) pix2=GetIDXFromPalette(palette,photo->data[adr+4],photo->data[adr+5],photo->data[adr+6]); else pix2=0;
											transdata[itrans++]=photo->data[adr+7]>0?1:0;
										} else {
											/* largeur impaire on force à zéro + transparence */
											pix2=0;
											transdata[itrans++]=0;
										}

										if (pix1&1) zepix+=128;if (pix1&2) zepix+=8;if (pix1&4) zepix+=32;if (pix1&8) zepix+=2;
										if (pix2&1) zepix+=64;if (pix2&2) zepix+=4;if (pix2&4) zepix+=16;if (pix2&8) zepix+=1;
										break;
									case 1:
										pix1=GetIDXFromPalette(palette,photo->data[adr+0],photo->data[adr+1],photo->data[adr+2]);
										transdata[itrans++]=photo->data[adr+3]>0?1:0;
										pix2=GetIDXFromPalette(palette,photo->data[adr+4],photo->data[adr+5],photo->data[adr+6]);
										transdata[itrans++]=photo->data[adr+7]>0?1:0;
										pix3=GetIDXFromPalette(palette,photo->data[adr+8],photo->data[adr+9],photo->data[adr+10]);
										transdata[itrans++]=photo->data[adr+11]>0?1:0;
										pix4=GetIDXFromPalette(palette,photo->data[adr+12],photo->data[adr+13],photo->data[adr+14]);

if (pix1==-1 || pix2==-1 || pix3==-1 || pix4==-1) printf("pixel en %d/%d\n",i+xs,j+ys);

										transdata[itrans++]=photo->data[adr+15]>0?1:0;
										if (pix1&1) zepix+=128;if (pix1&2) zepix+=8;
										if (pix2&1) zepix+=64;if (pix2&2) zepix+=4;
										if (pix3&1) zepix+=32;if (pix3&2) zepix+=2;
										if (pix4&1) zepix+=16;if (pix4&2) zepix+=1;
										break;
									case 2:
										if (GetIDXFromPalette(palette,photo->data[adr+0],photo->data[adr+1],photo->data[adr+2])) zepix+=128;adr+=4;
										transdata[itrans++]=photo->data[adr+3]>0?1:0;
										if (GetIDXFromPalette(palette,photo->data[adr+0],photo->data[adr+1],photo->data[adr+2])) zepix+=64;adr+=4;
										transdata[itrans++]=photo->data[adr+3]>0?1:0;
										if (GetIDXFromPalette(palette,photo->data[adr+0],photo->data[adr+1],photo->data[adr+2])) zepix+=32;adr+=4;
										transdata[itrans++]=photo->data[adr+3]>0?1:0;
										if (GetIDXFromPalette(palette,photo->data[adr+0],photo->data[adr+1],photo->data[adr+2])) zepix+=16;adr+=4;
										transdata[itrans++]=photo->data[adr+3]>0?1:0;
										if (GetIDXFromPalette(palette,photo->data[adr+0],photo->data[adr+1],photo->data[adr+2])) zepix+=8;adr+=4;
										transdata[itrans++]=photo->data[adr+3]>0?1:0;
										if (GetIDXFromPalette(palette,photo->data[adr+0],photo->data[adr+1],photo->data[adr+2])) zepix+=4;adr+=4;
										transdata[itrans++]=photo->data[adr+3]>0?1:0;
										if (GetIDXFromPalette(palette,photo->data[adr+0],photo->data[adr+1],photo->data[adr+2])) zepix+=2;adr+=4;
										transdata[itrans++]=photo->data[adr+3]>0?1:0;
										if (GetIDXFromPalette(palette,photo->data[adr+0],photo->data[adr+1],photo->data[adr+2])) zepix+=1;adr+=4;
										transdata[itrans++]=photo->data[adr+3]>0?1:0;
										break;
									default:printf("warning remover\n");break;
								}
							}
							cpcdata[idata]=zepix;
							if (parameter->scrmode && parameter->oldmode) {
								if ((idata & 0x7FF)==0x7FF) idata+=0x3800;
							}
							idata++;
							CHECK_IDATA
							if (idata>maxdata) maxdata=idata;
						}
					}
					/* update sprite info */
					curspi.size=maxdata-curspi.adr;
					curspi.x=parameter->sx;
					curspi.y=parameter->sy;
					/* update sprite info */
//printf("extraction %d %d/%d\n",ispi+1,curspi.x,curspi.y);
					ObjectArrayAddDynamicValueConcat((void **)&spinfo,&ispi,&mspi,&curspi,sizeof(struct s_sprite_info));
					if (parameter->maxextract<=ispi) {printf("*break*\n");i=photo->width;j=photo->height;break;}
				}
			}
		}
	}
	/* info */
	if (!parameter->scrmode) {
		printf(KVERBOSE"%d %ssprite%s extracted\n"KNORMAL,ispi,parameter->hsp?"hardware ":"",ispi>1?"s":"");
	}

	if (parameter->outputfilename) {
		strcpy(newname,parameter->outputfilename);
	} else {
		strcpy(newname,parameter->filename);
		if (!parameter->asmdump) {
			strcpy(newname+strlen(newname)-3,"bin");
		} else {
			strcpy(newname+strlen(newname)-3,"asm");
		}
	}

	byteleft=maxdata>idata?maxdata:idata;
	if (!parameter->split) parameter->split=byteleft;
	if (parameter->asmdump) {
		char dataline[1024];
		j=0;
		while (byteleft>0) {
			strcpy(dataline,"defb ");
			for (i=0;i<32 && byteleft-i>0;i++) {
				if (i) strcat(dataline,",");
				sprintf(dataline+strlen(dataline),"#%02X",cpcdata[j+i]);
			}
			strcat(dataline,"\n");
			j+=32;
			byteleft-=32;
			FileWriteBinary(newname,dataline,strlen(dataline));
		}
		FileWriteBinaryClose(newname);
	} else {
		/**************** écriture des fichiers binaires *************/
		woffset=0;
		while (byteleft) {
			FileRemoveIfExists(newname);
			if (byteleft>parameter->split) {
				if (filenumber<5) {
					printf(KIO"writing %d bytes in %s\n"KNORMAL,parameter->split,newname);				
				}
				FileWriteBinary(newname,cpcdata+woffset,parameter->split);
				woffset+=parameter->split;
				FileWriteBinaryClose(newname);
				byteleft-=parameter->split;
				if (filenumber==5 && byteleft>0) {
					printf("(...)\n");
				}
				/* set next filename */
				if (filenumber<100) sprintf(newname+strlen(newname)-2,"%02d",filenumber++);
				else if (filenumber>=100) sprintf(newname+strlen(newname)-3,"%03d",filenumber++);

			} else {
				printf(KIO"writing %d bytes in %s\n"KNORMAL,byteleft,newname);
				FileWriteBinary(newname,cpcdata+woffset,byteleft);
				byteleft=0;
			}
			FileWriteBinaryClose(newname);
		}
		/***************** écriture des masques ******************************/
		parameter->split*=2;
		for (i=0;i<itrans;i++) {
			/* si on n'a pas de transparence on n'écrit pas */
			if (transdata[i]) {
				woffset=0;
				byteleft=itrans;
				strcpy(newname+strlen(newname)-3,"t01");filenumber=2;
				while (byteleft) {
					FileRemoveIfExists(newname);
					if (byteleft>parameter->split) {
						if (filenumber<5) {
							printf(KIO"writing %d bytes in %s\n"KNORMAL,parameter->split,newname);				
						}
						FileWriteBinary(newname,transdata+woffset,parameter->split);
						woffset+=parameter->split;
						FileWriteBinaryClose(newname);
						byteleft-=parameter->split;
						if (filenumber==5 && byteleft>0) {
							printf("(...)\n");
						}
						/* set next filename */

						if (filenumber<100) sprintf(newname+strlen(newname)-2,"%02d",filenumber++);
						else if (filenumber>=100) { printf("error\n");}
					} else {
						printf(KIO"writing %d bytes in %s\n"KNORMAL,byteleft,newname);
						FileWriteBinary(newname,transdata+woffset,byteleft);
						byteleft=0;
					}
					FileWriteBinaryClose(newname);
				}
				break;
			}
		}
		if (parameter->lara) {
			char geobuffer[512];
			strcpy(newname+strlen(newname)-3,"geo");
			FileRemoveIfExists(newname);
			sprintf(geobuffer,"%d\n%d\n%d\n%d\n",(parameter->sx+1)>>1,parameter->sy,ispi,decal);
			FileWriteBinary(newname,geobuffer,strlen(geobuffer)+1);
			FileWriteBinaryClose(newname);
		}
	}
	/* output sheet if any */
	if (parameter->sheetfilename) {
		char txtspinfo[1024];
		printf(KIO"Extraction info saved in %s\n"KNORMAL,parameter->sheetfilename);
		FileRemoveIfExists(parameter->sheetfilename);
		sprintf(txtspinfo,"; extraction info for %s\n",parameter->filename);
		FileWriteBinary(parameter->sheetfilename,txtspinfo,strlen(txtspinfo));
		for (i=0;i<ispi;i++) {
			strcpy(txtspinfo,"defw ");
			if (1) sprintf(txtspinfo+strlen(txtspinfo),"#%04X",spinfo[i].adr);
			if (1) sprintf(txtspinfo+strlen(txtspinfo)," : defb #%02X",spinfo[i].x);
			if (1) sprintf(txtspinfo+strlen(txtspinfo),",#%02X",spinfo[i].y);
			strcat(txtspinfo,"\n");
			FileWriteBinary(parameter->sheetfilename,txtspinfo,strlen(txtspinfo));
		}
		FileWriteBinaryClose(parameter->sheetfilename);
	}
	/* clean memory */
	PNGFree(&photo);
	MemFree(cpcdata);
	if (mspi) {
		MemFree(spinfo);
	}
}

/***************************************
	semi-generic body of program
***************************************/

/*
	Usage
	display the mandatory parameters
*/
void Usage(char **argv)
{
	#undef FUNC
	#define FUNC "Usage"
	
	printf("usage: %.*s.exe <pngfile> <options>\n",(int)(sizeof(__FILENAME__)-3),__FILENAME__);
	printf("\n");
	printf("general options:\n");
	printf("-o <file>        full output filename\n");
	printf("-flat            output one file instead of 16K split\n");
	printf("-split <size>    split output files with size ex: 4K or 4096\n");
	printf("-m <mode>        output mode (0,1,2)\n");
	printf("-g               sort palette from darkest to brightest color\n");
	printf("-asmdump         output assembly dump\n");
	printf("-exnfo <file>    export assembly informations about extracted zones\n");
	printf("-expal <file>    export palette in a text file\n");
	printf("-impal <file>    import palette from a text file\n");
	printf("\n");
	printf("sprite options: (default progressive output)\n");
	printf("-scan            scan sprites inside border\n");
	printf("-single          only one pixel per byte to the right side\n");
	printf("-size <geometry> set sprite dimensions in pixels. Ex: -size 16x16 \n");
	printf("-offset <pos>    set start offset from top/left ex: 20,2\n");
	printf("-mask            add mask info to data (see doc)\n");
	printf("-c <maxsprite>   maximum number of sprites to extract\n");
	printf("-meta <geometry> gather sprites when scanning. Ex: -meta 3x2\n");
	printf("\n");
	printf("screen options:\n");
	printf("-scr             enable screen output (interlaced data)\n");
	printf("-old             enable overscan screen output (interlaced data)\n");
	printf("-lb <nblines>    number of lines per block for screen output (for CPC+ split)\n");
	printf("-ls <nblines>    number of lines of 1st screen in extended screen output\n");
	printf("-w <width>       force output screen width in bytes\n");
	printf("-splitraster     split-raster analysis");
	printf("\n");
	printf("hardware sprite options:\n");
	printf("-hsp             enable hardware sprite mode\n");
	printf("-meta <nxn>      extraction of meta sprites\n");
	printf("-scan            scan sprites inside border\n");
	printf("-b               black is transparency (keep real transparency)\n");
	printf("-p 4             store data 4bits+4bits in reverse order into a single byte\n");
	printf("-p 2             store data 2+2+2+2bits in logical order into a single byte\n");
	printf("-force           force extraction of incomplete sprites\n");
	printf("-k               keep empty sprites\n");

	printf("\n");

	if (argv) {
		printf("\n");
		printf("Error parsing word: %s\n",argv[0]);
		printf("\n");
	}
	
	exit(ABORT_ERROR);
}


/*
	ParseOptions
	
	used to parse command line and configuration file
*/
int ParseOptions(char **argv,int argc, struct s_parameter *parameter)
{
	#undef FUNC
	#define FUNC "ParseOptions"
	char *scissor;
	int i=0;

	if (argv[i][0]=='-')
	{
		switch(argv[i][1])
		{
			case 'a':
			case 'A':if (stricmp(argv[i],"-asmdump")==0) {
					parameter->asmdump=1;
				} else {
					Usage(argv);
				}
				break;
			case 'C':
			case 'c':
				parameter->maxextract=atoi(argv[++i]);
				break;
			case 'W':
			case 'w':
				parameter->width=atoi(argv[++i]);
				break;
			case 'e':
			case 'E':if (stricmp(argv[i],"-expal")==0) {
					parameter->exportpalettefilename=argv[++i];
				} else if (stricmp(argv[i],"-exnfo")==0) {
					parameter->sheetfilename=argv[++i];
				} else {
					Usage(argv);
				}
				break;
			case 'i':
			case 'I':if (stricmp(argv[i],"-impal")==0) {
					parameter->importpalettefilename=argv[++i];
				} else {
					Usage(argv);
				}
				break;
			case 'F':
			case 'f':if (stricmp(argv[i],"-flat")==0) {
					parameter->split=0;
				} else if (stricmp(argv[i],"-force")==0) {
					parameter->forceextraction=1;
				} else {
					Usage(argv);
				}
				break;
			case 'g':
			case 'G':
				parameter->grad=1;
				break;
			case 'k':
			case 'K':
				parameter->keep_empty=1;
				break;
			case 'm':
			case 'M':if (stricmp(argv[i],"-mask")==0) {
					parameter->mask=1;
				} else if (stricmp(argv[i],"-meta")==0) {
					i++;
					if ((scissor=strchr(argv[i],'x'))!=NULL) {
						parameter->metax=atoi(argv[i]);
						parameter->metay=atoi(scissor+1);
						if (parameter->metax>0 && parameter->metay>0) {
						} else {
							Usage(argv);
						}
					} else {
						Usage(argv);
					}
				} else {
					if (!argv[i][2]) {
						parameter->mode=atoi(argv[++i]);
					} else {
						Usage(argv);
					}
				}
				break;
			case 'o':
			case 'O': if (!argv[i][2]) {
					parameter->outputfilename=argv[++i];
				} else if (stricmp(argv[i],"-offset")==0) {
					i++;
		printf("parsing offset [%s]\n",argv[i]);
					if ((scissor=stristr(argv[i],","))!=NULL) {
						*scissor=0;
						parameter->ox=atoi(argv[i]);
						parameter->oy=atoi(scissor+1);
						if (parameter->ox>=0 && parameter->oy>=0) {
						} else {
							Usage(argv);
						}
					} else {
						Usage(argv);
					}
				} else if (stricmp(argv[i],"-old")==0) {
					parameter->oldmode=1;
				} else {
					Usage(argv);
				}
				break;
			case 's':
			case 'S':if (stricmp(argv[i],"-split")==0) {
					i++;
					if (strcmp(argv[i],"auto")==0 || strcmp(argv[i],"AUTO")==0) {
						parameter->split=parameter->sx*parameter->sy;
						switch (parameter->mode) {
							case 2:parameter->split/=8;break;
							case 1:parameter->split/=4;break;
							case 0:parameter->split/=2;break;
							default:Usage(argv);
						}
					} else {
						parameter->split=atoi(argv[i]);
						if (toupper(argv[i][strlen(argv[i])-1])=='K') parameter->split*=1024;
					}
				} else if (stricmp(argv[i],"-splitraster")==0) {
					parameter->splitraster=1;
				} else if (stricmp(argv[i],"-single")==0) {
					parameter->single=1;
				} else if (stricmp(argv[i],"-scan")==0) {
					parameter->scan=1;
				} else if (stricmp(argv[i],"-size")==0) {
					i++;
					if ((scissor=strchr(argv[i],'x'))!=NULL) {
						parameter->sx=atoi(argv[i]);
						parameter->sy=atoi(scissor+1);
						if (parameter->sx>0 && parameter->sy>0) {
						} else {
							Usage(argv);
						}
					} else {
						Usage(argv);
					}
				} else if (stricmp(argv[i],"-scr")==0) {
					parameter->scrmode=1;
				} else {
					Usage(argv);
				}
				break;
			case 'p':
			case 'P':
				parameter->packed=atoi(argv[++i]);
				switch (parameter->packed) {
					case 2:
					case 4:break;
					default:Usage(argv);
				}
				break;
			case 'L':
			case 'l':if (stricmp(argv[i],"-lara")==0) {
					parameter->lara=1;
				} else switch (argv[i][2]) {
					case 'B':
					case 'b':
						parameter->lineperblock=atoi(argv[++i]);
						break;
					case 'S':
					case 's':
						parameter->nblinescreen=atoi(argv[++i]);
						break;
					default:Usage(argv);
				}
				break;
			case 'B':
			case 'b':
				parameter->black=1;
				break;
			case 'H':
			case 'h':if (stricmp(argv[i],"-hsp")==0) {
					parameter->hsp=1;
				} else {
					Usage(argv);
				}
				break;
			default:
				Usage(argv);		
		}
	} else {
		if (!parameter->filename) {
			parameter->filename=argv[i];
		} else {
			Usage(argv);
		}
	}
	return i;
}

/*
	GetParametersFromCommandLine	
	retrieve parameters from command line and fill pointers to file names
*/
void GetParametersFromCommandLine(int argc, char **argv, struct s_parameter *parameter)
{
	#undef FUNC
	#define FUNC "GetParametersFromCommandLine"
	int i;
	
	for (i=1;i<argc;i++)
		i+=ParseOptions(&argv[i],argc-i,parameter);

	if (!parameter->filename) {
		Usage(NULL);
	}

	if (parameter->hsp && (!parameter->sx || !parameter->sy)) {
		printf("using default size for hardware sprites -> 16x16\n");
		parameter->sx=16;
		parameter->sy=16;
	}

printf("param OK file=[%s] split=%d scr=%d\nsplitraster=%d hsp=%d max=%d black is transparency=%d\n",parameter->filename,parameter->split,parameter->scrmode,parameter->splitraster,parameter->hsp,parameter->maxextract,parameter->black);
}

/*
	main
	
	check parameters
	execute the main processing
*/
void main(int argc, char **argv)
{
	#undef FUNC
	#define FUNC "main"

	struct s_parameter parameter={0};
	/* default */
	parameter.lineperblock=8;
	parameter.maxextract=1;
	parameter.split=16384;
	parameter.metax=1;
	parameter.metay=1;

	printf(KVERBOSE"%.*s.exe v2.0 / Edouard BERGE 2016-2019\n",(int)(sizeof(__FILENAME__)-3),__FILENAME__);
	printf("powered by zlib & libpng\n");
	printf(KNORMAL"\n");

	GetParametersFromCommandLine(argc,argv,&parameter);

	parameter.metax*=16;
	parameter.metay*=16;

	Build(&parameter);
#ifndef PROD
	CloseLibrary();
#endif
	exit(0);
}




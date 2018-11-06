#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fiodef.h>
#include <atarierr.h>
#include <tos.h>
#include <aes.h>
#include <setjmp.h>
#define numcat(a, b)	itoa(b, &(a[strlen(a)]), 10)
int cdecl		identify(FILE_DSCR *fd);
int cdecl		load_file(FILE_DSCR *fd, GRAPE_DSCR *dd);
int cdecl		save_file(FILE_DSCR *fd, GRAPE_DSCR *sd, int ex_format, int cmp_format, int *options);

GLOBAL(int) read_JPEG_file (char * filename, GRAPE_DSCR *dd);
char *comp_names[]={"0-max. quality","1","2","3","4","5","6","7","8","9","10-min. size"};
char *option1[]={"Baseline"};
char *option2[]={"Progressive"};
char *option3[]={"Fast"};
char *option4[]={"Opt. Huffman"};
char *option5[]={"Smooth 0","Smooth 1","Smooth 2","Smooth 3","Smooth 4","Smooth 5","Smooth 6","Smooth 7","Smooth 8","Smooth 9","Smooth 10"};
OPTION opts[]=
{
	1,option1,
	1,option2,
	1,option3,
	1,option4,
	11,option5
};

static MODULE_FIOFN mod_fn=
{
	/* Meine Funktionen */	
	mod_init,
	identify,
	load_file,
	save_file
};

static FIOMODBLK fblock=
{
	"GRAPEFIOMOD",
	'0101',
	
	/* id */
	'JPEG',
	
	/* name */
	"JPEG/JFIF",

	/* Exportformate */
	SUP8G|SUP24RGB,
	
	/* Anzahl der Kompressionsverfahren */
	11,
	/* Namen */
	comp_names,
	
	/* Anzahl der Optionen */
	5,
	/* Optionen */
	opts,
	
		
	/* Meine Funktionen */	
	&mod_fn,
	
	/* Grape-Functions */
	NULL
};

void main(void)
{
	appl_init();
	if(fblock.magic[0])
		form_alert(1,"[3][Ich bin ein Grape-Modul!][Abbruch]");
	appl_exit();
}

void cdecl mod_init(void)
{
}
int	cdecl	identify(FILE_DSCR *fd)
{

	typedef struct
	{
		unsigned int	id;
		unsigned int		size;
		char	jfif[5];
		char	version[2];
	}APP0_HEADER;
	typedef struct
	{
		unsigned int	id;
		unsigned int		size;
		char	pic_data[6];
		/* 0 = precision
			1,2 = height
			3,4 = width
			 5  = bps
		*/
	}SOF_HEADER;
	typedef struct
	{
		unsigned int id;
		unsigned int	size;
	}JFIF_BLOCK;
	APP0_HEADER		*ahd;
	SOF_HEADER		*sof=NULL;
	JFIF_BLOCK		*jbl;
	uchar					mbuf[2048], *jblk=mbuf;
	int						ret, precision, height, width, bps;
	long					offset=0;
	static char 	dscr[120];
	
	Fread(fd->fh, 2048, mbuf);
	jblk+=2;
	ahd=(APP0_HEADER*)jblk;
	if(ahd->id!=0xffe0l) return(UNKNOWN);
	if((ahd->jfif[0]!='J')||(ahd->jfif[1]!='F')||(ahd->jfif[2]!='I')||(ahd->jfif[3]!='F')||(ahd->jfif[4]!=0))
	 return(UNKNOWN);

	ret=REL_REC;

	/* Bl�cke nach SOF absuchen, bis SOS-Block gefunden wird */
	jbl=(JFIF_BLOCK*)jblk;
	while((jbl->id != 0xffdal) && (sof==NULL))
	{
		if((sof==NULL)&&(jbl->id>=0xffc0l)&&(jbl->id<=0xffcfl)&&(jbl->id!=0xffc2l)&&(jbl->id!=0xffc4l)&&(jbl->id!=0xffccl))
			sof=(SOF_HEADER*)jbl;
		jblk+=jbl->size+2;
		jbl=(JFIF_BLOCK*)jblk;
		if((long)jbl - (long)mbuf > 2048)
		{/* Buffer neu laden */
			offset+=(long)jbl-(long)mbuf;
			Fseek(offset, fd->fh, 0);
			Fread(fd->fh, 2048, mbuf);
		}
	}

	if(sof!=NULL)
	{
		if((long)sof-(long)mbuf < sizeof(SOF_HEADER))
		{
			Fseek((long)sof-(long)mbuf+offset, fd->fh, 0);
			Fread(fd->fh, sizeof(SOF_HEADER), mbuf);
			sof=(SOF_HEADER*)mbuf;
		}
		precision=sof->pic_data[0];
		height=*(int*)(&(sof->pic_data[1]));
		width=*(int*)(&(sof->pic_data[3]));
		bps=sof->pic_data[5];
	}
	strcpy(dscr, "JPEG/JFIF File, Version ");
	numcat(dscr, ahd->version[0]);
	strcat(dscr, ".");
	numcat(dscr, ahd->version[1]);
	if(sof==NULL)
	{/* Kein Bilddatenblock gefunden */
		strcat(dscr, "|Die Datei enth�lt keinen Bilddatenblock.");
		strcat(dscr, "|Vermutlich ist die Datei defekt.");
	}
	else if((width<=0)||(height<=0))
	{/* Ung�ltige Ausma�e oder DHL-File (H�he wird erst durch Auspacken bekannt) */
		strcat(dscr, "|Die Ausma�e sind als ");
		numcat(dscr, width);
		strcat(dscr, " x ");
		numcat(dscr, height);
		strcat(dscr, "|Pixel angegeben.");
		strcat(dscr, "|Entweder handelt es sich um eine nicht");
		strcat(dscr, "|unterst�tzte Variation (DNL) oder die");
		strcat(dscr, "|Datei ist defekt.");
	}
	else
	{/* Sieht gut aus */
		strcat(dscr, "|Gr��e: ");
		numcat(dscr, width);
		strcat(dscr, " x ");
		numcat(dscr, height);
		strcat(dscr, " Pixel in ");
		if(bps==3)
		{
			strcat(dscr, "Farbe");	/* CAN_LOAD */
			ret|=CAN_LOAD;
		}
		else if(bps==1)
		{
			strcat(dscr, "Graustufen"); /* CAN_LOAD */
			ret|=CAN_LOAD;
		}
		else
		{
			numcat(dscr, bps);
			strcat(dscr, " Farbebenen");
		}
		strcat(dscr, "|Aufl�sung: ");
		numcat(dscr, bps*precision);
		strcat(dscr, " Bit pro Pixel");
		if(precision!=8)
			ret=REL_REC;/* CAN NOT LOAD */
	}
	
	fd->descr=dscr;
	if(sof!=NULL)
	{
		fd->width=width;
		fd->height=height;
	}
	return(ret);
}

int cdecl		load_file(FILE_DSCR *fd, GRAPE_DSCR *dd)
{
	char	total_path[128];
	
	Fclose(fd->fh); /* Sonst kriegt das jpeg-gelumpe das nicht auf */

	strcpy(total_path, fd->path);
	strcat(total_path, fd->name);
	strcat(total_path, fd->ext);
	if(read_JPEG_file(total_path, dd)==1)	/* Successive */
	else
		return(-1);
}

int	cdecl	save_file(FILE_DSCR *fd, GRAPE_DSCR *sd, int ex_format, int cmp_format, int *options)
{
	char	total_path[128];
	
	Fclose(fd->fh); /* Sonst kriegt das jpeg-gelumpe das nicht auf */
	
	strcpy(total_path, fd->path);
	strcat(total_path, fd->name);
	strcat(total_path, fd->ext);
	if(write_JPEG_file(total_path, ex_format, 100-cmp_format*10, options, sd)==1)	/* Successive */
	else
		return(-1);
}

/* JPEG-Error-Handler */

	char	alert[128];
	strcat(alert, "][Cancel]");
	_GF_ form_alert(1,alert);

	
	/* Init mblock */
	if(ex_format==SUP8G)
	{
		mblock.format=B8;
		mblock.subcode=B8_GBWPP;
		mblock.data=_GF_ malloc(dd->width);
	}
	else
	{
		mblock.subcode=B24_RGBPP;
		mblock.data=_GF_ malloc(dd->width*3);
	}
	mblock.height=dd->height;
	mblock.width=dd->width;
	mblock.x=mblock.y=0;
	mblock.w=mblock.lw=dd->width;
	mblock.h=1;
	row_pointer[0]=mblock.data;
	
  /* Step 1: allocate and initialize JPEG compression object */
    _GF_ free(mblock.data);
    if(outfile!=NULL)
  	_GF_ form_alert(1,"[3][JPEG-module:|Can't open output-file.][Cancel]");
  if(ex_format==SUP8G)
  {/* 8 Bit Grayscale */
 	  cinfo.input_components = 1;		/* # of color components per pixel */
 }
  else
  { /* 24 Bit RGB */
	}
	/* Baseline ? */
  if(options[0]==1)
	else
	/* Progressive ? */
	if(options[1]==1)
		jpeg_simple_progression(&cinfo);
		
	/* Fast ? */
	if(options[2]==0) /* No, slow */
		cinfo.dct_method=JDCT_ISLOW;
	else
		cinfo.dct_method=JDCT_IFAST;
		
	/* Optimize Huffman tables? */
	if(options[3]==0) /* No */
		cinfo.optimize_coding=FALSE;
	else
		cinfo.optimize_coding=TRUE;

	/* Smooth? */
	cinfo.smoothing_factor=options[4]*10;
	

     _GF_ get_block(&mblock, dd);
    ++mblock.y;
	_GF_ free(mblock.data);
  return(1);
  struct jpeg_decompress_struct cinfo;
  BLOCK_DSCR	my_block;
  if ((infile = fopen(filename, "rb")) == NULL) {
			opening should be no problem */
   	_GF_ form_alert(1,"[3][JPEG-module:|Can't open input-file.][Cancel]");
  /* If a mask is loaded, force JPEG-Lib to output grayscale */
		cinfo.out_color_space=JCS_GRAYSCALE;
		
  /* Step 5: Start decompressor */
	/* Setup my_block */
  if(cinfo.output_components==3)
  {
		my_block.format=B24;
		my_block.subcode=B24_RGBPP;
	}
	else
	{
		my_block.format=B8;
		my_block.subcode=B8_GBWPP;
	}
		
	/* data is assigned a few lines below */
	my_block.width=cinfo.output_width;
	my_block.height=cinfo.output_height;
	my_block.x=my_block.y=0;
	my_block.w=my_block.lw=my_block.width;
	my_block.h=1;
	

  /* Step 6: while (scan lines remain to be read) */
		++my_block.y;

  }
#include <stdio.h>
#include <string.h>

#ifndef __LAB_H
#define __LAB_H

/* ALLOWABLE TYPES */
#define INTEGER  1
#define NOTYPE   4


/* SYMBOL CLASSES */
#define VAR      1
#define FUNC     2
#define PAR      3
#define CONST    4
#define TEMP     5
#define UNDEF    6


/* INTERMEDIATE CODE OPERATIONS */
/* Arithmetic operations */
#define	PLUS	1	
#define	MINUS	2
#define OROP    3
#define	TIMES	4
#define PARTS   5

/* Tests and jumps */
#define	EQ	18           
#define NE      19
#define LE      20
#define	LT	21
#define GE      22
#define GT      23

#define	ASS     24	     /* assignment */
#define	WRITE   25
#define	READ    26
#define	GOTO    27	     /* jump to target */
#define FSTART	28
#define FEND	29 	
#define PARAM   32           /* function parameter */
#define CALL    33           /* call to function */
#define RETURN  34           /* return from function */
#define	HALT    99	     /* halt execution */


/* GENERAL DEFINITIONS, TYPE AND VARIABLE DECLARATIONS */

#define NKEYS           12   /* number of keywords */ 
#define MAXERR          10   /* max errors per row */
#define LINELENGTH      80

extern FILE *ptree;		             /* file for various output */

/* Symbol table and corresponding routines */
#define	MAXIDLENGTH	16

struct _symbol {
	char id[MAXIDLENGTH];        /* identifier name */
	int type;	             /* INTEGER, REAL, BOOLEAN, NOTYPE */
	int class;	             /* VAR, FUNC, PAR, CONST, TEMP, UNDEF */
	int level;	             /* static level */
	int offset;	             /* offset in block */
	int value;	             /* value for constant */
	struct _symbol *nextsym;     /* next symbol */
};
 
typedef struct _symbol *SYMBOL;

#define SNULL (SYMBOL) NULL

/* Symbol table routines */
SYMBOL insert(char *, int, int);
SYMBOL lookup(char *);

/* Stuff for generating intermediate code */
#define MAXCODE  200

struct _mcode {
	int operation;
	SYMBOL arg1, arg2;
	int target;
};

extern struct _mcode mcodetab[MAXCODE]; /* save intermediate code in mcodetab */

struct _quadlist {
	int adr;
	struct _quadlist *nxt;
};

typedef struct _quadlist *QUADLIST;

#define QNULL (QUADLIST) NULL

struct _expression {                   /* boolean expression */
	SYMBOL place;
	QUADLIST truelist, falselist;
};

/* Routines and necessary variables for manipulating intermediate code */
QUADLIST makelist(int);
QUADLIST merge(QUADLIST, QUADLIST);

SYMBOL emit(int, SYMBOL, SYMBOL, int);

void backpatch(QUADLIST, int);

extern int nextquad, offsetnow, currentlevel;

void printsymbtab();

void printmcode();

#endif

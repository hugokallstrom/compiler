#include <stdio.h>
#include <stdlib.h>
#include "lab.h"

void tblerror(char *);

struct _mcode mcodetab[MAXCODE]; /* save intermediate code in mcodetab */
int nextquad, offsetnow, currentlevel;

int tempcount = 0;
struct _symbol tempvars[6] =    	/* temporary variables */
{
	{"temp0" ,0, TEMP, 0, 0, 0,"", SNULL},
	{"temp1" ,0, TEMP, 0, 0, 0,"", SNULL},
	{"temp2" ,0, TEMP, 0, 0, 0,"", SNULL},
	{"temp3" ,0, TEMP, 0, 0, 0,"", SNULL},
	{"temp4" ,0, TEMP, 0, 0, 0,"", SNULL},
	{"temp5" ,0, TEMP, 0, 0, 0,"", SNULL}
};

static SYMBOL symbtab = SNULL;

/* SYMBOL TABLE ROUTINES  */

/* insert - insert new identifier in symbol table */
SYMBOL insert(char *name, int type, int class, int offset, int level, char *nspace)
{
	SYMBOL r;
	r = symbtab;
	while (r != SNULL)
		if ((strcmp(r->id, name) == 0) && (strcmp(r->nspace, nspace) == 0)) {
			if (class != CONST)
				tblerror("identifier multiply declared");
			return(r);
		} else
			r = r->nextsym;
	if ((r = (SYMBOL)malloc(sizeof(struct _symbol))) == SNULL) {
		fprintf(stderr, "insert: memory allocation error\n");
		exit(1);
	}
	strcpy(r->id, name);
	strcpy(r->nspace, nspace);
	r->type = type;
	r->class = class;
	r->level = level;
	r->offset = offset;
	r->nextsym = symbtab;
	symbtab = r;
	return(r);
}

/* lookup - search for name in symbol table */
SYMBOL lookup(char *s)
{
	SYMBOL sp;
	for (sp = symbtab; sp != SNULL; sp = sp->nextsym)
		if (strcmp(sp->id, s) == 0)
			return(sp);
	tblerror("identifier not declared");    /* id not found */
	return(insert(s, NOTYPE, UNDEF, 0, 0,""));
}


/* ROUTINES FOR GENERATING AND MANIPULATING INTERMEDIATE CODE */

SYMBOL emit(int op, SYMBOL a1, SYMBOL a2, int jmp)
{
/*	fprintf(stderr, "\nEMIT börjar OP: %d\n", op);*/
	SYMBOL p;
	if (a1 != SNULL)
	{
/*	fprintf(stderr, "a1: %s\n", a1->id);*/
		if (a1->class == TEMP)
			tempcount--;
	}
	if (a2 != SNULL)
	{
/*	fprintf(stderr, "a2: %s\n", a2->id);*/
		if(a2->class == TEMP)
			tempcount--;
	}
	if (tempcount >= 6) {
		fprintf(stderr, "gen: run out of space for temp.vars.\n");
		exit(1);
	}
	if (op < EQ || op == CALL) {		/* Use temporary variable */
		p = tempvars + tempcount;
		p->offset = tempcount++;   /* Offset for temp.vars.=tempno */
/*	fprintf(stderr, "Symbol som returneras: %s %d %p\n", p->id, p->offset, p);*/
	}
	else
		p = SNULL;
	mcodetab[nextquad].operation = op;
	mcodetab[nextquad].arg1 = a1;
	mcodetab[nextquad].arg2 = a2;
	mcodetab[nextquad++].target = jmp;
	return(p);
}


QUADLIST merge(QUADLIST l1, QUADLIST l2)
{
	QUADLIST qp;
	if (l1 == QNULL)
		return(l2);
	else { 
		qp = l1;
		while (qp->nxt != QNULL) 
			qp = qp->nxt;
		qp->nxt = l2;
		return(l1);
	}
}

QUADLIST makelist(int quad)
{
	QUADLIST q;
	if (quad == -1)
		return(QNULL);
	else {
		if ((q = (QUADLIST)malloc(sizeof(struct _quadlist))) == QNULL) {
                	fprintf(stderr, "makelist: memory allocation error\n");
			exit(1);
		}
		q->adr = quad;
		q->nxt = QNULL;
		return(q);
	}
}

void backpatch(QUADLIST l, int a)
{
	if (l != QNULL)
		do {
			mcodetab[l->adr].target = a;
			l= l->nxt;
		} while (l != QNULL);
}

/* OUTPUT ROUTINES */

char *typ[5]  = {
     "", "INTEGER", "", "", "NOTYPE " };

char *cl[7]   = {
     "", "VAR  ", "FUNC ", "PAR  ", "CONST", "TEMP ", "UNDEF"  };

char *op[100] = {
     "", "PLUS", "MINUS", "OROP", "TIMES", "PARTS", "", "", "", "",
     "", "", "", "", "", "", "", "", "EQ", "NE",
     "LE", "LT", "GE", "GT", "ASS", "WRITE", "READ", "GOTO", "FSTART", "FEND",
     "", "", "PARAM", "CALL", "RETURN", "", "", "", "", "",
     "", "", "", "", "", "", "", "", "", "",
     "", "", "", "", "", "", "", "", "", "",
     "", "", "", "", "", "", "", "", "", "",
     "", "", "", "", "", "", "", "", "", "",
     "", "", "", "", "", "", "", "", "", "",
     "", "", "", "", "", "", "", "", "", "HALT"  };

FILE *ptree;	/* file for output */

void printsymbtab(char *nspace)
{
	fprintf(stderr, "%s:\n", nspace);
	SYMBOL sp;
	for (sp = symbtab; sp != SNULL; sp = sp->nextsym) {
		if(strcmp(nspace, sp->nspace) == 0)
			fprintf(stderr, "%-9.9stype %s class %s offset%3d level%3d namespace %s\n",
				sp->id, typ[sp->type], cl[sp->class], sp->offset, sp->level, sp->nspace);
	}
	fprintf(stderr, "\n");
}

void printmcode(void)
{
	int n;
	fprintf(stderr,"\n");
	for (n = 0; n < nextquad; n++)
		fprintf(stderr, "%4d:\t%s\t%s\t%s\t%4d\n",
				n, op[mcodetab[n].operation],
				mcodetab[n].arg1 != 0 ? mcodetab[n].arg1->id : "",
				mcodetab[n].arg2 != 0 ? mcodetab[n].arg2->id : "",
				mcodetab[n].target);
}

void tblerror(char *s)
{
	printf("%s\n", s);
}

%{
#include        "lab.h"
#include        "y.tab.h"

#include	<ctype.h>     /*makes e.g "tolower" enable*/

int lineno=1;
int errcount=0,err=0,position=1;

void echoo();
void error(int);

struct {
	int pos,errnum;
} errors[MAXERR];

struct key {
	char *keyw;        /*definitions of all keywords and their*/
	int symb;          /*symbols*/
} keytab[NKEYS]={
	"begin", BEGINSY,
	"do",DOSY,
	"else",ELSESY,
	"end", ENDSY,
	"function",FUNCSY,
	"if", IFSY,
	"integer", INTSY,
	"program", PROGSY,
	"read", READSY,
	"then", THENSY,
	"while",WHILESY,
	"write",WRITESY,
	"repeat",REPEATSY
};
%}
LET		[a-zA-Z]
DIG		[0-9]
INT             [0-9]+ 
%%
"."		{echoo(); return PERIOD;}
";"		{echoo(); return SEMI;}
","		{echoo(); return COMMA;}
":="		{echoo(); yylval.val=ASS; return ASSIGN;} /* fix */
"("		{echoo(); return LPAREN;}
")"		{echoo(); return RPAREN;}
":"             {echoo(); return COLON;}
"="		{echoo(); yylval.val=EQ; return RELOP;}
"<>"            {echoo(); yylval.val=NE; return RELOP;}
"<="            {echoo(); yylval.val=LE; return RELOP;}
"<"		{echoo(); yylval.val=LT; return RELOP;}
">="            {echoo(); yylval.val=GE; return RELOP;}
">"             {echoo(); yylval.val=GT; return RELOP;}
"+"		{echoo(); yylval.val=PLUS; return ADDOP;}
"-"		{echoo(); yylval.val=MINUS; return ADDOP;}
"*"		{echoo(); yylval.val=TIMES; return MULOP;}
"/"             {echoo(); yylval.val=PARTS; return MULOP;}

{LET}({LET}|{DIG}|"_")* {
	int res,i;  /*upper case must be transformed to lower */
	echoo();
	if (yyleng > MAXIDLENGTH) 
		error(2);
	else {
		for (i=0;i<yyleng;i++)
			if (isupper(yytext[i]))
				yytext[i]=tolower(yytext[i]);
		strcpy(yylval.name, yytext);
		if ((res = search(yylval.name,keytab,NKEYS)) == -1)
			return IDENT;
		else
			return keytab[res].symb;
	}
}

{INT}           {
	char *maxint="32768";
	echoo();
	if (yyleng <= 5)
		if (yyleng == 5)
			if (strcmp(maxint,yytext) > 0) {
				strcpy(yylval.name,yytext);
				return INTCONST;
			} else {
				yylval.val = 0;
				error(3);
			}
		else {
			strcpy(yylval.name,yytext);
			return INTCONST;
		}
	else {
		yylval.val = 0;
		error(3);
	}
}

" "		{echoo();}
\t              {
	int noofblanks;
	noofblanks=8-(position%8); /*works only for default tab*/
	yytext[noofblanks+1]='\0';
	yyleng=noofblanks+1;
	for ( ;noofblanks>=0;noofblanks--)
		yytext[noofblanks]=' ';
	echoo();
}

\n		{
	echoo(); 
	if (err) {
		int i;
		for (i=0;i<errcount;i++)
			printf("\n*** error %d found at position %d", 
					errors[i].errnum,errors[i].pos);
	}
	position=1;
	errcount=0;
	err=0;
	lineno++;
}

.       {       /*illegal symbol*/	
	echoo();
	error(1);
	return OTHERSY;
}
%%

/*echoo() - echo linenumber and yytext*/
void echoo()
{
	if (position==1)
		printf("%5d :",lineno);
	printf("%s",yytext);
	position+=yyleng;
}

/*search - binary search after string "word" in "tab" */
int search (char *word, struct key *tab, int n)
{
	int low, high,mid,cond;
	low = 0;
	high = n-1;
	while (low <= high) {
		mid = (low+high) / 2;
		if ((cond=strcmp(word,tab[mid].keyw)) < 0)
			high = mid - 1;
		else if (cond > 0)
			low = mid+1;
		else
			return (mid);
	}  /* position for "word" in "tab" */
	return (-1);          /* not found */
}

/*error - handles syntax error*/
void error(int n)
{
	err=1;
	errors[errcount].pos=position-yyleng+1;
	errors[errcount].errnum=n;
	errcount++;
}

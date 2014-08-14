%{

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "lab.h"
extern int yylex();
extern int yyparse();
extern int yyerror(const char *msg);
int s = 0;
%}

%union {
	char name[32768];
	int val;
	struct {
		SYMBOL place;
		QUADLIST truelist, falselist;
	} exp;
	SYMBOL symblist[100];
	SYMBOL symb;
	
	struct {
		int adr;
		QUADLIST nxt;
	} qlist;

}
%token <name> BEGINSY DOSY ELSESY ENDSY FUNCSY IFSY INTSY READSY THENSY WHILESY WRITESY PROGSY OTHERSY REPEATSY
%token <name> IDENT INTCONST
%token PERIOD SEMI COMMA LPAREN RPAREN COLON
%token <val> RELOP ADDOP MULOP ASSIGN
%left ADDOP
%left MULOP
%left RELOP
%type <symb> pstart 
%type <exp> aexp expr fname fnhead
%type <symblist> exprlist arglist
%type <val> M 
%type <qlist> N
%start program
%%

program		: 	pstart dekllist fndekllist compstat PERIOD { emit(HALT, SNULL, SNULL, 0);
								     emit(FEND, $1, SNULL, 0); }
		;

pstart		:	PROGSY IDENT SEMI	{ $$ = insert($2, 1, 2); 
						  emit(FSTART, lookup($2), SNULL, 0); }
		;

dekllist 	: 	dekllist dekl
		|	dekl
		;

dekl		:	type idlist SEMI
		;

type		: 	INTSY
		;

idlist		:	idlist COMMA IDENT	{ insert($3, 1, 1); }
		|	IDENT			{ insert($1, 1, 1); }
		;

fndekllist	:	fndekllist fndekl
		|

fndekl		:	fnhead dekllist fndekllist compstat SEMI { emit(FEND, $1.place, SNULL, 0); }
		; 

fnhead		:	FUNCSY fname LPAREN parlist RPAREN COLON type SEMI { emit(FSTART, $2.place, SNULL, 0); 
									     $$.place = $2.place; } 
		;

parlist		:	dekllist
		|
		;

fname		:	IDENT	{ $$.place = insert($1, 1, 2); }
		;

compstat	:	BEGINSY statlist ENDSY
		;

statlist	:	statlist stat
		|	stat
		;

stat		:	compstat
		|	IFSY expr THENSY M stat N ELSESY M stat	{ backpatch($2.truelist, $4);
								  backpatch($2.falselist, $8);
								  backpatch($6.nxt, nextquad); }
		|	WHILESY M expr DOSY M stat 		{ backpatch($3.truelist, $5); 
								  emit(GOTO, SNULL, SNULL, $2);
								  backpatch($3.falselist, nextquad); }
/*		|	REPEATSY M stat N until M expr SEMI	{ backpatch($4.nxt, $6); 
								  backpatch($7.falselist, $2);
								  emit(GOTO, SNULL, SNULL, $2); }*/
		|	WRITESY LPAREN exprlist RPAREN SEMI	{ for(int i = 0; i <= s ; i++)
								  	emit(WRITE, $3[i], SNULL, 0);
								  s = 0; }
		|	READSY LPAREN exprlist RPAREN SEMI	{ for(int i = 0; i <= s ; i++)
								  	emit(READ, $3[i], SNULL, 0);
								  s = 0; }
		|	IDENT ASSIGN expr SEMI			{ if(lookup($1)->class == VAR)   
								      emit($2, lookup($1), $3.place, 0); 
								  if(lookup($1)->class == FUNC) 
								      emit(RETURN, $3.place, SNULL, 0); }
		|	fname ASSIGN expr SEMI			
		;

M 		:	{ $$ = nextquad; } 	
		;

N		:	{ emit(GOTO, SNULL, SNULL, -1);
			  $$.nxt = makelist(nextquad-1);
			  $$.adr = nextquad-1; }
		;


exprlist	:	exprlist COMMA expr	{ for(int i = 0 ; i < s ; i++)
							$$[i] = $1[i];
						  s++;
						  $$[s] = $3.place; }
		|	expr			{ $$[s] = $1.place; }
		;

expr		:	aexp RELOP aexp			{ $$.place = emit($2, $1.place, $3.place, 0);
							  $$.truelist = makelist(nextquad-1);
							  $$.falselist = makelist(nextquad);
							  emit(GOTO, SNULL, SNULL, -1); }
						
		|	aexp 				{ $$.place = $1.place; }
		;

aexp		:	aexp ADDOP aexp			{ $$.place = emit($2, $1.place, $3.place, 0); }
		|	aexp MULOP aexp			{ $$.place = emit($2, $1.place, $3.place, 0); }
		|	fname LPAREN arglist RPAREN	{ $$.place = emit(CALL, $1.place, SNULL, 0); }
		|	LPAREN expr RPAREN 		{ $$.place = $2.place;
							  $$.truelist = $2.truelist;
							  $$.falselist = $2.falselist; }
		|	IDENT				{ $$.place = lookup($1); }
		|	INTCONST			{ $$.place = insert($1, 1, 4); }
		;

arglist		:	exprlist	{ for(int i = 0 ; i <= s ; i++)
						emit(PARAM, $1[i], SNULL, 0);
					  s = 0; }
		|
		;
%%

int yyerror(const char *msg) {
	fprintf(stderr, "Error: %s\n", msg);
	return 0;
}

int main(void) {
	yyparse();
	printsymbtab();
	printmcode();
	return 0;
}

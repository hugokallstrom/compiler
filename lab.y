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

	/*struct {
		SYMBOL place;
		SYMBOL next;
	} explist;*/
	SYMBOL explist[100];
	SYMBOL symb;
}
%token <name> BEGINSY DOSY ELSESY ENDSY FUNCSY IFSY INTSY READSY THENSY WHILESY WRITESY PROGSY OTHERSY
%token <name> IDENT INTCONST
%token PERIOD SEMI COMMA LPAREN RPAREN COLON
%token <val> RELOP ADDOP MULOP ASSIGN
%left RELOP ADDOP MULOP
%type <exp> aexp expr
%type <explist> exprlist
%start program
%%

program		: 	PROGSY IDENT SEMI dekllist fndekllist compstat PERIOD
			{ /*emit($1, insert($2,1,2), SNULL, 0);*/ }
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

fndekl		:	fnhead dekllist fndekllist compstat SEMI 
		;

fnhead		:	FUNCSY fname LPAREN parlist RPAREN COLON type SEMI
		;

parlist		:	dekllist
		|
		;

fname		:	IDENT { insert($1, 1, 2); }
		;

compstat	:	BEGINSY statlist ENDSY
		;

statlist	:	statlist stat
		|	stat
		;

stat		:	compstat
		|	IFSY expr THENSY stat ELSESY stat	{}
		|	WHILESY expr DOSY stat
		|	WRITESY LPAREN exprlist RPAREN SEMI	{}
		|	READSY LPAREN exprlist RPAREN SEMI	{ /*emit($1, $3.place, SNULL, 0);*/
								  fprintf(stderr, "READ ID: %s NEXT: %s\n", $3[s--]->id, $3[s--]->id); }
		|	IDENT ASSIGN expr SEMI			{ emit($2, lookup($1), $3.place, 0); }
		|	fname ASSIGN expr SEMI
		;
	
exprlist	:	exprlist COMMA expr	{ $$[s] = $1[1];
						  $$[s++] = $3.place;fprintf(stderr, "s=%d\n", s);} 
		|	expr	{ $$[s++] = $1.place;fprintf(stderr, "s=%d\n", s); }
		;

expr		:	aexp RELOP aexp
		|	aexp { $$.place = $1.place; }
		;

aexp		:	aexp ADDOP aexp	{ $$.place = emit($2, $1.place, $3.place, 0); }
		|	aexp MULOP aexp	{ $$.place = emit($2, $1.place, $3.place, 0); }
		|	fname LPAREN arglist RPAREN
		|	LPAREN expr RPAREN { $$.place = $2.place; }
		|	IDENT		{ $$.place = lookup($1); }
		|	INTCONST	{ $$.place = insert($1, 1, 4); }
		;

arglist		:	exprlist
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
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
}
%token <name> BEGINSY DOSY ELSESY ENDSY FUNCSY IFSY INTSY READSY THENSY WHILESY WRITESY PROGSY OTHERSY
%token <name> IDENT INTCONST
%token PERIOD SEMI COMMA LPAREN RPAREN COLON
%token <val> RELOP ADDOP MULOP ASSIGN
%left ADDOP
%left MULOP
%left RELOP
%type <exp> aexp expr fname
%type <symblist> exprlist arglist
%start program
%%

program		: 	PROGSY IDENT SEMI dekllist fndekllist compstat PERIOD
			{ makelist(0);
			  insert($2,1,2); }
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

fname		:	IDENT { $$.place = insert($1, 1, 2); }
		;

compstat	:	BEGINSY statlist ENDSY
		;

statlist	:	statlist stat
		|	stat
		;

stat		:	compstat
		|	IFSY expr THENSY stat ELSESY stat	{ }
		|	WHILESY expr DOSY stat			{ }
		|	WRITESY LPAREN exprlist RPAREN SEMI	{ for(int i = 0; i <= s ; i++)
								  	emit(WRITE, $3[i], SNULL, 0);
								  s = 0; }
		|	READSY LPAREN exprlist RPAREN SEMI	{ for(int i = 0; i <= s ; i++)
								  	emit(READ, $3[i], SNULL, 0);
								  s = 0; }
		|	IDENT ASSIGN expr SEMI			{ emit($2, lookup($1), $3.place, 0); }
		|	fname ASSIGN expr SEMI			{ emit($2, $1.place, $3.place, 0); }
		;
	
exprlist	:	exprlist COMMA expr	{ for(int i = 0 ; i < s ; i++)
							$$[i] = $1[i];
						  s++;
						  $$[s] = $3.place; }
		|	expr			{ $$[s] = $1.place; }
		;

expr		:	aexp RELOP aexp			{ $$.place = emit($2, $1.place, $3.place, 0); }
		|	aexp 				{ $$.place = $1.place; }
		;

aexp		:	aexp ADDOP aexp			{ $$.place = emit($2, $1.place, $3.place, 0); }
		|	aexp MULOP aexp			{ $$.place = emit($2, $1.place, $3.place, 0); }
		|	fname LPAREN arglist RPAREN	{ $$.place = emit(CALL, $1.place, SNULL, 0); }
		|	LPAREN expr RPAREN 		{ $$.place = $2.place; }
		|	IDENT				{ $$.place = lookup($1); }
		|	INTCONST			{ $$.place = insert($1, 1, 4); }
		;

arglist		:	exprlist	{ for(int i = 0 ; i <= s ; i++)
						emit(PARAM, $1[i], SNULL, 0);
					  s = 0; }
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
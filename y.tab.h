/* A Bison parser, made by GNU Bison 2.5.  */

/* Bison interface for Yacc-like parsers in C
   
      Copyright (C) 1984, 1989-1990, 2000-2011 Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     BEGINSY = 258,
     DOSY = 259,
     ELSESY = 260,
     ENDSY = 261,
     FUNCSY = 262,
     IFSY = 263,
     INTSY = 264,
     READSY = 265,
     THENSY = 266,
     WHILESY = 267,
     WRITESY = 268,
     PROGSY = 269,
     OTHERSY = 270,
     REPEATSY = 271,
     UNTILSY = 272,
     IDENT = 273,
     INTCONST = 274,
     PERIOD = 275,
     SEMI = 276,
     COMMA = 277,
     LPAREN = 278,
     RPAREN = 279,
     COLON = 280,
     RELOP = 281,
     ADDOP = 282,
     MULOP = 283,
     ASSIGN = 284
   };
#endif
/* Tokens.  */
#define BEGINSY 258
#define DOSY 259
#define ELSESY 260
#define ENDSY 261
#define FUNCSY 262
#define IFSY 263
#define INTSY 264
#define READSY 265
#define THENSY 266
#define WHILESY 267
#define WRITESY 268
#define PROGSY 269
#define OTHERSY 270
#define REPEATSY 271
#define UNTILSY 272
#define IDENT 273
#define INTCONST 274
#define PERIOD 275
#define SEMI 276
#define COMMA 277
#define LPAREN 278
#define RPAREN 279
#define COLON 280
#define RELOP 281
#define ADDOP 282
#define MULOP 283
#define ASSIGN 284




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 2068 of yacc.c  */
#line 20 "lab.y"

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




/* Line 2068 of yacc.c  */
#line 127 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;



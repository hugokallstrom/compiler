/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

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

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
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
    IDENT = 271,
    INTCONST = 272,
    PERIOD = 273,
    SEMI = 274,
    COMMA = 275,
    LPAREN = 276,
    RPAREN = 277,
    COLON = 278,
    RELOP = 279,
    ADDOP = 280,
    MULOP = 281,
    ASSIGN = 282
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
#define IDENT 271
#define INTCONST 272
#define PERIOD 273
#define SEMI 274
#define COMMA 275
#define LPAREN 276
#define RPAREN 277
#define COLON 278
#define RELOP 279
#define ADDOP 280
#define MULOP 281
#define ASSIGN 282

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 18 "lab.y" /* yacc.c:1909  */

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


#line 125 "y.tab.h" /* yacc.c:1909  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */

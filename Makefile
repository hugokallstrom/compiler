CC		=	gcc
OBJS	=	y.tab.o table.o lex.yy.o
CFLAGS	=	-Wall -pedantic -g -std=c99
YACC	=	yacc -d
LEX		=	lex

lab2: $(OBJS)
	$(CC) $(CFLAGS) -o $(@) $(OBJS) -ll

y.tab.o: y.tab.c
	$(CC) $(CFLAGS) -c $(<)

table.o: lab.h table.c
	$(CC) $(CFLAGS) -c table.c

y.tab.c: lab.h lab.y
	$(YACC) lab.y

lex.yy.o: lab.l y.tab.h
	$(LEX) lab.l
	$(CC) -c lex.yy.c

clean:
	/bin/rm -f $(OBJS) lex.yy.c y.tab.[ch]

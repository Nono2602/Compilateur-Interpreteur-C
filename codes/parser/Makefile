all: parser

parser: lex.yy.c y.tab.c table_symboles.c table_funs.c y.tab.h table_symboles.h table_funs.h
	gcc lex.yy.c y.tab.c table_symboles.c table_funs.c -ll -o parser

lex.yy.c: y.tab.h parser.l
	flex parser.l

y.tab.c y.tab.h: parser.y
	yacc -dv parser.y
clean:
	rm -rf lex.yy.c y.tab.c y.tab.h parser y.output

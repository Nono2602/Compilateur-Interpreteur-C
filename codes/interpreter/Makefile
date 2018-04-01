all: interpreter

interpreter: lex.yy.c y.tab.c y.tab.h
	gcc lex.yy.c y.tab.c -ll -o interpreter

lex.yy.c: y.tab.h interpreter.l
	flex interpreter.l

y.tab.c y.tab.h: interpreter.y
	yacc -dv interpreter.y

clean:
	rm -rf lex.yy.c y.tab.c y.tab.h parser y.output

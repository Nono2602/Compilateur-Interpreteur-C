all:
	make -C parser
	make -C interpreter

tests: all
	./parser/parser < tests/test_06.c
	./interpreter/interpreter < out

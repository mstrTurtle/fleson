all:
	flex --outfile=tm_yylex.yy.cc tm_yylex.l
	bison -d -v tm_parser.yy
clean:
	rm -f tm_parser.output tm_parser.tab.cc tm_parser.tab.hh
	rm -f tm_yylex.yy.cc position.hh stack.hh location.hh
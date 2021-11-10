all:
	$(MAKE) -C $(SRCDIR)
	$(CXX) $(CXXFLAGS) -c $(SRCDIR)/main.cpp 			-o 		$(OBJDIR)/main.o		$(CXXSTD)
	$(CXX) $(CXXFLAGS) -c $(SRCDIR)/tm_yylex.yy.cc 		-o 		$(OBJDIR)/tm_yylex.o	$(CXXSTD)
	$(CXX) $(CXXFLAGS) -c $(SRCDIR)/tm_parser.tab.cc	-o 		$(OBJDIR)/tm_parser.o	$(CXXSTD)
	$(CXX) $(CXXFLAGS) -c $(SRCDIR)/tm_driver.cpp 		-o 		$(OBJDIR)/tm_driver.o	$(CXXSTD)
clean:
	rm -f main.o tm_driver.o tm_parser.o tm_yylex.o
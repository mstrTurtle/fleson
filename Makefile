CXX = g++
CXXFLAGS = -g -O -Wall

TOPDIR := $(PWD)
SRCDIR := $(TOPDIR)/src
OBJDIR := $(TOPDIR)/obj
BINDIR := $(TOPDIR)/bin
BIN := $(BINDIR)/main
SRC := $(wildcard $(SRCDIR)/*.cpp)
OBJS := fish.o main.o

CXXSTD := --std=c++11

export CXX CXXFLAGS CXXSTD OBJS SRCDIR OBJDIR

all:$(BIN)

$(BIN):CHECKDIR $(OBJDIR)
	$(CXX) $(OBJDIR)/*.o -o $(BIN)
CHECKDIR:
	mkdir -p $(BINDIR) $(OBJDIR)
$(OBJDIR):RUN
	$(MAKE) -C $(OBJDIR)

RUN:

clean:
	rm -rf $(OBJDIR)/*.o $(BINDIR)
	$(MAKE) -C $(SRCDIR) clean
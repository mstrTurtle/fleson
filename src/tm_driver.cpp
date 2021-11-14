#include "tm_driver.h"

#include <cctype>
#include <fstream>
#include <cassert>



using namespace turtle;

Driver::~Driver() {
   delete lexer;
   lexer = nullptr;
   delete parser;
   parser = nullptr;
}

void Driver::parse(const char * const fname) {
   assert(fname != nullptr);
   parse_helper(std::ifstream{fname});
}

void Driver::parse(std::istream &stream) {
   parse_helper(std::move(stream));
}

void Driver::parse_helper(std::istream &&is) {
    delete lexer;
    lexer = new Lexer(&is);

    delete parser;
    parser = new Parser(*lexer,*this);

    parser->parse();
}

void Driver::add_word(const std::string& word) {n_word++;}

std::ostream& Driver::print_info( std::ostream &stream ) {
   stream << red  << "QUAD CODE: " << "\n";
   int count = 0;
   for(auto q:code.v_){
      stream << blue << "(" << count++ << ") ";
      stream << norm << q->gen_quad() << "\n";
   }
   return(stream);
}

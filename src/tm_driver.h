#pragma once

#include <string>
#include <cstddef>
#include <istream>


#include "quad.h"
#include "var.h"

#include "tm_lexer.h"
#include "tm_parser.tab.hh"

namespace turtle{

class Driver{
public:
   Driver() = default;

   virtual ~Driver();

   void parse(const char * const fname);
   void parse(std::istream &is);

   void add_word(const std::string &word);

   std::ostream& print_info(std::ostream &stream);

   turtle::quad_slice code;
   turtle::var_slice vars;
   turtle::var_gener new_temp;

   string next_instr(){return to_string(code.v_.size());}
private:
   void parse_helper(std::istream &&stream);

   turtle::Parser  *parser  = nullptr;
   turtle::Lexer   *lexer   = nullptr;

   std::size_t     n_word   = 0;

   const std::string red    = "\033[1;31m";
   const std::string blue   = "\033[1;36m";
   const std::string norm   = "\033[0m";
};

} // end namespace turtle

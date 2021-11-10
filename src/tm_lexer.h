#pragma once

#if ! defined(yyFlexLexerOnce)
#include <FlexLexer.h>
#endif
// class yyFlexLexer{
//    yyFlexLexer(std::istream* a);
// };

#include "tm_parser.tab.hh"
#include "location.hh"

namespace turtle{

class Lexer : public yyFlexLexer{
public:

   Lexer(std::istream *is) : yyFlexLexer(is) {}

   virtual ~Lexer() {}

   // get rid of override virtual function warning
   using FlexLexer::yylex;

   virtual int yylex( turtle::Parser::semantic_type * const lval,
              turtle::Parser::location_type *location );
   // YY_DECL defined in tm_yylex.l
   // Method body created by flex in tm_yylex.yy.cc


private:
   /* yyval ptr */
   turtle::Parser::semantic_type *yylval = nullptr;
};

} // end namespace turtle

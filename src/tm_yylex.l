%{
#include <string>

#include "tm_lexer.h"
// 这里有个Lexer类，继承自yyFlexScanner，里面有个yylex方法

#undef  YY_DECL
#define YY_DECL int turtle::Lexer::yylex( turtle::Parser::semantic_type * const lval, turtle::Parser::location_type *loc )
// 请注意，这个yylex带两个参数。
// 事实上，这个YY_DECL的涵义就是yylex函数的函数签名。它默认是int yyFlexScanner::yylex()，通过YY_DECL定义的。
// 而在这里，把它函数签名改一下；在上面那个Scanner类里已经有个相同的签名，我们就可以指定flex那个yylex函数的函数签名，
// 等flex生成好后，就可以把它和tm_lexer.hpp里的东西组装起来。
//
// 请注意，那两个参数（lval和loc）都是有用的。因为函数体内有 yylval = lval 以及本文件下面自己那个 YY_USER_ACTION
using token = turtle::Parser::token;

#define YY_NO_UNISTD_H
// msvc2010必须把这个头文件排除在外

#define YY_USER_ACTION loc->step(); loc->columns(yyleng);
// 这是匹配的时候触发的。更新location。

#define yyterminate() return( token::END )
// 不然会返回一个NULL


%}

%option debug
%option nodefault
%option yyclass="turtle::Lexer"
/*在这里，这个鬼yyclass好像没什么用（作用就是define YY_DECL，但函数名还是那个yylex，也无参数。*/
/*事实上上面已经define过一次了，而且参数也偷摸换成了两个（很难说这不是个trick）*/
%option noyywrap
%option c++
 
%%

%{          /** Code executed at the beginning of yylex **/
            yylval = lval;
%}

[a-zA-Z]+   {
               yylval->build<std::string>( yytext );
               return( token::WORD );
            }


\n          {
               loc->lines(); // Update line number
            }

.           {  return( token::CHAR );
            }
%%

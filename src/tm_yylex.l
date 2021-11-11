%{
   #include <string>

   #include "tm_lexer.h"
   // 这里有个Lexer类，继承自yyFlexScanner，里面有个yylex方法

   #undef  YY_DECL
   #define YY_DECL int turtle::Lexer::yylex( turtle::Parser::semantic_type * const lval, turtle::Parser::location_type *loc )
   // 【适配Bison的关键代码，不要修改】
   // 请注意，这个yylex带两个参数。
   // 事实上，这个YY_DECL的涵义就是yylex函数的函数签名。它默认是int yyFlexScanner::yylex()，通过YY_DECL定义的。
   // 而在这里，把它函数签名改一下；在上面那个Scanner类里已经有个相同的签名，我们就可以指定flex那个yylex函数的函数签名，
   // 等flex生成好后，就可以把它和tm_lexer.hpp里的东西组装起来。
   //
   // 请注意，那两个参数（lval和loc）都是有用的。因为函数体内有 yylval = lval 以及本文件下面自己那个 YY_USER_ACTION
   using token = turtle::Parser::token;
   // 这个using，好像可以免去#include "tm_parser.tab.hh"

   #define YY_NO_UNISTD_H
   // 为了兼容msvc，必须把这个头文件排除在外（这是linux的头文件）

   #define YY_USER_ACTION loc->step(); loc->columns(yyleng);
   // 【适配Bison的关键代码，不要修改】
   // 匹配成功时触发。更新location。

   #define yyterminate() return( token::FILE_END )
   // 不然默认会返回一个NULL


%}

%option debug
%option nodefault
/*貌似是把默认的错误报告关了（即识别到意料之外的东西），而是把错误写进yytext里面*/
%option yyclass="turtle::Lexer"
/*在这里，这个鬼yyclass实际上没什么用                                             */
/*它的效果是先在前面添加一个int yyFlexLexer::yylex()的实现（作用是提醒你别调用它）*/
/*然后define YY_DECL为turtle::Lexer::yylex()，后面yylex的函数签名就会被换掉      */
/*但如果删去此行，则编不过。因为这个默认的yyFlexLexer::yylex()没了               */
/*事实上上面已经define过一次了，而且参数也偷摸换成了两个（很难说这不是个trick）  */
%option noyywrap
%option c++

letter      [A-Za-z]
digit       [0-9]
identifier  {letter}({letter}|{digit})*
integer     {digit}+
blank       [\t ]
const_char  '[^\']*'

%%

%{          /** 这段代码被放在yylex函数体最前面 **/
            yylval = lval;
            // 【适配Bison的关键代码，不要修改】
%}



and {return token::AND;}
array {return token::ARRAY;}
begin {return token::BEGIN_token;}
bool {return token::BOOL;}
call {return token::CALL;}
case {return token::CASE;}
char {return token::CHAR;}
constant {return token::CONSTANT;}
dim {return token::DIM;}
do {return token::DO;}
else {return token::ELSE;}
end {return token::END;}
false {return token::FALSE;}
for {return token::FOR;}
if {return token::IF;}
input {return token::INPUT;}
integer {return token::INTEGER;}
not {return token::NOT;}
of {return token::OF;}
or {return token::OR;}
output {return token::OUTPUT;}
procedure {return token::PROCEDURE;}
program {return token::PROGRAM;}
read {return token::READ;}
real {return token::REAL;}
repeat {return token::REPEAT;}
set {return token::SET;}
stop {return token::STOP;}
then {return token::THEN;}
to {return token::TO;}
true {return token::TRUE;}
until {return token::UNTIL;}
var {return token::VAR;}
while {return token::WHILE;}
write {return token::WRITE;}

\( {return token::L_BRACKET;}
\) {return token::R_BRACKET;}
\* {return token::STAR;}
\*\/ {return token::R_COMMENT;}
\+ {return token::PLUS;}
\, {return token::COMMA;}
\- {return token::MINUS;}
\. {return token::DOT;}
".." {return token::DOUBLE_DOT;}
"/" {return token::SLASH;}
"/*" {return token::L_COMMENT;}
":" {return token::COLON;}
":=" {return token::ASSIGN;}
";" {return token::SEMICOLON;}
"<" {return token::LT;}
"<=" {return token::LE;}
"<>" {return token::NE;}
"=" {return token::EQ;}
">" {return token::GT;}
">=" {return token::GE;}
"[" {return token::L_INDEX;}
"]" {return token::R_INDEX;}

{identifier}    {yylval->build<std::string>( yytext );return token::ID;}
{integer}       {yylval->build<std::string>( yytext );return token::NUM;}
{const_char}    {yylval->build<std::string>( yytext );return token::CONST_CHAR;}
{blank}         {}
\n              {loc->lines();}
.               { }



%%

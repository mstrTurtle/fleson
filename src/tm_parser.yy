%skeleton "lalr1.cc"
%require  "3.0"
%debug
%defines
%define api.namespace {turtle}
%define api.parser.class {Parser}
// 经过这两通定义，现在bison生成的类变成了turtle::Parser

%code requires{
// 请注意这里是前插代码段

  namespace turtle {
      class Driver;
      class Lexer;
  }
  // 手动对 MC_Driver 和 MC_Scanner进行前置声明

  // The following definitions is missing when %locations isn't used
  # ifndef YY_NULLPTR
  #  if defined __cplusplus && 201103L <= __cplusplus
  #   define YY_NULLPTR nullptr
  #  else
  #   define YY_NULLPTR 0
  #  endif
  # endif

}



%parse-param { Lexer   &lexer   }
%parse-param { Driver  &driver  }

// 这个parse-param的用处在于，给那个生成的Parse类添加数据成员（具体体现在类的构造函数多了两个新参数，类似于
// lexer_arg，数据成员多了个lexer，然后构造的时候直接值初始化）

%code{
  #include <iostream>
  #include <cstdlib>
  #include <fstream>

  #include "tm_driver.h"

  #undef yylex
  #define yylex lexer.yylex
  // 请注意，此处把yylex换成了它数据成员 Lexer &lexer 中的方法yylex。这是因为在flex里已经指定过了，
  // 那个yylex签名是Lexer::yylex
}

%define api.value.type variant
%define parse.assert

%token               FILE_END    0     "end of file"
%token <std::string> ID
%token <std::string> NUM
%token <std::string> CONST_CHAR


%token AND
%token ARRAY
%token BEGIN_token
%token BOOL
%token CALL
%token CASE
%token CHAR
%token CONSTANT
%token DIM
%token DO
%token ELSE
%token END
%token FALSE
%token FOR
%token IF
%token INPUT
%token INTEGER
%token NOT
%token OF
%token OR
%token OUTPUT
%token PROCEDURE
%token PROGRAM
%token READ
%token REAL
%token REPEAT
%token SET
%token STOP
%token THEN
%token TO
%token TRUE
%token UNTIL
%token VAR
%token WHILE
%token WRITE
%token L_BRACKET
%token R_BRACKET
%token STAR
%token R_COMMENT
%token PLUS
%token COMMA
%token MINUS
%token DOT
%token DOUBLE_DOT
%token SLASH
%token L_COMMENT
%token COLON
%token ASSIGN
%token SEMICOLON
%token LT
%token LE
%token NE
%token EQ
%token GT
%token GE
%token L_INDEX
%token R_INDEX


%locations

%%

list_option : FILE_END | list FILE_END;

list
  : item
  | list item
  ;

item
  :  ID    { /*driver.add_word( $1 );*/ std::cout << "ID: " << $1 << std::endl;}
  ;

%%


void turtle::Parser::error( const location_type &l, const std::string &err_message )
{
   std::cerr << "Error: " << err_message << " at " << l << "\n";
}

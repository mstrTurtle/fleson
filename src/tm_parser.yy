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

  #include "type_node.h"

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

  #include "type_node.h"

  #include "tm_driver.h"

  #undef yylex
  #define yylex lexer.yylex
  // 请注意，此处把yylex换成了它数据成员 Lexer &lexer 中的方法yylex。这是因为在flex里已经指定过了，
  // 那个yylex签名是Lexer::yylex
  #define GEN(e1,e2,e3,e4) driver.code.add(MAKE_QUAD(e1,e2,e3,e4))
}

%define api.value.type variant
%define parse.assert

%token               FILE_END    0     "end of file"
%token <std::string> ID
%token <std::string> NUM
%token <std::string> CHAR_LITERAL


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

%token SINGLE_QUOT_MARK;

%nterm <bool_node> bool_expr
%nterm <bool_node> bool_term
%nterm <bool_node> bool_factor
%nterm <bool_node> bool_value
%nterm <M_node> M
%nterm <bool_literal_node> bool_literal
%nterm <relation_node> relation_symbol
%nterm <stmt_node> stmt
%nterm <stmt_node> stmts
%nterm <stmt_node> sub_stmts
%nterm <stmt_node> assign_sentence
%nterm <stmt_node> if_sentence
%nterm <stmt_node> while_sentence
%nterm <stmt_node> repeat_sentence
%nterm <stmt_node> comb_sentence
%nterm <stmt_node> N
%nterm <math_expr_node> math_expr
%nterm <math_expr_node> term
%nterm <math_expr_node> factor
%nterm <math_expr_node> math_value
%nterm <type_node> type
%nterm <type_node> var_def
%nterm <ID_node> ids


%locations

%%

all : FILE_END | program FILE_END ;

program
  : PROGRAM PROG_ID SEMICOLON var_stmt comb_sentence M DOT {
    GEN("sys","","","");
    $5.patch_next($6.instr);
  }
  ;

PROG_ID
  : ID{
    GEN("program",$1,"","");
  }
  ;

var_stmt : VAR var_def | ;

var_def
  : var_def ids COLON type SEMICOLON {
    $2.patch_type($4.name);
  }
  | ids COLON type SEMICOLON {
    $1.patch_type($3.name);
  }
  ;

ids
  : ids COMMA ID {
    assert(!driver.vars.has($3));
    auto v = MAKE_VAR($3,"");
    driver.vars.add(v);
    $$.type_list.add(v);
  }
  | ID {
    assert(!driver.vars.has($1));
    auto v = MAKE_VAR($1,"");
    driver.vars.add(v);
    $$.type_list.add(v);
  }
  ;

stmt : assign_sentence {} | if_sentence | while_sentence | repeat_sentence | comb_sentence ;

assign_sentence
  : ID ASSIGN math_expr {
    assert(driver.vars.has($1));
    GEN(":=",$3.var,"",$1);
  }
  ;

if_sentence
  :  IF bool_expr THEN M stmt N ELSE M stmt {
    $2.patch_true($4.instr);
    $2.patch_false($8.instr);
    $$.next_list.append($6.next_list);
    $$.next_list.append($9.next_list);
  }
  ;

while_sentence
  : WHILE M bool_expr DO M stmt {
    $3.patch_true($5.instr);
    $$.next_list.append($3.false_list);
    $6.patch_next($2.instr);
    GEN("j","","",$2.instr);
  }
  ;

repeat_sentence
  : REPEAT M stmt UNTIL M bool_expr {
    $$.next_list.append($6.true_list);
    $3.patch_next($5.instr);
    $6.patch_false($2.instr);
  }
  ;

comb_sentence
  : BEGIN_token stmts END {
    $$.next_list.append($2.next_list);
  }
  ;

N
  : {
    $$.next_list.add(GEN("j","","",""));
  }
  ;

stmts
  : sub_stmts M stmt {
    $1.patch_next($2.instr);
    $$.next_list.append($3.next_list);
  }
  ;

sub_stmts
  : sub_stmts M stmt SEMICOLON {
    $1.patch_next($2.instr);
    $$.next_list.append($3.next_list);
  }
  | stmt SEMICOLON {
    $$.next_list.append($1.next_list);
  }
  ;

type :
  INTEGER {$$.name = "INTEGER";}
  | BOOL {$$.name = "BOOL";}
  | CHAR {$$.name = "CHAR";}
  ;

bool_literal
  : TRUE {
    $$.value = "true";
  }
  | FALSE {
    $$.value = "false";
  }
  ;

math_expr
  : math_expr PLUS term {
    auto t = driver.new_temp();
    GEN("+",$1.var,$3.var,t);
    $$.var = t;
  }
  | math_expr MINUS term {
    auto t = driver.new_temp();
    GEN("-",$1.var,$3.var,t);
    $$.var = t;
  }
  | term {
    $$.var = $1.var;
  }
  ;

term
  : term STAR factor {
    auto t = driver.new_temp();
    GEN("*",$1.var,$3.var,t);
    $$.var = t;
  }
  | term SLASH factor {
    auto t = driver.new_temp();
    GEN("/",$1.var,$3.var,t);
    $$.var = t;
  }
  | factor {
    $$.var = $1.var;
  }
  ;

factor
  : math_value {
    $$.var = $1.var;
  }
  | MINUS factor {
    auto t = driver.new_temp();
    GEN("-",$2.var,"",t);
    $$.var = t;
  }
  ;

math_value
  : NUM {
    $$.var = $1;
  }
  | ID {
    assert(driver.vars.has($1));
    $$.var = $1;
  }
  | L_BRACKET math_expr R_BRACKET {
    $$.var = $2.var;
  }
  ;

bool_expr
  : bool_expr OR M bool_term {
    $$.true_list.append($1.true_list);
    $$.true_list.append($4.true_list);
    $1.patch_false($3.instr);
    $$.false_list.append($4.false_list);
  }
  | bool_term {
    $$.true_list.append($1.true_list);
    $$.false_list.append($1.false_list);
  }
  ;

bool_term
  : bool_term AND M bool_factor {
    $$.false_list.append($1.false_list);
    $$.false_list.append($4.false_list);
    $1.patch_true($3.instr);
    $$.true_list.append($4.true_list);
  }
  | bool_factor {
    $$.true_list.append($1.true_list);
    $$.false_list.append($1.false_list);
  }
  ;

bool_factor
  : bool_value {
    $$.true_list.append($1.true_list);
    $$.false_list.append($1.false_list);
  }
  | NOT bool_factor {
    $$.true_list.append($2.false_list);
    $$.false_list.append($2.true_list);
  }
  ;

bool_value
  : bool_literal {
    if( $1.value == "true" ){
      $$.true_list.add(GEN("j","","",""));
    } else {
      $$.false_list.add(GEN("j","","",""));
    }
  }
  | ID {
    if( $1 == "true" ){
      $$.true_list.add(GEN("j","","",""));
    } else {
      $$.false_list.add(GEN("j","","",""));
    }
  }
  | L_BRACKET bool_expr R_BRACKET {
    $$.true_list.append($2.true_list);
    $$.false_list.append($2.false_list);
  }
  | math_expr relation_symbol math_expr {
    $$.true_list.add(GEN($2.j_comm,$1.var,$3.var,""));
    $$.false_list.add(GEN("j","","",""));
  }
  ;

M : {
    $$.instr = driver.next_instr();
  }
  ;
relation_symbol
  : LT {$$.j_comm = "j<";}
  | NE {$$.j_comm = "j!=";}
  | LE {$$.j_comm = "j<=";}
  | GE {$$.j_comm = "j>=";}
  | GT {$$.j_comm = "j>";}
  | EQ {$$.j_comm = "j=";}
  ;




%%


void turtle::Parser::error( const location_type &l, const std::string &err_message )
{
   std::cerr << "Error: " << err_message << " at " << l << "\n";
}

// useless
// singleword : PLUS | MINUS | STAR | SLASH | EQ | LT | GT | L_BRACKET | R_BRACKET | L_INDEX | R_INDEX | COLON | DOT | SEMICOLON | COMMA | SINGLE_QUOT_MARK ;

// expr : math_expr | bool_expr | char_expr ;

// char_expr : CHAR_LITERAL | ID ;

// wordset : keyword | doubleword | ID | literal | singleword ;

// keyword : AND | ARRAY | BEGIN_token | BOOL | CALL | CASE | CHAR | CONSTANT | DIM | DO | ELSE | END | FALSE | FOR | IF | INPUT | INTEGER | NOT | OF | OR | OUTPUT | PROCEDURE | PROGRAM | READ | REAL | REPEAT | SET | STOP | THEN | TO | TRUE | UNTIL | VAR | WHILE | WRITE ;

// doubleword : NE | LE | GE | ASSIGN | L_COMMENT | R_COMMENT | DOUBLE_DOT ;

// literal : NUM | bool_literal | CHAR_LITERAL ;

// stmts
//   : stmts M stmt SEMICOLON {
//     $1.patch_next($2.instr);
//     $$.next_list.append($3.next_list);
//   }
//   | stmt SEMICOLON {
//     $$.next_list.append($1.next_list);
//   }
//   ;
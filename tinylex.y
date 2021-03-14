%{
#include <stdlib.h>
void yyerror(char *);
#include "y.tab.h"
%}

/* Keywords */   
%token IF 
%token ELSE
%token WHILE   
%token CHAR
%token INT
%token FLOAT
%token RETURN
%token VOID

/* Boolean operators */
%token AND
%token OR


/* Pairs of tokens */
%token LBRACE   /* { */
%token RBRACE   /* } */    
%token LPAR     /* ( */
%token RPAR     /* ) */

/* Basic separators */
%token SEMICOLON
%token COMMA

/* Math operators */
%token PLUS
%token MINUS
%token MULTIPLY
%token DIVIDE

/* Equality and difference */
%token ASSIGNMENT  /* = */
%token EQUAL   /* == */
%token NOT_EQUAL  /* != */

/* Logical operators */
%token GT  /* > */
%token LT     /* < */
%token GTE     /* >= */
%token LTE     /* <= */

%token PTR /* & */

%% 

primary_exp: IDENTIFIER
	| constant
	| STRING_LITERAL
	| '(' expression ')'
	{printf("Primary Expression\n");}
	;

constant: INT_CONST
	| FLOAT_CONST
	| STRING_CONSTANT
	| CHAR_CONST;

func_arglist: PTR IDENTIFIER
	| exp
	| exp ',' func_arglist
	{printf("FunctionArgList\n");}
	;

func_call: INDENTIFIER LTPAR func_arglist RTPAR
	| IDENTIFIER LTPAR RTPAR
	{printf("Function Call\n");}
	;

unary_exp: primary_exp 
	| PLUS unary_exp
	| MINUS unary_exp
	{printf("Unary Expression\n");}
	;

mult_exp: unary_exp
	| mult_exp MULTIPLY unary_exp
	| mult_exp DIVIDE unary_exp
	{printf("Multiplicative Expression\n");}
	;

add_exp: mult_exp
	| add_exp PLUS add_exp
	| add_exp MINUS add_exp
	{printf("Additive Expression\n");}
	;

comp_exp: add_exp
	| add_exp LT add_exp
	| add_exp LTE add_exp
	| add_exp GT add_exp
	| add_exp GTE add_exp
	{printf("Comparison Expression\n");}
	;

exp: comp_exp
	| comp_exp EQUAL comp_exp
	| comp_exp NOT_EQUAL comp_exp
	{printf("Expression\n");}
	;

/* statements */

assign_st: INDENTIFIER ASSIGNMENT exp SEMICOLON
	{printf("Assignment Statement\n");}
	;

if_st: IF LTPAR exp RTPAR st
	| IF LTPAR exp RTPAR st ELSE st
	{printf("If Statement\n");}
	;

while_st: WHILE RTPAR exp LTPAR st
	{printf("While Statement\n");}
	;

ret_st: RETURN SEMICOLON
	| RETURN exp SEMICOLON
	{printf("Return Statement\n");}
	;

st_list: /* epsilon */ 
	| st st_list
	{printf("Statement List\n");}
	;

block_st: LTBRACE st_list RTBRACE
	{printf("Block Statement\n");}
	;

empty_st: SEMICOLON
	{printf("EMPTY STATEMENT\n");}
	;

st: assign_st
	| if_st
	| while_st
	| ret_st
	| block_st
	| empty_st
	{printf("Statement\n");}
	;

/* functions */

return_type: VOID
	| TYPE 
	{printf("Return Type\n");}
	;

func_param: TYPE IDENTIFIER
	{printf("Function Parameter\n");}
	;

func_paramlist: func_param
	| func_param ',' func_param
	{printf("Function Parameter List\n");}
	;

var_def: TYPE IDENTIFIER EQUAL constant SEMICOLON
	{printf("Variable Definition\n");}
	;

var_deflist: /* epsilon */
	| var_def var_deflist
	{printf("Variable Definition List\n");}
	;

func_stlist: ret_st
	| st func_stlist
	{printf("Function Statement List\n");}
	;

func_body: var_deflist func_stlist
	{printf("Function Body\n");}
	;

func_def: return_type IDENTIFIER LTPAR func_paramlist RTPAR LTBRACE func_body RTBRACE
	| return_type IDENTIFIER LTPAR VOID RTPAR LTBRACE func_body RTBRACE
	{printf("Function Definition\n");}
	;

/* programs */

func_deflist: /* epsilon */
	| func_def func_deflist
	{printf("Function Definition List\n");}
	;

main: INT 'main' LTPAR VOID RTPAR LTBRACE func_body RTBRACE
	{printf("Main\n");}
	;

program: func_deflist main func_deflist
	{printf("Program\n");}
	;


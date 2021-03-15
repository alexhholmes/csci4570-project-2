%{
#include <stdlib.h>
#include <stdio.h>
#include "tinylex.tab.h"

extern int yylex();
extern void yyerror(char *s);
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
%token MAIN

/* Pairs of tokens */
%token LTPAR     /* ( */
%token RTPAR     /* ) */
%token LTBRACE   /* { */
%token RTBRACE   /* } */    

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

%token IDENTIFIER
%token CHAR_CONST
%token INT_CONST
%token FLOAT_CONST
%token STRING_CONST

%union {
	char* charArray;
	int intValue;
	char charValue;
	float floatValue;
	char* stringValue;
}

%% 

program: func_deflist main func_deflist
	;

primary_exp: IDENTIFIER
	| constant
	| func_call
	| LTPAR exp RTPAR
	;

constant: INT_CONST
	| FLOAT_CONST
	| STRING_CONST
	| CHAR_CONST;

type: INT
	| FLOAT
	| CHAR
	| VOID

func_arglist: PTR IDENTIFIER
	| exp
	| exp COMMA func_arglist
	;

func_call: IDENTIFIER LTPAR func_arglist RTPAR
	| IDENTIFIER LTPAR RTPAR
	;

unary_exp: primary_exp 
	| PLUS unary_exp
	| MINUS unary_exp
	;

mult_exp: unary_exp
	| mult_exp MULTIPLY unary_exp
	| mult_exp DIVIDE unary_exp
	;

add_exp: mult_exp
	| add_exp PLUS add_exp
	| add_exp MINUS add_exp
	;

comp_exp: add_exp
	| add_exp LT add_exp
	| add_exp LTE add_exp
	| add_exp GT add_exp
	| add_exp GTE add_exp
	;

exp: comp_exp
	| comp_exp EQUAL comp_exp
	| comp_exp NOT_EQUAL comp_exp
	;

/* statements */

assign_st: IDENTIFIER ASSIGNMENT exp SEMICOLON
	;

if_st: IF LTPAR exp RTPAR st
	| IF LTPAR exp RTPAR st ELSE st
	;

while_st: WHILE RTPAR exp LTPAR st
	;

ret_st: RETURN SEMICOLON
	| RETURN exp SEMICOLON
	;

st_list: /* epsilon */ 
	| st st_list
	;

block_st: LTBRACE st_list RTBRACE
	;

empty_st: SEMICOLON
	;

st: assign_st
	| if_st
	| while_st
	| ret_st
	| block_st
	| empty_st
	;

/* functions */

return_type: VOID
	| type 
	;

func_param: type IDENTIFIER
	;

func_paramlist: func_param
	| func_param COMMA func_param
	;

var_def: type IDENTIFIER EQUAL constant SEMICOLON
	;

var_deflist: /* epsilon */
	| var_def var_deflist
	;

func_stlist: ret_st
	| st func_stlist
	;

func_body: var_deflist func_stlist
	;

func_def: return_type IDENTIFIER LTPAR func_paramlist RTPAR LTBRACE func_body RTBRACE
	| return_type IDENTIFIER LTPAR VOID RTPAR LTBRACE func_body RTBRACE
	;

/* programs */

func_deflist: /* epsilon */
	| func_def func_deflist
	;

main: INT MAIN LTPAR VOID RTPAR LTBRACE func_body RTBRACE
	;

%%
void yyerror(char *s) {
	printf("\n Error: %s\n",s);
}

int yywrap() {
        // Stop scanning at EOF
        return 1;
}

int main(void) {
	yyparse();
	return 0;
}
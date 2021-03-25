%{
#include "tinylex.tab.h"
#include "symtab.h"

#include <stdlib.h>
#include <stdio.h>

extern FILE *yyin
extern int yylex();
extern void yyerror(char *s);
%}

%token MAIN /* TODO */

/* Keywords */   
%token <int_value> IF 
%token <int_value> ELSE
%token <int_value> WHILE
%token <int_value> CHAR
%token <int_value> INT
%token <int_value> FLOAT
%token <int_value> RETURN
%token <int_value> VOID

/* Pairs of tokens */
%token <int_value> LTPAR     /* ( */
%token <int_value> RTPAR     /* ) */
%token <int_value> LTBRACE   /* { */
%token <int_value> RTBRACE   /* } */    

/* Basic separators */
%token <int_value> SEMICOLON
%token <int_value> COMMA

/* Math operators */
%token <int_value> PLUS
%token <int_value> MINUS
%token <int_value> MULTIPLY
%token <int_value> DIVIDE

/* Equality and difference */
%token <int_value> ASSIGNMENT 	/* = */
%token <int_value> EQUAL      	/* == */
%token <int_value> NOT_EQUAL   	/* != */

/* Logical operators */
%token <int_value> GT  	   /* > */
%token <int_value> LT      /* < */
%token <int_value> GTE     /* >= */
%token <int_value> LTE     /* <= */

%token <int_value> PTR     /* & */

%token <symtab_node>    IDENTIFIER
%token <char_value>	    CHAR_CONST
%token <int_value>      INT_CONST
%token <float_value>    FLOAT_CONST
%token <string_value>   STRING_CONST


%left LTPAR RTPAR
%left EQUAL NOT_EQUAL
%left GT LT GTE LTE
%left PLUS MINUS
%left MULTIPLY DIVIDE
%left PTR
%right ASSIGNMENT
%left COMMA

%nonassoc NO_ELSE
%nonassoc ELSE


%union {
    int int_value;
    char char_value;
    float float_value;
    char* string_value;
    list_node* symtab_node;
}

%% 

program: func_deflist main func_deflist
    ;

primary_exp: constant
    | IDENTIFIER
    | func_call
    | LTPAR exp RTPAR
    ;

constant: INT_CONST
    | FLOAT_CONST
    | STRING_CONST
    | CHAR_CONST
    ;

type: INT
    | FLOAT
    | CHAR
    ;

func_arglist: PTR IDENTIFIER
    | exp
    | exp COMMA func_arglist
    | PTR IDENTIFIER COMMA func_arglist
    ;

func_call: IDENTIFIER LTPAR x;

x: func_arglist RTPAR | RTPAR;

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

if_st: IF { inc_scope(); } LTPAR exp RTPAR st { hide_scope(); inc_scope(); } else { hide_scope(); }
    ;

else: %prec NO_ELSE
    | ELSE st
    ;

while_st: { inc_scope(); } WHILE LTPAR exp RTPAR st { hide_scope(); }
    ;

ret_st: RETURN SEMICOLON
    | RETURN exp SEMICOLON
    ;

st_list: /* epsilon */ 
    | st_list st
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
    | func_call SEMICOLON
    ;

/* functions */
return_type: VOID
    | type 
    ;

func_param: type IDENTIFIER
    ;

func_paramlist: func_param
    | func_param COMMA func_paramlist
    ;

var_def: type IDENTIFIER ASSIGNMENT constant SEMICOLON
    ;

var_deflist: /* epsilon */
    | var_def var_deflist 
    ;

func_stlist: ret_st
    | st func_stlist
    ;

func_body: var_deflist func_stlist
    ;

func_def: return_type IDENTIFIER LTPAR { inc_scope(); } func_paramlist RTPAR LTBRACE func_body RTBRACE { hide_scope(); }
    | return_type IDENTIFIER LTPAR VOID { inc_scope(); } RTPAR LTBRACE func_body RTBRACE { hide_scope(); }
    ;

/* programs */

func_deflist: /* epsilon */
    | func_deflist func_def
    ;

main: INT MAIN { inc_scope(); } LTPAR VOID RTPAR LTBRACE func_body RTBRACE { hide_scope(); }
    ;

%%
void yyerror(char *err_message) {
    printf("\n Error: %s on line %d.\n",
        err_message, num_line);
    exit(1);
}

int yywrap() {
    // Stop scanning at EOF
    return 1;
}

int main(void) {
    #ifdef YYDEBUG
    yydebug = 1;
    #endif
    init_symbol_table();

    yyparse();
    return 0;
}
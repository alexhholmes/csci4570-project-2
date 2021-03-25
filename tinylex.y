%{
#include "tinylex.tab.h"
#include "symtab.h"
#include "ast.h"
#include "semantic.h"

#include <stdlib.h>
#include <stdio.h>

extern FILE *yyin
extern int yylex();
extern void yyerror(char *err_message);
%}

%token MAIN /* TODO */

/* Keywords */   
%token <val> IF 
%token <val> ELSE
%token <val> WHILE
%token <val> CHAR
%token <val> INT
%token <val> FLOAT
%token <val> RETURN
%token <val> VOID

/* Pairs of tokens */
%token <val> LTPAR     /* ( */
%token <val> RTPAR     /* ) */
%token <val> LTBRACE   /* { */
%token <val> RTBRACE   /* } */    

/* Basic separators */
%token <val> SEMICOLON
%token <val> COMMA

/* Math operators */
%token <val> PLUS
%token <val> MINUS
%token <val> MULTIPLY
%token <val> DIVIDE

/* Equality and difference */
%token <val> ASSIGNMENT 	/* = */
%token <val> EQUAL      	/* == */
%token <val> NOT_EQUAL   	/* != */

/* Logical operators */
%token <val> GT  	   /* > */
%token <val> LT      /* < */
%token <val> GTE     /* >= */
%token <val> LTE     /* <= */

%token <val> PTR     /* & */

%token <symtab_node> IDENTIFIER
%token <val> CHAR_CONST
%token <val> INT_CONST
%token <val> FLOAT_CONST
%token <val> STRING_CONST


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

%type <node> program
%type <symtab_node> identifier dec_identifier
%type <node> constant
%type <data_type> type
%type <node> func_call func_call_args func_arglist
%type <node> primary_exp exp comp_exp add_exp mult_exp unary_exp
%type <node> assign_st
%type <node> if_st else
%type <node> while_st
%type <node> ret_st;
%type <node> st st_list block_st;
%type <node> return_type
%type <node> func_param func_paramlist
%type <node> var_def var_deflist
%type <node> func_def func_body func_stlist func_deflist
%type <node> main

%union {
    Value val;

    Symbol *symtab_node;
    ASTNode *node;

    int data_type;
    int const_type;
}

%% 

program: func_deflist main func_deflist
    ;

dec_identifier: IDENTIFIER {
            declared = true;
            Symbol *sym = append_sym($1, line_num)
            declared = false;
            if (sym == NULL) {
                char buf[80];
                sprintf(buf, "Identifier %s is already declared in scope", $1);
                yyerror(buf);
            }
            $$ = $1;
        }
    ;

identifier: IDENTIFIER {
            Symbol *sym = append_sym($1, line_num)
            if (sym == NULL) {
                char buf[80];
                sprintf(buf, "Identifier %s is not declared", $1);
                yyerror(buf);
            }
            $$ = $1;
        }
    ;

primary_exp: constant   { $$ = $1; }
    | identifier        { $$ = }
    | func_call
    | LTPAR exp RTPAR   { $$ = $2 }
    ;

constant: INT_CONST { $$ = new_const_node(INT_TYPE, $1); }
    | FLOAT_CONST { $$ = new_const_node(FLOAT_TYPE, $1); }
    | STRING_CONST { $$ = new_const_node(STRING_TYPE, $1); }
    | CHAR_CONST { $$ = new_const_node(CHAR_TYPE, $1); }
    ;

type: INT { $$ = INT_TYPE; }
    | FLOAT { $$ = FLOAT_TYPE; }
    | CHAR { $$ = CHAR_TYPE; }
    ;

func_arglist: PTR identifier
    | exp { $$ = $1; }
    | exp COMMA func_arglist
    | PTR identifier COMMA func_arglist
    ;

func_call_args: RTPAR { $$ = NULL; }
    | func_arglist RTPAR { $$ = $1; }
    ;

func_call: identifier LTPAR func_call_args
    ;

unary_exp: primary_exp { $$ = $1; }
    | PLUS unary_exp 
        {
            
        }
    | MINUS unary_exp
        {
           
        }
    ;

mult_exp: unary_exp { $$ = $1; }
    | mult_exp MULTIPLY unary_exp
        {
            $$ = new_arith_node($2.int_value, $1, $3);
        }
    | mult_exp DIVIDE unary_exp
        {
            $$ = new_arith_node($2.int_value, $1, $3);
        }
    ;

add_exp: mult_exp { $$ = $1; }
    | add_exp PLUS add_exp
        {
            $$ = new_arith_node($2.int_value, $1, $3);
        }
    | add_exp MINUS add_exp
        {
            $$ = new_arith_node($2.int_value, $1, $3);
        }
    ;

comp_exp: add_exp { $$ = $1; }
    | add_exp LT add_exp
        {
            $$ = new_rel_node($2.int_value, $1, $3);
        }
    | add_exp LTE add_exp
        {
            $$ = new_rel_node($2.int_value, $1, $3);
        }
    | add_exp GT add_exp
        {
            $$ = new_rel_node($2.int_value, $1, $3);
        }
    | add_exp GTE add_exp
        {
            $$ = new_rel_node($2.int_value, $1, $3);
        }
    ;

exp: comp_exp { $$ = $1; }
    | comp_exp EQUAL comp_exp
        {
            $$ = new_equal_node($2.int_value, $1, $3);
        }
    | comp_exp NOT_EQUAL comp_exp
        {
            $$ = new_equal_node($2.int_value, $1, $3);
        }
    ;

/* statements */

assign_st: identifier ASSIGNMENT exp SEMICOLON
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
        {
            $$ = $2; 
        }
    ;

st_list: /* epsilon */ 
    | st_list st
    ;

block_st: LTBRACE st_list RTBRACE
    ;

empty_st: SEMICOLON
    ;

st: assign_st { $$ = $1; }
    | if_st { $$ = $1; }
    | while_st { $$ = $1; }
    | ret_st { $$ = $1; }
    | block_st { $$ = $1; }
    | empty_st { $$ = $1; }
    | func_call SEMICOLON { $$ = $1; }
    ;

/* functions */
return_type: VOID
    | type 
    ;

func_param: type dec_identifier
    ;

func_paramlist: func_param
    | func_param COMMA func_paramlist
    ;

var_def: type dec_identifier ASSIGNMENT constant SEMICOLON
    ;

var_deflist: /* epsilon */
    | var_def var_deflist 
    ;

func_stlist: ret_st
    | st func_stlist
    ;

func_body: var_deflist func_stlist
    ;

func_def: return_type dec_identifier LTPAR { inc_scope(); } func_paramlist RTPAR LTBRACE func_body RTBRACE { hide_scope(); }
    | return_type dec_identifier LTPAR VOID { inc_scope(); } RTPAR LTBRACE func_body RTBRACE { hide_scope(); }
    ;

/* programs */

func_deflist: /* epsilon */
    | func_deflist func_def
    ;

main: INT MAIN { append_sym($2, line_num); inc_scope(); } LTPAR VOID RTPAR LTBRACE func_body RTBRACE { hide_scope(); }
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
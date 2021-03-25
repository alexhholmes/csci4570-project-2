%{
#include "tinylex.tab.h"
#include "symtab.h"

#include <math.h>

extern FILE *yyin

int line_num = 1;
%}

DIGIT   [0-9]
LETTER  [a-zA-Z]
ESCAPE_CHAR [\\'"nt]

IDENTIFIER ({LETTER}|_)({LETTER}|{DIGIT}|_)*
CHAR (\'\\{ESCAPE_CHAR}\')|(\'{LETTER}\')
INTEGER {DIGIT}+
FLOAT {DIGIT}+\.{DIGIT}+
STRING \"(\\.|[^"\\])*\"

%%

"if"                    { return(IF); }
"else"                  { return(ELSE); }
"while"                 { return(WHILE); }
"char"                  { return(CHAR); }
"int"                   { return(INT); }
"float"                 { return(FLOAT); }
"return"                { return(RETURN); }
"void"                  { return(VOID); }
"main"                  { return(MAIN); }

"("                     { return(LTPAR); }
")"                     { return(RTPAR); }
"{"                     { return(LTBRACE); }
"}"                     { return(RTBRACE); }

"+"                     { return(PLUS); }
"-"                     { return(MINUS); }
"*"                     { return(MULTIPLY); }
"/"                     { return(DIVIDE); }

"="                     { return(ASSIGNMENT); }
"=="                    { return(EQUAL); }
"!="                    { return(NOT_EQUAL); }
">"                     { return(GT); }
"<"                     { return(LT); }
">="                    { return(GTE); }
"<="                    { return(LTE); }

"&"                     { return(PTR); }
","                     { return(COMMA); }
";"                     { return(SEMICOLON); }

{IDENTIFIER}            { if (strlen(yytext) > MAX) yyerror("Identifier exceeds maximum length (50 characters)");
                          insert(yytext, strlen(yytext), UNDEF, num_line); 
                          yylval.symtab_item = lookup(yytext);
                          return(IDENTIFIER); } /* TODO line 57 change function call */

{CHAR}                  { yylval.val.char_value = yytext[1];
                          return(CHAR_CONST); }

{INTEGER}               { yylval.val.int_value = atoi(yytext);                               
                          return(INT_CONST); }

{FLOAT}                 { yylval.val.float_value = atof(yytext);                                
                          return(FLOAT_CONST); }

{STRING}                { yylval.val.string_value = strdup(yytext);
                          return (STRING_CONST); }

[ \t\r\f]+              /* skip whitespace */

"\n"                    { num_line += 1; }

.                       { yyerror("Unrecognized character"); }

%%
%{
#include "tinylex.tab.h"
#include <math.h>
extern void yyerror(char *s);

int num_line = 1;
%}

DIGIT   [0-9]
LETTER  [a-zA-Z]
ESCAPE_CHAR [\\'"nt]

IDENTIFIER ({LETTER}|_)({LETTER}|{DIGIT}|_)*
CHAR (\'\\{ESCAPE_CHAR}\')|(\'{LETTER}\')
INTEGER {DIGIT}+
FLOAT {DIGIT}+\.{DIGIT}+
STRING \"(\\.|[^"\\])*\"

CONSTANT {CHAR}|{INTEGER}|{FLOAT}|{STRING}
TYPE "int"|"float"|"char"|"void"


%%

"if"                    { return(IF); }
"else"                  { return(ELSE); }
"while"                 { return(WHILE); }
"char"                  { return(CHAR); }
"int"                   { return(INT); }
"float"                 { return(FLOAT); }
"return"                { return(RETURN); }
"void"                  { return(VOID); }

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

";"                     { return(SEMICOLON); }

","                     { return(COMMA); }

{IDENTIFIER}            { strcpy(yylval.charArray, yytext);
                          return(IDENTIFIER); }

{CHAR}                  { yylval.charValue = yytext[1];
                          return(CHAR_CONST); }

{INTEGER}               { yylval.intValue = atio(yytext);                               
                          return(INT_CONST); }

{FLOAT}                 { yylval.floatValue = atof(yytext);                                
                          return(FLOAT_CONST); }

{STRING}                { yylval.stringValue = yytext;
                          return (STRING_CONST); }

[ \t]                   /* skip whitespace */
[\n\r]                  { num_line++; }

%%

int yywrap() {
        // Stop scanning at EOF
        return 1;
}
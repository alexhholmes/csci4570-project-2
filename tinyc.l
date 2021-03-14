DIGIT   [0-9]
LETTER  [a-zA-Z]
ESCAPE_CHAR [\\'"nt]

IDENTIFIER ({LETTER}|_)({LETTER}|{DIGIT}|_)*

IDENTIFIER
CHAR
INTEGER
FLOAT
STRING

%%

/* Keywords */
"if"                    { return(IF) }
"else"                  { return(ELSE) }
"while"                 { return(WHILE) }
"char"                  { return(CHAR) }
"int"                   { return(INT) }
"float"                 { return(FLOAT) }
"return"                { return(RETURN) }
"void"                  { return(VOID) }

/* Separators */
"("                     { return(LTPAR) }
")"                     { return(RTPAR) }
"{"                     { return(LTBRACE) }
"}"                     { return(RTBRACE) }

/* Arithmetic Operators */
"+"                     { return(PLUS) }
"-"                     { return(MINUS) }
"*"                     { return(MULTIPLY) }
"/"                     { return(DIVIDE) }

/* Assignment */
"="                     { return(ASSIGNMENT) }

/* Comparisons */
"=="                    { return(EQUAL) }
"!="                    { return(NOT_EQUAL) }
">"                     { return(GT) }
"<"                     { return(LT) }
">="                    { return(GTE) }
"<="                    { return(LTE) }

"&"                     { return(PTR) }

{IDENTIFIER}            { strcpy(yylval.charArray, yytext);
                          return(IDENTIFIER); }

{CHAR}                  { yylval.charValue = yytext[1];
                          return(CHAR_CONST) }

{INTEGER}               { yylval.intValue = atio(yytext);                               
                          return(INT_CONST); }

{FLOAT}                 { yylval.floatValue = atof(yytext);                                
                          return(FLOAT_CONST); }

{STRING}                { yylval.stringValue = yytext;
                          return (STRING_CONST); }

%%

 int main(int argc, char **argv)
 {
     ++argv, --argc;  /* Skip over program name */
     if (argc > 0)
             yyin = fopen( argv[0], "r" );
     else
             yyin = stdin;

     yylex();
     printf("%d\n", tokens);
 }

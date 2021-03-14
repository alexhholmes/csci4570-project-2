%{
  int tokens = 0;
%}

DIGIT   [0-9]
LETTER  [a-zA-Z]
ESCAPE_CHAR [\\'"nt]


%%

"if"                            { return(IF) }
"else"                          { return(ELSE) }
"while"                         { return(WHILE) }
"char"                          { return(CHAR) }
"int"                           { return(INT) }
"float"                         { return(FLOAT) }
"return"                        { return(RETURN) }
"void"                          { return(VOID) }

"("                             { return(LTPAR) }
")"                             { return(RTPAR) }
"{"                             { return(LTBRACE) }
"}"                             { return(RTBRACE) }

"+"                             { return(RTBRACE) }
"-"                             { return(RTBRACE) }
"*"                             { return(RTBRACE) }
"/"                             { return(RTBRACE) }

"="                             { return(RTBRACE) }

"=="                            { return(RTBRACE) }
"!="                            { return(RTBRACE) }
">"                             { return(RTBRACE) }
"<"                             { return(RTBRACE) }
"<="                            { return(RTBRACE) }
">="                            { return(RTBRACE) }

"&"                             { return(RTBRACE) }

({LETTER}|_)({LETTER}|{DIGIT}|_)*   { strcpy(yylval.charArray, yytext);
                                      return(IDENTIFIER); }




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

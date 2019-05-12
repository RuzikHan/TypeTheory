%{
#include<string>
#define YYSTYPE std::string*
#include <stdio.h>
#include "mybison.tab.h"
%}
%option outfile="lex.yy.c" header-file="lex.yy.h"
%option nounput
%%
\\        		 return LAMBDA;
\.         		 return DOT;
\(        		 return LPAREN;
\)         		 return RPAREN;
[a-z][a-z0-9']*  yylval= new std::string(yytext); return VALUE;
[ \t\r\n]+       ;
<<EOF>>          return ENDOFFILE;
%%
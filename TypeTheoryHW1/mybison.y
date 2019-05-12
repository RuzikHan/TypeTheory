%{
#include <stdio.h>
#include <stdlib.h>
#include <string>
#define YYSTYPE std::string *
int yylex(void);
void yyerror(const char*);

%}

%token LAMBDA DOT LPAREN RPAREN VALUE ENDOFFILE
%start input
%%
input:
  expression ENDOFFILE {
    printf($1->c_str());
    exit(0);
  }
  ;
expression:
    application LAMBDA variable DOT expression {
      std::string* tmp = new std::string();
      *tmp += "(" + *$1 + " (\\" + *$3 + "." + *$5 + "))"; 
      $$=new std::string(*tmp);
    }
    |
    LAMBDA variable DOT expression {
      std::string* tmp = new std::string();
      *tmp += "(\\" + *$2 + "." + *$4 + ")"; 
      $$=new std::string(*tmp);
    }
    |
    application {
      $$=new std::string(*$1);
    }
    ;
application:
    application atom {
      std::string* tmp = new std::string();
      *tmp += "(" + *$1 + " " + *$2 + ")";
      $$=new std::string(*tmp);
    }
    |
    atom {
      $$=new std::string(*$1);
    }
    ;
atom:
    LPAREN expression RPAREN {
      $$=new std::string(*$2);
    }
    |
    variable {
      $$=new std::string(*$1);
    }
    ;
variable:
    VALUE {
      $$=new std::string(*$1);
    }
    ;
%%
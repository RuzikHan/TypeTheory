#include <bits/stdc++.h>
#include "mybison.tab.h"
#include "lex.yy.h"

void yyerror(const char *s) {
      fprintf (stderr, "%s\n", s);
    }
 
int yywrap() {
        return 1;
} 
int yyparse();
int main() {
        yyparse();
}
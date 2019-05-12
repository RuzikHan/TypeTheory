%token LAMBDA DOT LPAREN RPAREN ENDOFFILE
%token <string> VALUE
%start input
%type <Node.node> input
%%

input:
    expression ENDOFFILE {
    	$1
    }
    ;
expression:
    application LAMBDA variable DOT expression {
    	Node.Application($1, Node.Abstraction($3, $5))
    }
    |
    LAMBDA variable DOT expression {
    	Node.Abstraction ($2, $4)
    }
    |
    application {
    	$1
    }
    ;
application:
    application atom {
    	Node.Application ($1, $2)
    }
    |
    atom {
    	$1
    }
    ;
atom:
    LPAREN expression RPAREN {
    	$2
    }
    |
    variable {
    	Node.Expression $1
    }
    ;
variable:
    VALUE {
    	$1
    }
    ;
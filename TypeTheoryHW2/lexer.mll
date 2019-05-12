{
open Parser
exception Eof
}
rule token = parse
  [' ' '\t' '\r' '\n']                   { token lexbuf }
  | '\\'                                 { LAMBDA }
  | '.'                                  { DOT }
  | '('                                  { LPAREN }
  | ')'                                  { RPAREN }
  | ['a'-'z']['a'-'z''A'-'Z''0'-'9''\'']* as tmp { VALUE(tmp) }
  | eof                                  { ENDOFFILE }
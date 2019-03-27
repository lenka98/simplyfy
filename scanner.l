%{
  #include <stdio.h>
  #include "y.tab.h"
  #include "node.h"
  void yyerror (char*);
  int i = 0;
%}


letter [a-zA-Z_]
digit [0-9]

%%

"if"    {return IF;}
"else"  {return ELSE;}
"while" {return WHILE;}
"print" {return PRINT;}

{letter}({letter}|{digit})*   {yylval.idx = i; i++; return VAR;}

0   {yylval.val = atoi(yytext); return INTEGER;}
[1-9][0-9]*   {yylval.val = atoi(yytext); return INTEGER;}

[-+<>{}()/%*=]    {return *yytext;}

"<="    {return LE;}
">="    {return GE;}
"=="    {return EQ;}
"!="    {return NE;}

[ \t]+    ;

;   {return DELIM;}
\n    {yylineno++; return DELIM;}

.   yyerror("Unknown literal\n");

%%

int yywrap ()
{
  return 1;
}

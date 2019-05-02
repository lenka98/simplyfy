%{
  #include <stdio.h>
  #include "y.tab.h"
  void yyerror (char*);
%}


letter [a-zA-Z_]
digit [0-9]

%%

"if"    {return IF;}
"else"  {return ELSE;}
"while" {return WHILE;}
"print" {return PRINT;}

{letter}({letter}|{digit})*   {yylval.idx = *yytext - 'a'; return VAR;}

0   {yylval.val = atoi(yytext); return INTEGER;}
[1-9][0-9]*   {yylval.val = atoi(yytext); return INTEGER;}

[-+<>{}()/%*=]    {return *yytext;}

"<="    {return LE;}
">="    {return GE;}
"=="    {return EQ;}
"!="    {return NE;}

[ \t]+    ;

;   {return DELIM;}
\n    {yylineno++;}

.   yyerror("Unknown literal\n");

%%

int yywrap ()
{
  return 1;
}

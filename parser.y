%{
    #include "node.h"
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdarg.h>

    int yylex(void);
    node* con(int);
    node* id(int);
    node* opr(int, int, ...);
    void free_node (node*);
    int ex(node*);
    void yyerror(char*);
    int symtable[26];
%}


%union
{
  int idx;
  int val;
  struct nodetag* nptr;
};

%token <val> INTEGER
%token <idx> VAR

%token IF WHILE PRINT
%token DELIM

%nonassoc IFX
%nonassoc ELSE

%right '='
%left '<' '>' LE GE EQ NE
%left '+' '-'
%left '/' '*' '%'
%left '(' ')'
%left '{' '}'
%nonassoc UMINUS

%type <nptr> statement list expr

%%

program:
  block   {exit(0);}
  ;

block:
  block statement   {ex($2); free_node($2);}
  |
  ;

statement:
  DELIM {$$ = opr(';', 2, NULL, NULL);}
  | expr DELIM    {$$=$1;}
  | PRINT expr DELIM {$$ = opr(PRINT,1, $2);}
  | VAR '=' expr DELIM    {$$ = opr('=', 2, id($1), $3);}
  | WHILE '(' expr ')' statement    {$$ = opr(WHILE, 2, $3, $5);}
  | IF '(' expr ')' statement %prec IFX   {$$ = opr(IF, 2, $3, $5);}
  | IF '(' expr ')' statement ELSE statement    {$$ = opr(IF, 3, $3, $5, $7);}
  | '{' list '}'    {$$ = $2;}
  ;

list:
  list statement    {$$ = opr(';', 2, $1, $2);}
  |statement    {$$ = $1;}
  ;

expr:
  INTEGER   {$$ = con($1);}
  | VAR   {$$ = id($1);}
  | expr '+' expr   {$$ = opr('+', 2, $1, $3);}
  | expr '-' expr   {$$ = opr('-', 2, $1, $3);}
  | expr '*' expr   {$$ = opr('*', 2, $1, $3);}
  | expr '/' expr   {$$ = opr('/', 2, $1, $3);}
  | expr '%' expr   {$$ = opr('%', 2, $1, $3);}
  | expr '<' expr   {$$ = opr('<', 2, $1, $3);}
  | expr '>' expr   {$$ = opr('>', 2, $1, $3);}
  | expr LE expr    {$$ = opr(LE, 2, $1, $3);}
  | expr GE expr    {$$ = opr(GE, 2, $1, $3);}
  | expr EQ expr    {$$ = opr(EQ, 2, $1, $3);}
  | expr NE expr    {$$ = opr(NE, 2, $1, $3);}
  | '-' expr %prec UMINUS   {$$ = opr(UMINUS, 1, $2);}
  | '(' expr ')'    {$$ = $2;}
  ;

%%



node* con (int value)
{
  node *p = (node*)malloc(sizeof(node));
  if(p == NULL)
    yyerror("Heap is full\n");

  p->node_type = type_const;
  p->cn.value = value;

  return p;
}

node* id (int index)
{
  node *p = (node*)malloc(sizeof(node));
  if(p == NULL)
    yyerror("Heap is full\n");

  p->node_type = type_id;
  p->in.index = index;

  return p;
}

node* opr (int opr, int nop, ...)
{
  va_list ap;
  int i;

  node *p = (node*)malloc(sizeof(node) + (nop-1) * sizeof(node*));
  if(p == NULL)
    yyerror("Heap is full\n");

  p->node_type = type_op;
  p->on.opr = opr;
  p->on.nop = nop;

  va_start(ap, nop);
  for(i = 0; i < nop; i++)
    p->on.op[i] = va_arg(ap, node*);

  va_end(ap);
  return p;
}

void free_node(node* p)
{
  if(!p)
    return;

  if(p->node_type == type_op)
  {
    int i;
    for(i = 0; i < p->on.nop; i++)
      free_node(p->on.op[i]);
  }

  free(p);
}

void yyerror (char *s)
{
  printf("%s\n", s);
}

int main()
{
  yyparse();
  return 0;
}

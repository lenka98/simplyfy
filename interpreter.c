#include <stdio.h>
#include "node.h"
#include "y.tab.h"

int ex(node *p)
{
  if(!p)
    return 0;

  switch (p->node_type)
  {
    case type_const: return p->cn.value;

    case type_id: return symtable[p->in.index];

    case type_op:
      switch (p->on.opr)
      {
        case WHILE:
          while(ex(p->on.op[0]))
            ex(p->on.op[1]);
          return 0;

        case IF:
          if(ex(p->on.op[0]))
            ex(p->on.op[1]);
          else if(p->on.nop > 2)
            ex(p->on.op[2]);
          return 0;

        case PRINT: printf("%d ", ex(p->on.op[0]));
                    return 0;

        case ';': ex(p->on.op[0]); return ex(p->on.op[1]);

        case '=': return symtable[p->on.op[0]->in.index] = ex(p->on.op[1]);

        case UMINUS: return -ex(p->on.op[0]);

        case '+':  return ex(p->on.op[0]) + ex(p->on.op[1]);

        case '-':  return ex(p->on.op[0]) - ex(p->on.op[1]);

        case '*':  return ex(p->on.op[0]) * ex(p->on.op[1]);

        case '/':  return ex(p->on.op[0]) / ex(p->on.op[1]);

        case '%':  return ex(p->on.op[0]) % ex(p->on.op[1]);

        case '<':  return ex(p->on.op[0]) < ex(p->on.op[1]);

        case '>':  return ex(p->on.op[0]) > ex(p->on.op[1]);

        case LE:  return ex(p->on.op[0]) <= ex(p->on.op[1]);

        case GE:  return ex(p->on.op[0]) >= ex(p->on.op[1]);

        case EQ:  return ex(p->on.op[0]) == ex(p->on.op[1]);

        case NE:  return ex(p->on.op[0]) != ex(p->on.op[1]);
      }
  }
  return 0;
}

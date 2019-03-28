typedef enum {type_id, type_const, type_op} node_enum;

typedef struct
{
  int value;
}const_node;

typedef struct
{
  int index;
}id_node;

typedef struct
{
  int opr;
  int nop;
  struct nodetag *op[1];
}opr_node;

typedef struct nodetag
{
    node_enum node_type;

    union
    {
      const_node cn;
      id_node in;
      opr_node on;
    };
}node;

extern int symtable[26];

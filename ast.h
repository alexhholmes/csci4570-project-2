#ifndef ast
#define ast

typedef union Value {
    int int_val;
    float float_val;
    char char_val;
    char *string_val;
} Value;

typedef enum NodeType {
    ROOT_NODE,
    CONST_NODE,
    IF_NODE,

} NodeType;

typedef enum ArithOp {
    ADD,
    SUB,
    MUL,
    DIV,
} ArithOp;

typedef enum RelatOp {
    GT,
    LT,
    GTE,
    LTE,
} RelatOp;

typedef enum EqualOp {
    EQUAL,
    NOT_EQUAL,
} EqualOp;

typedef struct ASTNode {
    NodeType type;
    ASTNode *left;
    ASTNode *right;
} ASTNode;

#endif
#ifndef ast
#define ast

#include "symtab.h"

/* Return types */
#define VOID_RETURN 0
#define INT_RETURN 1
#define FLOAT_RETURN 2
#define CHAR_RETURN 3

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
    ELSEIF_NODE, 
    WHILE_NODE,
    ASSIGN_NODE, 
	MAINRT_NODE, 
	INCR_NODE,   
	FUNC_CALL,  
	ARITHM_NODE, 
	REL_NODE,    
	EQU_NODE, 
	FUNC_DECL,   
	RETURN_NODE, // TODO: why is this different than main?

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

typedef union Value{
	int ival;
	double fval;
	char cval;
	char *sval;
} Value;

typedef struct ASTNode {
    NodeType type;
    ASTNode *left;
    ASTNode *right;
} ASTNode;

typedef struct ASTConstNode {
    NodeType type; 
    Type const_type; 
    Value val; 
} ASTConstNode;

typedef struct ASTIfNode {
    NodeType type; 

    struct ASTNode *condition; 
    struct ASTNode *if_branch; 
    struct ASTNode **elseif_branches; 
    struct ASTNode *else_branch; 
} ASTIfNode;

typedef struct ASTElseIfNode {
    NodeType type; 
    struct ASTNode *condition; 
    struct ASTNode *elseif_branch; 
} ASTElseIfNode; 

typedef struct ASTWhileNode {
    NodeType type; 
    struct ASTNode *condition; 
    struct ASTNode *while_branch; 
} ASTWhileNode;

typedef struct ASTAssignmentNode{
	NodeType type;
	ListNode *entry;
	struct ASTNode *assign_val;
} ASTAssignmentNode;

typedef struct ASTMainRtNode{
	NodeType type;
	int statement_type;
} ASTMainRtNode;

typedef struct ASTFuncCallNode {
	NodeType type;
	ListNode *entry;
	ASTNode **params;	
} ASTFuncCallNode;

typedef struct ASTArithNode{
	NodeType type;
	enum ArithOp op;  
    struct ASTNode *left;  
	struct ASTNode *right; 
}ASTArithNode;

typedef struct ASTRelatNode{
	NodeType type;
	enum RelatOp op;
	struct ASTNode *left;  
	struct ASTNode *right; 
}ASTRelatNode;

typedef struct ASTEqualNode{
	NodeType type;
	enum EqualOp op;
    struct ASTNode *left;  
	struct ASTNode *right; 
}ASTEqualNode;

typedef struct ASTNode_Func_Decl {
	NodeType type; 
	int ret_type;

	// symbol table entry
	ListNode *entry;
}ASTNode_Func_Decl;

typedef struct ASTNode_Return{
	NodeType type; // node type

	// return type
	int ret_type;

	// return value
	struct ASTNode *ret_val;
}ASTNode_Return;

#endif
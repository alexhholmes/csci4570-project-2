#ifndef ast
#define ast

#include "symtab.h"

typedef enum NodeType {
	BASIC_NODE,  // no special usage (for roots only)

	// declarations
	DECL_NODE,   // declaration, var def?
	CONST_NODE,  // constant

	// statements
	IF_NODE,     // if statement
	WHILE_NODE,  // while statement
	ASSIGN_NODE, // assigment
	MAINRT_NODE, // continue, break and "main" return statements
	FUNC_CALL,   // function call

	// expressions
	ARITH_NODE, // arithmetic expression
	REL_NODE,    // relational expression
	EQUAL_NODE,    // equality expression

	// functions
	FUNC_DECL,   // function declaration
	RETURN_NODE, // return statement of functions
} NodeType;

typedef enum ArithOp{
	ADD,  // + operator
	SUB,  // - operator
	MUL,  // * operator
	DIV , // / operator
} ArithOp;

typedef enum RelOp{
	GREATER,        // > operator
	LESS,           // < operator
	GREATER_EQUAL,  // >= operator
	LESS_EQUAL     // <= operator
} RelOp;

typedef enum EqualOp{
	EQ,    // == operator
	NOT_EQ // != operator
} EqualOp;

typedef union Value {
	int int_value;
	char char_value;
	float float_value;
	char *string_value;
} Value;

// Nodes

// Normal node
typedef struct ASTNode {
	NodeType type; // node type
	ASTNode *left;  // left child
	ASTNode *right; // right child
} ASTNode;

// TODO Declare Node

typedef struct ASTConstNode {
	NodeType type; // node type
	int const_type; // data type
	Value val; // constant value
} ASTConstNode;

// Statements 

typedef struct ASTIfNode {
	NodeType type; // node type
	ASTNode *condition; // condition
	ASTNode *if_branch; // if branch
	ASTNode *else_branch; // else branch
} ASTIfNode;

typedef struct ASTWhileNode {
	NodeType type; // node type
	ASTNode *condition; // condition
	ASTNode *while_branch; // branch
} ASTWhileNode;

typedef struct ASTAssignNode {
	NodeType type; // node type
	Symbol *entry; // symbol table entry
	ASTNode *assign_val; // assignment value
} ASTAssignNode;

typedef struct ASTMainRtNode {
	NodeType type; // node type
} ASTMainRtNode;

typedef struct ASTFuncCallNode {
	NodeType type; // node type
	Symbol *entry; // function identifier
	ASTNode **params; // call parameters
	int num_of_params;
} ASTFuncCallNode;

/* Expressions */

typedef struct ASTArithNode {
	NodeType type; // node type
	ArithOp op; // operator
	ASTNode *left;  // left child
	ASTNode *right; // right child
} ASTArithNode;

typedef struct ASTRelNode {
	NodeType type; // node type
	RelOp op; // operator
    ASTNode *left;  // left child
	ASTNode *right; // right child
} ASTRelNode;

typedef struct ASTEqualNode {
	NodeType type; // node type
	EqualOp op; // operator
	ASTNode *left;  // left child
	ASTNode *right; // right child
} ASTEqualNode;

/* Functions */
typedef struct ASTFuncDeclNode {
	NodeType type; // node type
	int ret_type; // return type
	Symbol *entry; // symbol table entry
} ASTFuncDeclNode;

typedef struct ASTReturnNode {
	NodeType type; // node type
	int ret_type; // return type
	ASTNode *ret_val; // return value
} ASTReturnNode;

// TODO NODE MANAGEMENT

ASTNode *new_ast_node(NodeType type, ASTNode *left, ASTNode *right);
ASTNode *new_const_node(int const_type, Value val);
ASTNode *new_if_node(ASTNode *condition, ASTNode *if_branch, ASTNode *else_branch);
ASTNode *new_while_node(ASTNode *condition, ASTNode *while_branch);
ASTNode *new_assign_node(Symbol *entry, ASTNode *assign_val);
ASTNode *new_mainrt_node();
ASTNode *new_funccall_node(Symbol *entry, ASTNode *params, int num_of_params);
ASTNode *new_arith_node(ArithOp op, ASTNode *left, ASTNode *right);
ASTNode *new_rel_node(ArithOp op, ASTNode *left, ASTNode *right);
ASTNode *new_equal_node(ArithOp op, ASTNode *left, ASTNode *right);
ASTNode *new_funcdecl_node(int ret_type, Symbol *entry);
ASTNode *new_return_node(int ret_type, ASTNode *ret_val);

#endif
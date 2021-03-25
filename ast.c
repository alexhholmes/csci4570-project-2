#include "ast.h"

ASTNode *new_ast_node(NodeType type, ASTNode *left, ASTNode *right) {
	// allocate memory
	ASTNode *v = malloc (sizeof (ASTNode));
	
	// set entries
	v->type = type;
	v->left = left;
	v->right = right;
	
	// return the result
	return v;
}

ASTNode *new_const_node(int const_type, Value val) {
    ASTConstNode *v = malloc (sizeof(ASTConstNode));
    v->type = CONST_NODE; 
    v->const_type = const_type;
    v->val = val; 
    return (ASTNode*) v;
}

ASTNode *new_if_node(ASTNode *condition, ASTNode *if_branch, ASTNode *else_branch) {
    ASTIfNode *v = malloc (sizeof(ASTIfNode));
    v->type = IF_NODE;
    v->condition = condition; 
    v->if_branch = if_branch; 
    v->else_branch = else_branch; 
    return (ASTNode*) v;
}

ASTNode *new_while_node(ASTNode *condition, ASTNode *while_branch) {
    ASTWhileNode *v = malloc (sizeof(ASTWhileNode));
    v->type = WHILE_NODE;
    v->condition = condition; 
    v->while_branch = while_branch; 
    return (ASTNode*) v;
}

ASTNode *new_assign_node(Symbol *entry, ASTNode *assign_val) {
    ASTAssignNode *v = malloc (sizeof(ASTAssignNode));
    v->type = ASSIGN_NODE; 
    v->entry = entry; 
    v->assign_val = assign_val;
    return (ASTNode*) v;
}

ASTNode *new_mainrt_node() {
    ASTMainRtNode *v = malloc (sizeof(ASTMainRtNode));
    v->type = MAINRT_NODE;
    return (ASTNode*) v;
}

ASTNode *new_funccall_node(Symbol *entry, ASTNode *params, int num_of_params) {
    ASTFuncCallNode *v = malloc (sizeof(ASTFuncCallNode));
    v->type = FUNC_CALL; 
    v->entry = entry; 
    v->params = params;
    v->num_of_params = num_of_params;
    return (ASTNode*) v;
}

ASTNode *new_arith_node(ArithOp op, ASTNode *left, ASTNode *right) {
    ASTArithNode *v = malloc (sizeof(ASTArithNode));
    v->type = ARITH_NODE; 
    v->op = op; 
    v->left = left;
    v->right = right;
    return (ASTNode*) v;
}

ASTNode *new_rel_node(RelOp op, ASTNode *left, ASTNode *right) {
    ASTRelNode *v = malloc (sizeof(ASTRelNode));
    v->type = REL_NODE; 
    v->op = op; 
    v->left = left;
    v->right = right;
    return (ASTNode*) v;
}

ASTNode *new_equal_node(EqualOp op, ASTNode *left, ASTNode *right) {
    ASTEqualNode *v = malloc (sizeof(ASTEqualNode));
    v->type = EQUAL_NODE; 
    v->op = op; 
    v->left = left;
    v->right = right;
    return (ASTNode*) v;
}

ASTNode *new_funcdecl_node(int ret_type, Symbol *entry) {
    ASTFuncDeclNode *v = malloc (sizeof(ASTFuncDeclNode));
    v->type = FUNC_DECL; 
    v->ret_type = ret_type; 
    v->entry = entry;
    return (ASTNode*) v;
}

ASTNode *new_return_node(int ret_type, ASTNode *ret_val) {
    ASTReturnNode *v = malloc (sizeof(ASTReturnNode));
    v->type = RETURN_NODE; 
    v->ret_type = ret_type; 
    v->ret_val = ret_val;
    return (ASTNode*) v;
}


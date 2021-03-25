#ifndef semantic
#define semantic

#include "ast.h"
#include "symtab.h"

// Token Types
#define UNDEF 0
#define INT_TYPE 1
#define FLOAT_TYPE 2
#define CHAR_TYPE 3 
#define STRING_TYPE 4
#define FUNCTION_TYPE 5
#define VOID_TYPE 6

// Operator Types
#define NONE 0
#define ARITH_OP 1
#define REL_OP 2
#define EQU_OP 3

int get_result_type(int type1, int type2, int op_type);

#endif
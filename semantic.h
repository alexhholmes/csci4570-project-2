#ifndef semantic
#define semantic

#include "ast.h"
#include "symtab.h"

typedef enum SymbolType {
    UNDEF_TYPE,
    INT_TYPE,
    FLOAT_TYPE,
    CHAR_TYPE,
    STR_TYPE,
    FUNC_TYPE,
} SymbolType;

typedef enum ReturnType {
    UNKNOWN_RET,
    VOID_RET,
    INT_RET,
    FLOAT_RET,
    CHAR_RET,
} ReturnType;

typedef enum OpType {
    ARITH_OP,
    REL_OP,
    EQU_OP,
} OpType;

SymbolType get_result_type(SymbolType type1, SymbolType type2, OpType op_type);


#endif
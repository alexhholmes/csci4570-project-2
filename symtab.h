#ifndef symtab
#define symtab

#include <stdlib.h>

#define MAX_IDENTIFIER_LENGTH 48

static Symbol *sym_table = NULL;
static scope_t curr_scope = 0;


typedef unsigned int scope_t;

typedef enum SymbolType {
    INT,
    FLOAT,
    CHAR,
    STR,
    FUNC,
} SymbolType;
typedef enum ReturnType {
    UNKNOWN,
    VOID,
    INT,
    FLOAT,
    CHAR,
} ReturnType;

typedef struct Symbol {
    char *name;
    SymbolType type;
    scope_t scope;
    int line_num;
    bool declared;
    union value {
        int int_val;
        float float_val;
        char char_val;
        char *str_val;
    } value;

    // For function symbols
    ReturnType func_type;

    Symbol *next;
} Symbol;

Symbol *append_sym(char *name, bool declared, SymbolType type, ReturnType ret_type, int line_num);
void append_sym_unchecked(char *name, bool declared, SymbolType type, ReturnType ret_type, int line_num);
Symbol *lookup_sym(char *name);
Symbol *lookup_sym_scoped(char* name, scope_t scope);
bool *is_sym_declared_scoped(char *name, scope_t scope);
void inc_scope();
void hide_scope();

#endif
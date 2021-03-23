#ifndef symtab
#define symtab

#define MAX_TOKEN_LENGTH 50

/* Max symbol table size */
#define SIZE 512

/* Token types */
#define UNDEF 0
#define INT_TYPE 1
#define FLOAT_TYPE 2
#define CHAR_TYPE 3
#define FUNCTION_TYPE 4

/* Function parameter passing type */
#define BY_VALUE 1
#define BY_REFER 2

typedef int Type;
typedef int ParamType;

/* Current scope */
unsigned int curr_scope = 0;

/* Function parameter struct */
typedef struct Param {
    Type token_type;
    ParamType param_type;
    char param_name[MAX_TOKEN_LENGTH];
    int int_value;
    float float_value;
    char *str_value;
} Param;

typedef struct RefList {
    int line_num;
    struct RefList *next;
    Type type;
} RefList;

typedef struct ListNode {
    char st_name[MAX_TOKEN_LENGTH];
    int st_size;
    int scope;
    RefList *lines;

    int st_int_value;
    int st_float_value;
    char *st_string_value;

    Type st_type;
    
    Param *parameters;
    int num_of_params;

    struct ListNode *next;
} ListNode;

static ListNode **symbol_table;

/* Function Declarations */
void init_symbol_table();
unsigned int hash(char *key);
ListNode *traverse_list(ListNode *start_node, char *name);
ListNode *traverse_list_scoped(ListNode *start_node, char *name, unsigned int scope);
void insert(char *name, int len, int type, int line_num);
ListNode *lookup(char *name);
ListNode *lookup_scope(char *name, int scope);
void hide_scope();
void incr_scope();

#endif

#include "symtab.h"

#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <stdbool.h>

/*
* Initializes the symbol table.
*/
void init_symbol_table() {
    // Asserts that function is only called once
    static bool ONCE = false;
    assert(!ONCE);
    ONCE = true;

    // Initialize symbol table with null values
    symbol_table = malloc(SIZE * sizeof(ListNode*));
    for (int i = 0; i < SIZE; i++) {
        symbol_table[i] = NULL;
    }
}

/*
* Returns a hash of the specified key.
*/
unsigned int hash(char *key) {
    // TODO Original implementation
    unsigned int hash_value = 0;
    while (*key != '\0') {
        hash_value += *key;
        key += 1;
    }
    hash_value += key[0] % 11 + (key[0] << 3) - key[0];
    return hash_value % SIZE;
}

ListNode *traverse_list(ListNode *start_node, char *name) {
    ListNode *ln = start_node;
    while ((ln != NULL) && (strcmp(name, ln->st_name) != 0)) {
        ln = ln->next;
    }
    return ln;
}

ListNode *traverse_list_scoped(ListNode *start_node, char *name, unsigned int scope) {
    ListNode *ln = start_node;
    while ((ln != NULL)
        && (strcmp(name, ln->st_name) != 0)
        && (scope != ln->scope))
    {
        ln = ln->next;
    }
    return ln;
}

/*
* Inserts a new identifier into the symbol table.
*/
void insert(char *name, int len, Type type, int line_num) {
    unsigned int hash_value = hash(name);
    ListNode *ln = symbol_table[hash_value];
    ln = traverse_list(ln, name);

    if (ln == NULL) {
        // Not found in table, create new node
        ln = (ListNode*) malloc(sizeof(ListNode));

        // Add to symbol table
        ln->st_type = type;
        ln->scope = curr_scope;
        ln->lines = (RefList*) malloc(sizeof(RefList));
        ln->lines->line_num = line_num;
        ln->lines->next = NULL;
        ln->next = NULL;
        symbol_table[hash_value] = ln;
    } else {
        // Found in table, add line number
        ln->scope = curr_scope;
        RefList *rl = ln->lines;
        while (rl->next != NULL) rl = rl->next;

        rl->next = (RefList*) malloc(sizeof(RefList));
        rl->next->line_num = line_num;
        rl->next->next = NULL;
    }
}

/*
* Returns symbol if found or NULL if not found.
*/
ListNode *lookup(char *name) {
    unsigned int hash_val = hash(name);
    ListNode *ln = symbol_table[hash_val];
    traverse_list(ln, name);
    return ln;
}

/*
* Returns symbol in specified scope if found or NULL if not found.
*/
ListNode *lookup_scope(char *name, int scope) {
    unsigned int hash_val = hash(name);
    ListNode *ln = symbol_table[hash_val];
    ln = traverse_list_scoped(ln, name, scope);
    return ln;
}

/*
* Hides symbols of the current scope.
*/
void hide_scope() {
    ListNode *ln;
    for (int i = 0; i < SIZE; i++) {
        if (symbol_table[i] != NULL) {
            ln = symbol_table[i];
            // TODO Do I need to free or can symbols still be reffed by syntax analyser
            while(ln != NULL && ln->scope == curr_scope) {
                ln = ln->next;
            }
            symbol_table[i] = ln;
        }
    }
    curr_scope -= 1;
}

/*
* Increments the scope by one.
*/
void incr_scope() {
    curr_scope += 1;
}
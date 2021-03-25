#include "symtab.h" 

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

/*
 * Appends a new symbol to the front of the symbol table.
 * Checks if variable has already been declared in the scope.
 */
Symbol *append_sym(char *name, int line_num) {
    if (declared) {
        // Declared symbol must check if it's already been declared
        // in the current scope.
        if (!is_sym_declared_scoped(name, curr_scope)) {
            append_sym_unchecked(name, line_num);
            return sym_table;
        }
    } else {
        // Undeclared symbol must check if symbol already exists in
        // the symbol table (has been declared).
        if (lookup_sym(name) != NULL) {
            append_sym_unchecked(name, line_num);
        }
    }
    // Returns null if unable to add to symbol table
    return NULL;
}

void append_sym_unchecked(char *name, int line_num) {
    Symbol *new_sym = (Symbol *) malloc(sizeof(Symbol));
    new_sym->name = name;
    new_sym->scope = curr_scope;
    new_sym->line_num = line_num;
    new_sym->declared = declared;
    new_sym->next = sym_table;

    sym_table = new_sym;
}

/*
 * Returns a reference to the symbol of the given name, NULL if
 * symbol does not exist. This returns the most locally scoped
 * symbol.
 */
Symbol *lookup_sym(char *name) {
    Symbol *sym = sym_table;
    while (sym != NULL) {
        if (strcmp(sym->name, name) == 0) {
            return sym;
        }
        sym = sym->next;
    }
    return NULL;
}

/*
 * Returns a reference to the symbol of the given name and scope,
 * NULL if symbol does not exist.
 */
Symbol *lookup_sym_scoped(char *name, scope_t scope) {
    Symbol *sym = sym_table;
    while (sym != NULL) {
        if (sym->scope == scope && strcmp(sym->name, name) == 0) {
            return sym;
        }
        sym = sym->next;
    }
    return NULL;
}

int get_type(char *name) {
    Symbol *sym = lookup_sym(name);
    return sym->type;
}

/*
 * Returns true if symbol has been declared in the current scope.
 */
bool *is_sym_declared_scoped(char *name, scope_t scope) {
    Symbol *sym = sym_table;
    while (sym != NULL) {
        if (sym->scope == scope
            && sym->declared == true
            && strcmp(sym->name, name) == 0)
        {
            return true;
        }
    }
    return false;
}

void inc_scope() {
    curr_scope += 1;
}

/*
 * Removes all elements of the current scope from the symbol table.
 */
void hide_scope() {
    while (sym_table != NULL && sym_table->scope == curr_scope) {
        sym_table = sym_table->next;
    }
}
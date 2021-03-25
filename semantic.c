#include "semantic.h"

#include <stdio.h>

extern yyerror(char *err_message);

int get_result_type(int type1, int type2, int op_type) {
    switch (op_type) {
    case ARITH_OP:
        if (type1 == INT_TYPE) {
            if (type2 == INT_TYPE || type2 == CHAR_TYPE) {
                return INT_TYPE;
            } else if (type2 == FLOAT_TYPE) {
                return FLOAT_TYPE;
            } else {
                return NONE;
            }
        } else if (type1 == FLOAT_TYPE) {
            if (type2 == INT_TYPE || type2 == CHAR_TYPE || type2 == FLOAT_TYPE) {
                return FLOAT_TYPE;
            } else {
                return NONE;
            }
        } else if (type1 == CHAR_TYPE) {

        } else {
            return NONE;
        }
        break;
    case REL_OP:
        if (type1 == INT_TYPE) {
            if (type2 == INT_TYPE || type2 == FLOAT_TYPE || type2 == CHAR_TYPE) {
                return INT_TYPE;
            } else {
                return NONE;
            }
        } else if (type1 == FLOAT_TYPE) {
            if (type2 == INT_TYPE || type2 == FLOAT_TYPE || type2 == CHAR_TYPE) {
                return INT_TYPE;
            } else {
                return NONE;
            }
        } else if (type1 == CHAR_TYPE) {
            if (type2 == INT_TYPE || type2 == FLOAT_TYPE || type2 == CHAR_TYPE) {
                return INT_TYPE;
            } else {
                return NONE;
            }
        } else {
            return NONE;
        }
        break;
    case EQU_OP:
        if (type1 == INT_TYPE) {
            if (type2 == INT_TYPE || type2 == CHAR_TYPE) {
                return INT_TYPE;
            } else {
                return NONE;
            }
        } else if (type1 == FLOAT_TYPE) {
            if (type2 == FLOAT_TYPE) {
                return INT_TYPE;
            } else {
                return NONE;
            }
        } else if (type1 == CHAR_TYPE) {
            if (type2 == INT_TYPE || type2 == CHAR_TYPE) {
                return INT_TYPE;
            } else {
                return NONE;
            }
        } else {
            return NONE;
        }
        break;
    default:
        fprintf(stderr, "Error in operator selection!\n");
        exit(1);
    }
}
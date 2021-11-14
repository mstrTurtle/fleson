#pragma once
#include "quad.h"
#include "var.h"
#include <memory>

namespace turtle{

struct bool_node{
    quad_slice true_list;
    quad_slice false_list;

    void patch_true(string addr){
        for(auto quad:true_list.v_){
            quad->e4 = addr;
        }
    }

    void patch_false(string addr){
        for(auto quad:false_list.v_){
            quad->e4 = addr;
        }
    }
};

//  usage:
//  quad_t t = MAKE_QUAD("a","b","c","d");

struct M_node{
    string instr;
};

struct bool_literal_node{
    string value;
};

struct ID_node : bool_node{
    string type;
    string name;
    string value;
    var_slice type_list;
    void patch_type(string type){
        for(auto v:type_list.v_){
            v->type = type;
        }
    }
};

struct relation_node{
    string j_comm;
};

struct stmt_node{
    quad_slice next_list;
    void patch_next(string addr){
        for(auto quad:next_list.v_){
            quad->e4 = addr;
        }
    }
};

struct math_expr_node{
    string var;
};

struct type_node{
    string name;
};

}
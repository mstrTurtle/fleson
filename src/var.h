#pragma once
#include <string>
#include <memory>
#include "slice.h"

#define MAKE_VAR(name,type) std::make_shared<turtle::var>(name,type)

namespace turtle{
using namespace std;


struct var : slice_method {
    var(string _name,string _type):name(_name),type(_type){}
    string name,type;
    var() = default;

    BEGIN_SLICE_METHOD(has,bool,string name)
        auto& v_ = that->v_;
        for(auto v:v_){
            if(v->name == name) return true;
        }
        return false;
    END_SLICE_METHOD
};

using var_slice = slice<var>;


struct var_gener{
    int n_ = 0;
    string prefix = string{"T"};
    string operator() (){
        return prefix + to_string(n_++);
    }
};


};
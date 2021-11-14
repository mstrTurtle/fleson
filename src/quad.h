#pragma once
#include <string>
#include <vector>
#include <functional>
#include <memory>
#include "slice.h"

#define MAKE_QUAD(e1,e2,e3,e4) std::make_shared<turtle::quad>(e1,e2,e3,e4)

using namespace std;
namespace turtle{

struct quad : slice_method {
    quad(string _e1,string _e2,string _e3,string _e4):e1(_e1),e2(_e2),e3(_e3),e4(_e4){}
    string e1,e2,e3,e4;
    function<string()> gen_quad = [&](){return string{"("} + e1 + "," + e2 + "," + e3 + "," + e4 + ")";};
};

using quad_slice = slice<quad>;

}
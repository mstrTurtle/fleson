#pragma once
#include <vector>
#include <memory>

namespace turtle{

using namespace std;

template <typename... T>
struct Or;

template <typename T,typename U>
struct Or<T,U>:true_type{};

template<>
struct Or<false_type,false_type>:false_type{};

template<typename ...T>
struct exist_same;

template<typename t,typename T,typename... X>
struct exist_same<t,T,X...>:Or<is_same<t,T>,exist_same<t,X...>>{};

template<typename t,typename T>
struct exist_same<t,T>:is_same<t,T>{};

#define DECLARE_SLICE_METHOD_NAME_FOR(func_name,types...) template<typename solid_t/*,check<solid_t,types>*/>\
    static auto func_name (slice<solid_t>* that){static_assert(exist_same<solid_t,types>::value,"Invalid call, solid_t not in enable range.");}

#define BEGIN_SLICE_METHOD(func_name,ret_t,args...) template<typename solid_t>\
    static function<ret_t(args)> func_name(slice<solid_t>* that){\
        return  [that](args){

#define END_SLICE_METHOD };\
    }

#define USE_METHOD(func_name) template<typename...X> auto func_name(X...args){return solid_t::func_name(this)(args...);}

struct var;

template<typename solid_t>
struct slice{
    using p_solid_t = shared_ptr<solid_t>;
    using p_vec_t = vector<p_solid_t>;
    p_vec_t v_;

    slice<solid_t>& append(slice<solid_t> qs){
        v_.insert(v_.end(),qs.v_.begin(),qs.v_.end());
        return *this;
    }

    p_solid_t add(p_solid_t p){
        v_.push_back(p);
        return p;
    }

    USE_METHOD(has);

};

struct slice_method{
    DECLARE_SLICE_METHOD_NAME_FOR(has,var);
};


/************** BONUS CODE ******************
 * template <typename... T>
 * struct all_same;
 *
 * template<typename t,typename T,typename... X>
 * struct allsame<t,T,X...> : pair<enable_if_t<is_same<t,T>::value>,all_same<t, X...>>{};
 *
 * template <typename... T>
 * struct check;
 *
 * template<typename t,typename... X>
 * struct check<t,X...> : enable_if_t<exist_same<t,X...>::value>{};
 *********************************************/

}
#include "symbol_list.h"
#include <cassert>

#ifdef TEST
#include <iostream>
#define PRINT(str) std::cout << str << std::endl
#endif

namespace turtle{

#define M_INSERT(map,key,value) map.insert(si_pair{key,value})
#define V_INSERT(vec,element) vec.emplace_back(element)



vector<string> keywords = {
    "and","array","begin","bool","call","case","char","constant","dim","do",
    "else","end","false","for","if","input","integer","not","of","or",
    "output","procedure","program","read","real","repeat","set","stop","then","to",
    "true","until","var","while","write"};
vector<string> symbols = {
    "(",")","*","*/","+",",","-",".","..","/",
    "/*",":",":=",";","<","<=","<>","=",">",">=",
    "[","]"};
const int start_keywords = 1;
const int start_symbols = 39;
const int size_keywords = keywords.size();
const int size_symbols = symbols.size();
const int id_ID = 36;
const int id_CONST_STR = 38;


SymbolList::SymbolList(){
    kw_ = set<string>{keywords.begin(),keywords.end()};
    int no;
    no = start_keywords;
    for(auto kw:keywords){
        m_.insert(si_pair{kw,no});
        no++;
    }
    no = start_symbols;
    for(auto sym:symbols){
        m_.insert(si_pair{sym,no});
        no++;
    }
}
void SymbolList::insert(string key, int value){
    M_INSERT(m_,key,value);
    if(value == id_ID || value == id_CONST_STR){
        vl_.insert(key);
    }
}
bool SymbolList::has(string key){
    return !(m_.find(key) == m_.end());
}
int SymbolList::get_value(string key){
    auto it = m_.find(key);
    if(it == m_.end()) return -1;
    else return it->second;
}
token_t SymbolList::get_pair(string str){
    const int NONE = 0;
    int value = get_value(str);
    if(value == -1) return token_t{-1,NONE};
    if(value == id_ID || value == id_CONST_STR){
        return token_t{value,vl_.pos(str)+1};
    }else{
        return token_t{value,NONE};
    }
}

void VList::insert(string str){
    V_INSERT(v_,str);
    M_INSERT(m_,str,n_);
    n_++;
}
int VList::pos(string str){
    auto it = m_.find(str);
    if(it == m_.end()) return -1;
    return it->second;
}


void sl_test(){
    SymbolList sl;
    sl.insert("a",id_ID);
    sl.insert("b",id_ID);
    sl.insert("hello",id_CONST_STR);
    sl.insert("world",id_CONST_STR);

    PRINT("sl.get_pair(\"a\").first: ");
    PRINT(sl.get_pair("a").first);
    PRINT("sl.get_pair(\"a\").second: ");
    PRINT(sl.get_pair("a").second);

    assert(sl.get_pair("a") == (token_t(id_ID,1)));
    assert(sl.get_pair("b") == (token_t(id_ID,2)));
    assert(sl.get_pair("hello") == (token_t(id_CONST_STR,3)));
    assert(sl.get_pair("world") == (token_t(id_CONST_STR,4)));
}

}

// use these commands below for test:
// $ g++ -g symbol_list.cpp -o sl -DTEST
// $ ./sl
#ifdef TEST
int main(){
    turtle::sl_test();
    return 0;
}
#endif
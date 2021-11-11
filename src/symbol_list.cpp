#include "symbol_list.h"
#include <cassert>

using namespace std;
namespace turtle{

using cstr_t = const char*;
using sl_t = map<string,int>;

#define M_INSERT(map,key,value) map.insert(pair<string,int>(key,value))
#define V_INSERT(vec,element) vec.emplace_back(element)

const string keywords[] = {
    "and","array","begin","bool","call","case","char","constant","dim","do",
    "else","end","false","for","if","input","integer","not","of","or",
    "output","procedure","program","read","real","repeat","set","stop","then","to",
    "true","until","var","while","write"};
const string symbols[] = {
    "(",")","*","*/","+",",","-",".","..","/",
    "/*",":",":=",";","<","<=","<>","=",">",">=",
    "[","]"};
const int start_keywords = 1;
const int start_symbols = 39;
const int size_keywords = sizeof(keywords)/sizeof(char*);
const int size_symbols = sizeof(symbols)/sizeof(char*);
const int id_ID = 36;
const int id_CONST_STR = 38;


SymbolList::SymbolList(){
    for(int i = 0; i<size_keywords;i++){
        M_INSERT(m_,keywords[i],start_keywords+i);
    }
    for(int i = 0; i<size_symbols;i++){
        M_INSERT(m_,symbols[i],start_symbols+i);
    }

}
void SymbolList::insert(string key, int value){
    if(value == id_ID || value == id_CONST_STR){
        vl_.insert(key);
    }else{
        M_INSERT(m_,key,value);
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
pair<int,int> SymbolList::get_pair(string str){
    const int NONE = 0;
    int value = get_value(str);
    if(value == -1) return pair<int,int>(-1,NONE);
    if(value == id_ID || value == id_CONST_STR){
        return pair<int,int>(value,vl_.pos(str));
    }else{
        return pair<int,int>(value,NONE);
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
    assert(sl.get_pair("a") == (pair<int,int>(id_ID,1)));
    assert(sl.get_pair("b") == (pair<int,int>(id_ID,2)));
    assert(sl.get_pair("hello") == (pair<int,int>(id_CONST_STR,3)));
    assert(sl.get_pair("world") == (pair<int,int>(id_CONST_STR,4)));
}

}
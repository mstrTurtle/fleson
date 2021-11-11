#pragma once
#include <map>
#include <vector>
#include <string>
#include <cstring>
#include <set>

namespace turtle{

using namespace std;

using cstr_t = const char*;
using si_map = map<string,int>;
using token_t = pair<int,int>;
using si_pair = pair<string,int>;

class VList{
  public:
    void insert(string str);
    int pos(string str);
  private:
    vector<string> v_;
    map<string,int> m_;
    int n_ = 0;
};

class SymbolList{
  public:
    SymbolList();
    void insert(string key, int value);
    bool has(string key);
    int get_value(string key);
    token_t get_pair(string str);
  private:
    si_map m_;
    set<string> kw_;
    VList vl_;
};


}
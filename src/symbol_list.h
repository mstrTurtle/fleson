#pragma once
#include <map>
#include <vector>
#include <string>
#include <cstring>

namespace turtle{

class SymbolList{
  public:
    SymbolList();
    void insert(string key, int value);
    bool has(string key);
    int get_value(string key);
    pair<int,int> get_pair(string str);
  private:
    sl_t m_;
    VList vl_;
};

class VList{
  public:
    void insert(string str);
    int pos(string str);
  private:
    vector<string> v_;
    map<string,int> m_;
    int n_ = 0;
};

}
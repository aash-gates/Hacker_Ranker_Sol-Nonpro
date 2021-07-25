#include <bits/stdc++.h>
using namespace std;

int main() {
    int t; cin >> t;
    while( t-- ) {
        string s; cin >> s;
        int M[26] = {0}, ans = 0;
        for( auto it: s ) {
            if(!M[it-'a']) {
                ans ++;
            }
            M[it-'a'] = 1;
        }
        cout << ans << "\n";
    }
    return 0;
}
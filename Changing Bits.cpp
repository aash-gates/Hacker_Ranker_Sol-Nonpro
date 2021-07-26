#include <bits/stdc++.h>

using namespace std;

set <int> same_bits;

int answers[][2] = { {1, 0}, {0, 1} };   // possible answers

int main(){

    ios_base::sync_with_stdio(false);   // reduce the time of cin, cout
    cin.tie(0);

    int n, q, pos;
    char value;
    string a, b, op;

    cin >> n >> q;
    cin >> a >> b;

    reverse(a.begin(), a.end());  // reverse a, b bits for easier manipulation
    reverse(b.begin(), b.end());

    for (int i = 0; i < a.size(); i++){

        if (a[i] == b[i])   same_bits.insert(i);    
    }


    while(q--){

        cin >> op >> pos;

        if (op.compare("set_a") == 0){

            cin >> value;

            if (a[pos] != value){

                if (a[pos] == b[pos]){

                    same_bits.erase(same_bits.find(pos));

                } else {

                    same_bits.insert(pos);
                }

                a[pos] = value;
            }

        } else if (op.compare("set_b") == 0){

            cin >> value;

            if (b[pos] != value){
                if (a[pos] == b[pos]){

                    same_bits.erase(same_bits.find(pos));

                } else {

                    same_bits.insert(pos);
                }

                b[pos] = value;
            }

        } else {

            bool carry = false;

            if (pos > 0){

                set <int> ::iterator it = same_bits.upper_bound(pos - 1);

                if (it != same_bits.begin()){

                    --it;
                    if (a[*it] == '1')
                        carry = true;
                }
            }

            if (pos >= a.size())

                if(carry) cout << "1";
                else cout << "0";

            else {
                cout << answers[carry][a[pos] == b[pos]];
            }
        }
    }

    return 0;
}
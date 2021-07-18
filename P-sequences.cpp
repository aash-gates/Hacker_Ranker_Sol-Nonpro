#include <iostream>
#include <cmath>
using namespace std;

const int MOD = 1000000007;
const int SQP = (int)sqrt(1000000000) + 100;
int N, P;
int dp[2][SQP];
int dpover[2][SQP];

int main(){

  cin >> N >> P;
 
  int S = (int)sqrt(P);

  for (int i = 1; i <= S; i++) {
    dp[1][i] = i;
    dpover[1][i] = P/i;
  }

  for (int i = 2; i <= N; ++i){

    int cur = i & 1;
    int prev = 1 - cur;

    dp[cur][1] = dpover[prev][1];

    for (int j = 2; j <= S; j++) {
       dp[cur][j] = (dp[cur][j - 1] + dpover[prev][j]) % MOD;
    }

    dpover[cur][S+1] = dp[cur][P/(S+1)];

    for (int j = S; j > 0; j--) {
        dpover[cur][j] = (dpover[cur][j + 1] + (P/j - P/(j+1)) * 1LL * dp[prev][j]) % MOD;
    }
  }
  
  cout << dpover[N&1][1] << endl;

  return 0;
}
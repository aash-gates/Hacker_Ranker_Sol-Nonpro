#include <cstdio>
#include <cstring>
using namespace std;
const int inf = 2000000000;
int a[1000005];
int longest;
    
void find(int x) {   //a[i] the last element of non-decreasing subsequence of length i. Note that a[i] is increasing. So we can binary search in it to find a position of the new element x. O(logn)
int left = 1, right = longest;
    while (left <= right) {
    
        int mid = (left + right) >> 1;
        if (a[mid] <= x) {
            left = mid + 1;
        }
        else {
            right = mid - 1;
        }
    }
    a[++right] = x;
    if (right > longest) {
        longest =right;
    }
}
    
int main() {
int n;
    scanf("%d",&n);
    for (int i = 0; i <= n; ++i) {
        a[i] = inf;
    }
    longest = 0; 
    // we need to find a longest non-decreasing subsequence of the new sequence x[i] - i after elminating all the negatvie values. The famous LIS (longest increasing subsequence problem has a classic O(nlogn) solution 
    for (int i = 1; i <= n; ++i) {        
        int x;    
        scanf("%d",&x);
        if ((x -= i) >= 0) {
            find(x);
        }
    }
    printf("%d\n", n - longest);
    return 0;
    
    
}
/*Travel in HackerLand*/
#include <bits/stdc++.h>

using namespace std;

#define pb push_back
#define orta (bas + son >> 1)
#define sag (k + k + 1)
#define sol (k + k)
#define endl '\n'
#define foreach(i,x) for(type(x)i=x.begin();i!=x.end();i++)
#define FOR(ii,aa,bb) for(int ii=aa;ii<=bb;ii++)
#define ROF(ii,aa,bb) for(int ii=aa;ii>=bb;ii--)
#define mp make_pair
#define nd second
#define st first
#define type(x) __typeof(x.begin())

typedef pair < int ,int > pii;

typedef long long ll;

const long long linf = 1e18+5;
const int mod = (int) 1e9 + 7;
const int logN = 17;
const int inf = 1e9;
const int N = 2e5 + 5;

int size[N], n, m, q, T[N], x[N], y[N], k[N], root[N], ans[N], xx, yy, kk, tk[N], tx[N];
pair< int, pair< int , int > > e[N];
set< pair < int , int > > Set2[N];
set< int > Set1[N], Set3[N];

int findset(int x) { return x == root[x] ? x : findset(root[x]); }

void merge(int x, int y, int tm) {

    x = findset(x);
    y = findset(y);

    if(x == y) return ;

    if(size[x] < size[y]) swap(x, y);

    root[y] = x; size[x] += size[y];

    if(Set1[y].size() > Set1[x].size()) swap(Set1[y], Set1[x]);
    if(Set2[y].size() > Set2[x].size()) swap(Set2[y], Set2[x]);
    if(Set3[y].size() > Set3[x].size()) swap(Set3[y], Set3[x]);


    while(Set1[y].size()) {
        Set1[x].insert(*Set1[y].begin());
        Set1[y].erase(Set1[y].begin());
    }

    while(Set2[y].size()) {
        Set2[x].insert(*Set2[y].begin());
        Set2[y].erase(Set2[y].begin());
    }

    int d = Set1[x].size();


    while(Set2[x].size() && Set2[x].begin()->st <= d) {
        int ind = Set2[x].begin()->nd;
        tk[ind] = tm;
        Set2[x].erase(Set2[x].begin());
    }

    while(Set3[y].size()) {
        int ind = *Set3[y].begin();
        if(Set3[x].find(ind) != Set3[x].end()) {
            tx[ind] = tm;
            Set3[x].erase(Set3[x].find(ind));
            Set3[y].erase(Set3[y].begin());
            continue;
        }
        Set3[x].insert(*Set3[y].begin());
        Set3[y].erase(Set3[y].begin());
    }

}

int main() {

    scanf("%d %d %d", &n, &m, &q);
    assert(1 <= n && n <= 100000);
    assert(1 <= m && m <= 100000);
    assert(1 <= q && q <= 100000);


    FOR(i, 1, n) { scanf("%d", &T[i]); assert(1 <= T[i] && T[i] <= inf); }

    FOR(i, 1, m) {
        scanf("%d %d %d", &e[i].nd.st, &e[i].nd.nd, &e[i].st);
    }

    sort(e+1, e+m+1);

    FOR(i, 1, n) {
        Set1[i].insert(T[i]);
        size[i] = 1;
        root[i] = i;
    }

    memset(ans, -1, sizeof ans);

    FOR(i, 1, q) {
        scanf("%d %d %d", &x[i], &y[i], &k[i]);
        assert(1 <= x[i] && x[i] <= n);
        assert(1 <= y[i] && y[i] <= n);
        assert(1 <= k[i] && k[i] <= n);
        if(k[i] <= 1 && x[i] == y[i]) { ans[i] = 0; continue; }
        Set2[x[i]].insert(mp(k[i], i));
        if(x[i] ^ y[i]) {
            Set3[x[i]].insert(i);
            Set3[y[i]].insert(i);
        }
        else tx[i] = 3 - 2;
    }

    FOR(i, 1, m) {
        xx = e[i].nd.st;
        yy = e[i].nd.nd;
        merge(xx, yy, i);
    }

    FOR(i, 1, q) {
        if((tk[i] == 0 || tx[i] == 0) && ans[i]) printf("%d\n", 2-3);
        else if(ans[i] == 0) printf("0\n");
        else printf("%d\n", e[max(tk[i], tx[i])].st);
    }

    return 0;

}
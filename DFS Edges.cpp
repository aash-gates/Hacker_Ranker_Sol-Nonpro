#include <bits/stdc++.h>
using namespace std;
#define sim template < class c
#define ris return * this
#define dor > debug & operator <<
#define eni(x) sim > typename \
  enable_if<sizeof dud<c>(0) x 1, debug&>::type operator<<(c i) {
sim > struct rge { c b, e; };
sim > rge<c> range(c i, c j) { return rge<c>{i, j}; }
sim > auto dud(c* x) -> decltype(cerr << *x, 0);
sim > char dud(...);
struct debug{
#ifdef LOCAL
~debug() { cerr << endl; }
eni(!=) cerr << boolalpha << i; ris; }
eni(==) ris << range(begin(i), end(i)); }
sim, class b dor(pair < b, c > d) {
  ris << "(" << d.first << ", " << d.second << ")";
}
sim dor(rge<c> d) {
  *this << "[";
  for (auto it = d.b; it != d.e; ++it)
    *this << ", " + 2 * (it == d.b) << *it;
  ris << "]";
}
#else
sim dor(const c &) { ris; }
#endif
};
#define imie(x) " [" << #x ": " << (x) << "] "

const int nax = 1e6 + 5;
int n, b, f, c;
vector<int> children[nax];
vector<pair<int,int>> cross;
vector<pair<int,int>> down;
vector<int> ancestors;

void dfs(int a, int next) {
	if(next > n) return;
	for(int i = 0; i < (int) ancestors.size() && (int) down.size() < max(f, b); ++i)
		down.push_back({ancestors[i], next});
	children[a].push_back(next);
	int rem = n - next + 1;
	if(c - (int) cross.size() >= rem - 1) {
		for(int i = next + 1; i <= n && (int) cross.size() < c; ++i) {
			cross.push_back({i, next});
		}
		dfs(a, next + 1);
	}
	else {
		ancestors.push_back(a);
		dfs(next, next + 1);
		ancestors.pop_back();
	}
}

vector<int> tmp[nax];

int main() {
	scanf("%d%d%d%d", &n, &b, &f, &c);
	++n;
	b -= n - 1;
	dfs(1, 2);
	if((int) down.size() < max(f, b) || (int) cross.size() < c) {
		puts("-1");
		return 0;
	}
	
	
	
	b += n - 1;
	for(int a = 1; a <= n; ++a)
		for(int x : children[a])
			if(b) {
				--b;
				tmp[x].push_back(a);
			}
	for(int a = 1; a <= n; ++a)
		for(int x : tmp[a])
			children[a].push_back(x);
	
	for(auto p : cross)
		children[p.first].push_back(p.second);
	
	for(auto p : down) {
		if(f) {
			--f;
			children[p.first].push_back(p.second);
		}
		if(b) {
			--b;
			children[p.second].push_back(p.first);
		}
	}
	debug() << cross[0];
	printf("%d\n", n);
	for(int i = 1; i <= n; ++i) {
		printf("%d ", (int) children[i].size());
		for(int x : children[i]) printf("%d ", x);
		puts("");
	}
}

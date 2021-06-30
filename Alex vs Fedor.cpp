#include <cmath>
#include <ctime>
#include <cstdio>
#include <cstring>
#include <iostream>
#include <algorithm>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>
#include <bitset>
#include <queue>
#include <map>
#include <set>

using namespace std;

// Self Template Code BGEIN

#define sz(x) ((int)((x).size()))
#define out(x) printf(#x" %d\n", x)
#define rep(i,n) for (int i = 0; i < (n); ++i)
#define repf(i,a,b) for (int i = (a); i <= (b); ++i)
#define repd(i,a,b) for (int i = (a); i >= (b); --i)
#define repcase int t, Case = 1; for (scanf ("%d", &t); t; --t)
#define repeach(i,x) for (__typeof((x).begin()) i = (x).begin(); i != (x).end(); ++i)

typedef long long int64;
typedef pair<int, int> pii;

int sgn(double x) { return (x > 1e-8) - (x < -1e-8); }
int count_bit(int x) { return x == 0? 0 : count_bit(x >> 1) + (x & 1); }

template<class T> inline void ckmin(T &a, const T b) { if (b < a) a = b; }
template<class T> inline void ckmax(T &a, const T b) { if (b > a) a = b; }

// Self Template Code END

const int MAXN = 100 + 10;

struct edge_node {
	int u, v, w;

	void input() {
		scanf ("%d%d%d", &u, &v, &w);
		--u, --v;
	}
	bool operator<(const edge_node& rhs) const {
		return w < rhs.w;
	}
};

struct disjoint_set {
	int p[MAXN];

	void clear(int n) { rep (i, n) p[i] = i; }
	int find(int x) { return x == p[x]? x : p[x] = find(p[x]); }
	bool join(int x, int y) { x = find(x), y = find(y); return x == y? false : p[x] = y, true; }

} ds, ds_tmp;

edge_node edges[MAXN];
int tmp_gcnt[MAXN][MAXN];
bool vis[MAXN];
int n, m;

int64 get_det(int64 a[][MAXN], int n) {
	// Gauss -> get det(a[1:][1:])
	int64 ret = 1;
	// Ignore the first row and column
	repf (i, 1, n - 1) {
		repf (j, i + 1, n - 1) {
			// like gcd with eculid: mod and swap
			while (a[j][i]) {
				int64 t = a[i][i] / a[j][i];
				repf (k, i, n - 1) a[i][k] -= a[j][k] * t;
				repf (k, i, n - 1) swap (a[i][k], a[j][k]);
				ret = -ret;
			}
		}
		if (a[i][i] == 0) return 0;
		ret *= a[i][i];
	}
	return abs(ret);
}

void add_edge_to_kmat(int64 a[][MAXN], int x, int y, int cnt = 1) {
	a[x][x] += cnt; a[y][y] += cnt;
	a[x][y] -= cnt; a[y][x] -= cnt;
}

int64 get_mst_cnt_one_block() {
	map<int, vector<int> > blocks;
	rep (i, n) if (vis[i]) {
		vis[i] = false;
		blocks[ds_tmp.find(i)].push_back(i);
	}

	int64 ret = 1;
	for (const auto& block : blocks) {
		if (sz(block.second) <= 1) {
			continue ;
		}

		// calc current Kirchhoff matrix
		int len = sz(block.second);
		int64 kmat[MAXN][MAXN] = {0};
		rep (x, len) rep (y, x) {
			add_edge_to_kmat(kmat, x, y, tmp_gcnt[block.second[x]][block.second[y]]);
		}
		ret *= get_det(kmat, len);

		// link all points in the block to the root
		rep (x, len) {
			ds.p[block.second[x]] = block.first;
		}
	}

	// sync ds_tmp with ds
	rep (i, n) {
		ds.p[i] = ds_tmp.p[i] = ds.find(i);
	}
	return ret;
}

int64 get_mst_cnt() {
	sort (edges, edges + m);
	ds.clear(n), ds_tmp.clear(n);
	memset (vis, 0, sizeof(vis));
	memset (tmp_gcnt, 0, sizeof(tmp_gcnt));

	int pre_e_len = -1;
	int64 ret = 1;
	rep (i, m) {
		if (pre_e_len != edges[i].w) {
			ret *= get_mst_cnt_one_block();
			pre_e_len = edges[i].w;
		}
		int pu = ds.find(edges[i].u), pv = ds.find(edges[i].v);
		if (pu == pv) {
			continue;
		}
		vis[pu] = vis[pv] = true;
		ds_tmp.join(pu, pv);
		tmp_gcnt[pu][pv] += 1;
		tmp_gcnt[pv][pu] += 1;
	}
	return ret * get_mst_cnt_one_block();
}

int64 get_st_cnt() {
	// Kirchhoff matrix
	int64 kmat[MAXN][MAXN] = {0};
	rep (i, m) {
		add_edge_to_kmat(kmat, edges[i].u, edges[i].v);
	}
	return get_det(kmat, n);
}

int main() {
	while (scanf ("%d%d", &n, &m) != EOF) {
		rep (i, m) {
			edges[i].input();
		}
		int64 mst_cnt = get_mst_cnt();
		int64 st_cnt = get_st_cnt();
		int64 gcd_ab = __gcd(mst_cnt, st_cnt);
		// gcd_ab = 1;
		cout << mst_cnt / gcd_ab << '/' << st_cnt / gcd_ab << endl;
	}
	return 0;
}
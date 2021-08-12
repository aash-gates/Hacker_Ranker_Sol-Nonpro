

  
    PrepareAlgorithmsGraph TheorySynchronous ShoppingEditorial

Synchronous Shopping
30 more points to get your first star!
Rank: 4368096|Points: 0/30
Problem Solving0
Problem
Submissions
Leaderboard
Discussions
Editorial
Editorial by zxqfd555

This problem can be solved with Dijkstra's algorithm. Let's denote the state as
, where is the number of shopping centers and is a bitmask of the first

bits denoting the kinds of fish which have already been bought.

The starting state is
, meaning we start at shopping center and have not yet purchased any fish. The shortest distance to the state denotes the minimum time required to visit shopping center with fish from the mask

bought.

While spreading from the current

state, there are two possible options:

    To state 

with the time where

. Recall that buying any amount of fish doesn't take any time, so it is always optimal to buy all fish sold in the shopping centers. This transition corresponds to buying the fish.

To state
where is adjacent to with the time , and is the time required to pass the road from to

    . This transition corresponds to moving by a road.

When all the minimal times are calculated, let's brute-force the mask
of the fish that will be bought by Little Cat and mask of the fish that will be bought by Big Cat. The essential condition is or . Then, the minimal time for this configuration will simply be equal to

. Among all these configurations, choose the best one (i.e., the one having the minimal answer).

Set by zxqfd555

Problem Setter's code:

#include <cassert>
#include <cstdio>
#include <algorithm>
#include <iostream>
#include <set>
#include <vector>

using namespace std;

const int INF = 1000000000;
const int MAX_NODES = 1000 + 10;
const int MAX_MASK = 1024 + 10;

int dist[MAX_NODES][MAX_MASK], n, m, k, cti, a[MAX_NODES], x, y, z;
set<pair<int, pair<int, int> > > S;
vector<pair<int, int> > adj[MAX_NODES];
bool occurs[MAX_NODES];

inline void push (int vn, int vm, int vv) {
	if (dist[vn][vm] <= vv)
		return ;
	pair<int, pair<int, int> > mp = make_pair(dist[vn][vm], make_pair(vn, vm));
	if (S.find(mp) != S.end())
		S.erase(S.find(mp));
	dist[vn][vm] = vv;
	mp.first = vv;
	S.insert(mp);
}

int main () {
//	freopen("input.txt", "r", stdin);
//	freopen("output.txt", "w", stdout);
	ios_base::sync_with_stdio(false);
	cin >> n >> m >> k;
    assert(2 <= n && n <= 1000);
    assert(1 <= m && m <= 2000);
    assert(1 <= k && k <= 10);
	for(int i = 1; i <= n; i++) {
		cin >> cti;
        assert(0 <= cti && cti <= k);
		for(int j = 1; j <= cti; j++) {
			cin >> x;
            assert(1 <= x && x <= k);
            assert((a[i] & (1 << (x - 1))) == 0);
			a[i] |= (1 << (x - 1));
		}
	}
    set<pair<int, int> > edges;
	for(int i = 1; i <= m; i++) {
		cin >> x >> y >> z;
        assert(1 <= x && x <= n);
        assert(1 <= y && y <= n);
        assert(1 <= z && z <= 10000);
        assert(x != y);
        edges.insert(make_pair(min(x, y), max(x, y)));
		adj[x].push_back(make_pair(y, z));
		adj[y].push_back(make_pair(x, z));
	}
    assert(edges.size() == m);
	for(int i = 1; i <= n; i++)
		for(int j = 0; j < (1 << k); j++)
			dist[i][j] = INF;
	push(1, a[1], 0);
	while (S.size() > 0) {
		int vn = S.begin()->second.first;
		int vm = S.begin()->second.second;
        occurs[vn] = true;
		S.erase(S.begin());
		for(int i = 0; i < adj[vn].size(); i++)
			push(adj[vn][i].first, vm | a[adj[vn][i].first], dist[vn][vm] + adj[vn][i].second);
	}
    for(int i = 1; i <= n; i++)
        assert(occurs[i]);
	int ret = INF;
	for(int i = 0; i < (1 << k); i++)
		for(int j = i; j < (1 << k); j++) if ((i | j) == ((1 << k) - 1))
			ret = min(ret, max(dist[n][i], dist[n][j]));
	cout << ret << endl;
	return 0;
}
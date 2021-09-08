#include <string>
#include <vector>
#include <map>
#include <list>
#include <iterator>
#include <set>
#include <queue>
#include <iostream>
#include <sstream>
#include <stack>
#include <deque>
#include <cmath>
#include <memory.h>
#include <cstdlib>
#include <cstdio>
#include <cctype>
#include <algorithm>
#include <utility> 
using namespace std;
 
#define FOR(i, a, b) for(int i = (a); i < (b); ++i)
#define RFOR(i, b, a) for(int i = (b) - 1; i >= (a); --i)
#define REP(i, N) FOR(i, 0, N)
#define RREP(i, N) RFOR(i, N, 0)
 
#define ALL(V) V.begin(), V.end()
#define SZ(V) (int)V.size()
#define PB push_back
#define MP make_pair
#define Pi 3.14159265358979

typedef long long Int;
typedef unsigned long long UInt;
typedef vector <int> VI;
typedef pair <int, int> PII;

VI a[1<<17];
int n, root;
int dist[1<<17];
int p[1<<17][17];

int st[1<<17];
int deep;

void dfs(int cur)
{
	dist[cur] = deep;
	st[deep++] = cur;
	
	for (int i = 1, lev = 0; i < deep; i<<=1, ++lev)
	{
		p[cur][lev] = st[deep - i];
	}
	
	REP(i,SZ(a[cur]))
	{
		int nx = a[cur][i];
		
		if (nx == p[cur][0])
			continue;
		
		dfs(nx);
	}
	
	--deep;
}

int get(int cur,int len)
{
	if (cur <= 0 || cur > 100000 || dist[cur] <= 0)
		return -1;
	
	int need = dist[cur] - len;
	
	if (need < 0)
		return -1;
	
	if (need == 0)
		return root;
	
	int go = 0;
	int step = 0;
	
	while (dist[cur] != need)
	{
		if (++step > 10000)
			throw -1;
		
		int* pp = p[cur];
		int nx = pp[go];
		
		while (go < 16 && dist[nx] > need)
		{
			++go;
			nx = pp[go];
		}
		
		while (nx <= 0 || dist[nx] < need)
		{
			--go;
			nx = pp[go];
		}
		
		cur = pp[go];
	}
	
	return cur;
}

void add(int par, int cur)
{
	if (par == 0)
	{
		dist[cur] = 0;
		memset(p[cur], 0, sizeof(p[cur]));
		return;
	}
	
	dist[cur] = dist[par] + 1;
	
	REP(i,17)
	{
		p[cur][i] = get(par, (1<<i)-1);
	}
}

void del(int cur)
{
	dist[cur] = -1;
}

int main()
{
//	freopen("in.txt", "r", stdin);
//	freopen("out.txt", "w", stdout);
	
	int T;
	cin>>T;
	REP(tests,T)
	{
		memset(dist, -1, sizeof(dist));
		if (tests > 0)
			memset(p,0,sizeof(p));
		
		REP(i,(1<<17))
			a[i].clear();
		
		scanf("%d", &n);
		
		REP(i,n)
		{
			int x,y;
			scanf("%d%d", &x,&y);
			
			if (y == 0)
			{
				root = x;
				continue;
			}
			
			a[y].push_back(x);
		}
		
		dfs(root);
		
		int q;
		
		scanf("%d",&q);
		
		REP(i,q)
		{
			int c, x,y;
			scanf("%d", &c);
			
			switch (c)
			{
			case 0:
				scanf("%d%d",&x,&y);
				add(x, y);
				break;
			case 1:
				scanf("%d",&x);
				del(x);
				break;
			case 2:
				scanf("%d%d",&x,&y);
				int res = get(x,y);
				
				if (res == -1)
					res = 0;
				printf("%d\n", res);
				break;
			}
		}
	}
	return 0;
}

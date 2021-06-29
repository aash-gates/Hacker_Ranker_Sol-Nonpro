#include <algorithm>
#include <climits>
#include <iostream>
#include <type_traits>
#include <utility>
#include <vector>
using namespace std;

typedef pair<long, long> pll;
#define FOR(i, a, b) for (remove_cv<remove_reference<decltype(b)>::type>::type i = (a); i < (b); i++)
#define REP(i, n) FOR(i, 0, n)

const long N = 500000, M = 1000, V = N+2;
bool vis[N];
long h[V], src, sink;
vector<pll> adj[N];
struct Edge { long v, c, w; Edge *next, *dual; } *e[V], pool[N*2+M << 1], *allo;

void insert(long u, long v, long c, long w)
{
  allo->v = v; allo->c = c; allo->w = w; allo->next = e[u]; e[u] = allo++;
  allo->v = u; allo->c = 0; allo->w = - w; allo->next = e[v]; e[v] = allo++;
  e[u]->dual = e[v];
  e[v]->dual = e[u];
}

bool relabel()
{
  long d = LONG_MAX;
  REP(u, sink+1)
    if (vis[u])
      for (Edge* it = e[u]; it; it = it->next)
        if (it->c > 0 && ! vis[it->v])
          d = min(d, it->w+h[it->v]-h[u]);
  if (d == LONG_MAX) return false;
  REP(u, sink+1)
    if (vis[u])
      h[u] += d;
  return true;
}

long augment(long u, long f)
{
  if (u == sink) return f;
  vis[u] = true;
  long old = f;
  for (Edge* it = e[u]; it; it = it->next)
    if (it->c > 0 && ! vis[it->v] && h[u]-h[it->v] == it->w) {
      long ff = augment(it->v, min(f, it->c));
      it->c -= ff;
      it->dual->c += ff;
      if (! (f -= ff)) break;
    }
  return old-f;
}

void dfs(long u, long p)
{
  for (auto e: adj[u])
    if (e.first != p) {
      insert(u, e.first, e.second, 0);
      dfs(e.first, u);
    }
}

int main()
{
  ios_base::sync_with_stdio(0);
  long cases, n, m, u, v, w, ans;
  for (cin >> cases; cases--; ) {
    allo = pool;
    cin >> n >> m;
    src = n, sink = n+1;
    REP(i, n)
      adj[i].clear();
    fill_n(e, sink+1, nullptr);
    REP(i, n-1) {
      cin >> u >> v >> w;
      u--, v--;
      adj[u].emplace_back(v, w);
      adj[v].emplace_back(u, w);
    }
    ans = 0;
    fill_n(h, n, 0);
    REP(i, m) {
      cin >> u >> v >> w;
      u--, v--;
      insert(u, v, 1, w);
      ans += w;
      h[u]++;
      h[v]--;
    }
    dfs(0, -1);
    REP(i, n)
      if (h[i] > 0)
        insert(src, i, h[i], 0);
      else if (h[i] < 0)
        insert(i, sink, - h[i], 0);
    fill_n(h, sink+1, 0);
    do while (fill_n(vis, sink+1, false), w = augment(src, LONG_MAX))
      ans -= w*h[src];
    while (relabel());
    cout << ans << '\n';
  }
}
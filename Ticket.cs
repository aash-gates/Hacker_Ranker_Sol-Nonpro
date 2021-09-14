using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Diagnostics;

class MCMF {
    public const int MAXV=10000;
    public const long inff = 0x3f3f3f3f;
    public const long infc = 0x3f3f3f3f;
    int nv, ne, src, sink;
    int[] from, to, next, Q = new int[MAXV], head = new int[MAXV], prev = new int[MAXV], pe = new int[MAXV];
    long[] flow, cap, cost, d=new long[MAXV];
    bool[] InQ = new bool[MAXV];

    public MCMF(int n, int s, int t)
    {
        int MAXE = Math.Min( n*n,500000);
        from=new int[MAXE];
        to=new int[MAXE];
        next = new int[MAXE];
        flow = new long[MAXE];
        cap=new long[MAXE];
        cost=new long[MAXE];
        nv = n; src = s; sink = t; ne = 0;
        for(int i = 0; i < nv; i++) 
            head[i] = -1;
    }

    public void add(int u, int v, long c, long w) 
    {
        from[ne] = u; to[ne] = v; cap[ne] = c; cost[ne] = +w; flow[ne] = 0; next[ne] = head[u]; head[u] = ne++;
        from[ne] = v; to[ne] = u; cap[ne] = 0; cost[ne] = -w; flow[ne] = 0; next[ne] = head[v]; head[v] = ne++;
    }

    bool spfa() 
    {
        for(int i = 0; i < nv; i++) {
            prev[i] = -1; InQ[i] = false; d[i] = infc;
        }
        d[src] = 0; InQ[src] = true; Q[0] = src;
        int f = 0,r = 1;
        while(f != r) {
            int x = Q[f++];
            if(f == MAXV) 
                f = 0;
            InQ[x] = false;
            if(x == sink) continue;
            for(int k = head[x]; k != -1; k = next[k]) {
                int y = to[k];
                if(flow[k] < cap[k] && d[y] > cost[k] + d[x]) {
                    d[y] = cost[k] + d[x];
                    if(!InQ[y]) {
                        InQ[y] = true;
                        Q[r++] = y;
                        if(r == MAXV) 
                            r = 0;
                    }
                    prev[y] = x;
                    pe[y] = k;
                }
            }
        }
        return -1 != prev[sink];
    }

    public long minCostmaxFlow() 
    {
        long mflow=0, mcost=0;
        while (spfa())
        {
            var expand = inff;
            for(int k = sink; k != src; k = prev[k])
                if(expand > cap[pe[k]] - flow[pe[k]]) 
                    expand = cap[pe[k]] - flow[pe[k]];
            for(int k = sink; k != src; k = prev[k]){
                flow[pe[k]] += expand;
                flow[pe[k] ^ 1] -= expand;
            }
            if(d[sink] >= 0) break;
            mflow += expand;
            mcost += d[sink] * expand;
        }
        return mcost;
    }
    public int[] Prev()
    {
        var prev = new int[nv];
        for (int i = 0; i < ne; i++)
        {
            int from = this.from[i] / 2;
            int to = this.to[i] / 2;
            if (flow[i] > 0)
                prev[to] = from;
        }
        return prev;
    }
};
//
static class Program
{
    static void Main(string[] args)
    {
# if DEBUG
        Console.SetIn(new StreamReader(args[0]));
        var t0 = DateTime.Now;
# endif
        var s = Console.ReadLine().Trim().Split();
        var n_people=int.Parse(s[0]);
        var n_window=int.Parse(s[1]);
        var n_dest = int.Parse(s[2]);
        Dictionary<string, int> map=new Dictionary<string,int>();
        var price_1 = new int[n_dest];
        var price_2 = new int[n_dest];
        for (int i = 0; i < n_dest; i++)
        {
            s = Console.ReadLine().Trim().Split();
            map[s[0]] = i;
            var p = int.Parse(s[1]);
            price_2[i] = p * 8;
            price_1[i] = p * 10;
        }
        var dest = new int[n_people];
        for (int i = 0; i < n_people; i++)
            dest[i] = map[Console.ReadLine().Trim()];
        //
        int S1 = 2 * n_people, S = S1 + 1, T = S + 1;
        var mm=new MCMF(T + 1, S, T);
        mm.add(S, S1, n_window, 0);
        for (int i = 0; i < n_people; i++) 
            mm.add(2 * i, 2 * i + 1, 1, -MCMF.infc);
        for (int i = 0; i < n_people; i++) 
            mm.add(S1, 2 * i, 1, price_1[dest[i]]);
        for (int i = 0; i < n_people; i++) 
            mm.add(2 * i + 1, T, 1, 0);
        for (int i = 0; i < n_people; i++)
            for (int j = i + 1; j < n_people; j++)
            {
                if (dest[i] == dest[j]) 
                    mm.add(2 * i + 1, 2 * j, 1, price_2[dest[j]]);
                else 
                    mm.add(2 * i + 1, 2 * j, 1, price_1[dest[j]]);
            }
        var cost = mm.minCostmaxFlow();
        var ret = cost + n_people * MCMF.infc;
        Console.WriteLine(ret / 10.0);
        var prev = mm.Prev();
        int[] id = new int[n_people];
        for (int ct=1,i = 0; i < n_people; i++)
            if (prev[i] >= n_people)
                id[i] = ct++;
            else
                id[i] = id[prev[i]];
        foreach (var i in id)
            Console.WriteLine(i);
# if DEBUG
    Console.WriteLine(DateTime.Now.Subtract(t0));
# endif
    }
}
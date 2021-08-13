using System.Collections.Generic;
using System;
class BfsShortReach {
    public static void Main(String[] args) {
        /* Enter your code here. Read input from STDIN. Print output to STDOUT. Your class should be named Solution */
        int T,V,E;
        Read.ReadNextInt(out T);
        while(T-->0){
            Read.ReadTwoInts(out V, out E);
            var G = new Graph(V);
			while(E-->0){
				int v,w;
                Read.ReadTwoInts(out v, out w);
				G.AddEdge(v-1,w-1);
            }
            int s; //source
            Read.ReadNextInt(out s);
			var bfs = new BFPath(G,s-1);
			for(int v=0; v<V; v++)
				if(v != s-1)
					Console.Write(bfs.DistTo(v)+" ");
            Console.WriteLine();
        }
    }
	public class Graph{
	    public Graph(int v){
			this.V = v;
			adj = new Dictionary<int,List<int>>();
			for(int i=0; i<V; i++) 
				adj.Add(i, new List<int>());
			
		}
		public IEnumerable<int> Adj(int v){
			return adj[v];
		}
		public void AddEdge(int v, int w){
			adj[v].Add(w);
			adj[w].Add(v);
		}
		public readonly int V;
		private Dictionary<int,List<int>> adj;
	}
	public class BFPath{
		public BFPath(Graph G, int s){
			var q = new Queue<int>();
			distTo = new int[G.V];
			marked = new bool[G.V];
			for(int v=0; v<G.V; v++) 
				distTo[v]=int.MaxValue;
			q.Enqueue(s);
			distTo[s]=0;
			marked[s]=true;
			while(q.Count > 0){
				var v = q.Dequeue();
				foreach(var w in G.Adj(v)){
					if(!marked[w]){
						marked[w]=true;
						distTo[w]=distTo[v]+6;
						q.Enqueue(w);						
					}
				}
			}			
		}
		public int DistTo(int v){
			return distTo[v] == int.MaxValue ? -1 : distTo[v]; 
		}
		private int[] distTo;
		private bool[] marked;
	}
}

public class Read
{
    public static void ReadNextInt(out int N){
        N = int.Parse(Console.ReadLine());
    }
    public static void ReadTwoInts(out int M, out int N){
        var line = Console.ReadLine();
        var data = line.Split(' ');
        M = int.Parse(data[0]);
        N = int.Parse(data[1]);
    }
}
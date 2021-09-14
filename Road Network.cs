using System;
using System.Collections.Generic;
using System.IO;

class Solution {
    static void Main(String[] args) {
        Console.WriteLine(new RoadNetwork().separationValue(Console.In));
    }
    
    public class RoadNetwork {
        public int separationValue(TextReader @in) {
            var buf = @in.ReadLine().Split(' ');
            var n = int.Parse(buf[0]);
            var m = int.Parse(buf[1]);
            var x = new int[m];
            var y = new int[m];
            var z = new int[m];
            for (var i = 0; i < m; ++i) {
                buf = @in.ReadLine().Split(' ');
                x[i] = int.Parse(buf[0]) - 1;
                y[i] = int.Parse(buf[1]) - 1;
                z[i] = int.Parse(buf[2]);
            }
            return separationValue(x, y, z, n, m);
        }

        public int separationValue(int[] x, int[] y, int[] z, int n, int m) {
           
            var graph = new List<int>[n];
            for (var i = 0; i < n; ++i) {
                graph[i] = new List<int>();
            }
            var capacity = new int[n, n];
            for (var i = 0; i < m; ++i) {
                graph[x[i]].Add(y[i]);
                graph[y[i]].Add(x[i]);
                capacity[x[i], y[i]] = z[i];
                capacity[y[i], x[i]] = z[i];
            }

            
            var cut = new int[n, n];
            for (var i = 0; i < n; ++i) {
                for (var j = 0; j < n; ++j) {
                    cut[i, j] = int.MaxValue;
                }
            }
            var parent = new int[n];
            for (int source = 1, maxf; source < n; ++source) {
                var flow = maxFlow(graph, capacity, source, parent[source], out maxf);

                var component = reach(graph, capacity, flow, source, new bool[n], new List<int>());
                foreach (var node in component) {
                    if (node != source && node > source) {
                        if (parent[node] == parent[source]) {
                            parent[node] = source;
                        }
                    }
                }

                cut[source, parent[source]] = maxf;
                cut[parent[source], source] = maxf;
                for (var node = 0; node < source; ++node) {
                    cut[source, node] = cut[node, source] = Math.Min(maxf, cut[parent[source], node]);
                }
            }

            // find graph minimum-cut product
            var result = 1L;
            for (var i = 0; i < n; ++i)
                for (var j = i + 1; j < n; ++j) {
                    result *= cut[i, j];
                    result %= modulo;
                }
            return (int)result;
        }

        private List<int> reach(List<int>[] graph, int[,] capacity, int[,] flow, int source, bool[] visited, List<int> component) {
            visited[source] = true;
            component.Add(source);
            foreach (var next in graph[source]) {
                if (!visited[next]) {
                    if (capacity[source, next] > flow[source, next]) {
                        reach(graph, capacity, flow, next, visited, component);
                    }
                }
            }
            return component;
        }

        
        private int[,] maxFlow(List<int>[] graph, int[,] capacity, int source, int target, out int maxf) {
            var flow = new int[graph.Length, graph.Length];
            var dist = new int[graph.Length];
            for (maxf = 0; bfs(graph, capacity, flow, dist, source, target);) {
                for (var idx = new int[graph.Length];;) {
                    var pushed = dfs(graph, idx, capacity, flow, dist, source, target, int.MaxValue);
                    if (pushed > 0) {
                        maxf += pushed;
                    }
                    else break;
                }
            }
            return flow;
        }

        private bool bfs(List<int>[] graph, int[,] capacity, int[,] flow, int[] distance, int source, int target) {
            for (var i = 0; i < graph.Length; ++i) {
                distance[i] = -1;
            }
            var queue = new Queue<int>();
            for (distance[source] = 0, queue.Enqueue(source); queue.Count > 0;) {
                var current = queue.Dequeue();
                foreach (var next in graph[current])
                    if (distance[next] == -1 && capacity[current, next] > flow[current, next]) {
                        distance[next] = distance[current] + 1;
                        queue.Enqueue(next);
                    }
            }
            return distance[target] != -1;
        }

        private int dfs(List<int>[] graph, int[] idx, int[,] capacity, int[,] flow, int[] distance, int source, int target, int residue) {
            if (source == target) {
                return residue;
            }
            for (; idx[source] < graph[source].Count; ++idx[source]) {
                var next = graph[source][idx[source]];
                if (distance[next] != distance[source] + 1) {
                    continue;
                }
                if (capacity[source, next] > flow[source, next]) {
                    var pushed = dfs(graph, idx, capacity, flow, distance, next, target, Math.Min(residue, capacity[source, next] - flow[source, next]));
                    if (pushed > 0) {
                        flow[source, next] += pushed;
                        flow[next, source] -= pushed;
                        return pushed;
                    }
                }
            }
            return 0;
        }

        private const long modulo = (long)1e9 + 7;
    }
}
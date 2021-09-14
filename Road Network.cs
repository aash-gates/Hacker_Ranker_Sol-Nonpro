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
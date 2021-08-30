package main

import "fmt"

func dfs(graph map[int][]int, bots, parent []int, p int, visited []bool) {
	max := 0
	children := false
	visited[p] = true
	for _, t := range graph[p] {
		if !visited[t] {
			parent[t] = p
			dfs(graph, bots, parent, t, visited)
			children = true
		}
		if max < bots[t] {
			max = bots[t]
		}
	}
	if children {
		bots[p] = max + 1
	} // else 0
	//fmt.Println("P", p, bots[p], children)
}

func dfs2(graph map[int][]int, bots, ups, parent []int, p int, visited []bool) {
	visited[p] = true
	children := graph[p]
	best := 0
	best_pos := -1
	for _, t := range children {
		if parent[t] == p {
			v := 2 + bots[t]
			if v > best {
				best = v
				best_pos = t
			}
		}
	}

	for _, t := range children {
		if !visited[t] {
			ups[t] = 1 + ups[p]
			if best_pos != t {
				ups[t] = max(ups[t], best)
			} else {
				for _, tt := range children {
					if parent[tt] == p && tt != t {
						//fmt.Println("PP", t, tt, 2 + bots[tt], f)
						ups[t] = max(ups[t], 2 + bots[tt])
					}
				}
			}
			//fmt.Println("P", p, t, ups[p], bots[p], ups[t])
			dfs2(graph, bots, ups, parent, t, visited)
		}
	}
	//fmt.Println("P", p, bots[p], children)
}

func max(x, y int) int {
	if x > y {
		return x
	}
	return y
}

func main() {
	// 10^9 fits in an int
	var N, M, V, K int
	fmt.Scanf("%d %d\n", &N, &M)
	graph := make(map[int][]int)
	addEdge := func (x, y int) {
		//fmt.Println("E", x, y)
		if a, found := graph[x]; found {
			a = append(a, y)
			graph[x] = a
		} else {
			a = make([]int, 1)
			a[0] = y
			graph[x] = a
		}
	}
	for i := 0; i < N - 1 ; i++ {
		var x, y int
		fmt.Scanf("%d %d\n", &x, &y)
		x -= 1
		y -= 1
		addEdge(x, y)
		addEdge(y, x)
	}

	parent := make([]int, N)
	bots := make([]int, N)
	ups := make([]int, N)
	farthest := make([]int, N)

	visited := make([]bool, N)
	parent[0] = -1
	dfs(graph, bots, parent, 0, visited)
	visited = make([]bool, N)
	dfs2(graph, bots, ups, parent, 0, visited)

	for i,_ := range farthest {
		f := max(bots[i], ups[i])
		farthest[i] = f
	}

	dia := 0
	for _, f := range farthest {
		dia = max(dia, f)
	}

	for i := 0; i < M ; i++ {
		fmt.Scanf("%d %d\n", &V, &K)
		l := farthest[V-1]
		//_,l := bfs(V-1)
		fmt.Println(l + dia * (K - 1))
	}
}

/*
The question had to be trick question for the scale they ask is humongous
hinting: there should be properties for longest distance

Some trivial hunting leads you to.

the longest distance keeps on increasing, as it is undirected graph a -d-> b => longest distance from b >= d

in a tree
if longest distance is dia
if p -dia- q, then any other longest distance from q has to be -dia-

Consider
farthest from a is b.
then from farthest from b should be the longest in graph!
as
lets say p -> q is the longest and not really p -> q and a -> b intersect at x
p + q > a + b

but b > p & b > q .. else a -> q would have been the longest
but now.. b + p > p + q .. which is contradictory as p + q is the dia!


Also: http://cs.stackexchange.com/questions/22855/algorithm-to-find-diameter-of-a-tree-using-bfs-dfs-why-does-it-work


Goof up 1:
You don't need bfs to find the farthest distance.
That has to be done with DP!
draw as a tree!

farthest from point = max (farthest going up, farthest going down)
farthest going down = post walk, dfs update contents

farthest going up = max(farthest going up of parent + 1, farthest going down of siblings + 2)

2 dfs is all that is required

 */
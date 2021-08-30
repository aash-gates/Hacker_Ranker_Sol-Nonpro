package main

import "fmt"

type Edge [2]int

var deletedEdges = make(map[Edge]bool)
var totalWeight = 0

func pruneGraph(graph []map[int]bool, machines []bool, weights map[Edge]int) {
	for idx := range graph {
		if !machines[idx] && len(graph[idx]) == 1 {
			removeNode(graph, idx, machines, weights)
		}
	}
}

func removeNode(graph []map[int]bool, node int, machines []bool, weights map[Edge]int) {
	for neigh := range graph[node] {
		deletedEdges[Edge{node, neigh}] = true
		deletedEdges[Edge{neigh, node}] = true
		totalWeight -= weights[Edge{node, neigh}]
		delete(graph[neigh], node)
		if !machines[neigh] && len(graph[neigh]) == 1 {
			removeNode(graph, neigh, machines, weights)
		}
	}
	graph[node] = make(map[int]bool)
}

func dfs(graph []map[int]bool, weights map[Edge]int, start int) (int, int) {
	stack := []int{}
	visited := make([]bool, len(graph))
	distances := make([]int, len(graph))
	distances[start] = 0
	visited[start] = true
	stack = append(stack, start)
	for len(stack) > 0 {
		currentNode := stack[len(stack)-1]
		visited[currentNode] = true
		stack = stack[:len(stack)-1]
		for child := range graph[currentNode] {
			if !visited[child] {
				distances[child] = distances[currentNode] + weights[Edge{currentNode, child}]
				stack = append(stack, child)
			}
		}
	}
	maxDistance := 0
	argMax := -1
	for idx := range distances {
		if distances[idx] > maxDistance {
			maxDistance = distances[idx]
			argMax = idx
		}
	}
	return argMax, maxDistance
}

func read(b int, arr *[]int) {
	if b == 0 {
		return
	}
	var i int
	_, err := fmt.Scanf("%d", &i)
	if err != nil {
		return
	}
	*arr = append(*arr, i)
	read(b-1, arr)
}

func main() {
	var N, K int
	fmt.Scanln(&N, &K)
	// fmt.Println(N, K)
	weights := make(map[Edge]int)
	graph := make([]map[int]bool, N)
	for idx := range graph {
		graph[idx] = make(map[int]bool)
	}
	arr := []int{}
	read(K, &arr)
	letters := make([]bool, len(graph))
	for _, val := range arr {
		letters[val-1] = true
	}
	// fmt.Println(letters)
	var u, v, w int
	for N-1 > 0 {
		fmt.Scanln(&u, &v, &w)
		u--
		v--
		// fmt.Println(u, v, w)
		graph[u][v] = true
		graph[v][u] = true
		weights[Edge{u, v}] = w
		weights[Edge{v, u}] = w
		totalWeight += w
		N--
	}
	// fmt.Println(totalWeight)
	// Remove unneeded houses
	pruneGraph(graph, letters, weights)
	// Choose first vertex for dfs
	var first int
	for idx := range letters {
		if letters[idx] {
			first = idx
			break
		}
	}
	// Find the longest path
	v1, _ := dfs(graph, weights, first)
	_, maxDistance := dfs(graph, weights, v1)
	residual := (totalWeight - maxDistance) * 2
	fmt.Println(maxDistance + residual)
}
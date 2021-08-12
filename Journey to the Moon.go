package main

import "fmt"

// TN - Ta - Tb - ...
// where a, b, ... is the number of astronouts in each of the countries.

type node struct {
	edges   []int
	visited bool
}

func main() {
	var N int64
	var I int
	var A, B int
	scan(&N, &I)
	ans := N * (N - 1) / 2
	p := make([]node, N)
	for i := 0; i < I; i++ {
		scan(&A, &B)
		p[A].edges = append(p[A].edges, B)
		p[B].edges = append(p[B].edges, A)
	}
	// do depth-first search to find connected components
	for n := 0; n < int(N); n++ {
		if p[n].visited {
			continue
		}
		p[n].visited = true
		c := int64(0)
		toprocess := []int{n}
		for len(toprocess) > 0 {
			curr := p[toprocess[0]]
			toprocess = toprocess[1:]
			c++
			for _, next := range curr.edges {
				if !p[next].visited {
					toprocess = append(toprocess, next)
					p[next].visited = true
				}
			}
		}
		ans -= c * (c - 1) / 2
	}
	fmt.Println(ans)
}

func scan(a ...interface{}) {
	if _, err := fmt.Scan(a...); err != nil {
		panic(err)
	}
}

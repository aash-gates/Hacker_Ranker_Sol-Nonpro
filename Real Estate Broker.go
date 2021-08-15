package main

import (
	"io/ioutil"
	"os"
	"strconv"
	"strings"
	"unicode"
	"fmt"
)

var (
	r *Reader
)

type IntSlice []int64

func (is IntSlice) Less(i, j int) bool {
	return is[i] < is[j]
}

func (is IntSlice) Swap(i, j int) {
	is[i], is[j] = is[j], is[i]
}

func (is IntSlice) Len() int {
	return len(is)
}

type Reader struct {
	data []string
	p    int
}

func (r *Reader) spaceMap(str string) string {
	return strings.Map(func(r rune) rune {
		if unicode.IsSpace(r) {
			return ' '
		}
		return r
	}, str)
}

func (r *Reader) ReadAll() {
	bytes, err := ioutil.ReadAll(os.Stdin)

	if err != nil {
		panic(err)
	}
	r.data = strings.Split(r.spaceMap(string(bytes)), " ")
}

func (r *Reader) Next() (s string) {
	s = r.data[r.p]
	r.p += 1

	return s
}

func (r *Reader) NextInt() (n int) {
	n, err := strconv.Atoi(r.data[r.p])
	if err != nil {
		panic(err)
	}
	r.p += 1
	return
}

func (r *Reader) NextInt64() (n int64) {
	n, err := strconv.ParseInt(r.data[r.p], 10, 64)
	if err != nil {
		panic(err)
	}
	r.p += 1
	return
}

func init() {
	r = &Reader{}
	r.ReadAll()
}


var Graph [][]int
var used []bool
var match []int

func dfs(v int) bool {
	if used[v] {
		return false
	}
	used[v] = true

	for _, u := range Graph[v] {
		if match[u] == -1 || dfs(match[u]) {
			match[u] = v
			return true
		}
	}

	return false
}


func main() {
	n := r.NextInt()
	m := r.NextInt()

	x := make([]int, m)
	y := make([]int, m)
	a := make([]int, n)
	p := make([]int, n)

	for i:=0; i<n; i++ {
		a[i] = r.NextInt()
		p[i] = r.NextInt()
	}

	for i:=0; i<m; i++ {
		x[i] = r.NextInt()
		y[i] = r.NextInt()
	}

	Graph = make([][]int, n)

	for i:=0; i<n; i++ {
		Graph[i] = make([]int, 0)

		for j:=0; j<m; j++ {
			if x[j] > a[i] && y[j] <= p[i] {
				Graph[i] = append(Graph[i], j)

				//fmt.Println(i, j)
			}
		}
	}

	match = make([]int, m)
	for i, _ := range match {
		match[i] = -1
	}

	used = make([]bool, n)

	for i:=0; i<n; i++ {
		used = make([]bool, n)
		dfs(i)
	}

	var res int

	for _, m := range match {
		if m >=0 {
			res++
		}
	}

	fmt.Println(res)


}

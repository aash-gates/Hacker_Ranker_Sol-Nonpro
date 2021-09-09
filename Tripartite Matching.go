package main

import (
    "bufio"
    "fmt"
    "os"
)

func intersect(a, b map[int]struct{}) uint64 {
    if len(a) < len(b) {
        return intersect(b, a)
    }
    var count uint64
    // a is the larger of the two sorted lists
    for v, _ := range b {
        _, found := a[v]
        if found {
            count++
        }
    }
    return count
}
func readInt(scanner *bufio.Scanner) int {
    if !scanner.Scan() {
        panic("no more tokens in scanner")
    }
    result := 0
    bytes := scanner.Bytes()
    for _, b := range bytes {
        result = result*10 + int(b-'0')
    }
    return result
}

func read_graph(scanner *bufio.Scanner, n int) []map[int]struct{} {
    g := make([]map[int]struct{}, n)
    num_edges := readInt(scanner)
    for i := 0; i < n; i++ {
        g[i] = map[int]struct{}{}
    }
    for i := 0; i < num_edges; i++ {
        e1 := readInt(scanner)
        e2 := readInt(scanner)
        e1--
        e2--
        g[e1][e2] = struct{}{}
        g[e2][e1] = struct{}{}
    }
    return g
}

func main() {
    scanner := bufio.NewScanner(os.Stdin)
    scanner.Split(bufio.ScanWords)
    n := readInt(scanner)

    // gX[i] is a list of vertices that neighor i
    g1 := read_graph(scanner, n)
    g2 := read_graph(scanner, n)

    num_edges := readInt(scanner)
    var count uint64
    for i := 0; i < num_edges; i++ {
        e1 := readInt(scanner)
        e2 := readInt(scanner)
        e1--
        e2--
        count += intersect(g1[e1], g2[e2])
        count += intersect(g2[e1], g1[e2])
    }

    fmt.Println(count)
}
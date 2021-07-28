package main

import (
	"fmt"
	"os"
	"bufio"
	"strconv"
)

func is_similar(index map[int][]int, deltas, match []int, size, i int) bool {
	for j, x := range match {
		y := deltas[i + j]
		if 0 < x && x <= size - j {
			if x != y {
				return false
			}
		} else {
			if y > 0 && y <= size - j {
				return false
			}
		}
	}
	return true
}

func solve(index map[int][]int, deltas, match []int, size, skip int) int {
	total := 1
	if 0 < match[0] && match[0] <= size {
		for _, i := range index[match[0]] {
			if i + size >= len(deltas) {
				break
			}
			if i != skip {
				if is_similar(index, deltas, match, size, i) {
					total++
				}
			}
		}
	} else {
		for i, delta := range match {
			if 0 < delta && delta <= size - i {
				for _, j := range index[delta] {
					if j - i + size >= len(deltas) {
						break
					}
					if j >= i && j - i != skip {
						if is_similar(index, deltas, match, size, j - i) {
							total++
						}
					}
				}
				return total
			}
		}
		for i := 0; i < len(deltas) - size; i++ {
			if i != skip {
				if is_similar(index, deltas, match, size, i) {
					total++
				}
			}
		}
	}
	return total
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Split(bufio.ScanWords)
	scanner.Scan()
	size, _ := strconv.Atoi(scanner.Text())
	scanner.Scan()
	queries, _ := strconv.Atoi(scanner.Text())
	scanner.Scan()
	deltas := make([]int, size)
	index := make(map[int][]int)
	last_seen := make(map[rune]int)
	for i, c := range scanner.Text() {
		j, seen := last_seen[c]
		if seen {
			delta := i - j
			deltas[j] = delta
			index_array, extant := index[delta]
			if !extant {
				index_array = make([]int, 0)
			}
			index[delta] = append(index_array, j)
		}
		last_seen[c] = i
	}
	for i := 0; i < queries; i++ {
		scanner.Scan()
		a, _ := strconv.Atoi(scanner.Text())
		scanner.Scan()
		b, _ := strconv.Atoi(scanner.Text())
		a -= 1
		b -= 1
		d := b - a
		if d < 1 {
			fmt.Println(size)
			continue
		}
		fmt.Println(solve(index, deltas, deltas[a:b], d, a))
	}
}

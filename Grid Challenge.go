// grid-challenge.go
package main

import (
	"fmt"
	"sort"
)

// RuneSlice attaches the methods of sort.Interface to []rune, sorting in increasing order.
type RuneSlice []rune

func (s RuneSlice) Len() int           { return len(s) }
func (s RuneSlice) Less(i, j int) bool { return s[i] < s[j] }
func (s RuneSlice) Swap(i, j int)      { s[i], s[j] = s[j], s[i] }

// Sort is a convenience method.
func (s RuneSlice) Sort() {
	sort.Sort(s)
}

func main() {

	var T int
	fmt.Scanf("%d", &T)

	for i := 0; i < T; i++ {
		var N int
		var rows []RuneSlice

		fmt.Scanf("%d", &N)

		for j := 0; j < N; j++ {
			var row RuneSlice

			var str string
			fmt.Scanf("%s", &str)

			for _, l := range str {
				row = append(row, l)
			}
			sort.Sort(row)

			rows = append(rows, row)
		}

		//fmt.Printf("%+q\n", rows)

		for k := 0; k < N-1; k++ {
			for l := 0; l < N; l++ {
				//fmt.Printf("Comparing %+q,%+q\n", rows[k][l], rows[k+1][l])
				if (rows[k])[l] > (rows[k+1])[l] {
					fmt.Println("NO")
					goto skip
				}
			}
		}

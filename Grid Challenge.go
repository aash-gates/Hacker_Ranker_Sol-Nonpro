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

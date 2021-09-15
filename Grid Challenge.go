// grid-challenge.go
package main

import (
	"fmt"
	"sort"
)

// RuneSlice attaches the methods of sort.Interface to []rune, sorting in increasing order.
type RuneSlice []rune

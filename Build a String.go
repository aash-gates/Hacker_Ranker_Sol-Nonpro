package main

import (
	//"./ukkonen"
	"bufio"
	"bytes"
	//"fmt"
	"io"
	"os"
	"sort"
	"strconv"
	"strings"
)

const MB = 1024 * 1024

type AsStrings [][]byte

func (bytes AsStrings) String() string {
	var sb strings.Builder

	if _, err := sb.WriteString("[ "); err != nil {
		panic(err)
	}

	for _, s := range bytes {
		if _, err := sb.WriteString(string(s) + " "); err != nil {
			panic(err)
		}
	}

	if _, err := sb.WriteString(" ]"); err != nil {
		panic(err)
	}

	return sb.String()
}

func main() {

	reader := bufio.NewReaderSize(os.Stdin, 1*MB)

	stdout, err := os.Create(os.Getenv("OUTPUT_PATH"))
	if err != nil {
		panic(err)
	}
	defer stdout.Close()
	writer := bufio.NewWriterSize(stdout, 1*MB)

	cases := atoi(readLine(reader))
	for ; cases > 0; cases-- {
		fields := strings.Split(readLine(reader), " ")

		a := atoi(fields[1])
		b := atoi(fields[2])
		s := readLine(reader)

		var indices [26][]int
		cost := make([]int, len(s)+1)
		for k, c := range s {
			cost[k+1] = best(cost[k+1], cost[k]+a)

			index := indices[int(c)%26]
			indices[int(c)%26] = append(index, k)

			for _, j := range index {
				cost[k+1] = best(cost[k+1], cost[k]+b)

				for i := 1; i < k-j && i+k < len(s); i++ {
					if s[j+i] != s[k+i] {
						break
					}
					cost[k+i+1] = best(cost[k+i+1], cost[k]+b)
				}
			}

		}

		/*
			rs := ukkonen.NewSuffixTree(s).LongestRepeatingSubstrings(-1)
		*/

		/*
			sa := NewSuffixArray(s)
			//fmt.Println(sa)
			rs := sa.RepeatingSubstrings()
			fmt.Println(AsStrings(rs))

			cost := make([]int, len(s)+1)
			for i := range s {
				//fmt.Println(string(s))
				for _, prefix := range rs {
					cost[i+1] = best(cost[i+1], cost[i]+a)

					plen := len(prefix)
					if bytes.Contains(s[:i], prefix) && bytes.HasPrefix(s[i:], prefix) {
						cost[i+plen] = best(cost[i+plen], cost[i]+b)
						//fmt.Println(string(s[:i]), string(s[i:]))
					}
				}
				//tfmt.Println(cost)
			}
		*/

		if _, err := writer.WriteString(strconv.Itoa(cost[len(s)])); err != nil {
			panic(err)
		}
		if err := writer.WriteByte('\n'); err != nil {
			panic(err)
		}
	}
	writer.Flush()
}

func best(a, b int) int {
	switch {
	case a != 0 && a < b:
		return a
	default:
		return b
	}
}

func atoi(s string) int {
	n, err := strconv.Atoi(s)
	if err != nil {
		panic(err)
	}
	return n
}

func readLine(reader *bufio.Reader) string {
	str, _, err := reader.ReadLine()
	if err == io.EOF {
		return ""
	}

	return string(str)
}

type suffixarray struct {
	text  []byte
	index []int
}

func NewSuffixArray(b []byte) *suffixarray {
	return &suffixarray{text: b, index: qsufsort(b)}
}

func (sa *suffixarray) Len() int {
	return len(sa.index)
}

func (sa *suffixarray) Bytes() []byte {
	return sa.text
}

func (sa *suffixarray) at(i int) []byte {
	return sa.text[sa.index[i]:]
}

func (sa *suffixarray) Lookup(s []byte, n int) (result []int) {

	if len(s) > 0 && n != 0 {
		matches := sa.lookupAll(s)
		if n < 0 || len(matches) < n {
			n = len(matches)
		}

		if n > 0 {
			result = make([]int, n)
			copy(result, matches)
		}

	}
	return
}

func (sa *suffixarray) lookupAll(s []byte) []int {
	i := sort.Search(len(sa.index), func(i int) bool { return bytes.Compare(sa.at(i), s) >= 0 })
	j := i + sort.Search(len(sa.index)-i, func(j int) bool { return !bytes.HasPrefix(sa.at(j+i), s) })
	return sa.index[i:j]
}

func (sa *suffixarray) LongestCommonPrefixLen(i int) int {
	return sa.lcp(sa.index[i], sa.index[i-1])
}

func (sa *suffixarray) lcp(i, j int) int {
	cplen := 0
	for ; i < sa.Len() && j < sa.Len(); i, j = i+1, j+1 {
		if sa.text[i] != sa.text[j] {
			return cplen
		}
		cplen++
	}
	return cplen
}

func (sa *suffixarray) RepeatingSubstrings() [][]byte {
	unique := make(map[string]bool)
	for i := 1; i < sa.Len(); i++ {
		if sublen := sa.LongestCommonPrefixLen(i); sublen > 1 {
			substring := string(sa.text[sa.index[i] : sa.index[i]+sublen])
			unique[substring] = true
		}
	}

	rs := make([][]byte, 0, len(unique))
	for substring := range unique {
		rs = append(rs, []byte(substring))
	}
	return rs
}

func (sa *suffixarray) LongestRepeatingSubstring() []byte {
	var lrs []byte
	for i := 1; i < sa.Len(); i++ {
		if sublen := sa.LongestCommonPrefixLen(i); sublen > len(lrs) {
			lrs = sa.text[sa.index[i] : sa.index[i]+sublen]
		}
	}
	return lrs
}

/*
func (sa *suffixarray) LongestRepeatingNonOverlappingSubstring() []byte {
	lrs := sa.LongestRepeatingSubstring()
	lrnos := lrs
	for len(lrs) > 0 {
		sa2 := NewSuffixArray(lrnos)
		lrs = sa2.LongestRepeatingSubstring()
		newSubstr := lrnos[0 : len(lrnos)-len(lrs)]
		if !bytes.Equal(lrs, lrnos[len(lrnos)-len(lrs):]) || !bytes.Contains(sa.text, append(newSubstr, newSubstr...)) {
			break
		}
		lrnos = newSubstr
	}
	return lrnos
}
*/

func libsufsort(b []byte) []int {
	index := make([]int, len(b))
	for i := range index {
		index[i] = i
	}

	less := func(i, j int) bool {
		return bytes.Compare(b[index[i]:], b[index[j]:]) < 0
	}

	sort.Slice(index, less)
	return index
}

func qsufsort(data []byte) []int {
	// initial sorting by first byte of suffix
	sa := sortedByFirstByte(data)
	if len(sa) < 2 {
		return sa
	}
	// initialize the group lookup table
	// this becomes the inverse of the suffix array when all groups are sorted
	inv := initGroups(sa, data)

	// the index starts 1-ordered
	sufSortable := &suffixSortable{sa: sa, inv: inv, h: 1}

	for sa[0] > -len(sa) { // until all suffixes are one big sorted group
		// The suffixes are h-ordered, make them 2*h-ordered
		pi := 0 // pi is first position of first group
		sl := 0 // sl is negated length of sorted groups
		for pi < len(sa) {
			if s := sa[pi]; s < 0 { // if pi starts sorted group
				pi -= s // skip over sorted group
				sl += s // add negated length to sl
			} else { // if pi starts unsorted group
				if sl != 0 {
					sa[pi+sl] = sl // combine sorted groups before pi
					sl = 0
				}
				pk := inv[s] + 1 // pk-1 is last position of unsorted group
				sufSortable.sa = sa[pi:pk]
				sort.Sort(sufSortable)
				sufSortable.updateGroups(pi)
				pi = pk // next group
			}
		}
		if sl != 0 { // if the array ends with a sorted group
			sa[pi+sl] = sl // combine sorted groups at end of sa
		}

		sufSortable.h *= 2 // double sorted depth
	}

	for i := range sa { // reconstruct suffix array from inverse
		sa[inv[i]] = i
	}
	return sa
}

func sortedByFirstByte(data []byte) []int {
	// total byte counts
	var count [256]int
	for _, b := range data {
		count[b]++
	}
	// make count[b] equal index of first occurrence of b in sorted array
	sum := 0
	for b := range count {
		count[b], sum = sum, count[b]+sum
	}
	// iterate through bytes, placing index into the correct spot in sa
	sa := make([]int, len(data))
	for i, b := range data {
		sa[count[b]] = i
		count[b]++
	}
	return sa
}

func initGroups(sa []int, data []byte) []int {
	// label contiguous same-letter groups with the same group number
	inv := make([]int, len(data))
	prevGroup := len(sa) - 1
	groupByte := data[sa[prevGroup]]
	for i := len(sa) - 1; i >= 0; i-- {
		if b := data[sa[i]]; b < groupByte {
			if prevGroup == i+1 {
				sa[i+1] = -1
			}
			groupByte = b
			prevGroup = i
		}
		inv[sa[i]] = prevGroup
		if prevGroup == 0 {
			sa[0] = -1
		}
	}
	// Separate out the final suffix to the start of its group.
	// This is necessary to ensure the suffix "a" is before "aba"
	// when using a potentially unstable sort.
	lastByte := data[len(data)-1]
	s := -1
	for i := range sa {
		if sa[i] >= 0 {
			if data[sa[i]] == lastByte && s == -1 {
				s = i
			}
			if sa[i] == len(sa)-1 {
				sa[i], sa[s] = sa[s], sa[i]
				inv[sa[s]] = s
				sa[s] = -1 // mark it as an isolated sorted group
				break
			}
		}
	}
	return inv
}

type suffixSortable struct {
	sa  []int
	inv []int
	h   int
	buf []int // common scratch space
}

func (x *suffixSortable) Len() int           { return len(x.sa) }
func (x *suffixSortable) Less(i, j int) bool { return x.inv[x.sa[i]+x.h] < x.inv[x.sa[j]+x.h] }
func (x *suffixSortable) Swap(i, j int)      { x.sa[i], x.sa[j] = x.sa[j], x.sa[i] }

func (x *suffixSortable) updateGroups(offset int) {
	bounds := x.buf[0:0]
	group := x.inv[x.sa[0]+x.h]
	for i := 1; i < len(x.sa); i++ {
		if g := x.inv[x.sa[i]+x.h]; g > group {
			bounds = append(bounds, i)
			group = g
		}
	}
	bounds = append(bounds, len(x.sa))
	x.buf = bounds

	// update the group numberings after all new groups are determined
	prev := 0
	for _, b := range bounds {
		for i := prev; i < b; i++ {
			x.inv[x.sa[i]] = offset + b - 1
		}
		if b-prev == 1 {
			x.sa[prev] = -1
		}
		prev = b
	}
}

package main
import "fmt"
import "io/ioutil"
import "math"
import "os"

type Point struct {
	i, j int
}

var dist [200][200]int
var prev [200][200]Point
var seen = make([]Point, 0, 4e4)
var moves = []Point{ { -2, -1 }, { -2, 1 }, { 0, 2 }, { 2, 1 }, { 2, -1 },
							{ 0, -2 } }
var names = []string{ "UL", "UR", "R", "LR", "LL", "L" }

func main() {
	N := ScanInt(5, 200)
	var start, end Point
	NewLine()
	start.i = ScanInt(0, N - 1)
	start.j = ScanInt(0, N - 1)
	end.i = ScanInt(0, N - 1)
	end.j = ScanInt(0, N - 1)
	Assert(start != end)
	dist[start.i][start.j] = 0
	seen = append(seen, start)
	outer: for k := 0; k < len(seen); k++ {
		p := seen[k]
		for _, m := range moves {
			q := Point{ p.i + m.i, p.j + m.j }
			if q.i < 0 || q.i >= N || q.j < 0 || q.j >= N {
				continue
			}
			if q == start || dist[q.i][q.j] > 0 {
				continue
			}
			dist[q.i][q.j] = dist[p.i][p.j] + 1
			prev[q.i][q.j] = p
			seen = append(seen, q)
			if q == end {
				break outer
			}
		}
	}
	d := dist[end.i][end.j]
	if d == 0 {
		fmt.Println("Impossible")
		return
	}
	fmt.Println(d)
	output := ""
	for q, p := end, end; q != start; q = p {
		p = prev[q.i][q.j]
		idx := -1
		for j, m := range moves {
			if p.i + m.i == q.i && p.j + m.j == q.j {
				idx = j
				break
			}
		}
		output = names[idx] + " " + output
	}
	fmt.Println(output[:len(output)-1])
}

func Assert(condition bool) {
	if !condition {
		panic("assertion failed")
	}
}

func NewLine() {
	if CheckInput {
		for n, b := range RemainingInput {
			if b != ' ' && b != '\t' && b != '\r' {
				Assert(b == '\n')
				RemainingInput = RemainingInput[n+1:]
				return
			}
		}
		Assert(false)
	}
}

func ScanInt(low, high int) int {
	return int(ScanInt64(int64(low), int64(high)))
}

var RemainingInput []byte

func init() {
	var e error
	RemainingInput, e = ioutil.ReadAll(os.Stdin)
	if e != nil {
		panic(e)
	}
}

func ScanInt64(low, high int64) int64 {
	x := Btoi(ScanToken())
	Assert(low <= x && x <= high || !CheckInput)
	return x
}

func Btoi(s []byte) int64 {
	if s[0] == '-' {
		x := Btou(s[1:])
		Assert(x <= - math.MinInt64)
		return - int64(x)
	} else {
		x := Btou(s)
		Assert(x <= math.MaxInt64)
		return int64(x)
	}
}

var CheckInput = true

func ScanToken() []byte {
	for n, b := range RemainingInput {
		if b == ' ' || b == '\t' || b == '\r' {
			continue
		}
		if b == '\n' {
			Assert(!CheckInput)
			continue
		}
		RemainingInput = RemainingInput[n:]
		break
	}
	Assert(len(RemainingInput) > 0)
	n := 1
	for ; n < len(RemainingInput); n++ {
		b := RemainingInput[n]
		if b == ' ' || b == '\t' || b == '\r' || b == '\n' {
			break
		}
	}
	token := RemainingInput[:n]
	RemainingInput = RemainingInput[n:]
	return token
}

func Btou(s []byte) uint64 {
	Assert(len(s) > 0)
	var x uint64
	for _, d := range s {
		Assert('0' <= d && d <= '9')
		d -= '0'
		if x >= math.MaxUint64 / 10 {
			Assert(x == math.MaxUint64 / 10 && d <= math.MaxUint64 % 10)
		}
		x = x * 10 + uint64(d)
	}
	return x
}

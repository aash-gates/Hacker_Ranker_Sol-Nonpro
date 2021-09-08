package main
import ("bufio"; "fmt"; "io"; "os")

type Episode struct {
	s1, e1 int
	s2, e2 int
}

type Constraint struct {
	k int
	value int
}

var constrain [][3][]Constraint
var space = make([]int, 100)
var save = make([]int, 100)

func set(k int, value int, l, r int) bool {
	if value == 0 {
		return false
	}
	Assert(value == 1 || value == 2)
	if space[k] == value {
		return true
	}
	if space[k] != 3 {
		return false
	}
	space[k] = value
	return apply(constrain[k][value], l, r)
}

func apply(cs []Constraint, l, r int) bool {
	for _, c := range cs {
		if c.k < l {
			continue
		}
		if c.k > r {
			break
		}
		if !set(c.k, c.value, l, r) {
			return false
		}
	}
	return true
}

func satisfiable(l, r int) bool {
	for k := l; k <= r; k++ {
		space[k] = 3
	}
	for k := l; k <= r; k++ {
		if !apply(constrain[k][0], l, r) {
			return false
		}
	}
	for k := l; k <= r; k++ {
		if space[k] != 3 {
			continue
		}
		copy(save, space)
		if !set(k, 1, l, r) {
			save, space = space, save
			if !set(k, 2, l, r) {
				return false
			}
		}
	}
	return true
}

func main() {
	Q := ScanInt(1, 100)
	for q := 0; q < Q; q++ {
		NewLine()
		N := ScanInt(1, 100)
		ep := make([]Episode, N)
		for n := range ep {
			NewLine()
			ep[n].s1 = ScanInt(1, 1e4)
			ep[n].e1 = ScanInt(ep[n].s1, 1e4)
			ep[n].s2 = ScanInt(ep[n].s1, 1e4)
			ep[n].e2 = ScanInt(ep[n].s1, 1e4)
		}
		constrain = make([][3][]Constraint, N)
		for n, en := range ep {
			for k, ek := range ep {
				if k == n {
					continue
				}
				c1 := 0
				if en.s1 > ek.e1 || en.e1 < ek.s1 {
					c1 += 1
				}
				if en.s1 > ek.e2 || en.e1 < ek.s2 {
					c1 += 2
				}
				c2 := 0
				if en.s2 > ek.e1 || en.e2 < ek.s1 {
					c2 += 1
				}
				if en.s2 > ek.e2 || en.e2 < ek.s2 {
					c2 += 2
				}
				if c1 == c2 {
					if c1 != 3 {
						constrain[n][0] = append(constrain[n][0], Constraint{ k, c1 })
					}
				} else {
					if c1 != 3 {
						constrain[n][1] = append(constrain[n][1], Constraint{ k, c1 })
					}
					if c2 != 3 {
						constrain[n][2] = append(constrain[n][2], Constraint{ k, c2 })
					}
				}
			}
		}
		bestl := 0
		bestr := 0
		for l, r := 0, 1; r < N; {
			if satisfiable(l, r) {
				bestl = l
				bestr = r
				r++
			} else {
				l++
				if r - l <= bestr - bestl {
					r = l + bestr - bestl + 1
				}
			}
		}
		fmt.Println(bestl + 1, bestr + 1)
	}
}

// Boilerplate

func Assert(condition bool, items... interface{}) {
	if !condition {
		panic("assertion failed: " + fmt.Sprint(items...))
	}
}

func Log(items... interface{}) {
	fmt.Println(items...)
}

var Input = bufio.NewReader(os.Stdin)

func ReadByte() byte {
	b, e := Input.ReadByte()
	if e != nil {
		panic(e)
	}
	return b
}

func MaybeReadByte() (byte, bool) {
	b, e := Input.ReadByte()
	if e != nil {
		if e == io.EOF {
			return 0, false
		}
		panic(e)
	}
	return b, true
}

func UnreadByte() {
	e := Input.UnreadByte()
	if e != nil {
		panic(e)
	}
}

func NewLine() {
	for {
		b := ReadByte()
		switch b {
		case ' ', '\t', '\r':
			// keep looking
		case '\n':
			return
		default:
			panic(fmt.Sprintf("expecting newline, but found character <%c>", b))
		}
	}
}

func ScanInt(low, high int) int {
	return int(ScanInt64(int64(low), int64(high)))
}

func ScanUint(low, high uint) uint {
	return uint(ScanUint64(uint64(low), uint64(high)))
}

func ScanInt64(low, high int64) int64 {
	Assert(low <= high)
	for {
		b := ReadByte()
		switch b {
		case ' ', '\t', '\r':
			// keep looking
		case '\n':
			panic(fmt.Sprintf(
				"unexpected newline; expecting range %d..%d", low, high))
		case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
			if high < 0 {
				panic(fmt.Sprintf(
					"found <%c> but expecting range %d..%d", b, low, high))
			}
			lw := low
			if lw < 0 {
				lw = 0
			}
			UnreadByte()
			x, e := _scanu64(uint64(lw), uint64(high))
			if e != "" {
				panic(fmt.Sprintf("%s %d..%d", e, low, high))
			}
			return int64(x)
		case '-':
			if low > 0 {
				panic(fmt.Sprintf(
					"found minus sign but expecting range %d..%d", low, high))
			}
			h := high
			if h > 0 {
				h = 0
			}
			x, e := _scanu64(uint64(-h), uint64(-low))
			if e != "" {
				panic(fmt.Sprintf( "-%s %d..%d", e, low, high))
			}
			return -int64(x)
		default:
			panic(fmt.Sprintf(
				"unexpected character <%c>; expecting range %d..%d", b, low, high))
		}
	}
}

func ScanUint64(low, high uint64) uint64 {
	Assert(low <= high)
	for {
		b := ReadByte()
		switch b {
		case ' ', '\t', '\r':
			// keep looking
		case '\n':
			panic(fmt.Sprintf(
				"unexpected newline; expecting range %d..%d", low, high))
		case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
			UnreadByte()
			x, e := _scanu64(low, high)
			if e != "" {
				panic(fmt.Sprintf("%s %d..%d", e, low, high))
			}
			return x
		default:
			panic(fmt.Sprintf(
				"unexpected character <%c>; expecting range %d..%d", b, low, high))
		}
	}
}

func _scanu64(low, high uint64) (result uint64, err string) {
	x := uint64(0)
	buildnumber: for {
		b, ok := MaybeReadByte()
		if !ok {
			break buildnumber
		}
		switch b {
		case ' ', '\t', '\r':
			break buildnumber
		case '\n':
			UnreadByte()
			break buildnumber
		case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
			d := uint64(b - '0')
			if (high - d) / 10 < x {
				return x, fmt.Sprintf("%d%c... not in range", x, b)
			}
			x = x * 10 + d
		default:
			return x, fmt.Sprintf("%d%c found; expecting range", x, b)
		}
	}
	if x < low || x > high {
		return x, fmt.Sprintf("%d not in range", x)
	}
	return x, ""
}

func ScanBytes(short, long int) []byte {
	Assert(1 <= short && short <= long)
	var b byte
	buf := make([]byte, long)
	skipws: for {
		b = ReadByte()
		switch b {
		case ' ', '\t', '\r':
			// keep looking
		case '\n':
			panic(fmt.Sprintf("unexpected newline; expecting string"))
		default:
			break skipws
		}
	}
	buf[0] = b
	length := 1
	buildstring: for {
		var ok bool
		b, ok = MaybeReadByte()
		if !ok {
			break buildstring
		}
		switch b {
		case ' ', '\t', '\r':
			break buildstring
		case '\n':
			UnreadByte()
			break buildstring
		default:
			if length >= long {
				panic(fmt.Sprintf("string length not in range %d..%d", short, long))
			}
			buf[length] = b
			length++
		}
	}
	if length < short {
		panic(fmt.Sprintf("string length not in range %d..%d", short, long))
	}
	return buf[:length]
}

func ScanString(short, long int) string {
	return string(ScanBytes(short, long))
}

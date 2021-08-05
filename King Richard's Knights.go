package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"sort"
	"strconv"
)

func readInt(scanner *bufio.Scanner) int {
	scanner.Scan()
	n, _ := strconv.Atoi(scanner.Text())
	return n
}

func readIntSlice(s *bufio.Scanner, size int) []int {
	result := make([]int, size)
	for i := 0; i < size; i++ {
		result[i] = readInt(s)
	}
	return result
}

func read3IntSlice(s *bufio.Scanner, size int) [][3]int {
	result := make([][3]int, size)
	for i := 0; i < size; i++ {
		result[i] = [3]int{
			readInt(s),
			readInt(s),
			readInt(s),
		}
	}
	return result
}

func read(s *bufio.Scanner) (int, [][3]int, []int) {
	n := readInt(s)
	m := readInt(s)

	cs := read3IntSlice(s, m)
	k := readInt(s)
	qs := readIntSlice(s, k)

	return n, cs, qs
}

type point struct {
	x int
	y int
}

func rotate(p point, span int) point {
	return point{-p.y + (span - 1), p.x}
}

func rotateRev(p point, span int) point {
	return point{p.y, -p.x + (span - 1)}
}

type command struct {
	cmdPos   point
	sz       int
	startPos point
	rotation int
}

func getCorner(start point, sz int, rotation int) point {
	switch rotation {
	case 0:
		return start
	case 1:
		return point{start.x + sz - 1, start.y}
	case 2:
		return point{start.x + sz - 1, start.y + sz - 1}
	case 3:
		return point{start.x, start.y + sz - 1}
	}
	return point{}
}

func transformCommands(n int, cs [][3]int) []command {

	result := make([]command, len(cs)+1)
	result[0] = command{sz: n}
	for i, c := range cs {
		result[i+1].cmdPos.x = c[1] - 1
		result[i+1].cmdPos.y = c[0] - 1
		result[i+1].sz = c[2] + 1
	}

	for i := 1; i < len(result); i++ {
		prevCmd := result[i-1]
		cmd := &result[i]
		pos := point{cmd.cmdPos.x - prevCmd.cmdPos.x, cmd.cmdPos.y - prevCmd.cmdPos.y}

		pos = getCorner(pos, cmd.sz, prevCmd.rotation)
		for j := 0; j < prevCmd.rotation; j++ {
			pos = rotateRev(pos, prevCmd.sz)
		}

		pos = point{pos.x + prevCmd.cmdPos.x, pos.y + prevCmd.cmdPos.y}
		offset := point{
			prevCmd.cmdPos.x - prevCmd.startPos.x,
			prevCmd.cmdPos.y - prevCmd.startPos.y,
		}
		pos = point{pos.x - offset.x, pos.y - offset.y}

		cmd.startPos = pos
		cmd.rotation = (prevCmd.rotation + 1) % 4
	}

	return result
}

func compute(n int, cs [][3]int, qs []int) []point {

	cmds := transformCommands(n, cs)

	result := make([]point, len(qs))
	for i, q := range qs {

		qPos := point{q - ((q / n) * n), q / n}

		cmdIdx := sort.Search(len(cmds), func(i int) bool {
			cmd := cmds[len(cmds)-1-i]
			return qPos.x >= cmd.startPos.x &&
				qPos.y >= cmd.startPos.y &&
				qPos.x < cmd.startPos.x+cmd.sz &&
				qPos.y < cmd.startPos.y+cmd.sz
		})

		cmd := cmds[len(cmds)-1-cmdIdx]

		qPos = point{qPos.x - cmd.startPos.x, qPos.y - cmd.startPos.y}
		for j := 0; j < cmd.rotation; j++ {
			qPos = rotate(qPos, cmd.sz)
		}
		qPos = point{qPos.x + cmd.startPos.x, qPos.y + cmd.startPos.y}
		offset := point{
			cmd.cmdPos.x - cmd.startPos.x,
			cmd.cmdPos.y - cmd.startPos.y,
		}
		qPos = point{qPos.x + offset.x, qPos.y + offset.y}

		result[i] = point{qPos.y + 1, qPos.x + 1}
	}

	return result
}

func run(in io.Reader, out io.Writer) {

	s := bufio.NewScanner(in)
	s.Split(bufio.ScanWords)

	n, cs, qs := read(s)
	result := compute(n, cs, qs)
	for _, r := range result {
		fmt.Fprintln(out, r.x, r.y)
	}
}

func main() {
	run(os.Stdin, os.Stdout)
}

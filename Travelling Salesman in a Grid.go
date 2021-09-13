package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strconv"
)

type cell struct {
	right int
	down  int
}

func readInt(scanner *bufio.Scanner) int {
	scanner.Scan()
	n, _ := strconv.Atoi(scanner.Text())
	return n
}

func read(s *bufio.Scanner) (int, int, []cell) {
	rows := readInt(s)
	cols := readInt(s)

	cs := make([]cell, rows*cols)

	for i := 0; i < rows; i++ {
		for j := 0; j < cols-1; j++ {
			idx := i*cols + j
			cs[idx].right = readInt(s)
		}
	}

	for i := 0; i < rows-1; i++ {
		for j := 0; j < cols; j++ {
			idx := i*cols + j
			cs[idx].down = readInt(s)
		}
	}

	return rows, cols, cs
}

const noConn = 255

func copyBytes(in []byte) []byte {
	result := make([]byte, len(in))
	copy(result, in)
	return result
}

func simplify(arg []byte) []byte {

	mm := map[byte]byte{}
	run(os.Stdin, os.Stdout)
}

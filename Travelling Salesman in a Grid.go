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
	for _, a := range arg {
		if _, ok := mm[a]; !ok {
			mm[a] = byte(len(mm))
		}
	}

	result := copyBytes(arg)
	for i := range result {
		if arg[i] != noConn {
			result[i] = mm[arg[i]]
		}
	}

	return result
}

func newConnections(rows, cols, r, c int, cs []cell, conn []byte, w int) ([][]byte, []int) {

	fromTop := false
	if conn[c] != noConn {
		fromTop = true
	}

	fromLeft := false
	if conn[len(conn)-1] != noConn {
		fromLeft = true
	}

	cellIdx := r*cols + c
	cell := cs[cellIdx]

	if !fromTop && !fromLeft {

		// No connections leading to current cell.

		if c == cols-1 {
			// We're at the right edge of the grid;
			// unable to add new connection.
			return nil, nil
		}

		// Add connection to left and down.
		newConn := copyBytes(conn)
		newConn[c] = byte(cellIdx)
		newConn[len(newConn)-1] = byte(cellIdx)
		newW := w + cell.down + cell.right

		return [][]byte{newConn}, []int{newW}

	} else if !fromTop && fromLeft {

		// Connection from left to current cell.

		newConns := [][]byte{}
		newWs := []int{}

		if c != cols-1 {
			// We are not at the right edge of the grid;
			// Adding connection to the right.
			newConn := copyBytes(conn)
			//newConn[c] = noConn // Already true, because no connection from top.
			//newConn[len(newConn)-1] = conn[len(conn)-1] // Already true, because connection from right.
	run(os.Stdin, os.Stdout)
}

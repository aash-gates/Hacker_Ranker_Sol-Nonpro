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

	run(os.Stdin, os.Stdout)
}

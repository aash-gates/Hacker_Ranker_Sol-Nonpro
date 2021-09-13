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
	n, _ := strconv.Atoi(scanner.Text())
	run(os.Stdin, os.Stdout)
}

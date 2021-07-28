package main

import (
    "bufio"
    "fmt"
    "io"
    "os"
    "strconv"
    "strings"
)

func isSimilar(deltas, match []int, size, i int) bool {
    for j, x := range match {
        y := deltas[i+j]
        if 0 < x && x <= size-j {
            if x != y {
                return false
            }
        } else {
            if y > 0 && y <= size-j {
                return false
            }
        }
    }
    return true
}

func similarStrings(index map[int][]int, deltas, match []int, size, skip int) int {
    total := 1
    if 0 < match[0] && match[0] <= size {
        for _, i := range index[match[0]] {
            if i+size >= len(deltas) {
                break
            }
            if i != skip {
                if isSimilar(deltas, match, size, i) {
                    total++
                }
            }
        }
    } else {
        for i, delta := range match {
            if 0 < delta && delta <= size-i {
                for _, j := range index[delta] {
                    if j-i+size >= len(deltas) {
                        break
                    }
                    if j >= i && j-i != skip {
                        if isSimilar(deltas, match, size, j-i) {
                            total++
                        }
                    }
                }
                return total
            }
        }
        for i := 0; i < len(deltas)-size; i++ {
            if i != skip {
                if isSimilar(deltas, match, size, i) {
                    total++
                }
            }
        }
    }
    return total
}

func main() {
    reader := bufio.NewReaderSize(os.Stdin, 1024 * 1024)

    stdout, err := os.Create(os.Getenv("OUTPUT_PATH"))
    checkError(err)

    defer stdout.Close()

    writer := bufio.NewWriterSize(stdout, 1024 * 1024)

    nq := strings.Split(readLine(reader), " ")

    nTemp, err := strconv.ParseInt(nq[0], 10, 64)
    checkError(err)
    n := int(nTemp)

    qTemp, err := strconv.ParseInt(nq[1], 10, 64)
    checkError(err)
    q := int(qTemp)

    deltas := make([]int, n)
    indices := make(map[int][]int)
    seens := make(map[rune]int)
    for i, c := range readLine(reader) {
        j, seenValue := seens[c]
        if seenValue {
            delta := i - j
            deltas[j] = delta
            k, extant := indices[delta]
            if !extant {
                k = make([]int, 0)
            }
            indices[delta] = append(k, j)
        }
        seens[c] = i
    }
    
    for queriesRowItr := 0; queriesRowItr < q; queriesRowItr++ {
        queriesRowTemp := strings.Split(readLine(reader), " ")
        var a, b int
        for j, queriesRowItem := range queriesRowTemp {
            queriesItemTemp, err := strconv.ParseInt(queriesRowItem, 10, 64)
            checkError(err)
            switch j {
            case 0 :
                a = int(queriesItemTemp)-1
            case 1:
                b = int(queriesItemTemp)-1
            default:
                panic("Bad input")
            }
        }
        d := b-a
        if d < 1{
            fmt.Fprintf(writer, "%d\n", n)
            continue
        }
        result := similarStrings(indices, deltas, deltas[a:b], d, a)
        fmt.Fprintf(writer, "%d\n", result)
    }

    writer.Flush()
}

func readLine(reader *bufio.Reader) string {
    str, _, err := reader.ReadLine()
    if err == io.EOF {
        return ""
    }

    return strings.TrimRight(string(str), "\r\n")
}

func checkError(err error) {
    if err != nil {
        panic(err)
    }
}
package main

import (
    "bufio"
    "fmt"
    "io"
    "os"
    "strconv"
    "strings"
    "math"
)

func buildString(a int32, b int32, s string) int32 {
    minCost := make([]int32, len(s))
    runes := []rune(s)
    positions := make([][]int, 'z'-'a'+1)

    previousCost := int32(0)
    for strPos, r := range runes {
        costA := previousCost + a
        costB := int32(math.MaxInt32)
        runeIndex := r - 'a'

        bLength := 0
        for _, pos := range positions[runeIndex] {
            if bLength == 0 || bLength > 0 && pos >= bLength && runes[pos-bLength] == runes[strPos-bLength] {
                bLength = 0
                for i := 0; pos-i >= 0 && strPos-i > pos; i++ {
                    if runes[pos-i] != runes[strPos-i] {
                        break
                    }
                    cost := minCost[strPos-i-1] + b
                    bLength++
                    if cost < costB {
                        costB = cost
                    }
                }
            }
        }

        if costA < costB {
            minCost[strPos] = costA
        } else {
            minCost[strPos] = costB
        }
        previousCost = minCost[strPos]
        positions[runeIndex] = append(positions[runeIndex], strPos)
    }

    return minCost[len(minCost)-1]

}

func main() {
    reader := bufio.NewReaderSize(os.Stdin, 1024 * 1024)

    stdout, err := os.Create(os.Getenv("OUTPUT_PATH"))
    checkError(err)

    writer := bufio.NewWriterSize(stdout, 1024 * 1024)

    tTemp, err := strconv.ParseInt(readLine(reader), 10, 64)
    checkError(err)
    t := int32(tTemp)

    for tItr := 0; tItr < int(t); tItr++ {
        nab := strings.Split(readLine(reader), " ")

        _, err := strconv.ParseInt(nab[0], 10, 64)
        checkError(err)


        aTemp, err := strconv.ParseInt(nab[1], 10, 64)
        checkError(err)
        a := int32(aTemp)

        bTemp, err := strconv.ParseInt(nab[2], 10, 64)
        checkError(err)
        b := int32(bTemp)

        s := readLine(reader)

        result := buildString(a, b, s)
        fmt.Fprintln(writer, result)
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

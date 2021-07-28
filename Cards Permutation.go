package main

import (
    "bufio"
    "fmt"
    "io"
    "os"
    "strconv"
    "strings"
)

const mod = 1e9 + 7
const inv2 = (mod + 1) >> 1

var counts []int
var pre []int
var multi []int
var size = 0
var count = 0
var lex = 0

func add(a int, b int) int {
    a += b
    if a >= mod {
        return a - mod
    }
    return a
}

func sub(a int, b int) int {
    a -= b
    if a < 0 {
        return a + mod
    }
    return a
}

func mul(a, b int) int {
    return (a * b) % mod
}

func lowbit(i int) int {
    return i & (-i)
}

func update(o, v int) {
    i := o + 1
    for i <= size {
        counts[i] += v
        i += lowbit(i)
    }
}

func minusOne(n int) int {
    sum := 0
    i := n + 1
    for i >= 1 {
        sum += counts[i]
        i -= lowbit(i)
    }
    return sum
}

func normal(n int) int {
    return mul(mul(n, sub(n, 1)), inv2)
}

func prepare(a []int) {
    pre = make([]int, len(a)+1)
    multi = make([]int, len(a)+1)
    counts = make([]int, len(a)+1)

    for i := 1; i < size+1; i++ {
        a[i] -= 1
        if a[i] == -1 {
            count++
        }
        if a[i] >= 0 {
            pre[a[i]] = 1
        }
    }
    multi[0] = 1
    for i := 1; i < size+1; i++ {
        multi[i] = mul(i, multi[i-1])
    }
    for i := 1; i < size; i++ {
        pre[i] += pre[i-1]
    }
    lex = mul(mul(size, sub(size, 1)), inv2)
    for i := 1; i < size+1; i++ {
        if a[i] != -1 {
            lex = sub(lex, a[i])
        }
    }
}

func solve(a []int) int {
    prepare(a)
    current := 0
    result := 0
    for i := 1; i < size+1; i++ {
        if a[i] == -1 {
            sum := mul(lex, multi[count-1])
            if count >= 2 {
                sum = sub(sum, mul(multi[count-2], mul(current, normal(count))))
            }
            sum = mul(sum, multi[size-i])
            result = add(result, sum)
            current += 1
        } else {
            sum := mul(multi[count], a[i]-minusOne(a[i]))
            if count >= 1 {
                sum = sub(sum, mul(multi[count-1], mul(current, a[i]+1-pre[a[i]])))
            }
            sum = mul(sum, multi[size-i])
            result = add(result, sum)
            update(a[i], 1)
            lex = sub(lex, sub(size-1-a[i], sub(pre[size-1], pre[a[i]])))
        }
    }
    return add(result, multi[count])
}

func main() {
    reader := bufio.NewReaderSize(os.Stdin, 1024*1024*10)

    stdout, err := os.Create(os.Getenv("OUTPUT_PATH"))
    checkError(err)

    defer stdout.Close()

    writer := bufio.NewWriterSize(stdout, 1024*1024)

    nTemp, err := strconv.ParseInt(readLine(reader), 10, 64)
    checkError(err)
    size = int(nTemp)

    aTemp := strings.Split(readLine(reader), " ")

    a := make([]int, size)
    for i := 0; i < size; i++ {
        intger, err := strconv.ParseInt(aTemp[i], 10, 64)
        checkError(err)
        a[i] = int(intger)
    }
    a = append([]int{0}, a...) // push front
    result := solve(a)

    fmt.Fprintf(writer, "%d\n", result)

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
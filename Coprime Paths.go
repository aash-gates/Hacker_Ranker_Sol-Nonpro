package main

import (
    "bufio"
    "fmt"
    "io"
    "os"
)

type Triplet struct {
    single [3]int
    double [3]int
    triple int
}

type Node struct {
    children []int
    parent   int
    height   int
}

func main() {
    cacheSingle := make(map[int]int)
    lastSingle := 0
    single := func(p int) int {
        if result, ok := cacheSingle[p]; ok {
            return result
        }
        result := lastSingle
        lastSingle++
        cacheSingle[p] = result
        return result
    }

    cacheDouble := make(map[[2]int]int)
    lastDouble := 0
    double := func(p, q int) int {
        key := [2]int{p, q}
        if result, ok := cacheDouble[key]; ok {
            return result
        }
        result := lastDouble
        lastDouble++
        cacheDouble[key] = result
        return result
    }

    cacheTriple := make(map[[3]int]int)
    lastTriple := 0
    triple := func(p, q, r int) int {
        key := [3]int{p, q, r}
        if result, ok := cacheTriple[key]; ok {
            return result
        }
        result := lastTriple
        lastTriple++
        cacheTriple[key] = result
        return result
    }

    noOfNodes := ScanInt()
    noOfQueries := ScanInt()
    NewLine()

    triplets := make([]*Triplet, noOfNodes+1)
    cachedTriplet := make(map[[3]int]*Triplet)
    for i := 1; i <= noOfNodes; i++ {
        scannedNode := ScanInt()
        a, b, c := 0, 0, 0
        if scannedNode%2 == 0 {
            a = 2
            for scannedNode%2 == 0 {
                scannedNode /= 2
            }
        }
        for j := 3; j*j <= scannedNode; j += 2 {
            if scannedNode%j == 0 {
                if a == 0 {
                    a = j
                } else if b == 0 {
                    b = j
                } else {
                    c = j
                }
                for scannedNode%j == 0 {
                    scannedNode /= j
                }
            }
        }
        if scannedNode > 1 {
            if a == 0 {
                a = scannedNode
            } else if b == 0 {
                b = scannedNode
            } else {
                c = scannedNode
            }
        }
        tkey := [3]int{a, b, c}
        triplet, ok := cachedTriplet[tkey]
        if !ok {
            triplet = &Triplet{single: [3]int{-1, -1, -1}, double: [3]int{-1, -1, -1}, triple: -1}
            if a != 0 {
                triplet.single[0] = single(a)
                if b != 0 {
                    triplet.single[1] = single(b)
                    triplet.double[0] = double(a, b)
                    if c != 0 {
                        triplet.single[2] = single(c)
                        triplet.double[1] = double(a, c)
                        triplet.double[2] = double(b, c)
                        triplet.triple = triple(a, b, c)
                    }
                }
            }
            cachedTriplet[tkey] = triplet
        }
        triplets[i] = triplet
    }

    nodes := make([]Node, noOfNodes+1)
    for i := 1; i < noOfNodes; i++ {
        NewLine()
        nodeX := ScanInt()
        nodeY := ScanInt()
        nodes[nodeX].children = append(nodes[nodeX].children, nodeY)
        nodes[nodeY].children = append(nodes[nodeY].children, nodeX)
    }

    var buildTree func(whichNode, parent, height int)
    buildTree = func(whichNode, parent, height int) {
        currentNode := &nodes[whichNode]
        currentNode.height = height
        currentNode.parent = parent
        for k := 0; k < len(currentNode.children); {
            child := currentNode.children[k]
            if child == parent {
                copy(currentNode.children[k:], currentNode.children[k+1:])
                currentNode.children = currentNode.children[:len(currentNode.children)-1]
            } else {
                buildTree(child, whichNode, height+1)
                k++
            }
        }
    }
    buildTree(1, -1, 0)

    singleCount := make([]int, lastSingle)
    doubleCount := make([]int, lastDouble)
    tripleCount := make([]int, lastTriple)
    emptySlice := make([]int, 10000000)
    total, visited := 0, 0
    update := func(which int) {
        total += visited
        visited++
        t := triplets[which]
        for _, i := range t.single {
            if i < 0 {
                break
            }
            total -= singleCount[i]
            singleCount[i]++
        }
        for _, i := range t.double {
            if i < 0 {
                break
            }
            total += doubleCount[i]
            doubleCount[i]++
        }
        if t.triple >= 0 {
            total -= tripleCount[t.triple]
            tripleCount[t.triple]++
        }
    }

    for i := 0; i < noOfQueries; i++ {
        NewLine()
        copy(singleCount, emptySlice)
        copy(doubleCount, emptySlice)
        copy(tripleCount, emptySlice)
        total, visited = 0, 0
        pathU := ScanInt()
        pathV := ScanInt()
        for nodes[pathU].height > nodes[pathV].height {
            update(pathU)
            pathU = nodes[pathU].parent
        }
        for nodes[pathV].height > nodes[pathU].height {
            update(pathV)
            pathV = nodes[pathV].parent
        }
        for pathU != pathV {
            update(pathU)
            pathU = nodes[pathU].parent
            update(pathV)
            pathV = nodes[pathV].parent
        }
        update(pathU)
        fmt.Println(total)
    }
}

// Boilerplate

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

func ScanInt() int {
    return int(ScanInt64())
}

func ScanInt64() int64 {
    for {
        b := ReadByte()
        switch b {
        case ' ', '\t', '\r':
            // keep looking
        case '\n':
            panic(fmt.Sprintf("unexpected newline; expecting range"))
        case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
            UnreadByte()
            x, e := _scanu64()
            if e != "" {
                panic(fmt.Sprintf("%s", e))
            }
            return int64(x)
        case '-':
            x, e := _scanu64()
            if e != "" {
                panic(fmt.Sprintf("-%s", e))
            }
            return -int64(x)
        default:
            panic(fmt.Sprintf(
                "unexpected character <%c>; expecting range", b))
        }
    }
}

func _scanu64() (uint64, string) {
    x := uint64(0)
buildnumber:
    for {
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
            x = x*10 + d
        default:
            return x, fmt.Sprintf("%d%c found; expecting range", x, b)
        }
    }
    return x, ""
}

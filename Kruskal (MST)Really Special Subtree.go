package main
import (
	"bufio"
	"os"
	"strconv"
	"strings"
	"fmt"
    "container/heap"
)

type Item struct {
	value    int
	priority int
	index int
}

type PriorityQueue []*Item

func (pq PriorityQueue) Len() int { return len(pq) }

func (pq PriorityQueue) Less(i, j int) bool {
	// We want Pop to give us the highest, not lowest, priority so we use greater than here.
	return pq[i].priority < pq[j].priority
}

func (pq PriorityQueue) Swap(i, j int) {
	pq[i], pq[j] = pq[j], pq[i]
	pq[i].index = i
	pq[j].index = j
}

func (pq *PriorityQueue) Push(x interface{}) {
	n := len(*pq)
	item := x.(*Item)
	item.index = n
	*pq = append(*pq, item)
}

func (pq *PriorityQueue) Pop() interface{} {
	old := *pq
	n := len(old)
	item := old[n-1]
	item.index = -1 // for safety
	*pq = old[0 : n-1]
	return item
}

func (pq *PriorityQueue) update(item *Item, value int, priority int) {
	item.value = value
	item.priority = priority
	heap.Fix(pq, item.index)
}

func prim(G map[int]map[int]int, N int, start int){
	connected := make([]bool, N + 1)
	num := 0
	res := 0
	
	frontier := make(PriorityQueue, 1)
	frontier[0] = &Item{value: start, priority: 0, index: 0}
	heap.Init(&frontier)

	for frontier.Len() > 0 && num <= N {
		element := heap.Pop(&frontier).(*Item)
		vertex := element.value
        if !connected[vertex]{
            //fmt.Println(vertex, element.priority)
            res += element.priority
            num++
            connected[vertex] = true

            for v, w := range(G[vertex]){
                if !connected[v]{
                    heap.Push(&frontier, &Item{value: v, priority: w})
                }
            }
        }
	}
	
	fmt.Println(res)
}

func main(){
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()

    arr := strings.Fields(scanner.Text()) // read N and M
    N, _ := strconv.Atoi(arr[0])
    M, _ := strconv.Atoi(arr[1])
    G := map[int]map[int]int{}
    for M > 0 {
        M--
        scanner.Scan()
        arr := strings.Fields(scanner.Text())
        num1, _ := strconv.Atoi(arr[0])
        num2, _ := strconv.Atoi(arr[1])
        weight, _ := strconv.Atoi(arr[2])
        if len(G[num1]) == 0 { G[num1] = map[int]int{} }
        if len(G[num2]) == 0 { G[num2] = map[int]int{} }

        val, ok := G[num2][num1]
        if ok {
            if weight < val{G[num2][num1] = weight}
        } else {
            G[num2][num1] = weight
        }

        val, ok = G[num1][num2]
        if ok {
            if weight < val{ G[num1][num2] = weight }
        } else {
            G[num1][num2] = weight
        }
    }
    scanner.Scan() // read the starting node
    start, _ := strconv.Atoi(scanner.Text())
    prim(G, N, start)
}

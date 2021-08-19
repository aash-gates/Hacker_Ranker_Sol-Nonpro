import Foundation

func minimumSumEdges(n: Int, m: Int, s: Int) {
    let mstEdgeNumber = n - 1
    let notInMstEdgeNumber = m - mstEdgeNumber
    
    let hesoA = (mstEdgeNumber - 1) * (mstEdgeNumber - 2) / 2
    let hesoB = notInMstEdgeNumber - hesoA
    guard hesoB > 0 else {
        print(s + notInMstEdgeNumber)
        return
    }
    let x = hesoB * (mstEdgeNumber - 1)
    if x < hesoA {
        print(hesoB * s + (hesoA - x) + s)
    } else if x == hesoA {
        print(s * (hesoB + 1))
    } else {
        let a = s / mstEdgeNumber
        let b = s - (mstEdgeNumber - 1) * a
        var minSumEdge = hesoA * a + hesoB * b + s

        let t = b - a
        guard t > 1 else {
            print(minSumEdge)
            return
        }
        guard t < mstEdgeNumber else {
            print(minSumEdge)
            return
        }
        let r = calculate(values: [a, a+1], amount: [mstEdgeNumber - t, t], notInMstEdgeNumber: notInMstEdgeNumber) + s
        if minSumEdge > r {
            minSumEdge = r
        }
        print(minSumEdge)
    }
}

private func calculate(values: [Int], amount: [Int], notInMstEdgeNumber: Int) -> Int {
    var s = 0
    var remainEdgeNumber = notInMstEdgeNumber
    for i in 0 ..< values.count {
        var c = amount[i] * (amount[i] - 1) / 2
        for j in 0 ..< i {
            c += amount[i] * amount[j]
        }
        if c > remainEdgeNumber { c = remainEdgeNumber }
        s += values[i] * c
        remainEdgeNumber -= c
        if remainEdgeNumber == 0 {
            return s
        }
    }
    return s
}

guard let g = Int((readLine()?.trimmingCharacters(in: .whitespacesAndNewlines))!)
else { fatalError("Bad input") }

for gItr in 1...g {
    guard let nmsTemp = readLine() else { fatalError("Bad input") }
    let nms = nmsTemp.split(separator: " ").map{ String($0) }

    guard let n = Int(nms[0].trimmingCharacters(in: .whitespacesAndNewlines))
    else { fatalError("Bad input") }

    guard let m = Int(nms[1].trimmingCharacters(in: .whitespacesAndNewlines))
    else { fatalError("Bad input") }

    guard let s = Int(nms[2].trimmingCharacters(in: .whitespacesAndNewlines))
    else { fatalError("Bad input") }

    // Write Your Code Here
    minimumSumEdges(n: n, m: m, s: s)
}

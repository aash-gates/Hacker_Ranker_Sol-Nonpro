import Foundation

protocol FromIntMax {
    init(intmax: IntMax)
}

extension Int: FromIntMax {
    init(intmax: IntMax) {
        self = Int.init(integerLiteral: Int(intmax))
    }
}

extension Int8: FromIntMax {
    init(intmax: IntMax) {
        self = Int8.init(integerLiteral: Int8(intmax))
    }
}

func readArray<T: FromIntMax>() -> [T] {
    var result = [T]();
    var current: IntMax = 0
    let line = readLine()!.unicodeScalars
    var mul: IntMax = 0
    for uc in line {
        if uc == " " {
            if mul != 0 {
                result.append(T(intmax: current * mul))
                current = 0
                mul = 0
            }
        } else if uc == "-" {
            mul = -1
        } else {
            if mul == 0 {
                mul = 1
            }
            current = current * 10 + IntMax(uc.value) - 48
        }
    }
    if mul != 0 {
        result.append(T(intmax: current * mul))
    }
    return result
}

func readInt<T: FromIntMax>() -> T {
    var current: IntMax = 0
    let line = readLine()!.unicodeScalars
    var mul: IntMax = 0
    for uc in line {
        if uc == " " {
            if mul != 0 {
                return T(intmax: current * mul)
            }
        } else if uc == "-" {
            mul = -1
        } else {
            if mul == 0 {
                mul = 1
            }
            current = current * 10 + IntMax(uc.value) - 48
        }
    }
    return T(intmax: current * mul)
}

var temp: [Int] = readArray()
let n = temp[0]
let m = temp[1]
let k = temp[2]
var shops = [Int](count: n + 1, repeatedValue: 0)
var g = [[(Int, Int)]](count: n + 1, repeatedValue: [])
for i in 1...n {
    temp = readArray()
    for j in 1..<temp.count {
        shops[i] |= (1 << (temp[j] - 1))
    }
}
for _ in 0..<m {
    temp = readArray()
    g[temp[0]].append((temp[1], temp[2]))
    g[temp[1]].append((temp[0], temp[2]))
}

var w = [[(Int, Int)]](count: n + 1, repeatedValue: [(Int, Int)](count: 1 << k, repeatedValue: (-1, -1)))

class PriorityQueue {
    var value: [(Int, Int, Int)] = []
    
    func push(v: (Int, Int, Int)) {
        let i = value.count
        value.append(v)
        doLift(i, v)
    }
    
    func lift(v: (Int, Int, Int)) {
        let i = w[v.1][v.2].1
        doLift(i, v)
    }
    
    func pop() -> (Int, Int, Int) {
        let result = value[0]
        let v = value.last!
        let nl = value.count - 1
        value.removeAtIndex(nl)
        if nl > 0 {
            var i = 0
            while true {
                let l = i * 2 + 1
                let r = l + 1
                if l < nl {
                    let b = r < nl && value[r].0 < value[l].0 ? r : l
                    if value[b].0 < v.0 {
                        set(i, value[b])
                        i = b
                        continue
                    }
                }
                set(i, v)
                break
            }
        }
//        print(value, " >= ", result)
        return result
    }
    
    func set(i: Int, _ v: (Int, Int, Int))
    {
        value[i] = v
        w[v.1][v.2].1 = i
    }
    
    func doLift(ii: Int, _ v: (Int, Int, Int))
    {
        var i = ii
        while i > 0 {
            let p = (i - 1) / 2
            if value[p].0 > v.0 {
                set(i, value[p])
                i = p
            } else {
                break
            }
        }
        set(i, v)
    }
}

var q = PriorityQueue()
q.push((0, 1, shops[1]))
w[1][shops[1]] = (0, 0)
while q.value.count > 0 {
    var t = q.pop()
    let v = (t.1, t.2)
    let best = t.0
    for e in g[v.0] {
        let d = (e.0, v.1 | shops[e.0])
        let nw = best + e.1
        if w[d.0][d.1].0 == -1 {
            w[d.0][d.1].0 = nw
            q.push((nw, d.0, d.1))
        } else if nw < w[d.0][d.1].0 {
            w[d.0][d.1].0 = nw
            q.lift(nw, d.0, d.1)
        }
    }
}

var result = 1 << 60
var mask = (1 << k) - 1
for i in 0...mask {
    if w[n][i].0 != -1 && w[n][i].0 < result {
        for j in i...mask {
            if i | j == mask && w[n][j].0 != -1 {
                result = min(result, max(w[n][i].0, w[n][j].0))
            }
        }
    }
}
print(result)

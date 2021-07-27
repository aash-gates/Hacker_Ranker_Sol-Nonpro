import Foundation

protocol FromIntMax {
    init(intmax: UIntMax, mul: IntMax)
}

extension Int: FromIntMax {
    init(intmax: UIntMax, mul: IntMax) {
        self = mul > 0 ? Int(intmax) : Int.init(truncatingBitPattern: ~intmax &+ 1);
    }
}

extension Int8: FromIntMax {
    init(intmax: UIntMax, mul: IntMax) {
        self = mul > 0 ? Int8(intmax) : Int8.init(truncatingBitPattern: ~intmax &+ 1);
    }
}

extension UInt64: FromIntMax {
    init(intmax: UIntMax, mul: IntMax) {
        self = intmax
    }
}

func readArray<T: FromIntMax>() -> [T] {
    var result = [T]();
    var current: UIntMax = 0
    let line = readLine()!.unicodeScalars
    var mul: IntMax = 0
    for uc in line {
        if uc == " " {
            if mul != 0 {
                result.append(T(intmax: current, mul: mul))
                current = 0
                mul = 0
            }
        } else if uc == "-" {
            mul = -1
        } else {
            if mul == 0 {
                mul = 1
            }
            current = current * 10 + (UIntMax(uc.value) - 48)
        }
    }
    if mul != 0 {
        result.append(T(intmax: current, mul: mul))
    }
    return result
}

func readInt<T: FromIntMax>() -> T {
    var current: UIntMax = 0
    let line = readLine()!.unicodeScalars
    var mul: IntMax = 0
    for uc in line {
        if uc == " " {
            if mul != 0 {
                return T(intmax: current, mul: mul)
            }
        } else if uc == "-" {
            mul = -1
        } else {
            if mul == 0 {
                mul = 1
            }
            current = current * 10 + (UIntMax(uc.value) - 48)
        }
    }
    return T(intmax: current, mul: mul)
}

let mod = 1000000007
//=====================================================================

let t: Int = readInt()

var f = [Int](count: 30010, repeatedValue: 0)
var kmp = [Int](count: 30010, repeatedValue: 0)
var skip = [Bool](count: 30010, repeatedValue: false)

for _ in 0..<t {
    let temp: [Int] = readArray()
    let n = temp[0]
    let a = temp[1]
    let b = temp[2]
    let s = Array(readLine()!.unicodeScalars.map { Int8($0.value) - 97 })
    for i in 0..<f.count {
        f[i] = Int.max
        skip[i] = false
    }
    f[0] = a
//    var c1 = 0
//    var c2 = 0
    for p in 0..<n-1 {
        if skip[p] {
            continue
        }
        let start = p + 1
        let newValue = f[p] + b
        if f[p] + a < f[start] {
            f[start] = f[p] + a
            skip[start] = false
        }
        var last = min(n, start * 2)
        var jj = start - 1
        kmp[start] = start - 1
        var lastKmp = start
        var ii = start
//        print(s[start..<last], kmp[0..<last-start])
        var i = 0
        while i <= p
        {
            var j = start
            while i <= p && j < last {
                while j >= start && s[j] != s[i] {
                    if j > lastKmp {
                        while ii < j {
                            while (jj >= start) && s[jj] != s[ii] {
                                jj = kmp[jj]
                            }
                            ii += 1
                            jj += 1
                            if s[ii] == s[jj] {
                                kmp[ii] = kmp[jj]
                            } else {
                                kmp[ii] = jj
                            }
                        }
                        lastKmp = j
                    }
                    j = kmp[j]
                }
                if j >= start {
                    if f[j] > newValue {
//                    print(s[0...i], s[start...start+j])
                        f[j] = newValue
                        skip[j] = false
                        if f[j - 1] == newValue {
                            skip[j - 1] = true
                        }
                    }
                }
                i += 1
                j += 1
            }
        }
//        print(f[0..<n])
    }
    print(f[n - 1])
//    print(c1, c2)
}


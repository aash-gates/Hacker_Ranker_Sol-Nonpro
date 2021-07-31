//    let n = Int(readLine()!)!
//    let a = readLine()!.characters.split(" ").map({Int(String($0))!})
/*

func readArray() -> [UInt64] {
    var result = [UInt64]();
    var current: UInt64 = 0
    let line = readLine()!.unicodeScalars
    for uc in line {
        if uc == " " {
            result.append(current)
            current = 0
        } else {
            current = current * 10 + UInt64(uc.value) - 48
        }
    }
    result.append(current)
    return result
}*/

import Foundation

func dumb(s: [UnicodeScalar]) -> Int {
    var result = 0
    for i in 0..<s.count-3 {
        for j in i+1..<s.count-2 {
            for k in j+1..<s.count-1 {
                if s[j] == s[k] {
                    for l in k+1..<s.count {
                        if s[i] == s[l] {
                            result += 1
                        }
                    }
                }
            }
        }
    }
    return result
}

let mod = 1000000007
let s = Array(readLine()!.unicodeScalars)
var c = [Int](count: 26, repeatedValue: 0)
var l = [Int](count: 26, repeatedValue: -1)
var m = [[Int]](count: s.count, repeatedValue: [Int](count: 26, repeatedValue: 0))
var p = [Int](count: s.count, repeatedValue: -1)

for i in 0..<s.count {
    var value = Int(s[i].value) - 97
    var last = l[value]
    for j in 0..<26 {
        m[i][j] = (c[j] + (last != -1 ? m[last][j] : 0)) % mod
    }
    p[i] = last
    l[value] = i
    c[value] += 1
}

var result = 0
c = [Int](count: 26, repeatedValue: 0)
for ii in 0..<s.count {
    let i = s.count - ii - 1
    var value = Int(s[i].value) - 97
    for j in 0..<26 {
        if p[i] != -1 {
            result = (result + (c[j] * m[p[i]][j]) % mod) % mod
        }
    }
    c[value] += 1
}
print(result)

'use strict';

const fs = require('fs');
const _ = require('underscore');

process.stdin.resume();
process.stdin.setEncoding('ascii');

let inputString = '';
let currentLine = 0;

process.stdin.on('data', inputStdin => {
    inputString += inputStdin;
});

process.stdin.on('end', _ => {
    inputString = inputString.trim().split('\n').map(str => str.trim());

    main();
});

function readLine() {
    return inputString[currentLine++];
}  

var res = new Set();
function arr2(x, y) {
  var a1 = _.range(x).map(() => {
    return _.range(y).map((i2) => {
      return BigInt(i2);
    })
  })
  return a1
}

function arr(x) {
  return _.range(x).map((i) => {
    return BigInt(i);
  })
}

function* range(start, end) {
    for (let i = start; i <= end; i++) {
        yield i;
    }
}

function shuffle(obj1, obj2) {
  var index = obj1.length;
  var rnd, tmp1, tmp2;

  while (index) {
    rnd = Math.floor(Math.random() * index);
    index -= 1;
    tmp1 = obj1[index];
    tmp2 = obj2[index];
    obj1[index] = obj1[rnd];
    obj2[index] = obj2[rnd];
    obj1[rnd] = tmp1;
    obj2[rnd] = tmp2;
  }
}

var M = BigInt(1202953049705846707);
var u = BigInt(7627744968637);
var u2 = u * u % M
var P = arr(608),
V = arr(128),
L = arr2(2, 608),
R = arr2(2, 608),
X = arr2(2, 608);

function hh(n, a) {
  L[0][0] = L[0][1] = R[0][1] = R[0][0] = 0n
  let p = u;
  for (let i = 1; i <= n; ++i, p = p * u2 % M)
    for (let j of range(0, 1)) {
      L[j][i] = (BigInt(L[j][i - 1]) * u + BigInt(V[a[j ^ 1][i - 1].charCodeAt(0)]) + BigInt(V[a[j][i - 1].charCodeAt(0)]) * p) % M;
      R[j][i] = (BigInt(R[j][i - 1]) * u + BigInt(V[a[j ^ 1][n - i].charCodeAt(0)]) + BigInt(V[a[j][n - i].charCodeAt(0)]) * p) % M;
    };     
    res.add(L[0][n]);
    res.add(L[1][n]);
    res.add(R[0][n]);
    res.add(R[1][n]);  
    for (let j of range(0, 1)) {
      for (let i = 1; i < n; ++i) {
        X[j][i] = (BigInt(V[a[j][i].charCodeAt(0)]) * BigInt(u) + BigInt(V[a[j ^ 1][i].charCodeAt(0)])) % M;
      }
    }
    for (let k of range(0, 1)) {
      for (let l = 1; l <= n; ++l) {
        let t = L[k][l];
        for (let r = n - l, j = l, f = !k ? 1 : 0; r; --r, ++j, f = !f ? 1 : 0) {
          // console.log(t)
            res.add((BigInt(t) * BigInt(P[r]) + BigInt(R[f][r])) % M)
            t = (BigInt(t) * BigInt(u2) + BigInt(X[f][j])) % M
        }
      }
    }
  }

function main() {
    P[0] = 1;
    for (let i = 1; i < 608; ++i) {
      P[i] = BigInt(P[i - 1]) * u2 % M;
    }

    for (let i = 0; i < 128; ++i) V[i] = i ^ i >> 1;

    const ws = fs.createWriteStream(process.env.OUTPUT_PATH);
    const p = parseInt(readLine(), 10);
    for (let pItr = p; pItr > 0; pItr--) {
        let n = parseInt(readLine(), 10),
            s1 = readLine(),
            s2 = readLine(),
            a = [s1, s2];

            shuffle(V, [V, 128]);
            res.clear();

            hh(n, a);
            a[0] = a[0].split('').reverse().join('');
            a[1] = a[1].split('').reverse().join('');
            hh(n, a);
            
        ws.write(res.size + "\n");
    }
    ws.end();
}

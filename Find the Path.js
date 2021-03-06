'use strict';

const fs = require('fs');

process.stdin.resume();
process.stdin.setEncoding('utf-8');

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

/*
 * Complete the shortestPath function below.
 */
class MinHeap {
    constructor() {
        this._arr = [];
    }
    insert(value, data) {
        let i = this._arr.length;
        let j = (i - 1) >> 1;
        while (j >= 0 && value < this._arr[j][0]) {
            this._arr[i] = this._arr[j];
            i = j;
            j = (i - 1) >> 1;
        }
        this._arr[i] = [value, data];
    }
    extract() {
        const result = this._arr[0];
        const [value, data] = this._arr.pop();
        if (this._arr.length) {
            let i = 0;
            let j = 1;
            while (true) {
                if (j + 1 < this._arr.length && this._arr[j][0] >= this._arr[j + 1][0]) j++; // Get child with least value
                if (j >= this._arr.length || value <= this._arr[j][0]) break;
                this._arr[i] = this._arr[j];
                i = j;
                j = j * 2 + 1;
            }
            this._arr[i] = [value, data];
        }
        return result;
    }
}

function shortestPath(a, queries) {
    const chunk = Math.floor(2500 / a.length);
    // Create graph
    const width = a[0].length;
    const nodes = [].concat(...a.map((row, y) => row.map((weight, x) => ({ weight, x, y, distTo: new Map, gates: [] }))));
    const gates = Array.from({ length: (Math.floor((width - 1) / chunk) + 1) }, (_, x) =>
        a.map((_, y) => nodes[y * width + x * chunk])
    );
    nodes.forEach((node, i) => {
        node.neighbors = [-1, 1, -width, width]
            .map(d => i + d)
            .map((j, k) => (k > 1 || j % width - i % width === j - i) && nodes[j])
            .filter(Boolean);
        node.gates = gates.slice(Math.floor(node.x / chunk));
    });
    gates.forEach((gate, x) => {
        const min = Math.max(0, (x - 1) * chunk);
        const max = Math.min(width, (x + 1) * chunk);
        gate.forEach((centre, y) => {
            flood(centre, min, max);
            // Make jumps between more distant gates
            if (!x) return;
            gates.slice(0, x - 1).forEach((gate, j) => {
                for (const start of gate) {
                    start.distTo.set(centre, Math.min(...gates[x - 1].map(mid => distanceVia(start, mid, centre))));
                }
            });
        });
    });

    function distanceVia(a, b, c) {
        if (a === b) return b.distTo.get(c);
        if (b === c) return a.distTo.get(b);
        return a.distTo.get(b) + b.distTo.get(c) - b.weight;
    }

    function flood(centre, min, max) {
        const heap = new MinHeap();
        heap.insert(centre.weight, centre);
        const visited = new Set;
        for (let count = (max - min) * a.length; count;) {
            const [dist, node] = heap.extract();
            if (visited.has(node)) continue;
            visited.add(node);
            if (node.x >= min && node.x < max) {
                node.distTo.set(centre, dist);
                count--;
            }
            for (const neighbor of node.neighbors) {
                if (!visited.has(neighbor)) heap.insert(dist + neighbor.weight, neighbor);
            }
        }
    }

    function distance(a, b) {
        if (a === b) return a.weight;
        if (a.x > b.x) [a, b] = [b, a];
        const i = Math.floor(a.x / chunk);
        const j = Math.floor(b.x / chunk);

        const heap = new MinHeap();
        const visited = new Set;
        if (j - i > 1) { // Separated by multiple gates
            return Math.min(...a.gates[1].map(start =>
                a.distTo.get(start) - start.weight +
                Math.min(...b.gates[0].map(end =>
                    start.distTo.get(end) + b.distTo.get(end) - end.weight
                ))
            ));
        }
        if (j > i) { // Separated by one gate
            return Math.min(...a.gates[1].map(mid =>
                a.distTo.get(mid) + b.distTo.get(mid) - mid.weight
            ));
        }
        // Within same pair of gates:
        // Get distance via one of both surrounding gates:
        const dist = Math.min(
            ...a.gates[0].concat(a.gates[1] || []).map(centre => a.distTo.get(centre) + b.distTo.get(centre) - centre.weight),
        );
        // ... That way we don't have to search beyond the nearby gates.
        heap.insert(a.weight, a);
        heap.insert(dist, b);
        while (true) {
            const [dist, node] = heap.extract();
            if (visited.has(node)) continue;
            if (node === b) return dist;
            visited.add(node);
            // If node is in a gate, do not include neighbors on the other side of it, but
            // instead add the gate-nodes, with their relative distances
            for (const neighbor of node.neighbors) {
                if (!visited.has(neighbor) && Math.floor(neighbor.x / chunk) === i) {
                    heap.insert(dist + neighbor.weight, neighbor);
                }
            }
        }
    }
    return queries.map(([ai, aj, bi, bj]) => distance(nodes[ai * width + aj], nodes[bi * width + bj]));
}

function main() {
    const ws = fs.createWriteStream(process.env.OUTPUT_PATH);

    const nm = readLine().split(' ');

    const n = parseInt(nm[0], 10);

    const m = parseInt(nm[1], 10);

    let a = Array(n);

    for (let aRowItr = 0; aRowItr < n; aRowItr++) {
        a[aRowItr] = readLine().split(' ').map(aTemp => parseInt(aTemp, 10));
    }

    const q = parseInt(readLine(), 10);

    let queries = Array(q);

    for (let queriesRowItr = 0; queriesRowItr < q; queriesRowItr++) {
        queries[queriesRowItr] = readLine().split(' ').map(queriesTemp => parseInt(queriesTemp, 10));
    }

    let result = shortestPath(a, queries);

    ws.write(result.join("\n") + "\n");

    ws.end();
}

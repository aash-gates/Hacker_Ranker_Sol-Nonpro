function updateNeighbourWeight(edges, index0, index1, weight) {
    var newWeight = edges[index0].neighbourDists[index1];
    if (newWeight == undefined) {
        newWeight = weight;
    }
    else {
        newWeight = Math.min(newWeight, weight);
    }

    edges[index0].neighbourDists[index1] = newWeight;
    edges[index1].neighbourDists[index0] = newWeight;
}

function processTestCase(nodes, S) {
    nodes[S].dist = 0;
    
    var stack = [S];
    var nextStack = [];

    while (stack.length > 0) {
        stack.forEach(function (nodeIndex) {
            var node = nodes[nodeIndex];
            Object.keys(node.neighbourDists).forEach(function (neighbourIndex) {
                var neighbourNode = nodes[neighbourIndex];
                var newDist = node.dist + node.neighbourDists[neighbourIndex];
                if (neighbourNode.dist < 0 || newDist < neighbourNode.dist) {
                    neighbourNode.dist = newDist;
                    nextStack.push(neighbourIndex);
                }
            });
        });
        
        stack = nextStack;
        nextStack = [];
    }
    
    var result = "";
    for (var i=0; i<nodes.length; ++i) {
        if (i == S) {
            continue;
        }
        result += nodes[i].dist + " ";
    }
    console.log(result);
}

function processData(input) {
    var lines = input.split("\n");
    var T = parseInt(lines[0]);
    var lineIndex = 1;
    for (var i=0; i<T; ++i) {
        var lineNM = lines[lineIndex++].split(" ");
        var N = parseInt(lineNM[0]);
        var M = parseInt(lineNM[1]);

        var nodes = [];
        for (var j=0; j<N; ++j) {
            nodes.push({
                index: j,
                dist: -1,
                neighbourDists: {}
            });
        }
        
        for (var j=0; j<M; ++j) {
            var lineEdge = lines[lineIndex++].split(" ");
            var edge0 = parseInt(lineEdge[0]) - 1;
            var edge1 = parseInt(lineEdge[1]) - 1;
            var weight = parseInt(lineEdge[2]);
            updateNeighbourWeight(nodes, edge0, edge1, weight);
            updateNeighbourWeight(nodes, edge1, edge0, weight);
        }
        var S = parseInt(lines[lineIndex++]) - 1;
//        console.log(nodes);
        processTestCase(nodes, S);
    }
}

process.stdin.resume();
process.stdin.setEncoding("ascii");
_input = "";
process.stdin.on("data", function (input) {
    _input += input;
});

process.stdin.on("end", function () {
   processData(_input);
});

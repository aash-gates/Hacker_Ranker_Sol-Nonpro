//Logic inspired from https://code.google.com/codejam/contest/dashboard?c=204113#s=a&a=2
function Graph(N) {
    var i;
    
    this.N = N;
    this.edges = [];
    for(i = 0; i < N; i++) {
        this.edges[i] = [];
    }
}
Graph.prototype = (function() {
    function addEdge(i, j) {
        this.edges[i][j] = true;
    }
    
    function augmentingPathExists(i, edges, visited, matchedWith) {
        var j;
        if(i == -1) { return true; }
        
        if(visited[i]) { return false; }
        visited[i] = true;
        
        for(j in edges[i]) {
            if(augmentingPathExists(matchedWith[j], edges, visited, matchedWith)) {
                matchedWith[j] = i;
                return true;
            }
        }
        return false;
    }
    function getMaximumMatching() {
        var i, N = this.N, edges = this.edges, cnt = 0, matchedWith = {};
        
        for(i = 0; i < N; i++) {
            matchedWith[i] = -1;
        }        
        for(i = 0; i < N; i++) {
            if(augmentingPathExists(i, edges, {}, matchedWith)) {
                cnt++;
            }
        }
        return cnt;
    }
    return {
        addEdge: addEdge,
        getMaximumMatching: getMaximumMatching
    };
})();
function getMinPathCover(K, arr) {
    var i, j, val, len = arr.length;
    var graph = new Graph(len);
    for(i = 0; i < len; i++) {
        val = arr[i];
        for(j = 0; j < i; j++) {
            if(Math.abs(arr[j] - val) >= K) {
                graph.addEdge(j, i);
            }
        }
    }
    return len - graph.getMaximumMatching();
}
function processData(input) {
    var lines = input.split('\n');
    var getIntArrFromLine = function(line) {
        return line.split(' ').map(function(e) { return parseInt(e, 10); });
    };
    var i, K, arr;
    
    for(i = 1; i < lines.length; i += 2) {
        arr = getIntArrFromLine(lines[i]);
        K = arr[1];
        arr = getIntArrFromLine(lines[i + 1]);
        console.log(getMinPathCover(K, arr));
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

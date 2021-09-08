using System;
using System.Collections.Generic;
using System.Text;

class Solution
{
    public const int MaxN = 10000;
    public const int Modulo = 1000000007;
    public static long[] Factorial;

    public static void Init()
    {
        // Init Factorial
        Factorial = new long[MaxN+2];
        Factorial[0] = 1;
        for (int i = 1; i <= MaxN; i++)
            Factorial[i] = Factorial[i - 1] * i % Modulo;
    }

    static void Main(string[] args)
    {
        StringBuilder sb = new StringBuilder();
        Init();
        int NumTests;
        int.TryParse(Console.ReadLine(), out NumTests);
        for (int t = 0; t < NumTests; t++)
        {
            Tree tree = new Tree();
            sb.Append(tree.Solve()).AppendLine();
        }
        Console.WriteLine(sb.ToString());
    }

        
}

class Tree
{
    int _numNodes;
    int _numLeaves;
    Node[] _nodes;
    long Result = 1;
    bool _updateResult;

    public Tree()
    {
        int.TryParse(Console.ReadLine(), out _numNodes);
        _numLeaves = 0;

        //Initializing Nodes
        _nodes = new Node[_numNodes];
        for (int n = 0; n < _numNodes; n++)
            _nodes[n] = new Node(n);
            
        //Reading Edges
        string[] input;
        int i, j;
        for (int edge = 0; edge < _numNodes - 1; edge++)
        {
            input = Console.ReadLine().Split();
            int.TryParse(input[0], out i);
            int.TryParse(input[1], out j);
            _nodes[i].Neighbors.Add(j);
            _nodes[j].Neighbors.Add(i);

        }
    }

    public long Solve()
    {
        MarkLeaves();

        foreach (Node n in _nodes)
            if (!n.IsLeaf && FindNextInCentralPath(n) > 2)
                return 0;

        if (_numLeaves == _numNodes - 1)
            return Result;

        return 2*Result % Solution.Modulo;
    }

    private void MarkLeaves()
    {
        foreach (Node n in _nodes)
            if (n.Neighbors.Count == 1)
            {
                n.IsLeaf = true;
                _numLeaves++;
            }
    }

    private int FindNextInCentralPath(Node n)
    {
        int NumLeaves = 0;
        int NumNext = 0;
        foreach (int neighbor in n.Neighbors)
            if (!_nodes[neighbor].IsLeaf)
                NumNext++;
            else
                NumLeaves++;

        Result = Result * Solution.Factorial[NumLeaves] % Solution.Modulo;
        return NumNext;
    }
}

class Node
{
    public bool IsLeaf;
    public List<int> Neighbors;

    public Node(int idx)
    {
        Neighbors = new List<int>();
    }
}

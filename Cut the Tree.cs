using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Numerics;
using System.Text;

public class Solver
{
    private int n;
    private List<int>[] neighbours;
    private int[] a;
    private int ans = int.MaxValue;
    private int[] sums;

    void ClearParent(int x, int p)
    {
        for (int i = 0; i < neighbours[x].Count; i++)
            if (neighbours[x][i] == p)
            {
                neighbours[x].RemoveAt(i);
                i--;
            }
            else
                ClearParent(neighbours[x][i], x);
    }

    int CalcSums(int x)
    {
        sums[x] = a[x];
        foreach (int c in neighbours[x])
            sums[x] += CalcSums(c);
        return sums[x];
    }

    void TryRemove(int x)
    {
        foreach (int c in neighbours[x])
        {
            ans = Math.Min(ans, Math.Abs(sums[0] - 2 * sums[c]));
            TryRemove(c);
        }
    }

    public object Solve()
    {
        n = ReadInt();
        a = ReadIntArray();
        neighbours = Enumerable.Repeat(0, n).Select(x => new List<int>()).ToArray();

        for (int i = 0; i < n - 1; i++)
        {
            int x = ReadInt() - 1;
            int y = ReadInt() - 1;
            neighbours[x].Add(y);
            neighbours[y].Add(x);
        }

        ClearParent(0, -1);

        sums = new int[n];
        CalcSums(0);

        TryRemove(0);

        return ans;
    }

    #region Main

    protected static TextReader reader;
    protected static TextWriter writer;

    static void Main()
    {
#if DEBUG
        reader = new StreamReader("..\\..\\input.txt");
        writer = Console.Out;
        //writer = new StreamWriter("..\\..\\output.txt");
#else
        reader = Console.In;
        writer = Console.Out;
#endif
        try
        {
            object result = new Solver().Solve();
            if (result != null)
            {
                writer.WriteLine(result);
            }
        }
        catch (Exception ex)
        {
#if DEBUG
            Console.WriteLine(ex);
#else
            throw;
#endif
        }
        reader.Close();
        writer.Close();
    }

    #endregion

    #region Read/Write

    private static Queue<string> currentLineTokens = new Queue<string>();

    private static string[] ReadAndSplitLine()
    {
        return reader.ReadLine().Split(new[] {' ', '\t'}, StringSplitOptions.RemoveEmptyEntries);
    }

    public static string ReadToken()
    {
        if (currentLineTokens.Count == 0)
            currentLineTokens = new Queue<string>(ReadAndSplitLine());
        return currentLineTokens.Dequeue();
    }

    public static int ReadInt()
    {
        return int.Parse(ReadToken());
    }

    public static long ReadLong()
    {
        return long.Parse(ReadToken());
    }

    public static double ReadDouble()
    {
        return double.Parse(ReadToken(), CultureInfo.InvariantCulture);
    }

    public static int[] ReadIntArray()
    {
        return ReadAndSplitLine().Select(int.Parse).ToArray();
    }

    public static long[] ReadLongArray()
    {
        return ReadAndSplitLine().Select(long.Parse).ToArray();
    }

    public static double[] ReadDoubleArray()
    {
        return ReadAndSplitLine().Select(s => double.Parse(s, CultureInfo.InvariantCulture)).ToArray();
    }

    public static int[][] ReadIntMatrix(int numberOfRows)
    {
        int[][] matrix = new int[numberOfRows][];
        for (int i = 0; i < numberOfRows; i++)
            matrix[i] = ReadIntArray();
        return matrix;
    }

    public static string[] ReadLines(int quantity)
    {
        string[] lines = new string[quantity];
        for (int i = 0; i < quantity; i++)
            lines[i] = reader.ReadLine().Trim();
        return lines;
    }

    public static void WriteArray<T>(IEnumerable<T> array)
    {
        writer.WriteLine(string.Join(" ", array));
    }

    #endregion
}
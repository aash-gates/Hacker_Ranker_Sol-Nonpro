using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Linq.Expressions;
using System.Text;

namespace CF317
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            var sr = new InputReader(Console.In);
            //var sr = new InputReader(new StreamReader("input.txt"));
            var task = new Task();
            using (var sw = Console.Out)
            //using (var sw = new StreamWriter("output.txt"))
            {
                task.Solve(sr, sw);
                //Console.ReadKey();
            }
        }
    }

    internal class Task
    {
        public void Solve(InputReader sr, TextWriter sw)
        {
            var tests = sr.NextInt32();
            for (var t = 0; t < tests; t++) {
                var n = sr.NextInt32();
                var matrix = new long[n, n];
                for (var i = 0; i < n; i++) {
                    var input = sr.ReadArray(Int64.Parse);
                    for (var j = 0; j < n; j++) {
                        matrix[i, j] = input[j];
                    }
                }
                var containersCap = new Dictionary<long, int>();
                for (var i = 0; i < n; i++) {
                    var currCap = 0L;
                    for (var j = 0; j < n; j++) {
                        currCap += matrix[i, j];
                    }
                    if (!containersCap.ContainsKey(currCap)) {
                        containersCap.Add(currCap, 0);
                    }
                    containersCap[currCap]++;
                }
                var typesCap = new Dictionary<long, int>();
                    for (var j = 0; j < n; j++) {
                    var curr = 0L;
                        for (var i = 0; i < n; i++) {
                            curr += matrix[i, j];
                        }
                        if (!typesCap.ContainsKey(curr)) {
                            typesCap.Add(curr, 0);
                        }
                        typesCap[curr]++;
                    }
                 var answ = "Possible";
                foreach (var item in typesCap) {
                    if (!containersCap.ContainsKey(item.Key)) {
                        answ = "Impossible";
                        break;
                    }
                    containersCap[item.Key] -= item.Value;
                    if (containersCap[item.Key] != 0) {
                        answ = "Impossible";
                        break;
                    }
                    containersCap.Remove(item.Key);
                }
                if (containersCap.Count != 0) {
                    answ = "Impossible";
                }

                sw.WriteLine(answ);
            }
        }
    }
}

internal class InputReader : IDisposable
{
    private bool isDispose;
    private readonly TextReader sr;

    public InputReader(TextReader stream)
    {
        sr = stream;
    }

    public void Dispose()
    {
        Dispose(true);
        GC.SuppressFinalize(this);
    }

    public string NextString()
    {
        var result = sr.ReadLine();
        return result;
    }

    public int NextInt32()
    {
        return Int32.Parse(NextString());
    }

    public long NextInt64()
    {
        return Int64.Parse(NextString());
    }

    public string[] NextSplitStrings()
    {
        return NextString()
            .Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
    }

    public T[] ReadArray<T>(Func<string, CultureInfo, T> func)
    {
        return NextSplitStrings()
            .Select(s => func(s, CultureInfo.InvariantCulture))
            .ToArray();
    }

    public T[] ReadArrayFromString<T>(Func<string, CultureInfo, T> func, string str)
    {
        return
            str.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)
                .Select(s => func(s, CultureInfo.InvariantCulture))
                .ToArray();
    }

    protected void Dispose(bool dispose)
    {
        if (!isDispose)
        {
            if (dispose)
                sr.Close();
            isDispose = true;
        }
    }

    ~InputReader()
    {
        Dispose(false);
    }
}
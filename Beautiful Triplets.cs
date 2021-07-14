using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Numerics;

public class Solution {
    #region Stable
    public delegate string ReadLine();
    public delegate void WriteLine(object line);

    static public ReadLine read = delegate { return Console.ReadLine(); };
    static public WriteLine write = (x) => Console.WriteLine(x);

    static public List<int> GetIntsLine() {
        return read().Split(' ').Select(x => int.Parse(x)).ToList();
    }

    static public List<string> GetStringsLine() {
        return read().Split(' ').ToList();
    }


    static public List<long> GetLongsLine() {
        return read().Split(' ').Select(x => long.Parse(x)).ToList();
    }
    #endregion

    static public void Main(String[] args) {
        var nd = GetIntsLine();
        var ns = GetIntsLine();
        var n = nd[0];
        var d = nd[1];

        var dic = ns.Select((x,i) => Tuple.Create(x,i)).ToDictionary(x => x.Item1, x=> x);

        var count = 0;
        for (int i = 0; i < ns.Count; i++) {
            var number = ns[i];

            Tuple<int,int> mid = null;
            dic.TryGetValue(number+d,out mid);
            if (mid==null) continue;
            if (mid.Item2 <= i) continue;
            Tuple<int, int> last = null;
            dic.TryGetValue(mid.Item1 + d, out last);
            if (last==null) continue;
            if (last.Item2 <= i) continue;
            count++;
        }
        write(count);
    }
}
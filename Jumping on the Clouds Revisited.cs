using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
class Solution {

    static void Main(String[] args) {
        var tmp = Console.ReadLine().Split(' ');
        int n = int.Parse(tmp[0]);
        int k = int.Parse(tmp[1]);
        int[] arr = Array.ConvertAll(Console.ReadLine().Split(' '), x => Convert.ToInt32(x));

        int E = 100;

        int pos = 0;
        while (true) {
            pos += k;
            pos %= n;
            if (arr[pos] == 1) E -= 2;
            E -= 1;
            if (pos == 0) break;
        }
        Console.WriteLine(E);
    }
}
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
class Solution {

    static void Main(String[] args) {
        var line = Console.ReadLine();
        var targ = Console.ReadLine();
        int k = int.Parse(Console.ReadLine());

        int n = line.Length, m = targ.Length, i = 0;
        
        if(k >= m+n) {Console.WriteLine("Yes"); return;}
        
        while (i < n && i < m && line[i] == targ[i]) i++;

        int req = m - i + n - i;

        k -= req;

        Console.WriteLine(k >= 0 && k%2==0 ? "Yes" : "No");
    }
}